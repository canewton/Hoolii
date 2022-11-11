//
//  AutofillButton.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/7/22.
//

import UIKit

// define the autofill button style and link it to a callback function
class AutofillButton: UIView {
    @IBOutlet weak var plusIcon: UIImageView!
    var callback: (() -> Void)?
    
    override func awakeFromNib() {
        plusIcon.image = ScaledIcon(name: "plus-solid", width: 12, height: 12, color: .black).image
        backgroundColor = AppColors.main
        layer.cornerRadius = 20
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        if callback != nil {
            callback!()
        }
    }
    
    class func instanceFromNib() -> AutofillButton? {
        return UINib(nibName: "AutofillButton", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? AutofillButton
    }
}
