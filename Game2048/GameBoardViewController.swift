//
//  gameBoardViewController.swift
//  Game2048
//
//  Created by Jack Zou on 16/5/28.
//  Copyright © 2016年 Jack Zou. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController, GameBoardDelegate, GameBoardViewDelegate {
    
    var gameBoard = GameBoard(rows: 4, cols: 4)
    var gameboardView: GameBoardView!
    
    override func viewDidLoad() {
        gameBoard.delegate = self
        
        let width = self.view.bounds.width - 20
        gameboardView = GameBoardView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        gameboardView.layer.masksToBounds = true
        gameboardView.layer.cornerRadius = 10.0
        gameboardView.delegate = self
        self.view.addSubview(gameboardView)
        
        let _ = gameBoard.randomCreateNewCell()
        
        let swipeDownRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameBoardViewController.handleSwipe(_:)))
        swipeDownRecognizer.direction = .down
        self.gameboardView.addGestureRecognizer(swipeDownRecognizer)
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameBoardViewController.handleSwipe(_:)))
        swipeUpRecognizer.direction = .up
        self.gameboardView.addGestureRecognizer(swipeUpRecognizer)

        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameBoardViewController.handleSwipe(_:)))
        swipeLeftRecognizer.direction = .left
        self.gameboardView.addGestureRecognizer(swipeLeftRecognizer)
        
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameBoardViewController.handleSwipe(_:)))
        swipeRightRecognizer.direction = .right
        self.gameboardView.addGestureRecognizer(swipeRightRecognizer)
        
    }
    
    func newGame() {
        gameBoard.clean()
        gameboardView.clean()
        
        let _ = gameBoard.randomCreateNewCell()
    }
    
    func handleSwipe(_ recognizer: UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case UISwipeGestureRecognizerDirection.up:
            gameBoard.swipeUp()
            
        case UISwipeGestureRecognizerDirection.down:
            gameBoard.swipeDown()
            
        case UISwipeGestureRecognizerDirection.left:
            gameBoard.swipeLeft()
            
        case UISwipeGestureRecognizerDirection.right:
            gameBoard.swipeRight()
            
        default:
            ()
        }
    }
    
    // MARK: GameBoarViewdDelegate methods
    
    func getNumberOfRows() -> Int {
        return gameBoard.numRows
    }
    
    func getNumberOfColumns() -> Int {
        return gameBoard.numCols
    }
    
    func getGameBoardBackgroundColor() -> UIColor {
        return UIColor(red: 184.0/255.0, green: 175.0/255.0, blue: 158.0/255.0, alpha: 1.0)
    }
    
    func getCellBackgroundColor() -> UIColor {
        return 0.backgroundColor
    }
    
    func getInsetX() -> Float {
        return 10.0
    }
    
    func getInsetY() -> Float {
        return 10.0
    }
    
    func getCellSpaceX() -> Float {
        return 10.0
    }
    func getCellSpaceY() -> Float {
        return 10.0
    }
    
    func onGameBoardViewDidSwipe() {
        gameBoard.endSwipe()
        let _ = gameBoard.randomCreateNewCell()
    }
    
    
    // MARK: GameBoardDelegate methods
    
    func onGameBoardCreateNewCell(_ cell: Cell<Int>, atPostion position: Position) {
        gameboardView.createNewCellViewForCell(cell, atPosition: position)
    }
    
    func onGameBoardBeginSwipe(_ direction: SwipeDirection) {
        gameboardView.beginSwipe(direction)
    }
    
    func onGameBoardEndSwipe(_ direction: SwipeDirection) {
        gameboardView.endSwipe(direction)
    }
    
    func onGameBoardCellMove(_ cell: Cell<Int>, from: Position, to: Position) {
        gameboardView.moveCellViewForCell(cell, from: from, to: to)
    }
    
    func onGameBoardCellMerged(_ cell: Cell<Int>, atPosition position: Position) {
        gameboardView.updateCellViewForCell(cell, atPosition: position)
    }
    
    // MARK: Private methods
    
