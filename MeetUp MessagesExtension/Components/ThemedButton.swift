//
//  ThemedButton.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/13/22.
//

import UIKit

public class ThemedButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tintColor = AppColors.main
        self.setTitleColor(.black, for: .normal)
    }
}
