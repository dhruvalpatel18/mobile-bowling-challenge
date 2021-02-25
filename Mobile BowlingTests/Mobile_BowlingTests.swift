//
//  Mobile_BowlingTests.swift
//  Mobile BowlingTests
//
//  Created by Dhruval Patel on 12/24/20.
//

import XCTest
@testable import Mobile_Bowling

class Mobile_BowlingTests: XCTestCase {
    var bowlingHelper: BowlingHelper!
    var frameList: [Frame]!
    
    override func setUpWithError() throws {
        bowlingHelper = BowlingHelper()
        frameList = [Frame]()
    }

    override func tearDownWithError() throws {
        bowlingHelper = nil
        frameList = nil
    }

    func testResettGame() throws {
        bowlingHelper.slashBacklog = true
        bowlingHelper.resetGame()
        XCTAssertFalse(bowlingHelper.slashBacklog)
    }
    
    func testAllXInput() throws {
        for _ in 0..<12 {
            frameList = bowlingHelper.onBowling(manual: true, manualInput: "X")
        }
        XCTAssertEqual(frameList[frameList.count - 1].cumScore, 300, "Test Failed")
    }
    
    func testInputExample() throws {
        let input = ["X", "7", "/", "9", "-", "X", "-", "8", "8", "/", "-", "6" ,"X" , "X", "X", "8", "1"]
        for inputValue in input {
            frameList = bowlingHelper.onBowling(manual: true, manualInput: inputValue)
        }
        
        XCTAssertTrue(bowlingHelper.isGameOver)
        XCTAssertEqual(frameList.count, 10, "Game is not over yet")
        XCTAssertEqual(frameList[frameList.count - 1].cumScore, 167, "Test Failed")
    }
    
    func testGameNotOver() throws {
        let input = ["X", "7", "/", "9", "-", "X", "-", "8", "8", "/", "-", "6"]
        for inputValue in input {
            frameList = bowlingHelper.onBowling(manual: true, manualInput: inputValue)
        }
        
        XCTAssertFalse(bowlingHelper.isGameOver, "Game over")
        XCTAssertNotEqual(frameList.count, 10, "Game Over")
    }
    
    func testOverPlayed() throws {
        let input = ["X", "7", "/", "9", "-", "X", "-", "8", "8", "/", "-", "6" ,"X" , "X", "-", "8", "1", "5"]
        for inputValue in input {
            frameList = bowlingHelper.onBowling(manual: true, manualInput: inputValue)
        }
        var gameOverPlayed = false
        if (frameList.last?.score.count)! > 3 {
            gameOverPlayed = true
        } else if (frameList.last?.score.count)! == 3 {
            let arr = [frameList.last?.score[0], frameList.last?.score[1]]
            if !(arr.contains("X") || arr.contains("/")) {
                gameOverPlayed = true
            }
        }
        XCTAssertTrue(gameOverPlayed, "Game Not Over Played")
    }
    
    func testRandomExample() throws {
        let input = ["X", "7", "/", "9", "-", "X", "-", "8", "8", "/", "-", "6" ,"X" , "X", "X", "8", "X"]
        for inputValue in input {
            frameList = bowlingHelper.onBowling(manual: true, manualInput: inputValue)
        }
        
        XCTAssertTrue(bowlingHelper.isGameOver)
        XCTAssertEqual(frameList.count, 10, "Game is not over yet")
        XCTAssertEqual(frameList[frameList.count - 1].cumScore, 176, "Test Failed")
    }
    
    func testValidateInput() throws {
        let input = ["X", "7", "/", "9", "-", "X", "-", "8", "8", "/", "-", "6" ,"X" , "X", "X", "8", "X"]
        for (index, inputValue) in input.enumerated() {
            let possibleInput = bowlingHelper.getPossibleResults()
            let validInput = possibleInput.contains(inputValue)
            XCTAssertTrue(validInput, "Invalid Input Sequence Number: \(index + 1) , Input Value: \(inputValue)")
            frameList = bowlingHelper.onBowling(manual: true, manualInput: inputValue)
        }
        
        bowlingHelper.resetGame()
        
        let invalidInputArray = ["X", "7", "/", "9", "-", "/", "-", "8", "8", "/", "-", "6" ,"X" , "X", "X", "8", "X"]
        var hasInvalidInput = false
        for (index, inputValue) in invalidInputArray.enumerated() {
            let possibleInput = bowlingHelper.getPossibleResults()
            let validInput = possibleInput.contains(inputValue)
            if !validInput {
                hasInvalidInput = true
                print("Invalid Input Sequence Number: \(index + 1) , Input Value: \(inputValue)")
                break
            }
            frameList = bowlingHelper.onBowling(manual: true, manualInput: inputValue)
        }
        XCTAssertTrue(hasInvalidInput, "invalidInputArray has valid input values")
    }
    
    func testPerformanceExample() throws {
        self.measure {
            let input = ["X", "7", "/", "9", "-", "X", "-", "8", "8", "/", "-", "6" ,"X" , "X", "X", "8", "X"]
            for inputValue in input {
                frameList = bowlingHelper.onBowling(manual: true, manualInput: inputValue)
            }
        }
    }

}

