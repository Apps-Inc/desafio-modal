import XCTest

class DesafioModalUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        // Since UI tests are more expensive to run, it's usually a good idea
        // to exit if a failure was encountered
        continueAfterFailure = false

        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of
        // each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure
        // occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as
        // interface orientation - required for your tests before they run. The
        // setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of
        // each test method in the class.
        try super.setUpWithError()
        continueAfterFailure = false

        app.launch()
    }

    func testFilterAdditionAndRemoval() throws {
                
        app.launch()

        let app = XCUIApplication()

        app.navigationBars["desafio_modal.View"].buttons["Add"].tap()
        app.buttons["SEGUIDORES"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["ESTRELAS"]/*[[".buttons[\"ESTRELAS\"].staticTexts[\"ESTRELAS\"]",".staticTexts[\"ESTRELAS\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["DECRESCENTE"].tap()


        app.navigationBars["desafio_modal.FilterView"].buttons["Back"].tap()
        app.buttons["Estrelas"].tap()
        app.buttons["Seguidores"].tap()
        app.buttons["Data"].tap()
        app.buttons["Decrescente"].tap()


    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        
        
        let app = XCUIApplication()
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
