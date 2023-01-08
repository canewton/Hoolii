//
//  DarkenedScreen.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/1/23.
//

import UIKit

final class DarkenedScreen: UIViewController {
    var dismissCallback: (() -> Void)?
    
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
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true)
        if dismissCallback != nil {
            dismissCallback!()
        }
    }
    
    func addAlert(alert: UIView) {
        self.view.addSubview(alert)
        alert.translatesAutoresizingMaskIntoConstraints = false
        alert.widthAnchor.constraint(equalToConstant: 340).isActive = true
        alert.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alert.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        if let appAlert = alert as? AppAlert {
            appAlert.dismissCallback = {() -> Void in self.dismiss(animated: true)}
        }
    }
    
    func addDismissCallback(callback: @escaping (() -> Void)) {
        dismissCallback = callback
    }
}
