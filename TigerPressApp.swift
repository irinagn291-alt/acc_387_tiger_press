import SwiftUI

// MARK: - TigerPressApp

@main struct TigerPressApp: App {
    @StateObject private var book = AnimalBook(printPages)

    var body: some Scene {
        WindowGroup {
            PressStudio(book: book).preferredColorScheme(.dark).tint(.ink(0xDEFC65))
                .alert("Sketchbook", isPresented: Binding(get: { book.errorMessage != nil }, set: { if !$0 { book.errorMessage = nil } })) {
                    Button("OK", role: .cancel) {}
                } message: { Text(book.errorMessage ?? "") }
        }
    }
}

// MARK: - BrushBook

let printPages = [
    AnimalPage("monarch", "Tiger mask", "Portrait"),
    AnimalPage("fox", "Fox in the brush", "Woodland"),
    AnimalPage("artStainedGlassTiger", "Stained glass tiger", "Glasswork"),
    AnimalPage("artSpiralTiger", "Spiral tiger", "Curved forms"),
    AnimalPage("artPoppyTiger", "Poppy tiger", "Wildflowers"),
    AnimalPage("crane", "Sunrise crane", "Flight"),
    AnimalPage("artPaperBoatTiger", "Paper boat tiger", "Cub adventures"),
    AnimalPage("artConstellationTiger", "Constellation tiger", "Star map"),
    AnimalPage("chameleon", "Chameleon curl", "Canopy"),
    AnimalPage("artMoonJelly", "Moon jelly", "Ocean drift"),
    AnimalPage("artCheckerboardTiger", "Checkerboard tiger", "Graphic blocks"),
    AnimalPage("leap", "Leaping tiger", "Motion"),
    AnimalPage("artMountainIbex", "Mountain ibex", "Alpine crest"),
    AnimalPage("artPapercutTiger", "Papercut tiger", "Cut paper"),
    AnimalPage("artCrescentTiger", "Crescent tiger", "Moon shape"),
    AnimalPage("butterfly", "Painted wings", "Insects"),
    AnimalPage("artBambooFanTiger", "Bamboo fan tiger", "Botanical print"),
    AnimalPage("artLanternTiger", "Lantern tiger", "Festival night"),
    AnimalPage("bear", "Bloom bear", "Woodland"),
    AnimalPage("artEclipseTiger", "Eclipse tiger", "Celestial poster"),
    AnimalPage("artNautilusShell", "Nautilus shell", "Ocean spiral"),
    AnimalPage("seahorse", "Sea scroll", "Ocean"),
    AnimalPage("artLighthouseTiger", "Lighthouse tiger", "Coastal emblem"),
    AnimalPage("artCoralCuttlefish", "Coral cuttlefish", "Ocean camouflage"),
    AnimalPage("profileTiger", "Roaring tiger", "Profile"),
    AnimalPage("artQuiltBlockTiger", "Quilt block tiger", "Patchwork"),
    AnimalPage("artDiamondTiger", "Diamond tiger", "Geometric portrait"),
    AnimalPage("artGinkgoTiger", "Ginkgo tiger", "Autumn botanicals"),
    AnimalPage("restingStripe", "Reclining tiger", "Silhouette"),
    AnimalPage("artTelescopeTiger", "Telescope tiger", "Stargazing cub"),
    AnimalPage("artCometTiger", "Comet tiger", "Motion poster"),
    AnimalPage("lion", "Sunburst lion", "Portrait"),
    AnimalPage("artLunaMoth", "Luna moth", "Night wings"),
    AnimalPage("artSnowGlobeTiger", "Snow globe tiger", "Winter ornament"),
    AnimalPage("zebra", "Striped zebra", "Pattern"),
    AnimalPage("artLemurRingtail", "Lemur ringtail", "Tree canopy"),
    AnimalPage("artCeramicTiger", "Ceramic tiger", "Tilework"),
    AnimalPage("koala", "Eucalyptus koala", "Woodland"),
    AnimalPage("artLoopingTiger", "Looping tiger", "Ribbon line"),
    AnimalPage("artVineSwingTiger", "Vine swing tiger", "Leaf and line"),
    AnimalPage("artBookNookTiger", "Book nook tiger", "Reading corner"),
    AnimalPage("hare", "Running hare", "Motion"),
    AnimalPage("artMountainBadgeTiger", "Mountain badge tiger", "Travel print"),
    AnimalPage("artFennecFox", "Fennec fox", "Desert portrait"),
    AnimalPage("moonCub", "Moon tiger cub", "Moonlight"),
    AnimalPage("artTigerBookends", "Tiger bookends", "Paired portraits"),
    AnimalPage("artPineMarten", "Pine marten", "Forest print"),
    AnimalPage("curlTiger", "Curled tiger", "Silhouette"),
    AnimalPage("artMosaicTiger", "Mosaic tiger", "Stone mosaic"),
    AnimalPage("artTwinTigerCircle", "Twin tiger circle", "Balance"),
    AnimalPage("peacock", "Fan-tailed peacock", "Plumage"),
    AnimalPage("artMapleTiger", "Maple tiger", "Autumn print"),
    AnimalPage("artRainBootTiger", "Rain boot tiger", "Rainy morning"),
    AnimalPage("artWaveCrestTiger", "Wave crest tiger", "Ocean print"),
    AnimalPage("octopus", "Spiral octopus", "Ocean"),
    AnimalPage("artPuffinOnACliff", "Puffin on a cliff", "Coastal print"),
    AnimalPage("artTigerInALocket", "Tiger in a locket", "Keepsake"),
    AnimalPage("hummingbird", "Hummingbird", "Flight"),
    AnimalPage("artToucanetPair", "Toucanet pair", "Bird duet"),
    AnimalPage("artBatikTiger", "Batik tiger", "Textiles"),
    AnimalPage("ram", "Spiral-horned ram", "Portrait"),
    AnimalPage("artFanTiger", "Fan tiger", "Folding fan"),
    AnimalPage("artThistleTiger", "Thistle tiger", "Garden engraving"),
    AnimalPage("artWindowBoxTiger", "Window box tiger", "Windowsill"),
    AnimalPage("lilyTiger", "Lily tiger", "Florals"),
    AnimalPage("artThundercloudTiger", "Thundercloud tiger", "Weather icon"),
    AnimalPage("artKoiCircle", "Koi circle", "Pond print"),
    AnimalPage("floralTiger", "Tiger medallion", "Portrait"),
    AnimalPage("artTigerWindVane", "Tiger wind vane", "Roof silhouette"),
    AnimalPage("artFrilledDragon", "Frilled dragon", "Reptile portrait"),
    AnimalPage("manta", "Manta ray", "Ocean"),
    AnimalPage("artWovenTiger", "Woven tiger", "Basket weave"),
    AnimalPage("artKiteTiger", "Kite tiger", "Wind and paper"),
    AnimalPage("dolphin", "Leaping dolphin", "Motion"),
    AnimalPage("artLotusCrownTiger", "Lotus crown tiger", "Symmetry"),
    AnimalPage("artScarfTiger", "Scarf tiger", "Winter cub"),
    AnimalPage("artAuroraTiger", "Aurora tiger", "Polar sky"),
    AnimalPage("frog", "Tree frog", "Canopy"),
    AnimalPage("artArmadilloRoll", "Armadillo roll", "Armor study"),
    AnimalPage("artPrismBeetle", "Prism beetle", "Insect jewel"),
    AnimalPage("iguana", "Crested iguana", "Reptiles"),
    AnimalPage("artOrigamiTiger", "Origami tiger", "Paper folds"),
    AnimalPage("artTeacupTigerCub", "Teacup tiger cub", "Tiger cub miniature"),
    AnimalPage("duneTiger", "Sun disk tiger", "Motion"),
    AnimalPage("artCactusTiger", "Cactus tiger", "Desert print"),
    AnimalPage("artKiteFlyingTiger", "Kite-flying tiger", "Breezy day"),
    AnimalPage("giraffe", "Reticulated giraffe", "Pattern"),
    AnimalPage("artSunflowerTigerCub", "Sunflower tiger cub", "Garden portrait"),
    AnimalPage("artFlamingoArch", "Flamingo arch", "Wetland print"),
    AnimalPage("artHeronInReeds", "Heron in reeds", "Marsh poster"),
    AnimalPage("boar", "Wild boar", "Woodland"),
    AnimalPage("artEmbossedTiger", "Embossed tiger", "Metalwork"),
    AnimalPage("artTotemTiger", "Totem tiger", "Stacked shapes"),
    AnimalPage("penguin", "Penguin and chick", "Polar coast"),
    AnimalPage("artCherryBoughTiger", "Cherry bough tiger", "Spring print"),
    AnimalPage("artDrummingTiger", "Drumming tiger", "Festival cub"),
    AnimalPage("crocodile", "Crocodile", "Wetlands"),
    AnimalPage("artCompassTiger", "Compass tiger", "Navigation rose"),
    AnimalPage("artSailfinLizard", "Sailfin lizard", "Reptile print"),
    AnimalPage("macaw", "Long-tailed macaw", "Plumage")
]

