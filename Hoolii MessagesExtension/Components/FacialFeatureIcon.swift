//
//  FacialFeatureIcon.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/15/23.
//

import UIKit

final class FacialFeatureIcon: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var isActive: Bool = false
    var index: Int!
    var isSelectedCallback: ((Int) -> Void)!
    
    class func instanceFromNib(image: UIImage, text: String) -> FacialFeatureIcon? {
        let facialFeatureIcon = UINib(nibName: "FacialFeatureIcon", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? FacialFeatureIcon
        
        facialFeatureIcon?.imageView.image = image
        facialFeatureIcon?.label.text = text
        facialFeatureIcon?.nibSetup()
        
        return facialFeatureIcon
    }
    
    func nibSetup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunct(tapGestureRecognizer:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapFunct(tapGestureRecognizer: UITapGestureRecognizer) {
        if !isActive {
            select()
            isSelectedCallback(index)
        } else {
            deselect()
        }
    }
    
    func select() {
        self.backgroundColor = UIColor(named: "main")
    }
    
    func deselect() {
        self.backgroundColor = .clear
    }
}
