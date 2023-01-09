//
//  AppActionableAlert.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/1/23.
//

import UIKit

final class AppActionableAlert: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var leftButton: UIView!
    @IBOutlet weak var rightButton: UIView!
    @IBOutlet weak var leftButtonText: UILabel!
    @IBOutlet weak var rightButtonText: UILabel!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertDescription: UILabel!
    @IBOutlet weak var buttonsContainer: UIStackView!
    var cancelCallback: ((_ darkenedScreen: UIViewController) -> Void)!
    var acceptCallback: ((_ darkenedScreen: UIViewController) -> Void)!
    var darkenedScreen: UIViewController!
    
    class func instanceFromNib(image: UIImage?, cancelText: String, acceptText: String, title: String, description: String) -> AppActionableAlert? {
        let appAlert = UINib(nibName: "AppActionableAlert", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? AppActionableAlert
        appAlert?.imageView.image = image
        appAlert?.leftButtonText.text = cancelText
        appAlert?.rightButtonText.text = acceptText
        appAlert?.alertTitle.text = title
        appAlert?.alertDescription.text = description
        
        appAlert?.layer.cornerRadius = 15
        appAlert?.leftButton.backgroundColor = .clear
        appAlert?.rightButton.backgroundColor = .clear
        appAlert?.leftButton.addBorders(edges: [.right], color: AppColors.lightGrey, thickness: 0.5)
        appAlert?.rightButton.addBorders(edges: [.left], color: AppColors.lightGrey, thickness: 0.5)
        appAlert?.buttonsContainer.addBorders(edges: [.top], color: AppColors.lightGrey, thickness: 1)
        appAlert?.rightButtonText.textColor = AppColors.main
        
        return appAlert
    }
    
    override func awakeFromNib() {
        let acceptTap = UILongPressGestureRecognizer(target: self, action: #selector(handleAcceptTap(gesture:)))
        acceptTap.minimumPressDuration = 0
        rightButton.isUserInteractionEnabled = true
        rightButton.addGestureRecognizer(acceptTap)
        
        let cancelTap = UILongPressGestureRecognizer(target: self, action: #selector(handleCancelTap(gesture:)))
        cancelTap.minimumPressDuration = 0
        leftButton.isUserInteractionEnabled = true
        leftButton.addGestureRecognizer(cancelTap)
    }
    
    @objc func handleAcceptTap(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            rightButtonText.textColor = AppColors.lightGrey
        } else if gesture.state == .ended {
            rightButtonText.textColor = AppColors.main
            let loc = gesture.location(in: leftButton)
            if rightButton.frame.contains(loc){
                acceptCallback(darkenedScreen)
            }
        }
    }
    
    @objc func handleCancelTap(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            leftButtonText.textColor = AppColors.lightGrey
        } else if gesture.state == .ended {
            leftButtonText.textColor = .label
            let loc = gesture.location(in: leftButton)
            if leftButton.frame.contains(loc){
                cancelCallback(darkenedScreen)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension UIView {
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }
}
