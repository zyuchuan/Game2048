//
//  CellView.swift
//  Game2048
//
//  Created by Jack Zou on 16/5/29.
//  Copyright © 2016年 Jack Zou. All rights reserved.
//

import UIKit

class CellView: UIView {
    
    @IBOutlet weak var textLabel: UILabel!
        
//    init(frame: CGRect, position: Position, delegate: CellDelegate) {
//        super.init(frame: frame)
//        
//        self.delegate = delegate
//        self.position = position
//        
//        let cell: Cell<Int> = self.delegate.getCellForPosition(self.position)!
//        self.backgroundColor = cell.backgroundColor
//        self.textLabel.textColor = cell.foregroundColor
//        self.textLabel.text = String(cell.value)
//        self.textLabel.font = UIFont.boldSystemFontOfSize(frame.size.height / 2.0)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