struct PrintPaper<Content: View>: View {
    let title: String
    @ViewBuilder let canvas: () -> Content
    var body: some View {
        VStack(spacing: 0) {
            canvas().aspectRatio(1, contentMode: .fit)
            HStack {
                Text(title).font(.system(.headline, design: .monospaced, weight: .bold))
                Spacer()
                Image(systemName: "viewfinder").font(.caption)
            }.foregroundStyle(Color.ink(0x3F3041)).padding(.horizontal, 10).padding(.vertical, 5)
        }.padding(8).background(.white).overlay(Rectangle().strokeBorder(Color.ink(0xD6CFCA), lineWidth: 1))
    }
}

// MARK: - PrintShelf

struct PrintShelf: View {
    @ObservedObject var book: AnimalBook
    let choose: (AnimalPage) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var filter = "All stencils"
    @State private var query = ""

    private var matches: [AnimalPage] {
        book.pages.filter { page in
            let matches = query.isEmpty || (page.title + " " + page.subtitle).localizedCaseInsensitiveContains(query)
            let group = filter == "All stencils" || (filter == "Tigers" && page.title.localizedCaseInsensitiveContains("tiger"))
                || (filter == "My artwork" && !(book.works[page.id]?.active.isEmpty ?? true))
            return matches && group
        }
    }

