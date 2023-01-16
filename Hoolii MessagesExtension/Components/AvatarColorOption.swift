//
//  AvatarColorOption.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/15/23.
//

import UIKit

class AvatarColorOption: UIView {
    
    var callback: ((UIColor) -> Void)!
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let colorTapRecognizer = UITapGestureRecognizer(target:self, action: #selector(colorTapped(colorTapRecognizer:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(colorTapRecognizer)
        
        self.layer.cornerRadius = 8
    }
    
    @objc func colorTapped(colorTapRecognizer: UITapGestureRecognizer) {
        callback(backgroundColor!)
    }
    
    convenience init(color: UIColor) {
        self.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backgroundColor = color
    }
}
