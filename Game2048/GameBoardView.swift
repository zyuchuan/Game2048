//
//  GameBoardView.swift
//  Game2048
//
//  Created by Jack Zou on 16/5/21.
//  Copyright © 2016年 Jack Zou. All rights reserved.
//

import UIKit

class GameBoardView: UIView {
    
    private var cellViews: [String : CellView] = [:]
    private var mergedCells: [CellView] = []
    
    var delegate: GameBoardViewDelegate?
    
    func cellViewAt(position position: Position) -> CellView? {
        return cellViews[position.toString()]
    }
    
    func clean() {
        for (_, cellView) in cellViews {
            cellView.removeFromSuperview()
        }
        
        for cellView in mergedCells {
            cellView.removeFromSuperview()
        }
        
        cellViews.removeAll()
        mergedCells.removeAll()
    }
    
    override func drawRect(rect: CGRect) {
        
        guard delegate != nil else { return }
        
        let numRows = delegate!.getNumberOfRows()
        let numCols = delegate!.getNumberOfColumns()
        let cellSpaceX = CGFloat(delegate!.getCellSpaceX())
        let cellSpaceY = CGFloat(delegate!.getCellSpaceY())
        let cellWidth: CGFloat = (rect.width - CGFloat(numCols + 1) * cellSpaceX) / CGFloat(numCols)
        let cellHeight: CGFloat = (rect.height - CGFloat(numRows + 1) * cellSpaceY) / CGFloat(numRows)
        var cellX: CGFloat = rect.origin.x + cellSpaceX
        var cellY: CGFloat = rect.origin.y + cellSpaceY
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, delegate!.getGameBoardBackgroundColor().CGColor)
        CGContextFillRect(context, rect)
        
        CGContextSetFillColorWithColor(context, delegate!.getCellBackgroundColor().CGColor)
        for _ in 0..<numRows {
            for _ in 0..<numCols {
                let cellRect = CGRect(x: cellX, y: cellY, width: cellWidth, height: cellHeight)
                CGContextFillRect(context, cellRect)
                cellX += cellWidth + cellSpaceX
            }
            
            cellX = rect.origin.x + cellSpaceX
            cellY += cellHeight + cellSpaceY
        }
    }
    
    func createNewCellViewForCell(cell: Cell<Int>, atPosition position: Position) {
        let frame = getRectFor(row: position.x, col: position.y)
        let xib = NSBundle.mainBundle().loadNibNamed("CellView", owner: nil, options: nil)
        let cellView = xib.first as! CellView
        cellView.frame = frame
        cellView.backgroundColor = cell.backgroundColor
        cellView.textLabel.textColor = cell.foregroundColor
        cellView.textLabel.text = String(cell.value)
        cellView.textLabel.font = UIFont.boldSystemFontOfSize(frame.height / 2.0)
        cellView.transform = CGAffineTransformScale(cellView.transform, 0.1, 0.1)
        
        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 10, options: .CurveEaseIn,
                                   animations: {
                                    cellView.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        self.addSubview(cellView)
        cellViews[position.toString()] = cellView
    }
    
    func updateCellViewForCell(cell: Cell<Int>, atPosition position: Position) {
        if let cellView = cellViewAt(position: position) {
            cellView.backgroundColor = cell.backgroundColor
            cellView.textLabel.textColor = cell.foregroundColor
            cellView.textLabel.text = String(cell.value)
            cellView.transform = CGAffineTransformScale(cellView.transform, 1.2, 1.2)
            
            UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 30, options: .CurveEaseIn,
                                       animations: {
                                        cellView.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
    }
    
    func beginSwipe(direction: SwipeDirection) {
        UIView.beginAnimations("MoveCellAnimation", context: nil)
        UIView.setAnimationDelay(0.0)
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStopSelector(#selector(GameBoardView.cellDidMove(_:)))
    }
    
    func endSwipe(direction: SwipeDirection) {
        UIView.commitAnimations()
    }
    
    func moveCellViewForCell(cell: Cell<Int>, from: Position, to: Position) {
        if let cellView = cellViewAt(position: from) {
            self.bringSubviewToFront(cellView)
            let newFrame = getRectFor(row: to.x, col: to.y)
            cellView.frame.origin = newFrame.origin
            
            if cell.status == .Merged {
                if let mergedCellView = cellViews[to.toString()] {
                    mergedCells.append(mergedCellView)
                }
            }
            
            cellViews[to.toString()] = cellView
            cellViews.removeValueForKey(from.toString())
        }
    }
    
    @objc private func cellDidMove(finished: Bool) {
        for cellView in mergedCells {
            cellView.removeFromSuperview()
        }
        mergedCells.removeAll(keepCapacity: false)
        
        delegate?.onGameBoardViewDidSwipe()
    }
    
    private func getRectFor(row row: Int, col: Int) -> CGRect {
        let numRows = delegate!.getNumberOfRows()
        let numCols = delegate!.getNumberOfColumns()
        let cellSpaceX = CGFloat(delegate!.getCellSpaceX())
        let cellSpaceY = CGFloat(delegate!.getCellSpaceY())
        let cellWidth: CGFloat = (bounds.width - CGFloat(numCols + 1) * cellSpaceX) / CGFloat(numCols)
        let cellHeight: CGFloat = (bounds.height - CGFloat(numRows + 1) * cellSpaceY) / CGFloat(numRows)
        
        let cellX: CGFloat = CGFloat(col + 1) * cellSpaceX + CGFloat(col) * cellWidth
        let cellY: CGFloat = CGFloat(row + 1) * cellSpaceY + CGFloat(row) * cellHeight
        
        return CGRect(x: cellX, y: cellY, width: cellWidth, height: cellHeight)
    }
}


