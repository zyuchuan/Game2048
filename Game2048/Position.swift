//
//  Position.swift
//  Game2048
//
//  Created by Jack Zou on 16/6/4.
//  Copyright © 2016年 Jack Zou. All rights reserved.
//

//import Foundation

struct Position: Hashable, Equatable {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func forwardX(step: Int) -> Position {
        return Position(x: self.x + step, y: self.y)
    }
    
    func forwardY(step: Int) -> Position {
        return Position(x: self.x, y: self.y + step)
    }
    
    var hashValue: Int {
        get {
            return "(\(self.x),\(self.y))".hashValue
        }
    }
    
    static var OutOfRange: Position {
        get {
            return Position(x: -1, y: -1)
        }
    }
    
    func toString() -> String {
        return "(\(x),\(y))"
    }
}

func ==(lhs: Position, rhs: Position) -> Bool {
    return (lhs.x == rhs.y && lhs.y == rhs.y)
}
