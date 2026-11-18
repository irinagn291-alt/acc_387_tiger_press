import SwiftUI
import Photos
import UniformTypeIdentifiers
import ImageIO
import PhotosUI
import AVFoundation

// MARK: - ColorArtwork

struct AnimalPage: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    init(_ id: String, _ title: String, _ subtitle: String) { self.id = id; self.title = title; self.subtitle = subtitle }
}

struct PenLine: Codable, Equatable {
    var points: [CGPoint]
    let width: CGFloat
    let ink: Int?
    let region: Int?
}

enum ArtEdit: Codable, Equatable {
    case fill(Int, Int)
    case line(PenLine)
    case clear
}

struct Painting: Codable, Equatable {
    var edits: [ArtEdit] = []
    var cursor = 0
    var active: ArraySlice<ArtEdit> {
        let visible = edits.prefix(min(max(0, cursor), edits.count))
        guard let clear = visible.lastIndex(of: .clear) else { return visible }
        return visible.suffix(from: clear + 1)
    }
    var fills: [Int: Int] {
        var result: [Int: Int] = [:]
        for case let .fill(region, ink) in active {
            result[region] = ink == 0xffffff ? nil : ink
        }
        return result
    }
    mutating func append(_ edit: ArtEdit) {
        edits = Array(edits.prefix(cursor))
        edits.append(edit)
        cursor = edits.count
    }
}

extension Color {
    static func ink(_ hex: Int) -> Color {
        Color(red: Double((hex >> 16) & 255) / 255, green: Double((hex >> 8) & 255) / 255, blue: Double(hex & 255) / 255)
    }
}

final class ArtSheet {
    let outline: UIImage
    let pixels: Data
    let side: Int
    private let masks = NSCache<NSNumber, UIImage>()

    init?(outline: UIImage, pixels: Data) {
        let size = Int(Double(pixels.count).squareRoot())
        guard size > 0, size * size == pixels.count else { return nil }
        self.outline = outline; self.pixels = pixels; self.side = size
        masks.totalCostLimit = 12 * 1024 * 1024
    }
    func region(_ point: CGPoint) -> Int {
        let x = min(side - 1, max(0, Int(point.x * CGFloat(side))))
        let y = min(side - 1, max(0, Int(point.y * CGFloat(side))))
        return Int(pixels[y * side + x])
    }
    func painted(_ fills: [Int: Int]) -> UIImage? {
        guard !fills.isEmpty else { return nil }
        var colors = [UInt8](repeating: 255, count: 256 * 3)
        for (region, ink) in fills where (1...255).contains(region) {
            for channel in 0..<3 { colors[region * 3 + channel] = UInt8((ink >> ((2 - channel) * 8)) & 255) }
        }
        guard let space = CGColorSpace(indexedBaseSpace: CGColorSpaceCreateDeviceRGB(), last: 255, colorTable: colors),
              let provider = CGDataProvider(data: pixels as CFData),
              let image = CGImage(width: side, height: side, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: side,
                                  space: space, bitmapInfo: CGBitmapInfo(rawValue: 0), provider: provider, decode: nil,
                                  shouldInterpolate: false, intent: .defaultIntent) else { return nil }
        return UIImage(cgImage: image)
    }
    func mask(_ region: Int) -> UIImage? {
        let key = NSNumber(value: region)
        if let cached = masks.object(forKey: key) { return cached }
        var rgba = [UInt32](repeating: 0, count: pixels.count)
        pixels.withUnsafeBytes { (source: UnsafeRawBufferPointer) in
            for i in 0..<source.count where Int(source[i]) == region { rgba[i] = .max }
        }
        let data = rgba.withUnsafeBytes { Data($0) }
        guard let provider = CGDataProvider(data: data as CFData),
              let image = CGImage(width: side, height: side, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: side * 4,
                                  space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
                                  provider: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent) else { return nil }
        let mask = UIImage(cgImage: image)
        masks.setObject(mask, forKey: key, cost: data.count)
        return mask
    }
}

private struct PhotoPage: Codable {
    let outline: Data
    let regions: Data

