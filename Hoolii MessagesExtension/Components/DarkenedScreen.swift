//
//  DarkenedScreen.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/1/23.
//

import UIKit

final class DarkenedScreen: UIViewController {
    init(viewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        
        let darkenedScreen: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        darkenedScreen.backgroundColor = AppColors.darkenedScreen
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.view.addSubview(darkenedScreen)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addAlert(alert: AppAlert) {
        self.view.addSubview(alert)
        alert.translatesAutoresizingMaskIntoConstraints = false
        alert.widthAnchor.constraint(equalToConstant: 340).isActive = true
        alert.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alert.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}
