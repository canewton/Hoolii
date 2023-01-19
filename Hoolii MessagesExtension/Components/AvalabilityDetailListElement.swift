//
//  AvalabilityDetailListElement.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/17/23.
//

import UIKit

class AvalabilityDetailListElement: UIView {
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var icon: UIView!
    
    class func instanceFromNib(icon: UIView, text: String) -> AvalabilityDetailListElement {
        let listElem = UINib(nibName: "AvalabilityDetailListElement", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? AvalabilityDetailListElement
        
        listElem?.icon.addSubview(icon)
        
        listElem?.icon.leftAnchor.constraint(equalTo: icon.leftAnchor).isActive = true
        listElem?.icon.rightAnchor.constraint(equalTo: icon.rightAnchor).isActive = true
        listElem?.icon.topAnchor.constraint(equalTo: icon.topAnchor).isActive = true
        listElem?.icon.bottomAnchor.constraint(equalTo: icon.bottomAnchor).isActive = true
        
        listElem?.text.text = text
        
        return listElem!
    }
}
