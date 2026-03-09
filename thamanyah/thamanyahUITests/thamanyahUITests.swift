//
//  thamanyahUITests.swift
//  thamanyahUITests
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import XCTest

final class thamanyahUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Test: Home Screen Loading
    func testHomeScreenLoads() throws {
        // Verify that the app launches and home screen loads
        
        // Wait for any scroll view or content to appear (indicates home screen loaded)
        let scrollView = app.scrollViews.firstMatch
        let loadExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == true"),
            object: scrollView
        )
        wait(for: [loadExpectation], timeout: 10.0)
        
        // Verify scroll view exists
        XCTAssertTrue(scrollView.exists, "Home screen scroll view should exist")
    }
    
    // MARK: - Test: Search Navigation
    
    func testNavigateToSearch() throws {
        // Test opening search screen
        
        sleep(2)
        // Look for search button or icon in navigation
        // Try different possible search elements
        let searchButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'search' OR identifier CONTAINS[c] 'search'")).firstMatch
        
        if searchButton.exists {
            // Tap search button
            searchButton.tap()
            
            // Wait for search screen to appear
            sleep(1)
            
            // Verify search interface appears (search bar or search field)
            let searchBar = app.searchFields.firstMatch
            let searchTextField = app.textFields.firstMatch
            
            let searchExists = searchBar.exists || searchTextField.exists
            XCTAssertTrue(searchExists, "Search interface should appear")
        }
    }
    
    // MARK: - Test: Home Screen Elements
    
    func testHomeScreenHasContent() throws {
        // Verify home screen has some content
        
        // Wait for loading to complete
        sleep(3)
        
        // Check if there are any static texts (section titles, content titles, etc.)
        let staticTexts = app.staticTexts.allElementsBoundByIndex
        
        // Should have at least some text content
        XCTAssertGreaterThan(staticTexts.count, 0, "Home screen should have some text content")
    }
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
