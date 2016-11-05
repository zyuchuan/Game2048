//
//  Cell.swift
//  Game2048
//
//  Created by Jack Zou on 16/5/22.
//  Copyright © 2016年 Jack Zou. All rights reserved.
//

import UIKit

protocol Mergeable {
    mutating func merge(other: Self)
}

protocol Creatable {
    static func create() -> Self
}

protocol Presentable {
    var foregroundColor: UIColor {
        get
    }
    
    var backgroundColor: UIColor {
        get
    }
}

extension Int: Mergeable, Creatable, Presentable {
    mutating func merge(other: Int) {
        self += other
    }
    
    static func create() -> Int {
        return 2
    }
    
    var foregroundColor: UIColor {
        switch self {
        case 2:
            fallthrough
        case 32:
            fallthrough
        case 1024:
            return UIColor.redColor()
            
        case 4:
            fallthrough
        case 64:
            fallthrough
        case 2048:
            return UIColor.yellowColor()
            
        case 8:
            fallthrough
        case 128:
            return UIColor.orangeColor()
            
        case 16:
            fallthrough
        case 256:
            return UIColor.purpleColor()
            
        default:
            return UIColor.grayColor()
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case 2:
            fallthrough
        case 32:
            fallthrough
        case 1024:
            return UIColor(red: 238.0/255.0, green: 228.0/255.0, blue: 218.0/255.0, alpha: 1.0)
            
        case 4:
            fallthrough
        case 64:
            fallthrough
        case 2048:
            return UIColor(red: 236.0/255.0, green: 224.0/255.0, blue: 200.0/255.0, alpha: 1.0)
            
        case 8:
            fallthrough
        case 128:
            return UIColor(red: 242.0/255.0, green: 177.0/255.0, blue: 121.0/255.0, alpha: 1.0)
            
        case 16:
            fallthrough
        case 256:
            return UIColor(red: 245.0/255.0, green: 149.0/255.0, blue: 99.0/255.0, alpha: 1.0)
            
        default:
            return UIColor.grayColor()
        }
    }
}

enum CellStatus {
    case NoChanges
    case Merged
    case Disappeared
}

struct Cell<T where T: Mergeable, T: Comparable, T: Creatable, T: Presentable>: Mergeable, Presentable {
    var value: T = T.create()
    var position: Position = Position.OutOfRange
    var status: CellStatus = .NoChanges
    
    // MARK: Mergeable protocol
    mutating func merge(other: Cell) {
        value.merge(other.value)
        status = .Merged
    }
    
    // MARK: Presentable protocol
    
    var foregroundColor: UIColor {
        return value.foregroundColor
    }
    
    var backgroundColor: UIColor {
        return value.backgroundColor
    }
}

//protocol CellDelegate {
//    func getCellForPosition(position: Position) -> Cell<Int>?
//}
