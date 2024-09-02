//
//  AvatarCollectionViewCell.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 4/1/23.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    weak var cellContent: FacialFeatureOption?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var data: AvatarCellData? {
        didSet {
            if data != nil {
                contentView.layer.cornerRadius = 5
                contentView.layer.borderColor = UIColor.gray.cgColor
                
                cellContent?.freeMemory()
                cellContent?.removeFromSuperview()
                cellContent = nil
                
                cellContent = FacialFeatureOption.instanceFromNib()
                contentView.addSubview(cellContent!)
                
                cellContent!.translatesAutoresizingMaskIntoConstraints = false
                cellContent!.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
                cellContent!.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
                cellContent!.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
                cellContent!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
                
                changeAvatarImage(images: data!.images)
                
                if data!.avatar.avatarIndex == data!.cellIndex {
                    selectCell()
                } else {
                    deselectCell()
                }
            } else {
                cellContent?.freeMemory()
                cellContent?.removeFromSuperview()
                cellContent = nil
            }
        }
    }
    
    func selectCell() {
        contentView.layer.borderWidth = 2
    }
    
    func deselectCell() {
        contentView.layer.borderWidth = 0
    }
    
    func changeAvatarImage(images: AvatarImageCollection) {
        cellContent?.setFromImageCollection(images: images)
    }
}
