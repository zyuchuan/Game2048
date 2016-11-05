//
//  GameBoard.swift
//  Game2048
//
//  Created by Jack Zou on 16/5/22.
//  Copyright © 2016年 Jack Zou. All rights reserved.
//

import UIKit

struct GameBoard {
    // MARK: Private properties
    fileprivate var cells: [Cell<Int>?]
    fileprivate var mergedCells: [Cell<Int>?]
    
    // MARK: Public properties
    let numRows: Int
    let numCols: Int
    
    var delegate: GameBoardDelegate? = nil
    
    // MARK: Initializers
    init(rows: Int, cols: Int) {
        self.numRows = rows
        self.numCols = cols
        
        let count = numRows * numCols
        cells = Array(repeating: nil, count: count)
        mergedCells = Array(repeating: nil, count: count)
    }
    
    // MARK: Locate cells
    subscript(row: Int, col: Int) -> Cell<Int>? {
        get {
            return cells[(row * numCols) + col]
        }
        
        set {
            cells[row * numCols + col] = newValue
        }
    }
    
    subscript(position: Position) -> Cell<Int>? {
        get {
            return self[position.x, position.y]
        }
        
        set {
            self[position.x, position.y] = newValue
        }
    }
    
    func cellAt(row: Int, col: Int) -> Cell<Int>? {
        return self[row, col]
    }
    
    func cellAtPosition(_ postion: Position) -> Cell<Int>? {
        return self[postion]
    }
    
    fileprivate func mergedCellAt(row: Int, col: Int) -> Cell<Int>? {
        return mergedCells[(row * numCols) + col]
    }
    
    fileprivate func mergedCellAtPosition(_ position: Position) -> Cell<Int>? {
        return mergedCellAt(row: position.x, col: position.y)
    }
    
    fileprivate mutating func setMergedCell(_ cell: Cell<Int>?, at position: Position) {
        mergedCells[position.x * numCols + position.y] = cell
    }
    
    mutating func clean() {
        let count = numRows * numCols
        cells = Array(repeating: nil, count: count)
        mergedCells = Array(repeating: nil, count: count)
    }
    
    // MARK: Finger swipte handlers
    
    mutating func swipeDown() {
        prepareForSwipe()
        delegate?.onGameBoardBeginSwipe(.down)
        for col in 0..<numCols {
            for row in (0...numRows - 2).reversed() {
                let from = Position(x: row, y: col)
                let to = moveDownCellFrom(from)
                if from.x != to.x {
                    // noify cell move
                    delegate?.onGameBoardCellMove(self[to]!, from: from, to: to)
                }
            }
        }

        delegate?.onGameBoardEndSwipe(.down)
    }
    
    mutating func swipeUp() {
        prepareForSwipe()
        delegate?.onGameBoardBeginSwipe(.up)
        for col in 0..<numCols {
            for row in 1..<numRows {
                let from = Position(x: row, y: col)
                let to = moveUpCellFrom(from)
                if (from.x != to.x) {
                    delegate?.onGameBoardCellMove(self[to]!, from: from, to: to)
                }
            }
        }
        
        delegate?.onGameBoardEndSwipe(.down)
        
    }
    
    mutating func swipeLeft() {
        prepareForSwipe()
        delegate?.onGameBoardBeginSwipe(.left)
        for row in 0..<numRows {
            for col in 1..<numCols {
                let from = Position(x: row, y: col)
                let to = moveLeftCellFrom(from)
                if (from.y != to.y) {
                    delegate?.onGameBoardCellMove(self[to]!, from: from, to: to)
                }
            }
        }
        delegate?.onGameBoardEndSwipe(.left)
    }
    
    mutating func swipeRight() {
        prepareForSwipe()
        delegate?.onGameBoardBeginSwipe(.right)
        for row in 0..<numRows {
            for col in (0...(numCols - 2)).reversed() {
                let from = Position(x: row, y: col)
                let to = moveRightCellFrom(from)
                if from.y != to.y {
                    delegate?.onGameBoardCellMove(self[to]!, from: from, to: to)
                }
            }
        }
        
        delegate?.onGameBoardEndSwipe(.right)
    }
    
    func endSwipe() {
        for row in 0..<numRows {
            for col in 0..<numCols {
                let position = Position(x: row, y: col)
                if let cell = self[position] {
                    if cell.status == .merged {
                        delegate?.onGameBoardCellMerged(cell, atPosition: position)
                    }
                }
            }
        }
    }
    
