import XCTest

class DesafioModalUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        XCUIDevice.shared.orientation = .portrait

        // Since UI tests are more expensive to run, it's usually a good idea
        // to exit if a failure was encountered
        continueAfterFailure = true

        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state

    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of
        // each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure
        // occurs.
        continueAfterFailure = true

        // In UI tests it’s important to set the initial state - such as
        // interface orientation - required for your tests before they run. The
        // setUp method is a good place to do this.

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of
        // each test method in the class.

        try super.tearDownWithError()
    }

    func testFilterAdditionAndRemoval() throws {

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")

        app.launch()

        app.navigationBars["desafio_modal.View"].buttons["Add"].tap()
        app.buttons["SEGUIDORES"].tap()
        app.buttons["ESTRELAS"].staticTexts["ESTRELAS"].tap()
        app.buttons["DECRESCENTE"].tap()

        app.navigationBars["desafio_modal.FilterView"].buttons["Back"].tap()
        app.buttons["Estrelas"].tap()
        app.buttons["Seguidores"].tap()
        app.buttons["Data"].tap()
        app.buttons["Decrescente"].tap()

    }

    func testNavigationToFilterSection() throws {
        // UI tests must launch the application that they test.
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")

        app.launch()

        let toFiltersButton = app.navigationBars["desafio_modal.View"].buttons["Add"]
        toFiltersButton.tap()

        XCTAssertFalse(toFiltersButton.exists)

        let backToHome = app.navigationBars["desafio_modal.FilterView"].buttons["Back"]

        backToHome.tap()

        XCTAssertFalse(backToHome.exists)
        // Use recording to get started writing UI tests.

        // Use XCTAssert and related functions to verify your tests produce the
        // correct results.
    }
}
