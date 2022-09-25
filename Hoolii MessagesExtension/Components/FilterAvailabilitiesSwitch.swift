//
//  FilterAvailabilitiesSwitch.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/21/22.
//

import UIKit

class FilterAvailabilitiesSwitch: UIView {
    @IBOutlet weak var highlight: UIView!
    @IBOutlet weak var personalButton: UIView!
    @IBOutlet weak var groupButton: UIView!
    var callback: ((String)->())!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = 5
    }
    
    override func awakeFromNib() {
        let personalTap = UITapGestureRecognizer(target: self, action: #selector(handlePersonalButtonTapGesture(gesture:)))
        let groupTap = UITapGestureRecognizer(target: self, action: #selector(handleGroupButtonTapGesture(gesture:)))
        personalButton.addGestureRecognizer(personalTap)
        groupButton.addGestureRecognizer(groupTap)
        highlight.layer.cornerRadius = 5
        highlight.backgroundColor = AppColors.main
    }
    
    func configure(callback: @escaping (String)->()) {
        self.callback = callback
    }
    
    @objc func handlePersonalButtonTapGesture(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            callback("Personal")
            
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.highlight.frame = CGRect(x: 0,
                                              y: 0,
                                              width: self.highlight.frame.width,
                                              height: self.highlight.frame.height)
            }, completion: nil)
        }
    }
    
    @objc func handleGroupButtonTapGesture(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            callback("Group")
            
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.highlight.frame = CGRect(x: self.highlight.frame.width,
                                              y: 0,
                                              width: self.highlight.frame.width,
                                              height: self.highlight.frame.height)
            }, completion: nil)
        }
    }
}
