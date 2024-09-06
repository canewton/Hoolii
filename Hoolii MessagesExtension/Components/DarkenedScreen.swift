//
//  DarkenedScreen.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/1/23.
//

import UIKit

final class DarkenedScreen: UIViewController {
    var dismissCallback: (() -> Void)?
    var darkenedScreen: UIView!
    var dismissOnTap: Bool = true
    
    init(viewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        
        darkenedScreen = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
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
        let loc = gesture.location(in: self.view)
        var dismissController: Bool = true
        for i in 0..<darkenedScreen.subviews.count {
            if darkenedScreen.subviews[i].frame.contains(loc) {
                dismissController = false
            }
        }
        if dismissController && dismissOnTap {
            dissmissScreen()
        }
    }
    
    func dissmissScreen() {
        self.dismiss(animated: true)
        if dismissCallback != nil {
            dismissCallback!()
        }
    }
    
    func addAlert(alert: UIView) {
        darkenedScreen.addSubview(alert)
        alert.translatesAutoresizingMaskIntoConstraints = false
        alert.widthAnchor.constraint(equalToConstant: 340).isActive = true
        alert.centerXAnchor.constraint(equalTo: darkenedScreen.centerXAnchor).isActive = true
        alert.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        if let appAlert = alert as? AppAlert {
            appAlert.addDismissCallback(callback: dissmissScreen)
        } else if let appAlert = alert as? AppActionableAlert {
            appAlert.darkenedScreen = self
        }
    }
    
    func addDismissCallback(callback: @escaping (() -> Void)) {
        dismissCallback = callback
    }
}
