//
//  GameBoardView.swift
//  Game2048
//
//  Created by Jack Zou on 16/5/21.
//  Copyright © 2016年 Jack Zou. All rights reserved.
//

import UIKit

class GameBoardView: UIView {
    
    fileprivate var cellViews: [String : CellView] = [:]
    fileprivate var mergedCells: [CellView] = []
    
    var delegate: GameBoardViewDelegate?
    
    func cellViewAt(position: Position) -> CellView? {
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
    
    override func draw(_ rect: CGRect) {
        
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
        context?.setFillColor(delegate!.getGameBoardBackgroundColor().cgColor)
        context?.fill(rect)
        
        context?.setFillColor(delegate!.getCellBackgroundColor().cgColor)
        for _ in 0..<numRows {
            for _ in 0..<numCols {
                let cellRect = CGRect(x: cellX, y: cellY, width: cellWidth, height: cellHeight)
                context?.fill(cellRect)
                cellX += cellWidth + cellSpaceX
            }
            
            cellX = rect.origin.x + cellSpaceX
            cellY += cellHeight + cellSpaceY
        }
    }
    
    func createNewCellViewForCell(_ cell: Cell<Int>, atPosition position: Position) {
        let frame = getRectFor(row: position.x, col: position.y)
        let xib = Bundle.main.loadNibNamed("CellView", owner: nil, options: nil)
        let cellView = xib?.first as! CellView
        cellView.frame = frame
        cellView.backgroundColor = cell.backgroundColor
        cellView.textLabel.textColor = cell.foregroundColor
        cellView.textLabel.text = String(cell.value)
        cellView.textLabel.font = UIFont.boldSystemFont(ofSize: frame.height / 2.0)
        cellView.transform = cellView.transform.scaledBy(x: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 10, options: .curveEaseIn,
                                   animations: {
                                    cellView.transform = CGAffineTransform.identity
            }, completion: nil)
        
        self.addSubview(cellView)
        cellViews[position.toString()] = cellView
    }
    
    func updateCellViewForCell(_ cell: Cell<Int>, atPosition position: Position) {
        if let cellView = cellViewAt(position: position) {
            cellView.backgroundColor = cell.backgroundColor
            cellView.textLabel.textColor = cell.foregroundColor
            cellView.textLabel.text = String(cell.value)
            cellView.transform = cellView.transform.scaledBy(x: 1.2, y: 1.2)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 30, options: .curveEaseIn,
                                       animations: {
                                        cellView.transform = CGAffineTransform.identity
                }, completion: nil)
        }
    }
    
    func beginSwipe(_ direction: SwipeDirection) {
        UIView.beginAnimations("MoveCellAnimation", context: nil)
        UIView.setAnimationDelay(0.0)
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationCurve(UIViewAnimationCurve.easeIn)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(GameBoardView.cellDidMove(_:)))
    }
    
    func endSwipe(_ direction: SwipeDirection) {
        UIView.commitAnimations()
    }
    
    func moveCellViewForCell(_ cell: Cell<Int>, from: Position, to: Position) {
        if let cellView = cellViewAt(position: from) {
            self.bringSubview(toFront: cellView)
            let newFrame = getRectFor(row: to.x, col: to.y)
            cellView.frame.origin = newFrame.origin
            
            if cell.status == .merged {
                if let mergedCellView = cellViews[to.toString()] {
                    mergedCells.append(mergedCellView)
                }
            }
            
            cellViews[to.toString()] = cellView
            cellViews.removeValue(forKey: from.toString())
        }
    }
    
    @objc fileprivate func cellDidMove(_ finished: Bool) {
        for cellView in mergedCells {
            cellView.removeFromSuperview()
        }
        mergedCells.removeAll(keepingCapacity: false)
        
        delegate?.onGameBoardViewDidSwipe()
    }
    
    fileprivate func getRectFor(row: Int, col: Int) -> CGRect {
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


