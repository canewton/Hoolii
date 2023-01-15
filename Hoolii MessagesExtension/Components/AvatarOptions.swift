//
//  AvatarOptions.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/15/23.
//

import UIKit

class AvatarOptions: UIStackView {
    var currentTabIndex = 0
    let numTabs = 8
    var displayFacialFeatureOptionsCallback: ((Int) -> Void)!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        for i in 0..<numTabs {
            let facialFeature = FacialFeatureIcon.instanceFromNib(image: UIImage(named: AvatarConstants.facialFeatureIcons[i])!, text: AvatarConstants.facialFeatureIcons[i])!
            facialFeature.translatesAutoresizingMaskIntoConstraints = false
            facialFeature.heightAnchor.constraint(equalToConstant: 90).isActive = true
            facialFeature.widthAnchor.constraint(equalToConstant: 75).isActive = true
            facialFeature.index = i
            facialFeature.isSelectedCallback = selectFacialFeature
            
            if i == 0 {
                facialFeature.select()
            }
            
            self.addArrangedSubview(facialFeature)
        }
    }
    
    func selectFacialFeature(index: Int) {
        (self.arrangedSubviews[currentTabIndex] as! FacialFeatureIcon).deselect()
        currentTabIndex = index
        (self.arrangedSubviews[currentTabIndex] as! FacialFeatureIcon).select()
        
        displayFacialFeatureOptionsCallback(index)
    }
}
