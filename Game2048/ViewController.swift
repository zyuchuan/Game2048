//
//  ViewController.swift
//  Game2048
//
//  Created by Jack Zou on 16/5/21.
//  Copyright © 2016年 Jack Zou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var gameController: GameBoardViewController!

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
        let newGameButton = UIButton(type: UIButtonType.roundedRect)
        newGameButton.frame = newGameButtonFrame
        newGameButton.setTitle("New Game", for: UIControlState())
        newGameButton.backgroundColor = UIColor.blue
        newGameButton.setTitleColor(UIColor.white, for: UIControlState())
        newGameButton.addTarget(self, action: #selector(ViewController.newGame), for: UIControlEvents.touchUpInside)
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