//    private func animateCellViewFor(cell: Cell<Int>, cellView: CellView, from: Position, to: Position) {
//        let newRect =  gameboardView.getRectFor(row: to.x, col: to.y)
//        
//        // animate cell
//        self.gameboardView.bringSubviewToFront(cellView)
//        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
//            cellView.frame.origin = newRect.origin
//        }){ (finished: Bool) in
//            if (finished) && cell.status == .Merged {
//                cellView.backgroundColor = cell.backgroundColor
//                cellView.textLabel.textColor = cell.foregroundColor
//                cellView.textLabel.text = String(cell.value)
//            }
//        }
//        
//        // animate disappeared cell
//        if let disappearedCell = gameBoard.mergedCellAtPosition(to) {
//            if disappearedCell.position != to {
//                if let disappearedCellView = cellViews[disappearedCell.position.toString()] {
//                    UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
//                        disappearedCellView.frame.origin = newRect.origin
//                    }){ (finished: Bool) in
//                        if (finished) {
//                            self.gameboardView.sendSubviewToBack(disappearedCellView)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
//    private func redrawGameBoard(rows rows: Array<Int>, cols: Array<Int>) {
//        UIView.beginAnimations("Animation_MoveCell", context: nil)
//        UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
//        UIView.setAnimationDelay(0.0)
//        UIView.setAnimationDuration(0.3)
//        UIView.setAnimationDelegate(self)
//        UIView.setAnimationDidStopSelector(#selector(GameBoardViewController.MoveCellDidStop(_:context:)))
//        
//        for row in rows {
//            for col in cols {
//                
//                if let cell = gameBoard[row, col] {
//                    if cell.position.x != row || cell.position.y != col {
//                        let fromPos = cell.position
//                        let toPos = Position(x: row, y: col)
//                        let cellView = cellViews[fromPos.toString()]!
//                        let newRect =  gameboardView.getRectFor(row: toPos.x, col: toPos.y)
//                        
//                        // animate cell
//                        self.gameboardView.bringSubviewToFront(cellView)
//                        cellView.frame.origin = newRect.origin
//                        
//                        //cellViews[toPos.toString()] = cellView
//                        //cellViews.removeValueForKey(fromPos.toString())
//                        
//                        // animate disappeared cell
//                        if let disappearedCell = gameBoard.mergedCellAtPosition(toPos) {
//                            if disappearedCell.position != toPos {
//                                if let disappearedCellView = cellViews[disappearedCell.position.toString()] {
//                                    disappearedCellView.frame.origin = newRect.origin
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        
//        UIView.commitAnimations()
//        
//    }
    
//    @objc private func MoveCellDidStop(finished: Bool, context: UnsafeMutablePointer<Void> ) {
//        //EraseMergedCellViews()
//        updateCellViews()
//    }
    
//    private func updateCellViews() {
//        for row in 0..<gameBoard.numRows {
//            for col in 0..<gameBoard.numCols {
//                if let cell = gameBoard[row, col] {
//                    if let cellView = cellViews[Position(x: row, y: col).toString()] {
//                        if cell.status == .Merged {
//                            cellView.backgroundColor = cell.backgroundColor
//                            cellView.textLabel.textColor = cell.foregroundColor
//                            cellView.textLabel.text = String(cell.value)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
//    private func EraseMergedCellViews() {
//        for row in 0..<gameBoard.numRows {
//            for col in 0..<gameBoard.numCols {
//                
//                // Erase merged cell views
//                if let disappearedCell = gameBoard.mergedCellAt(row: row, col: col) {
//                    let key = disappearedCell.position.toString()
//                    if let disappearedCellView = cellViews[key] {
//                        disappearedCellView.removeFromSuperview()
//                        cellViews.removeValueForKey(key)
//                    }
//                }
//            }
//        }
//    }
}
