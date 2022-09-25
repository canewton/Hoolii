//
//  BackButton.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/14/22.
//

import Foundation
import UIKit

public class BackButton: UIButton {
    var viewController: UIViewController?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        let backButtonIcon: UIImage = ScaledIcon(name: "chevron-left-solid", width: 18, height: 18, color: .black).image
        
        self.addTarget(self, action: #selector(buttonPushed), for: .touchUpInside)
        self.setImage(backButtonIcon, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 10)
    }
    
    public func configure(viewController: UIViewController){
        self.viewController = viewController
    }
    
    @objc func buttonPushed() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
