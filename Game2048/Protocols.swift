//
//  Protocols.swift
//  Game2048
//
//  Created by Jack Zou on 16/6/8.
//  Copyright © 2016年 Jack Zou. All rights reserved.
//

import UIKit

enum SwipeDirection {
    case Up
    case Down
    case Left
    case Right
}

protocol GameBoardDelegate {
    
    func onGameBoardCreateNewCell(cell: Cell<Int>, atPostion position: Position)
    func onGameBoardBeginSwipe(direction: SwipeDirection)
    func onGameBoardEndSwipe(direction: SwipeDirection)
    func onGameBoardCellMove(cell: Cell<Int>, from: Position, to: Position)
    func onGameBoardCellMerged(cell: Cell<Int>, atPosition position: Position)
    
}

protocol GameBoardViewDelegate {
    func getInsetX() -> Float
    func getInsetY() -> Float
    func getCellSpaceX() -> Float
    func getCellSpaceY() -> Float
    func getNumberOfRows() -> Int
    func getNumberOfColumns() -> Int
    func getGameBoardBackgroundColor() -> UIColor
    func getCellBackgroundColor() -> UIColor
    
    func onGameBoardViewDidSwipe()
}