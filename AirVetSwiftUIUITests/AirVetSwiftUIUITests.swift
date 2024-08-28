//
//  AirVetSwiftUIUITests.swift
//  AirVetSwiftUIUITests
//
//  Created by Jian Ma on 8/27/24.
//

import XCTest

final class AirVetSwiftUIUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Set up the application to be tested
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Clean up after tests
        app = nil
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAddTask() throws {
        // Given
        let taskName = "Test Task"
        let taskDescription = "This is a test task."
        
        // When
        app.navigationBars["Tasks"].buttons["Add"].tap()
        
        let nameField = app.textFields["Task Name"]
        XCTAssertTrue(nameField.exists)
        nameField.tap()
        nameField.typeText(taskName)
        
        let descriptionField = app.textFields["Task Description"]
        XCTAssertTrue(descriptionField.exists)
        descriptionField.tap()
        descriptionField.typeText(taskDescription)
        
        app.buttons["Save"].tap()
        
        // Then
        let taskCell = app.staticTexts[taskName]
        XCTAssertTrue(taskCell.exists)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