    static func create(from data: Data) throws -> PhotoPage {
        let side = 192
        let options: [CFString: Any] = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                         kCGImageSourceCreateThumbnailWithTransform: true, kCGImageSourceThumbnailMaxPixelSize: 640]
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let photo = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { throw CocoaError(.fileReadCorruptFile) }
        let count = side * side
        var gray = [UInt8](repeating: 255, count: count)
        let space = CGColorSpaceCreateDeviceGray()
        let rendered = gray.withUnsafeMutableBytes { bytes -> Bool in
            guard let ctx = CGContext(data: bytes.baseAddress, width: side, height: side, bitsPerComponent: 8,
                                      bytesPerRow: side, space: space, bitmapInfo: CGImageAlphaInfo.none.rawValue) else { return false }
            let scale = CGFloat(side) / CGFloat(max(photo.width, photo.height))
            let w = CGFloat(photo.width) * scale, h = CGFloat(photo.height) * scale
            ctx.interpolationQuality = .high
            ctx.draw(photo, in: CGRect(x: (CGFloat(side) - w)/2, y: (CGFloat(side) - h)/2, width: w, height: h))
            return true
        }
        guard rendered else { throw CocoaError(.fileReadCorruptFile) }
        var tone = gray
        for y in 1..<side-1 {
            for x in 1..<side-1 {
                let i = y * side + x
                let sum = Int(gray[i])*4 + Int(gray[i-1])+Int(gray[i+1])+Int(gray[i-side])+Int(gray[i+side])
                tone[i] = UInt8(sum / 8)
            }
        }
        let levels = tone.map { Int($0) / 30 }
        var labels = [Int](repeating: -1, count: count), sizes = [Int]()
        func adjacent(_ i: Int, _ visit: (Int) -> Void) {
            if i % side > 0 { visit(i-1) }; if i % side < side-1 { visit(i+1) }
            if i >= side { visit(i-side) }; if i < count-side { visit(i+side) }
        }
        var queue = [Int]()
        for start in 0..<count where labels[start] == -1 {
            let label = sizes.count
            queue.removeAll(keepingCapacity: true); queue.append(start); labels[start] = label
            var head = 0
            while head < queue.count {
                let i = queue[head]; head += 1
                adjacent(i) { j in
                    if labels[j] == -1 && levels[j] == levels[start] { labels[j] = label; queue.append(j) }
                }
            }
            sizes.append(queue.count)
        }
        let ranked = sizes.indices.sorted { sizes[$0] > sizes[$1] }
        let keep = ranked.prefix(200).filter { sizes[$0] >= 15 || $0 == ranked.first }
        let ids = Dictionary(uniqueKeysWithValues: keep.enumerated().map { ($1, UInt8($0+1)) })
        var map = labels.map { ids[$0] ?? 0 }
        queue = map.indices.filter { map[$0] != 0 }
        var head = 0
        while head < queue.count {
            let i = queue[head]; head += 1
            adjacent(i) { j in if map[j] == 0 { map[j] = map[i]; queue.append(j) } }
        }
        var ink = [UInt8](repeating: 255, count: count)
        for i in 0..<count {
            if (i % side > 0 && map[i-1] != map[i]) || (i >= side && map[i-side] != map[i]) { ink[i] = 48 }
        }
        guard let provider = CGDataProvider(data: Data(ink) as CFData),
              let image = CGImage(width: side, height: side, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: side,
                                  space: space, bitmapInfo: CGBitmapInfo(rawValue: 0), provider: provider, decode: nil,
                                  shouldInterpolate: true, intent: .defaultIntent),
              let png = UIImage(cgImage: image).pngData() else { throw CocoaError(.fileWriteUnknown) }
        return PhotoPage(outline: png, regions: Data(map))
    }
}

@MainActor final class AnimalBook: ObservableObject {
    let originals: [AnimalPage]
    @Published private(set) var custom: [String]
    @Published private(set) var works: [String: Painting] = [:]
    @Published var errorMessage: String?
    private let cache = NSCache<NSString, ArtSheet>()
    private static var directory: URL { URL.applicationSupportDirectory.appendingPathComponent("AnimalColoring", isDirectory: true) }
    var pages: [AnimalPage] {
        originals + custom.enumerated().map { AnimalPage($0.element, "Photo study " + String($0.offset + 1), "From your photos") }
    }

