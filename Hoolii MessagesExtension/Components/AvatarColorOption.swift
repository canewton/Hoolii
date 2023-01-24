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
    var unselectedHeight: CGFloat
    var selectedHeight: CGFloat
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        unselectedHeight = 40
        selectedHeight = 30
        
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
        insideView.layer.cornerRadius = selectedHeight/2
        heightConstraint.constant = selectedHeight
        widthConstraint.constant = selectedHeight
    }
    
    func deselect() {
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.insideView.layer.cornerRadius = 8
            self.heightConstraint.constant = self.unselectedHeight
            self.widthConstraint.constant = self.unselectedHeight
            self.layoutIfNeeded()
        })
    }
    
    convenience init(color: UIColor, colorIndex: Int, unselectedHeight: CGFloat, selectedHeight: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: unselectedHeight, height: unselectedHeight))
        
        self.colorIndex = colorIndex
        self.selectedHeight = selectedHeight
        self.unselectedHeight = unselectedHeight
        
        outsideView = UIView()
        outsideView.backgroundColor = .clear
        outsideView.layer.cornerRadius = unselectedHeight/2
        outsideView.layer.borderWidth = 3 * 1/40 * unselectedHeight
        outsideView.layer.borderColor = UIColor.gray.cgColor
        outsideView.translatesAutoresizingMaskIntoConstraints = false
        outsideView.heightAnchor.constraint(equalToConstant: unselectedHeight).isActive = true
        outsideView.widthAnchor.constraint(equalToConstant: unselectedHeight).isActive = true
        
        addSubview(outsideView)
        
        insideView = UIView()
        insideView.backgroundColor = color
        insideView.translatesAutoresizingMaskIntoConstraints = false
        insideView.layer.cornerRadius = 8
        
        addSubview(insideView)
        
        heightAnchor.constraint(equalToConstant: unselectedHeight).isActive = true
        widthAnchor.constraint(equalToConstant: unselectedHeight).isActive = true
        
        heightConstraint = insideView.heightAnchor.constraint(equalToConstant: unselectedHeight)
        widthConstraint = insideView.widthAnchor.constraint(equalToConstant: unselectedHeight)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        insideView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        insideView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
