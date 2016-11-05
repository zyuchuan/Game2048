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
    private var cells: [Cell<Int>?]
    private var mergedCells: [Cell<Int>?]
    
    // MARK: Public properties
    let numRows: Int
    let numCols: Int
    
    var delegate: GameBoardDelegate? = nil
    
    // MARK: Initializers
    init(rows: Int, cols: Int) {
        self.numRows = rows
        self.numCols = cols
        
        let count = numRows * numCols
        cells = Array(count: count, repeatedValue: nil)
        mergedCells = Array(count: count, repeatedValue: nil)
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
    
    func cellAt(row row: Int, col: Int) -> Cell<Int>? {
        return self[row, col]
    }
    
    func cellAtPosition(postion: Position) -> Cell<Int>? {
        return self[postion]
    }
    
    private func mergedCellAt(row row: Int, col: Int) -> Cell<Int>? {
        return mergedCells[(row * numCols) + col]
    }
    
    private func mergedCellAtPosition(position: Position) -> Cell<Int>? {
        return mergedCellAt(row: position.x, col: position.y)
    }
    
    private mutating func setMergedCell(cell: Cell<Int>?, at position: Position) {
        mergedCells[position.x * numCols + position.y] = cell
    }
    
    mutating func clean() {
        let count = numRows * numCols
        cells = Array(count: count, repeatedValue: nil)
        mergedCells = Array(count: count, repeatedValue: nil)
    }
    
    // MARK: Finger swipte handlers
    
    mutating func swipeDown() {
        prepareForSwipe()
        delegate?.onGameBoardBeginSwipe(.Down)
        for col in 0..<numCols {
            for row in (0...numRows - 2).reverse() {
                let from = Position(x: row, y: col)
                let to = moveDownCellFrom(from)
                if from.x != to.x {
                    // noify cell move
                    delegate?.onGameBoardCellMove(self[to]!, from: from, to: to)
                }
            }
        }

        delegate?.onGameBoardEndSwipe(.Down)
    }
    
    mutating func swipeUp() {
        prepareForSwipe()
        delegate?.onGameBoardBeginSwipe(.Up)
        for col in 0..<numCols {
            for row in 1..<numRows {
                let from = Position(x: row, y: col)
                let to = moveUpCellFrom(from)
                if (from.x != to.x) {
                    delegate?.onGameBoardCellMove(self[to]!, from: from, to: to)
                }
            }
        }
        
        delegate?.onGameBoardEndSwipe(.Down)
        
    }
    
    mutating func swipeLeft() {
        prepareForSwipe()
        delegate?.onGameBoardBeginSwipe(.Left)
        for row in 0..<numRows {
            for col in 1..<numCols {
                let from = Position(x: row, y: col)
                let to = moveLeftCellFrom(from)
                if (from.y != to.y) {
                    delegate?.onGameBoardCellMove(self[to]!, from: from, to: to)
                }
            }
        }
        delegate?.onGameBoardEndSwipe(.Left)
    }
    
    mutating func swipeRight() {
        prepareForSwipe()
        delegate?.onGameBoardBeginSwipe(.Right)
        for row in 0..<numRows {
            for col in (0...(numCols - 2)).reverse() {
                let from = Position(x: row, y: col)
                let to = moveRightCellFrom(from)
                if from.y != to.y {
                    delegate?.onGameBoardCellMove(self[to]!, from: from, to: to)
                }
            }
        }
        
        delegate?.onGameBoardEndSwipe(.Right)
    }
    
    func endSwipe() {
        for row in 0..<numRows {
            for col in 0..<numCols {
                let position = Position(x: row, y: col)
                if let cell = self[position] {
                    if cell.status == .Merged {
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
        newCell.status = .NoChanges
        self[pos] = newCell
        
        delegate?.onGameBoardCreateNewCell(newCell, atPostion: pos)
        
        return true
    }
    
    func getForegroundColorFor(row row: Int, col: Int) -> UIColor {
        if let c = self[row, col] {
            return c.foregroundColor
        }
        
        return UIColor.grayColor()
    }
    
    func getBackgroundColorFor(row row: Int, col: Int) -> UIColor {
        if let c = self[row, col] {
            return c.backgroundColor
        }
        
        return UIColor(red: 204.0/255.0, green: 192.0/255.0, blue: 178.0/255.0, alpha: 1.0)
    }
    
    func getValueFor(row row: Int, col: Int) -> Int? {
        if let c = self[row, col] {
            return c.value
        }
        
        return nil
    }
    
    // MARK: Private methods
    
    private func positionOutOfBound(position: Position) -> Bool {
        return (position.x < 0 || position.x >= numRows || position.y < 0 || position.y >= numCols)
    }
    
    private mutating func moveCell(from from: Position, to: Position) -> Bool {
        
        if positionOutOfBound(to) { return false }
        
        var fromCell = self.cellAtPosition(from)!
        
        // Do not move merged cell
        if fromCell.status == .Merged { return false }
        
        if var toCell = self.cellAtPosition(to) {
            if toCell.value == fromCell.value && toCell.status == .NoChanges {
                fromCell.merge(toCell)
                fromCell.status = .Merged
                
                toCell.status = .Disappeared
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
    
    private mutating func moveDownCellFrom(position: Position) -> Position {
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
    
    private mutating func moveUpCellFrom(position: Position) -> Position {
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
    
    private mutating func moveLeftCellFrom(position: Position) -> Position {
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
    
    private mutating func moveRightCellFrom(position: Position) -> Position {
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
    
    private mutating func prepareForSwipe() {
        resetCells()
        cleanMergedCells()
    }
    
    private mutating func cleanMergedCells() {
        for i in 0..<mergedCells.count {
            mergedCells[i] = nil
        }
    }
    
    private mutating func resetCells() {
        for row in 0..<numRows {
            for col in 0..<numCols {
                if var cell = self[row, col] {
                    cell.position = Position(x: row, y: col)
                    cell.status = .NoChanges
                    self[row, col] = cell
                }
            }
        }
    }
}



