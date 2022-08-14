//
//  AppDropDown.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/12/22.
//

import UIKit

class CellClass: UITableViewCell {
    
}

final class AppDropDown: UIView {
    var expanded: Bool = false
    var dataSource: [String] = []
    
    private let tableView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.backgroundColor = .purple
        view.layer.cornerRadius = 5
        view.distribution = .fillEqually
        view.alignment = .fill
        view.clipsToBounds = true
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return view
    }()
    
    func configure(options: [String]) {
        self.dataSource = options
        tableView.frame = CGRect(x: 0,
                            y: self.frame.height,
                            width: self.frame.width,
                            height: 0)
        for i in 0..<options.count {
            let timeButton: UIView = UIView()
            let timeButtonLabel: UILabel = UILabel()
            timeButtonLabel.textAlignment = .center
            timeButtonLabel.text = options[i]
            timeButtonLabel.textColor = .black
            timeButtonLabel.isUserInteractionEnabled = false
            timeButtonLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            timeButton.backgroundColor = .gray
            timeButton.addSubview(timeButtonLabel)
            tableView.addArrangedSubview(timeButton)
        }
        addSubview(tableView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            if !expanded {
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                    self.tableView.frame = CGRect(x: 0,
                                                  y: self.frame.height,
                                                  width: self.frame.width,
                                                  height: CGFloat(self.dataSource.count * 50))
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                    self.tableView.frame = CGRect(x: 0,
                                                  y: self.frame.height,
                                                  width: self.frame.width,
                                                  height: 0)
                }, completion: nil)
            }
            expanded = !expanded
        }
    }
}