    var body: some View {
        let pages = matches
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Sketchbook").font(.system(.largeTitle, weight: .black).width(.condensed)).tracking(-1.4)
                    Spacer()
                    Text(pages.count == 1 ? "1 stencil" : "\(pages.count) stencils")
                        .font(.caption.monospacedDigit()).foregroundStyle(.secondary)
                        .accessibilityIdentifier("collectionCount")
                    Button { dismiss() } label: { Image(systemName: "xmark.circle.fill").font(.title2) }.accessibilityLabel("Close")
                }
                Text("Make a stencil from a photo").font(.headline)
                PhotoInput { data in choose(try await book.importPhoto(data)) }
                TextField("Find an animal", text: $query).textFieldStyle(.roundedBorder).autocorrectionDisabled().submitLabel(.search)
                Picker("Show stencils", selection: $filter) {
                    ForEach(["All stencils", "Tigers", "My artwork"], id: \.self) { Text($0) }
                }.pickerStyle(.segmented)
                if pages.isEmpty {
                    ContentUnavailableView(query.isEmpty ? "No artwork yet" : "No matching animals", systemImage: "paintbrush", description: Text(query.isEmpty ? "Choose a stencil and add your first brushstroke." : "Try a different animal or collection."))
                }
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 134), spacing: 12)], spacing: 15) {
                    ForEach(pages) { page in
                        Button { choose(page) } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                if let sheet = book.sheet(page.id) {
                                    AnimalCanvas(sheet: sheet, painting: book.works[page.id] ?? Painting()).padding(5)
                                        .background(.white).overlay(Rectangle().strokeBorder(Color.gray.opacity(0.22)))
                                }
                                Text(page.title).font(.system(.subheadline, design: .monospaced, weight: .semibold))
                            }
                        }.buttonStyle(.plain).accessibilityIdentifier("page-" + page.id)
                    }
                }
            }.padding(20).padding(.top, 10).frame(maxWidth: 680).frame(maxWidth: .infinity)
        }.background(Color.ink(0x191C29))
    }
}

// MARK: - PressStudio

struct PressStudio: View {
    @ObservedObject var book: AnimalBook
    @AppStorage("brush.page") private var pageID = "monarch"
    @AppStorage("brush.ink") private var ink = 0xe87332
    @AppStorage("brush.width") private var width = 0.065
    @AppStorage("brush.stayInside") private var stayInside = true
    @State private var shelf = false
    @State private var erasing = false
    @State private var live: PenLine?
    @State private var clear = false
    private var page: AnimalPage { book.pages.first { $0.id == pageID } ?? book.originals[0] }
    private var work: Painting { book.works[page.id] ?? Painting() }