    init(_ originals: [AnimalPage]) {
        self.originals = originals
        custom = UserDefaults.standard.stringArray(forKey: "coloring.photoIDs") ?? []
        for id in originals.map(\.id) + custom {
            let url = Self.directory.appendingPathComponent(id + ".json")
            if let data = try? Data(contentsOf: url), let saved = try? JSONDecoder().decode(Painting.self, from: data) { works[id] = saved }
        }
        cache.countLimit = 20
    }
    func sheet(_ id: String) -> ArtSheet? {
        if let sheet = cache.object(forKey: id as NSString) { return sheet }
        var result: ArtSheet?
        if let outline = UIImage(named: id), let map = NSDataAsset(name: id + "Map") {
            result = ArtSheet(outline: outline, pixels: map.data)
        } else if let data = try? Data(contentsOf: Self.directory.appendingPathComponent(id + ".page")),
                  let page = try? PropertyListDecoder().decode(PhotoPage.self, from: data), let outline = UIImage(data: page.outline) {
            result = ArtSheet(outline: outline, pixels: page.regions)
        }
        if let result { cache.setObject(result, forKey: id as NSString) }
        return result
    }
    func importPhoto(_ data: Data) async throws -> AnimalPage {
        let directory = Self.directory
        let id = UUID().uuidString
        try await Task.detached(priority: .userInitiated) {
            let page = try PhotoPage.create(from: data)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            try PropertyListEncoder().encode(page).write(to: directory.appendingPathComponent(id + ".page"), options: .atomic)
        }.value
        custom.append(id)
        UserDefaults.standard.set(custom, forKey: "coloring.photoIDs")
        return AnimalPage(id, "Photo study " + String(custom.count), "From your photos")
    }
    func change(_ id: String, _ update: (inout Painting) -> Void) {
        var painting = works[id] ?? Painting()
        update(&painting)
        do {
            try FileManager.default.createDirectory(at: Self.directory, withIntermediateDirectories: true)
            try JSONEncoder().encode(painting).write(to: Self.directory.appendingPathComponent(id + ".json"), options: .atomic)
            works[id] = painting
        } catch { errorMessage = "Your changes could not be saved. Check the available space on this device." }
    }
}

struct AnimalCanvas: View {
    let sheet: ArtSheet
    let painting: Painting
    var live: PenLine? = nil

    var body: some View {
        ZStack {
            Color.white
            if let base = sheet.painted(painting.fills) { Image(uiImage: base).resizable().interpolation(.none) }
            Canvas { context, size in
                for case let .line(line) in painting.active { draw(line, in: context, size: size) }
                if let live { draw(live, in: context, size: size) }
            }
            Image(uiImage: sheet.outline).resizable().blendMode(.multiply)
        }.compositingGroup().aspectRatio(1, contentMode: .fit)
    }
    private func draw(_ line: PenLine, in context: GraphicsContext, size: CGSize) {
        guard let first = line.points.first else { return }
        var ctx = context
        let bounds = CGRect(origin: .zero, size: size)
        if let region = line.region, let mask = sheet.mask(region) {
            ctx.clipToLayer { layer in layer.draw(Image(uiImage: mask), in: bounds) }
        }
        if line.ink == nil { ctx.blendMode = .clear }
        let shade = GraphicsContext.Shading.color(.ink(line.ink ?? 0))
        let width = size.width * line.width
        func pixel(_ p: CGPoint) -> CGPoint { CGPoint(x: p.x * size.width, y: p.y * size.height) }
        let origin = pixel(first)
        if line.points.count == 1 {
            ctx.fill(Path(ellipseIn: CGRect(x: origin.x-width/2, y: origin.y-width/2, width: width, height: width)), with: shade)
        } else {
            var path = Path(); path.move(to: origin)
            for point in line.points.dropFirst() { path.addLine(to: pixel(point)) }
            ctx.stroke(path, with: shade, style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
        }
    }
}

struct InksPanel: View {
    @Binding var ink: Int
    static let colors: [(String,Int)] = [("Marigold",0xf6af2d),("Tangerine",0xe87332),("Brick",0xb64235),("Rose",0xea9c9d),
        ("Lilac",0xab80c0),("Cobalt",0x4869aa),("Sky",0x84c4d4),("Teal",0x347e79),("Fern",0x628450),("Pear",0xb8c86e),
        ("Sand",0xe7cea2),("Umber",0x80553d),("Charcoal",0x383d42),("Paper",0xffffff)]
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 7), spacing: 3) {
            ForEach(Self.colors, id: \.1) { color in
                Button { ink = color.1 } label: {
                    Rectangle().fill(Color.ink(color.1)).frame(height: 32)
                        .overlay(alignment: .bottom) {
                            if ink == color.1 {
                                Rectangle().fill(.black).frame(height: 5).padding(2).background(.white)
                            }
                        }.contentShape(Rectangle())
                }.buttonStyle(.plain).accessibilityLabel(color.0)
                    .accessibilityAddTraits(ink == color.1 ? .isSelected : [])
            }
        }
    }
}

struct ColoringPNG: FileDocument {
    static var readableContentTypes: [UTType] { [.png] }
    let bytes: Data
    init(_ bytes: Data) { self.bytes = bytes }
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else { throw CocoaError(.fileReadCorruptFile) }; bytes = data
    }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper { FileWrapper(regularFileWithContents: bytes) }
}

struct ExportArt<Artwork: View>: View {
    let name: String
    @ViewBuilder var artwork: () -> Artwork
    @State private var file: ColoringPNG?
    @State private var exporting = false
    @State private var message: String?

