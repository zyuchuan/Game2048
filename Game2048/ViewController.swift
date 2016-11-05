//
//  ViewController.swift
//  Game2048
//
//  Created by Jack Zou on 16/5/21.
//  Copyright © 2016年 Jack Zou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var gameController: GameBoardViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.bounds.width - 20
        let gameBoardViewFrame = CGRect(x: 10, y: 30, width: width, height: width)
        gameController = GameBoardViewController()
        gameController.view.frame = gameBoardViewFrame
        gameController.view.layer.masksToBounds = true
        
        self.addChildViewController(gameController)
        self.view.addSubview(gameController.view)
        
        let newGameButtonFrame = CGRect(x: 10, y: 50 + gameBoardViewFrame.height, width: width, height: 40)
        let newGameButton = UIButton(type: UIButtonType.RoundedRect)
        newGameButton.frame = newGameButtonFrame
        newGameButton.setTitle("New Game", forState: UIControlState.Normal)
        newGameButton.backgroundColor = UIColor.blueColor()
        newGameButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        newGameButton.addTarget(self, action: #selector(ViewController.newGame), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(newGameButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func newGame() {
        gameController.newGame()
    }
}

