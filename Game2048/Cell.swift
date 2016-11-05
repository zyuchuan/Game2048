//
//  Cell.swift
//  Game2048
//
//  Created by Jack Zou on 16/5/22.
//  Copyright © 2016年 Jack Zou. All rights reserved.
//

import UIKit

protocol Mergeable {
    mutating func merge(_ other: Self)
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
    mutating func merge(_ other: Int) {
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
            return UIColor.red
            
        case 4:
            fallthrough
        case 64:
            fallthrough
        case 2048:
            return UIColor.yellow
            
        case 8:
            fallthrough
        case 128:
            return UIColor.orange
            
        case 16:
            fallthrough
        case 256:
            return UIColor.purple
            
        default:
            return UIColor.gray
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
            return UIColor.gray
        }
    }
}

enum CellStatus {
    case noChanges
    case merged
    case disappeared
}

struct Cell<T>: Mergeable, Presentable where T: Mergeable, T: Comparable, T: Creatable, T: Presentable {
    var value: T = T.create()
    var position: Position = Position.OutOfRange
    var status: CellStatus = .noChanges
    
    // MARK: Mergeable protocol
    mutating func merge(_ other: Cell) {
        value.merge(other.value)
        status = .merged
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
