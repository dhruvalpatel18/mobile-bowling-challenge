//
//  Frame.swift
//  Mobile Bowling
//
//  Created by Dhruval Patel on 12/24/20.
//

import Foundation

struct Frame {
    public private(set) var frameNum: Int!
    var score = [String]()
    var frameScore: Int?
    var cumScore: Int?
    
    init(currentFrame: Int) {
        frameNum = currentFrame
    }
}