    var body: some View {
        Menu {
            Button("Save PNG to Files", systemImage: "folder") {
                guard let data = png() else { message = "Couldn’t create the PNG."; return }
                file = ColoringPNG(data); exporting = true
            }
            Button("Save to Photos", systemImage: "photo") {
                Task { @MainActor in
                    let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                    guard status == .authorized || status == .limited else {
                        message = "Allow access in Settings or choose Save PNG to Files."; return
                    }
                    guard let data = png() else { message = "Couldn’t create the PNG."; return }
                    do {
                        try await PHPhotoLibrary.shared().performChanges {
                            let options = PHAssetResourceCreationOptions()
                            options.originalFilename = name + ".png"
                            PHAssetCreationRequest.forAsset().addResource(with: .photo, data: data, options: options)
                        }
                        message = "Your artwork was saved to Photos."
                    } catch { message = "Couldn’t save your artwork to Photos." }
                }
            }
        } label: { Label("Export", systemImage: "square.and.arrow.up") }
        .accessibilityIdentifier("export")
        .fileExporter(isPresented: $exporting, document: file, contentType: .png, defaultFilename: name) { result in
            if case .failure(let error) = result, (error as NSError).code != NSUserCancelledError { message = "Couldn’t save the PNG." }
        }
        .alert("Export artwork", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) {
            Button("OK", role: .cancel) {}
        } message: { Text(message ?? "") }
    }
    @MainActor private func png() -> Data? {
        let renderer = ImageRenderer(content: artwork().frame(width: 600))
        renderer.scale = 3; renderer.isOpaque = true
        return renderer.uiImage?.pngData()
    }
}

// MARK: - PhotoInput

struct PhotoInput: View {
    let receive: (Data) async throws -> Void
    @State private var selection: PhotosPickerItem?
    @State private var busy = false
    @State private var camera = false
    @State private var issue: String?
    @State private var needsSettings = false
    @Environment(\.openURL) private var openURL

    var body: some View {
        HStack(spacing: 10) {
            PhotosPicker(selection: $selection, matching: .images) {
                Label("Photo library", systemImage: "photo.on.rectangle")
            }.accessibilityIdentifier("photoLibrary")
            Button { Task { await openCamera() } } label: {
                Label("Camera", systemImage: "camera")
            }.accessibilityIdentifier("camera")
            if busy { ProgressView().accessibilityLabel("Loading photo") }
        }.buttonStyle(.bordered).disabled(busy)
        .onChange(of: selection) { _, item in
            guard let item else { return }
            busy = true
            Task { @MainActor in
                defer { busy = false; selection = nil }
                do {
                    guard let data = try await item.loadTransferable(type: Data.self) else { throw CocoaError(.fileReadCorruptFile) }
                    try await receive(data)
                } catch { issue = "This photo could not be opened. Try another image." }
            }
        }
        .fullScreenCover(isPresented: $camera) {
            CameraCapture { result in
                camera = false
                Task { @MainActor in
                    busy = true
                    defer { busy = false }
                    do { if let data = try result.get() { try await receive(data) } }
                    catch { issue = "The photo could not be saved. Please try again." }
                }
            }.ignoresSafeArea()
        }
        .alert("Camera and photos", isPresented: Binding(get: { issue != nil }, set: { if !$0 { issue = nil } })) {
            if needsSettings {
                Button("Open Settings") { if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) } }
            }
            Button("OK", role: .cancel) {}
        } message: { Text(issue ?? "") }
    }

    @MainActor private func openCamera() async {
        needsSettings = false
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            issue = "A camera is unavailable on this device. Choose a picture from your photo library."
            return
        }
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        let granted = status == .notDetermined ? await AVCaptureDevice.requestAccess(for: .video) : status == .authorized
        guard granted else {
            needsSettings = AVCaptureDevice.authorizationStatus(for: .video) == .denied
            issue = "Camera access is turned off. You can still choose a picture from your photo library."
            return
        }
        camera = true
    }
}

private struct CameraCapture: UIViewControllerRepresentable {
    let finish: (Result<Data?, Error>) -> Void
    func makeCoordinator() -> Coordinator { Coordinator(finish: finish) }
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ picker: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let finish: (Result<Data?, Error>) -> Void
        init(finish: @escaping (Result<Data?, Error>) -> Void) { self.finish = finish }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { finish(.success(nil)) }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard let photo = info[.originalImage] as? UIImage, let data = photo.jpegData(compressionQuality: 0.92) else {
                finish(.failure(CocoaError(.fileReadCorruptFile)))
                return
            }
            finish(.success(data))
        }
    }
}
