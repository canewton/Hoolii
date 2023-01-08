//
//  AppAlert.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/6/23.
//

import Foundation
import UIKit

final class AppAlert: UIView {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var dismissButton: UILabel!
    @IBOutlet weak var labelsBottomConstraint: NSLayoutConstraint!
    
    var dismissCallback: (() -> Void)?
    
    class func instanceFromNib(image: UIImage?, title: String, description: String, labelOnBottom: Bool = true, dismissButtonText: String? = nil) -> AppAlert? {
        let appAlert = UINib(nibName: "AppAlert", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? AppAlert
        let imageView: UIImageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        let labelsView = UINib(nibName: "AlertLabels", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! AlertLabels
        labelsView.alertTitle.text = title
        labelsView.alertDescription.text = description
        
        if labelOnBottom {
            appAlert?.topView.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: (appAlert?.topView.topAnchor)!).isActive = true
            imageView.leftAnchor.constraint(equalTo: (appAlert?.topView.leftAnchor)!).isActive = true
            imageView.rightAnchor.constraint(equalTo: (appAlert?.topView.rightAnchor)!).isActive = true
            imageView.bottomAnchor.constraint(equalTo: (appAlert?.topView.bottomAnchor)!).isActive = true
            
            appAlert?.bottomView.addSubview(labelsView)
            
            labelsView.translatesAutoresizingMaskIntoConstraints = false
            labelsView.topAnchor.constraint(equalTo: (appAlert?.bottomView.topAnchor)!).isActive = true
            labelsView.leftAnchor.constraint(equalTo: (appAlert?.bottomView.leftAnchor)!).isActive = true
            labelsView.rightAnchor.constraint(equalTo: (appAlert?.bottomView.rightAnchor)!).isActive = true
            labelsView.bottomAnchor.constraint(equalTo: (appAlert?.bottomView.bottomAnchor)!).isActive = true
        } else {
            appAlert?.topView.addSubview(labelsView)
            
            labelsView.translatesAutoresizingMaskIntoConstraints = false
            labelsView.topAnchor.constraint(equalTo: (appAlert?.topView.topAnchor)!).isActive = true
            labelsView.leftAnchor.constraint(equalTo: (appAlert?.topView.leftAnchor)!).isActive = true
            labelsView.rightAnchor.constraint(equalTo: (appAlert?.topView.rightAnchor)!).isActive = true
            labelsView.bottomAnchor.constraint(equalTo: (appAlert?.topView.bottomAnchor)!).isActive = true
            
            appAlert?.bottomView.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: (appAlert?.bottomView.topAnchor)!).isActive = true
            imageView.leftAnchor.constraint(equalTo: (appAlert?.bottomView.leftAnchor)!).isActive = true
            imageView.rightAnchor.constraint(equalTo: (appAlert?.bottomView.rightAnchor)!).isActive = true
            imageView.bottomAnchor.constraint(equalTo: (appAlert?.bottomView.bottomAnchor)!).isActive = true
        }
        
        appAlert?.layer.cornerRadius = 15
        
        if dismissButtonText == nil {
            appAlert?.dismissButton.removeFromSuperview()
            appAlert?.labelsBottomConstraint.constant = -15
        } else {
            appAlert?.dismissButton.textColor = AppColors.main
            appAlert?.dismissButton.text = dismissButtonText
        }
        
        if description == "" {
            appAlert?.descriptionHeight.constant = 0
        }
        
        if title == "" {
            appAlert?.titleHeight.constant = 0
        }
        
        return appAlert
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onDismiss(gesture:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        dismissButton.addGestureRecognizer(tap)
    }
    
    @objc func onDismiss(gesture: UITapGestureRecognizer) {
        if dismissCallback != nil {
            dismissCallback!()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