    // Public methods
    
    mutating func randomCreateNewCell() -> Bool {
        var empty: [Position] = []
        
        for row in 0..<numRows {
            for col in 0..<numCols {
                if self[row, col] == nil {
                    empty.append(Position(x: row, y: col))
                }
            }
        }
        
        guard !empty.isEmpty else { return false }
        
        let index = Int(arc4random()) % empty.count
        let pos = empty[index]
        var newCell = Cell<Int>()
        newCell.position = pos
        newCell.status = .noChanges
        self[pos] = newCell
        
        delegate?.onGameBoardCreateNewCell(newCell, atPostion: pos)
        
        return true
    }
    
    func getForegroundColorFor(row: Int, col: Int) -> UIColor {
        if let c = self[row, col] {
            return c.foregroundColor
        }
        
        return UIColor.gray
    }
    
    func getBackgroundColorFor(row: Int, col: Int) -> UIColor {
        if let c = self[row, col] {
            return c.backgroundColor
        }
        
        return UIColor(red: 204.0/255.0, green: 192.0/255.0, blue: 178.0/255.0, alpha: 1.0)
    }
    
    func getValueFor(row: Int, col: Int) -> Int? {
        if let c = self[row, col] {
            return c.value
        }
        
        return nil
    }
    
    // MARK: Private methods
    
    fileprivate func positionOutOfBound(_ position: Position) -> Bool {
        return (position.x < 0 || position.x >= numRows || position.y < 0 || position.y >= numCols)
    }
    
    fileprivate mutating func moveCell(from: Position, to: Position) -> Bool {
        
        if positionOutOfBound(to) { return false }
        
        var fromCell = self.cellAtPosition(from)!
        
        // Do not move merged cell
        if fromCell.status == .merged { return false }
        
        if var toCell = self.cellAtPosition(to) {
            if toCell.value == fromCell.value && toCell.status == .noChanges {
                fromCell.merge(toCell)
                fromCell.status = .merged
                
                toCell.status = .disappeared
                setMergedCell(toCell, at: toCell.position)
            }
            else {
                // can not move, do nothing
                return false
            }
        }
        
        self[to] = fromCell
        self[from] = nil
        return true
    }
    
    fileprivate mutating func moveDownCellFrom(_ position: Position) -> Position {
        guard self[position] != nil else { return position }
        
        // do not move last row
        guard position.x < (numRows - 1) else { return position }
        
        var from = position
        var to = from.forwardX(step: 1)
        while moveCell(from: from, to: to) {
            from = to
            to = to.forwardX(step: 1)
        }
        
        return from
    }
    
    fileprivate mutating func moveUpCellFrom(_ position: Position) -> Position {
        // do not move empty cell
        guard self[position] != nil else { return position}
        
        // do not move first row
        guard position.x > 0 else { return position }
        
        var from = position
        var to = from.forwardX(step: -1)
        while moveCell(from: from, to: to) {
            from = to
            to = to.forwardX(step: -1)
        }
        
        return from
    }
    
    fileprivate mutating func moveLeftCellFrom(_ position: Position) -> Position {
        guard self[position] != nil else {return position}
        
        // do not move first col
        guard position.y > 0 else { return position}
        
        var from = position
        var to = from.forwardY(step: -1)
        while moveCell(from: from, to: to) {
            from = to
            to = to.forwardY(step: -1)
        }
        
        return from
    }
    
    fileprivate mutating func moveRightCellFrom(_ position: Position) -> Position {
        guard self[position] != nil else {return position}
        
        guard position.y < numCols - 1 else { return position}
        
        var from = position
        var to = from.forwardY(step: 1)
        while moveCell(from: from, to: to) {
            from = to
            to = to.forwardY(step: 1)
        }
        
        return from
    }
    
    fileprivate mutating func prepareForSwipe() {
        resetCells()
        cleanMergedCells()
    }
    
    fileprivate mutating func cleanMergedCells() {
        for i in 0..<mergedCells.count {
            mergedCells[i] = nil
        }
    }
    
    fileprivate mutating func resetCells() {
        for row in 0..<numRows {
            for col in 0..<numCols {
                if var cell = self[row, col] {
                    cell.position = Position(x: row, y: col)
                    cell.status = .noChanges
                    self[row, col] = cell
                }
            }
        }
    }
}



