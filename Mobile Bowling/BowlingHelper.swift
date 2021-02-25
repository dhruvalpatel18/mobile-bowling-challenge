//
//  BowlingHelper.swift
//  Mobile Bowling
//
//  Created by Dhruval Patel on 12/24/20.
//

import Foundation

class BowlingHelper {
    
    var currentFrameNum = 1
    private var frameList = [Frame]()
    var firstChance = true
    var thirdChanceRequired = false
    var firstChanceScore: String?
    var xBackLog = 0
    var slashBacklog = false
    var willGameOver = false
    var isGameOver = false
    
    func onBowling(manual: Bool, manualInput: String) -> [Frame] {
        let currentScore = getBowlingResult(manual: manual, manualInput: manualInput)

        frameList[frameList.count - 1].score.append(currentScore)
        
        if firstChance, currentScore == "X" {
            print("", terminator: " ")
            if currentFrameNum != 10 {
                frameList[frameList.count - 1].score.append("")
            }
            xBackLog += 1
            if xBackLog > 2 {
                xBackLog -= 1
                updateFrameList(frameListIndex: frameList.count - 3, plus: "X", alsoAdd: "X")
            } else if slashBacklog {
                updateOnSlashBacklog(currentScore: currentScore)
            }
            
        } else {
            if !firstChance {
                while xBackLog > 0, currentFrameNum != 10 {
                    let backlogInst = xBackLog + 1
                    updateFrameList(frameListIndex: frameList.count - backlogInst, plus: frameList[frameList.count - xBackLog].score[0], alsoAdd: currentScore)
                    xBackLog -= 1
                }
                if currentFrameNum == 10, frameList[8].score.contains("X"), !willGameOver {
                    updateFrameList(frameListIndex: frameList.count - 2, plus: frameList[currentFrameNum - 1].score[0], alsoAdd: currentScore)
                }
                if currentScore == "/" {
                    slashBacklog = true
                } else if currentScore == "X" {
                    xBackLog += 1
                } else if frameList[currentFrameNum - 1].score[0] != "X" || willGameOver {
                    updateFrameList(frameListIndex: frameList.count - 1)
                }
            } else {
                if slashBacklog {
                    updateOnSlashBacklog(currentScore: currentScore)
                } else if xBackLog == 2 && currentScore != "X" {
                    xBackLog -= 1
                    updateFrameList(frameListIndex: frameList.count - 3, plus: "X", alsoAdd: currentScore)
                }
            }
        }
        
        if willGameOver {
            if frameList.count == 10 && currentScore == "X" {
                updateFrameList(frameListIndex: frameList.count - 1)
            }
            isGameOver = true
            return frameList
        }
        
        if frameList.count == 10 {
            updateVarIfLastFrame()
            if isGameOver {
                return frameList
            }
        } else {
            updateVarIfNotLastChance(currentScore: currentScore)
        }
        
        return frameList
    }
    
    func updateVarIfLastFrame() {
        if ((frameList[frameList.count - 1].score.contains("X")) || (frameList[frameList.count - 1].score.contains("/")) ) {
            thirdChanceRequired = true
        }
        
        if thirdChanceRequired, !firstChance {
            willGameOver = true
        }
        
        if !firstChance, !thirdChanceRequired {
            isGameOver = true
        }
        firstChance = false
    }
    
    func updateVarIfNotLastChance(currentScore: String) {
        if firstChance, currentScore == "X" {
            currentFrameNum += 1
        } else {
            if !firstChance {
                currentFrameNum += 1
            }
            firstChance = !firstChance
        }
    }
    
    func updateOnSlashBacklog(currentScore: String) {
        slashBacklog = false
        updateFrameList(frameListIndex: frameList.count - 2, plus: currentScore)
    }
    
    func getBowlingResult(manual: Bool, manualInput: String) -> String {
        let score = getPossibleResults().randomElement()!
        if firstChance {
            let frame = Frame(currentFrame: currentFrameNum)
            frameList.append(frame)
            firstChanceScore = !manual ? score : manualInput
        }

        print(!manual ? score : manualInput, terminator: " ")
        return !manual ? score : manualInput
    }
    
