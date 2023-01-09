//
//  AutofillFeedback.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/7/23.
//

import UIKit

class AutofillFeedback: UIView {
    @IBOutlet weak var feedbackLabel: UILabel!

    class func instanceFromNib() -> AutofillFeedback? {
        let autofillFeedback = UINib(nibName: "AutofillFeedback", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? AutofillFeedback
        autofillFeedback?.feedbackLabel.sizeToFit()
        autofillFeedback?.backgroundColor = AppColors.main
        autofillFeedback?.layer.cornerRadius = 10
        
        return autofillFeedback
    }
}
