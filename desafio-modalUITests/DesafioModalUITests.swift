import XCTest

class DesafioModalUITests: XCTestCase {
    var app: XCUIApplication!

    override class func setUp() {
        super.setUp()
        XCUIDevice.shared.orientation = .portrait
    }

    override func setUp() {
        // Since UI tests are more expensive to run, it's usually a good idea
        // to exit if a failure was encountered
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    func testFilterAdditionAndRemoval() throws {
        app.navigationBars["Github"].buttons["Add"].tap()
        app.buttons["SEGUIDORES"].tap()
        app.buttons["ESTRELAS"].tap()
        app.buttons["DECRESCENTE"].tap()
    }

    func testNavigationToFilterSection() throws {
        let toFiltersButton = app.navigationBars["Github"].buttons["Add"]
        toFiltersButton.tap()
        XCTAssertFalse(toFiltersButton.exists)

        let backToHome = app.navigationBars["Filtrar"].buttons["Github"]
        backToHome.tap()
        XCTAssertFalse(backToHome.exists)
    }

    func test() throws {

    }
}
