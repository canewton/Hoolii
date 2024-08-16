//
//  AvatarCreatorViewController.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 12/15/22.
//

import UIKit
import Messages

struct AvatarCellData {
    var images: AvatarImageCollection
    var facialFeatureSelection: String
    var skinColor: UIColor
    var hairColor: UIColor
    var avatar: Avatar
    var cellIndex: Int
    
    init(images: AvatarImageCollection, facialFeatureSelection: String, skinColor: UIColor, hairColor: UIColor, avatar: Avatar, cellIndex: Int) {
        self.images = images
        self.facialFeatureSelection = facialFeatureSelection
        self.skinColor = skinColor
        self.hairColor = hairColor
        self.avatar = avatar
        self.cellIndex = cellIndex
    }
}

class AvatarCreatorViewController: MSMessagesAppViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // MARK: VARIABLE DECLARATION START
    
    // Outlets for display of Avatar
    @IBOutlet weak var avatarOptions: AvatarOptions!
    @IBOutlet weak var facialFeatureOptionsLabel: UILabel!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var avatarOptionsHeight: NSLayoutConstraint!
    
    static var storyboardIdentifier: String = "AvatarCreatorViewController"
    var delegate: AnyObject?
    var collectionViewArr: [AvatarImageCollection] = []
    
    // Outlet for element table
    @IBOutlet weak var elemCollectionView: UICollectionView!
    
    var currFacialFeature: Int = 0
    var itemIndex = 0
    var facialFeatureIconIndex: Int = 0
    var avatarContent: AvatarImageCollection!
    var avatarDisplay: FacialFeatureOption!
    let colorScrollHeightConstant: CGFloat = 40
    
    // Define the actual avatar variable being made/stored
    var generatedAvatar: Avatar = Avatar()
    
    // MARK: VARIABLE DECLARATION END
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarContent = AvatarImageCollection().addHair(front: AvatarConstants.hairOption8.hairFront, back: AvatarConstants.hairOption8.hairBack).addMouth(AvatarConstants.mouthOption1.mouth).addEyes(AvatarConstants.eyeOption1.eyes).addNose(AvatarConstants.noseOption1.nose)
        
        avatarDisplay = FacialFeatureOption.instanceFromNib(images: avatarContent)
        avatarDisplay.translatesAutoresizingMaskIntoConstraints = false
        
        avatarOptions.displayFacialFeatureOptionsCallback = displayFacialFeatureOptions
        elemCollectionView.dataSource = self
        elemCollectionView.delegate = self
        elemCollectionView.register(UINib(nibName: "FacialFeatureOption", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        displayFacialFeatureOptions(index: 0)
    }
    
    func displayFacialFeatureOptions(index: Int) {
        collectionViewArr = AvatarConstants.facialFeatureSelectionList[index].options
        facialFeatureIconIndex = index
                
        facialFeatureOptionsLabel.text = AvatarConstants.facialFeatureSelectionList[index].iconName
        if AvatarConstants.facialFeatureSelectionList[index].iconName == "Background" {
            facialFeatureOptionsLabel.text = ""
        }
        
        elemCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCollectionViewCell
        cell.data = AvatarCellData(
            images: collectionViewArr[indexPath.item],
            facialFeatureSelection: AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName,
            skinColor: UIColor(red: 230/255.0, green: 186/255.0, blue: 157/255.0, alpha: 1.0),
            hairColor: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
            avatar: generatedAvatar,
            cellIndex: indexPath.item
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<collectionView.visibleCells.count {
            collectionView.visibleCells[i].contentView.layer.borderWidth = 0
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! AvatarCollectionViewCell
        let facialFeature = cell.cellContent!
        cell.selectCell()
        
        switch AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName {
        case "Hair":
            avatarDisplay.hairBack.image = facialFeature.hairBack.image
            avatarDisplay.hairFront.image = facialFeature.hairFront.image
            avatarDisplay.hairMidBack.image = facialFeature.hairMidBack.image
            avatarDisplay.hairMidFront.image = facialFeature.hairMidFront.image
            generatedAvatar.hairIndex = indexPath.item
        case "Head":
            avatarDisplay.chin.image = facialFeature.chin.image
            avatarDisplay.beard.image = facialFeature.beard.image
            generatedAvatar.chinIndex = indexPath.item
        case "Brows":
            avatarDisplay.brows.image = facialFeature.brows.image
            generatedAvatar.browIndex = indexPath.item
        case "Nose":
            avatarDisplay.nose.image = facialFeature.nose.image
            generatedAvatar.noseIndex = indexPath.item
        case "Ears":
            avatarDisplay.ears.image = facialFeature.ears.image
            generatedAvatar.earIndex = indexPath.item
        case "Eyes":
            avatarDisplay.eyes.image = facialFeature.eyes.image
            avatarDisplay.glasses.image = facialFeature.glasses.image
            generatedAvatar.glassIndex = indexPath.item
        case "Mouth":
            avatarDisplay.mouth.image = facialFeature.mouth.image
            generatedAvatar.mouthIndex = indexPath.item
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionItemWidth: CGFloat = (view.bounds.width - 40 - 40)/CGFloat(4)
        
        let itemSize = CGSize(width: collectionItemWidth, height: collectionItemWidth)
            
        return itemSize
    }
    
}
