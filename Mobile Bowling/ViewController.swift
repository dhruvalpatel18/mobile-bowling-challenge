//
//  ViewController.swift
//  Mobile Bowling
//
//  Created by Dhruval Patel on 12/24/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var input1: UILabel!
    @IBOutlet weak var input2: UILabel!
    @IBOutlet weak var input3: UILabel!
    @IBOutlet weak var input4: UILabel!
    @IBOutlet weak var input5: UILabel!
    @IBOutlet weak var input6: UILabel!
    @IBOutlet weak var input7: UILabel!
    @IBOutlet weak var input8: UILabel!
    @IBOutlet weak var input9: UILabel!
    @IBOutlet weak var input10: UILabel!
    
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var score3: UILabel!
    @IBOutlet weak var score4: UILabel!
    @IBOutlet weak var score5: UILabel!
    @IBOutlet weak var score6: UILabel!
    @IBOutlet weak var score7: UILabel!
    @IBOutlet weak var score8: UILabel!
    @IBOutlet weak var score9: UILabel!
    @IBOutlet weak var score10: UILabel!
    
    @IBOutlet weak var frame1: UILabel!
    @IBOutlet weak var frame2: UILabel!
    @IBOutlet weak var frame3: UILabel!
    @IBOutlet weak var frame4: UILabel!
    @IBOutlet weak var frame5: UILabel!
    @IBOutlet weak var frame6: UILabel!
    @IBOutlet weak var frame7: UILabel!
    @IBOutlet weak var frame8: UILabel!
    @IBOutlet weak var frame9: UILabel!
    @IBOutlet weak var frame10: UILabel!

    @IBOutlet weak var gameOverText: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var manualSwitch: UISwitch!
    @IBOutlet var resetButton: UIView!
    @IBOutlet var bowlButton: UIView!

    private var bowlingHelper: BowlingHelper!
    private var frameList = [Frame]()
    var pickerData = ["-", "X", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bowlingHelper = BowlingHelper()
        picker.delegate = self
        picker.dataSource = self
    }
    
    @IBAction func onBowlButttonClicked(_ sender: Any) {
        if !bowlingHelper.isGameOver {
            frameList = bowlingHelper.onBowling(manual: manualSwitch.isOn, manualInput: pickerData[picker.selectedRow(inComponent: 0)])
            if bowlingHelper.firstChance { updateFrameUI() }
            updateInputAndScoreUI()
        }
        updatePickerData()
    }
    
    func updatePickerData() {
        pickerData = bowlingHelper.updatePickerData()
        picker.reloadAllComponents()
    }
    
    func updateInputAndScoreUI() {
        var index = frameList.count
        while index > 0 {
            switch frameList[index - 1].frameNum {
            case 1:
                input1.text = bowlingHelper.getFrameScore(index: index)
                score1.text = bowlingHelper.getCumScore(index: index)
            case 2:
                input2.text = bowlingHelper.getFrameScore(index: index)
                score2.text = bowlingHelper.getCumScore(index: index)
            case 3:
                input3.text = bowlingHelper.getFrameScore(index: index)
                score3.text = bowlingHelper.getCumScore(index: index)
            case 4:
                input4.text = bowlingHelper.getFrameScore(index: index)
                score4.text = bowlingHelper.getCumScore(index: index)
            case 5:
                input5.text = bowlingHelper.getFrameScore(index: index)
                score5.text = bowlingHelper.getCumScore(index: index)
            case 6:
                input6.text = bowlingHelper.getFrameScore(index: index)
                score6.text = bowlingHelper.getCumScore(index: index)
            case 7:
                input7.text = bowlingHelper.getFrameScore(index: index)
                score7.text = bowlingHelper.getCumScore(index: index)
            case 8:
                input8.text = bowlingHelper.getFrameScore(index: index)
                score8.text = bowlingHelper.getCumScore(index: index)
            case 9:
                input9.text = bowlingHelper.getFrameScore(index: index)
                score9.text = bowlingHelper.getCumScore(index: index)
            case 10:
                input10.text = bowlingHelper.getFrameScore(index: index)
                score10.text = bowlingHelper.getCumScore(index: index)
                if bowlingHelper.isGameOver {
                    gameOverText.isHidden = false
                    resetButton.isHidden = false
                    bowlButton.isHidden = true
                }
            default:
                print("Out of index")
            }
            index -= 1
        }
    }
    
    func updateFrameUI() {
        switch bowlingHelper.currentFrameNum {
        case 1:
            frame1.textColor = .red
            frame10.textColor = .black
        case 2:
            frame2.textColor = .red
            frame1.textColor = .black
        case 3:
            frame3.textColor = .red
            frame2.textColor = .black
        case 4:
            frame4.textColor = .red
            frame3.textColor = .black
        case 5:
            frame5.textColor = .red
            frame4.textColor = .black
        case 6:
            frame6.textColor = .red
            frame5.textColor = .black
        case 7:
            frame7.textColor = .red
            frame6.textColor = .black
        case 8:
            frame8.textColor = .red
            frame7.textColor = .black
        case 9:
            frame9.textColor = .red
            frame8.textColor = .black
        case 10:
            frame10.textColor = .red
            frame9.textColor = .black
        default:
            print("Out of index")
        }
    }

    @IBAction func onResetButttonClicked(_ sender: Any) {
        gameOverText.isHidden = true
        resetButton.isHidden = true
        bowlButton.isHidden = false
        
        bowlingHelper.resetGame()
        
        input1.text = ""
        score1.text = ""
        input2.text = ""
        score2.text = ""
        input3.text = ""
        score3.text = ""
        input4.text = ""
        score4.text = ""
        input5.text = ""
        score5.text = ""
        input6.text = ""
        score6.text = ""
        input7.text = ""
        score7.text = ""
        input8.text = ""
        score8.text = ""
        input9.text = ""
        score9.text = ""
        input10.text = ""
        score10.text = ""
        updateFrameUI()
        updatePickerData()
    }
    
    @IBAction func onManualSwitchClicked(_ sender: UISwitch) {
        if sender.isOn {
            picker.isHidden = false
        } else {
            picker.isHidden = true
        }
    }
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
}
