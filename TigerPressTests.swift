import XCTest

final class TigerPressTests: XCTestCase {
    func testBrushEraseUndoRestoreAndExport() {
        continueAfterFailure = false
        let app = XCUIApplication(); app.launch()
        let home = XCTAttachment(screenshot: app.screenshot())
        home.name = "Start screen"
        home.lifetime = .keepAlways
        add(home)

        app.buttons["sketchbook"].tap()
        app.buttons["page-fox"].tap()
        let canvas = app.descendants(matching: .any)["canvas"].firstMatch
        XCTAssertTrue(canvas.waitForExistence(timeout: 4))
        app.buttons["Tangerine"].tap()
        let before = canvas.screenshot().pngRepresentation
        let p = canvas.coordinate(withNormalizedOffset: CGVector(dx: 0.47, dy: 0.61))
        let q = canvas.coordinate(withNormalizedOffset: CGVector(dx: 0.61, dy: 0.55))
        p.press(forDuration: 0.10, thenDragTo: q)
        XCTAssertTrue(app.buttons["Undo"].isEnabled)
        XCTAssertNotEqual(before, canvas.screenshot().pngRepresentation)
        app.buttons["Undo"].tap()
        XCTAssertFalse(app.buttons["Undo"].isEnabled)
        app.buttons["Redo"].tap()
        app.buttons["Eraser"].tap()
        p.tap()
        app.buttons["Undo"].tap()
        app.terminate(); app.launch()
        XCTAssertTrue(app.staticTexts["Fox in the brush"].exists)
        XCTAssertTrue(app.buttons["Undo"].isEnabled)
        app.buttons["sketchbook"].tap()
        app.buttons["My artwork"].tap()
        XCTAssertTrue(app.buttons["page-fox"].exists)
        app.buttons["page-fox"].tap()
        let shot = XCTAttachment(screenshot: app.screenshot()); shot.name = "Brush studio"; shot.lifetime = .keepAlways; add(shot)
        saveToPhotos(app)
    }

    func testPhotoStencil() {
        continueAfterFailure = false
        let app = XCUIApplication(); app.launch()
        app.buttons["sketchbook"].tap()
        #if targetEnvironment(simulator)
        app.buttons["camera"].tap()
        XCTAssertTrue(app.alerts["Camera and photos"].exists)
        app.buttons["OK"].tap()
        #endif
        pickLibraryPhoto(app)
        XCTAssertTrue(app.staticTexts["Photo study 1"].waitForExistence(timeout: 10), app.debugDescription)
        let canvas = app.descendants(matching: .any)["canvas"].firstMatch
        canvas.coordinate(withNormalizedOffset: CGVector(dx: 0.4,dy: 0.5)).tap()
        XCTAssertTrue(app.buttons["Undo"].isEnabled)
    }
    func testExpandedTigerSelection() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        app.buttons["sketchbook"].tap()
        app.buttons["Tigers"].tap()
        XCTAssertEqual(app.staticTexts["collectionCount"].label, "60 stencils")
        let search = app.textFields["Find an animal"]
        search.tap()
        search.typeText("wind vane\n")
        let result = app.buttons["page-artTigerWindVane"]
        XCTAssertTrue(result.waitForExistence(timeout: 5))
        result.tap()
        let canvas = app.descendants(matching: .any)["canvas"].firstMatch
        XCTAssertTrue(canvas.waitForExistence(timeout: 5))
        app.buttons["Tangerine"].tap()
        let before = canvas.screenshot().pngRepresentation
        canvas.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        XCTAssertNotEqual(canvas.screenshot().pngRepresentation, before)
        XCTAssertTrue(app.buttons["Undo"].isEnabled)
        app.buttons["Undo"].tap()
    }

    func testSearchAndTigerCollection() {
        continueAfterFailure = false
        let app = XCUIApplication(); app.launch()
        app.buttons["sketchbook"].tap()
        let query = app.textFields["Find an animal"]
        query.tap()
        query.typeText("macaw\n")
        XCTAssertTrue(app.buttons["page-macaw"].waitForExistence(timeout: 4))
        app.buttons["Tigers"].tap()
        XCTAssertTrue(app.staticTexts["No matching animals"].exists || app.staticTexts["No matching animals."].exists)
    }

    private func pickLibraryPhoto(_ app: XCUIApplication) {
        app.buttons["photoLibrary"].tap()
        let thumbnail = app.images.matching(NSPredicate(format: "label BEGINSWITH[c] %@", "Photo,")).firstMatch
        XCTAssertTrue(thumbnail.waitForExistence(timeout: 10), app.debugDescription)
        thumbnail.tap()
    }

    private func saveToPhotos(_ app: XCUIApplication) {
        app.buttons["export"].tap()
        app.buttons["Save to Photos"].tap()
        XCTAssertTrue(app.staticTexts["Your artwork was saved to Photos."].waitForExistence(timeout: 9), app.debugDescription)
        app.buttons["OK"].tap()
    }
}