    func updateFrameList(frameListIndex: Int, plus: String = "", alsoAdd: String = "") {
        frameList[frameListIndex].frameScore = sum(score: frameList[frameListIndex].score, plus: plus, alsoAdd: alsoAdd)
        frameList[frameListIndex].cumScore = cumSum(cumSumOfFrameNum: frameListIndex + 1)
        print(frameList[frameListIndex].frameScore!, terminator: " ")
        print(frameList[frameListIndex].cumScore!)
    }
    
    func sum(score: [String], plus: String, alsoAdd: String) -> Int {
        var sum = 0
        var lasrScore = 0
        var newScore = score
        newScore.append(plus)
        newScore.append(alsoAdd)
        for sc in newScore {
            switch sc {
            case "/":
                lasrScore = 10 - lasrScore
            case "X":
                lasrScore = 10
            case "1":
                lasrScore = 1
            case "2":
                lasrScore = 2
            case "3":
                lasrScore = 3
            case "4":
                lasrScore = 4
            case "5":
                lasrScore = 5
            case "6":
                lasrScore = 6
            case "7":
                lasrScore = 7
            case "8":
                lasrScore = 8
            case "9":
                lasrScore = 9
            default:
                lasrScore = 0
            }
            sum += lasrScore
        }
        return sum
    }
    
    func cumSum(cumSumOfFrameNum: Int) -> Int {
        if cumSumOfFrameNum > 1 {
            return frameList[cumSumOfFrameNum - 2].cumScore! + (frameList[cumSumOfFrameNum - 1].frameScore)!
        } else {
            return (frameList[0].frameScore!)
        }
    }
    
    func resetGame() {
        currentFrameNum = 1
        frameList.removeAll()
        firstChance = true
        thirdChanceRequired = false
        xBackLog = 0
        slashBacklog = false
        willGameOver = false
        isGameOver = false
    }
    
    func getFrameScore(index: Int) -> String {
        var score = ""
        for i in 0..<frameList[index - 1].score.count {
            score.append("\(frameList[index - 1].score[i]) ")
        }
        return score
    }
    
    func getCumScore(index: Int) -> String {
        guard  let cumScore = frameList[index - 1].cumScore  else {
            return ""
        }
        return "\(String(cumScore))"
    }
    
    func updatePickerData() -> [String] {
        var pickerData: [String]!

        if currentFrameNum == 10 && !firstChance && thirdChanceRequired {
            pickerData = ["-", "X", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        } else {
            pickerData = getPossibleResults()
        }
        
        return pickerData
    }
    
    func getPossibleResults() -> [String] {
        
        var possibleResultArray: [String]!
        
        if firstChance {
            possibleResultArray = ["-", "X", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        } else {
            switch firstChanceScore {
            case "-":
                possibleResultArray = ["-", "X", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
            case "X":
                if currentFrameNum == 10 {
                    possibleResultArray = ["-", "X", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
                } else {
                    possibleResultArray = [""]
                }
            case "1":
                possibleResultArray = ["-", "/", "1", "2", "3", "4", "5", "6", "7", "8"]
            case "2":
                possibleResultArray = ["-", "/", "1", "2", "3", "4", "5", "6", "7"]
            case "3":
                possibleResultArray = ["-", "/", "1", "2", "3", "4", "5", "6"]
            case "4":
                possibleResultArray = ["-", "/", "1", "2", "3", "4", "5"]
            case "5":
                possibleResultArray = ["-", "/", "1", "2", "3", "4"]
            case "6":
                possibleResultArray = ["-", "/", "1", "2", "3"]
            case "7":
                possibleResultArray = ["-", "/", "1", "2"]
            case "8":
                possibleResultArray = ["-", "/", "1"]
            case "9":
                possibleResultArray = ["-", "/"]
            default:
                possibleResultArray = ["/"]
            }
        }
        
        return possibleResultArray
    }
}