    private let accent = Color.ink(0xDEFC65)
    private let bench = Color.ink(0x191C29)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .center) {
                    Text("TIGER\nPRESS")
                        .font(.system(size: 38, weight: .black, design: .default).width(.condensed))
                        .lineSpacing(-8).fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Button { shelf = true } label: {
                        Label("Sketchbook", systemImage: "square.grid.2x2.fill")
                            .font(.subheadline.bold()).padding(12).background(accent).foregroundStyle(bench)
                    }.buttonStyle(.plain).accessibilityIdentifier("sketchbook")
                    if let sheet = book.sheet(page.id) {
                        ExportArt(name: page.title) {
                            PrintPaper(title: page.title) { AnimalCanvas(sheet: sheet, painting: work) }
                        }.labelStyle(.iconOnly).frame(minWidth: 44, minHeight: 44)
                    }
                }
                Divider().overlay(accent)
                if let sheet = book.sheet(page.id) {
                    HStack(alignment: .top, spacing: 10) {
                        toolRail
                        poster(sheet: sheet).frame(maxWidth: .infinity)
                    }
                }
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("INK").font(.headline.monospaced())
                        Spacer()
                        Text(InksPanel.colors.first(where: { $0.1 == ink })?.0 ?? "").font(.subheadline)
                    }
                    InksPanel(ink: Binding(get: { ink }, set: { ink = $0; erasing = false }))
                    Divider()
                    HStack {
                        Text("Brush size").font(.subheadline.bold())
                        Slider(value: $width, in: 0.012...0.17).accessibilityLabel("Brush size")
                    }
                    Toggle("Stay inside the lines", isOn: $stayInside).font(.subheadline)
                }.padding(16).background(Color.ink(0x292D3C))
            }.padding(16).frame(maxWidth: 800).frame(maxWidth: .infinity)
        }.background(bench).foregroundStyle(.white).tint(accent)
        .sheet(isPresented: $shelf) {
            PrintShelf(book: book) { chosen in pageID = chosen.id; live = nil; shelf = false }
                .presentationDragIndicator(.visible)
        }.confirmationDialog("Clear the artwork?", isPresented: $clear, titleVisibility: .visible) {
            Button("Clear artwork", role: .destructive) { book.change(page.id) { $0.append(.clear) } }
            Button("Cancel", role: .cancel) {}
        }
    }
    private var toolRail: some View {
        VStack(spacing: 4) {
            tool("Brush", "paintbrush.pointed.fill", selected: !erasing) { erasing = false }
            tool("Eraser", "eraser.fill", selected: erasing) { erasing = true }
            Divider().overlay(Color.gray)
            tool("Undo", "arrow.uturn.backward") { book.change(page.id) { $0.cursor -= 1 } }
                .disabled(work.cursor == 0)
            tool("Redo", "arrow.uturn.forward") { book.change(page.id) { $0.cursor += 1 } }
                .disabled(work.cursor >= work.edits.count)
            tool("Clear artwork", "trash") { clear = true }.disabled(work.active.isEmpty)
        }.frame(width: 44)
    }

    private func tool(_ name: String, _ symbol: String, selected: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol).frame(width: 44, height: 44)
                .background(selected ? accent : Color.ink(0x292D3C))
                .foregroundStyle(selected ? bench : Color.white)
        }.buttonStyle(.plain).accessibilityLabel(name)
    }

    private func poster(sheet: ArtSheet) -> some View {
        PrintPaper(title: page.title) {
            GeometryReader { geo in
                AnimalCanvas(sheet: sheet, painting: work, live: live)
                    .contentShape(Rectangle())
                    .highPriorityGesture(DragGesture(minimumDistance: 0).onChanged { event in
                        let p = CGPoint(x: max(0,min(1,event.location.x/geo.size.width)), y: max(0,min(1,event.location.y/geo.size.height)))
                        if live == nil {
                            live = PenLine(points: [p], width: width, ink: erasing ? nil : ink, region: stayInside ? sheet.region(p) : nil)
                        } else if let prev = live?.points.last, hypot(p.x-prev.x,p.y-prev.y) > 0.002 {
                            live?.points.append(p)
                        }
                    }.onEnded { _ in
                        guard let line = live else { return }
                        live = nil
                        book.change(page.id) { $0.append(.line(line)) }
                    })
                    .accessibilityElement(children: .ignore).accessibilityLabel("Drawing canvas").accessibilityIdentifier("canvas")
            }.aspectRatio(1, contentMode: .fit)
        }
    }
}
