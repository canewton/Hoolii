//
//  AvatarColorOption.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/15/23.
//

import UIKit

class AvatarColorOption: UIView {
    
    var callback: ((Int) -> Void)!
    var heightConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    var insideView: UIView!
    var outsideView: UIView!
    var colorIndex: Int!
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let colorTapRecognizer = UITapGestureRecognizer(target:self, action: #selector(colorTapped(colorTapRecognizer:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(colorTapRecognizer)
    }
    
    @objc func colorTapped(colorTapRecognizer: UITapGestureRecognizer) {
        callback(colorIndex)
        select()
    }
    
    func select() {
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.selectWithoutAnimation()
            self.layoutIfNeeded()
        })
    }
    
    func selectWithoutAnimation() {
        insideView.layer.cornerRadius = 15
        heightConstraint.constant = 30
        widthConstraint.constant = 30
    }
    
    func deselect() {
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.insideView.layer.cornerRadius = 8
            self.heightConstraint.constant = 40
            self.widthConstraint.constant = 40
            self.layoutIfNeeded()
        })
    }
    
    convenience init(color: UIColor, colorIndex: Int) {
        self.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        self.colorIndex = colorIndex
        
        outsideView = UIView()
        outsideView.backgroundColor = .clear
        outsideView.layer.cornerRadius = 20
        outsideView.layer.borderWidth = 3
        outsideView.layer.borderColor = UIColor.gray.cgColor
        outsideView.translatesAutoresizingMaskIntoConstraints = false
        outsideView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        outsideView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(outsideView)
        
        insideView = UIView()
        insideView.backgroundColor = color
        insideView.translatesAutoresizingMaskIntoConstraints = false
        insideView.layer.cornerRadius = 8
        
        addSubview(insideView)
        
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        heightConstraint = insideView.heightAnchor.constraint(equalToConstant: 40)
        widthConstraint = insideView.widthAnchor.constraint(equalToConstant: 40)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        insideView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        insideView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
