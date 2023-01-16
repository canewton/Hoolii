//
//  AvatarCreatorViewController.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 12/15/22.
//

import UIKit

class AvatarCreatorViewController: AppViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: VARIABLE DECLARATION START
    
    // Outlets for display of Avatar
    @IBOutlet weak var avatarOptions: AvatarOptions!
    @IBOutlet weak var colorOptionsStack: UIStackView!
    @IBOutlet weak var avatarContainerImgView: UIView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var saveAvatarButton: ThemedButton!
    @IBOutlet weak var backgroundColor: UIView!
    @IBOutlet weak var facialFeatureOptionsLabel: UILabel!
    
    // Outlet for element table
    @IBOutlet weak var elemCollectionView: UICollectionView!
    @IBOutlet weak var colorScrollHeight: NSLayoutConstraint!
    
    var currFacialFeature: Int = 0
    var itemIndex = 0
    var facialFeatureIconIndex: Int = 0
    var avatarContent: FacialFeatureOption = FacialFeatureOption.instanceFromNib()
    let colorScrollHeightConstant: CGFloat = 40
    var currSkinColor: UIColor = AppColors.skintoneArray[0]
    var currHairColor: UIColor = AppColors.hairColorArray[0]
    
    // Define the actual avatar variable being made/stored
    var generatedAvatar: Avatar = Avatar(chinIndex: 0, earIndex: 0, browIndex: 0, glassIndex: 0, mouthIndex: 0, noseIndex: 0, hairIndex: 0, skinTone: 0, hairColor: 0, backgroundIndex: 0)
    
    // MARK: VARIABLE DECLARATION END
    
    
    override func viewDidLoad() {
        // Function loaded: set all initial colors for elements
        super.viewDidLoad()
        
        avatarView.addSubview(avatarContent)
        avatarContent.translatesAutoresizingMaskIntoConstraints = false
        avatarContent.topAnchor.constraint(equalTo: avatarView.topAnchor).isActive = true
        avatarContent.leftAnchor.constraint(equalTo: avatarView.leftAnchor).isActive = true
        avatarContent.rightAnchor.constraint(equalTo: avatarView.rightAnchor).isActive = true
        avatarContent.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor).isActive = true
        
        avatarContent = avatarContent.addHair(front: AvatarConstants.hairOption8.hairFront.image, back: AvatarConstants.hairOption8.hairBack.image).addMouth(AvatarConstants.mouthOption1.mouth.image).addEyes(AvatarConstants.eyeOption1.eyes.image).addNose(AvatarConstants.noseOption1.nose.image)
        
        avatarOptions.displayFacialFeatureOptionsCallback = displayFacialFeatureOptions
        setUpColorStack(colors: AppColors.skintoneArray)
        configureBottomBar()
        backgroundColor.backgroundColor = AppColors.backgroundColorArray[0]
        
        backgroundColor.layer.cornerRadius = 50
        
        // declare delegate and source for collection
        elemCollectionView.dataSource = self
        elemCollectionView.delegate = self
        
        avatarContent.setHairColor(color: currHairColor)
        avatarContent.setSkinColor(color: currSkinColor)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        elemCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setUpColorStack(colors: [UIColor]) {
        for _ in 0..<colorOptionsStack.subviews.count {
            colorOptionsStack.subviews[0].removeFromSuperview()
        }
        
        for i in 0..<colors.count {
            let colorView = AvatarColorOption(color: colors[i])
            colorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            colorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            colorOptionsStack.addArrangedSubview(colorView)
            colorView.centerYAnchor.constraint(equalTo: colorOptionsStack.centerYAnchor).isActive = true
            colorView.callback = colorTapped
        }
    }
    
    func configureBottomBar() {
        bottomBar.layer.shadowColor = AppColors.shadowColor.cgColor
        bottomBar.layer.shadowOpacity = 0.4
        bottomBar.layer.shadowOffset = .zero
        bottomBar.layer.shadowRadius = 10
        
        saveAvatarButton.setImage(ScaledIcon(name: "checkmark", width: 15, height: 15, color: .label).image, for: .normal)
    }
    
    func displayFacialFeatureOptions(index: Int) {
        facialFeatureIconIndex = index
        
        switch AvatarConstants.facialFeatureSelectionList[index].iconName {
        case "Hair":
            colorScrollHeight.constant = colorScrollHeightConstant
            setUpColorStack(colors: AppColors.hairColorArray)
        case "Head":
            colorScrollHeight.constant = colorScrollHeightConstant
            setUpColorStack(colors: AppColors.skintoneArray)
        case "Brows":
            colorScrollHeight.constant = colorScrollHeightConstant
            setUpColorStack(colors: AppColors.skintoneArray)
        case "Background":
            colorScrollHeight.constant = colorScrollHeightConstant
            setUpColorStack(colors: AppColors.backgroundColorArray)
        default:
            colorScrollHeight.constant = 0
        }
        
        facialFeatureOptionsLabel.text = AvatarConstants.facialFeatureSelectionList[index].iconName
        if AvatarConstants.facialFeatureSelectionList[index].iconName == "Background" {
            facialFeatureOptionsLabel.text = ""
        }
        
        elemCollectionView.reloadData()
    }
    
    // Dismiss screen if user presses back button to return to profile creation
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // MARK: COLOR SELECTION METHODS BEGIN HERE
    func colorTapped(color: UIColor) {
        switch AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName {
        case "Hair":
            avatarContent.setHairColor(color: color)
            currHairColor = color
        case "Head":
            avatarContent.setSkinColor(color: color)
            currSkinColor = color
        case "Brows":
            avatarContent.setHairColor(color: color)
            currHairColor = color
        case "Background":
            backgroundColor.backgroundColor = color
        default:
            return
        }
        elemCollectionView.reloadData()
    }
    
    //MARK: COLOR SELECTION FUNCTS END HERE
    
    
    //MARK: METHODS/VARS FOR UPKEEP OF COLLECTION VIEW BEGIN HERE
    // Returns the number of sections in the view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // returns the number of images that cells are being made from
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        for _ in 0..<cell.subviews.count {
            cell.subviews[0].removeFromSuperview()
        }
        
        let avatarOption = AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].options[indexPath.item]
        cell.addSubview(avatarOption)
        avatarOption.translatesAutoresizingMaskIntoConstraints = false
        avatarOption.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        avatarOption.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        avatarOption.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        avatarOption.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        avatarOption.tapCallback = tapAvatarOption
        
        avatarOption.setSkinColor(color: currSkinColor)
        avatarOption.setHairColor(color: currHairColor)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionItemWidth: CGFloat = (view.bounds.width - 40 - 40)/CGFloat(4)
        
        let itemSize = CGSize(width: collectionItemWidth, height: collectionItemWidth)
            
        return itemSize
    }
    
    func tapAvatarOption(facialFeature: FacialFeatureOption) {
        switch AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName {
        case "Hair":
            avatarContent.hairBack.image = facialFeature.hairBack.image
            avatarContent.hairFront.image = facialFeature.hairFront.image
            avatarContent.hairMidBack.image = facialFeature.hairMidBack.image
            avatarContent.hairMidFront.image = facialFeature.hairMidFront.image
        case "Head":
            avatarContent.chin.image = facialFeature.chin.image
            avatarContent.beard.image = facialFeature.beard.image
        case "Brows":
            avatarContent.brows.image = facialFeature.brows.image
        case "Nose":
            avatarContent.nose.image = facialFeature.nose.image
        case "Ears":
            avatarContent.ears.image = facialFeature.ears.image
        case "Eyes":
            avatarContent.eyes.image = facialFeature.eyes.image
            avatarContent.glasses.image = facialFeature.glasses.image
        case "Mouth":
            avatarContent.mouth.image = facialFeature.mouth.image
        default:
            return
        }
    }
    
    //MARK: COLLECTION VIEW METHODS END HERE
    
    
    //MARK: METHODS FOR SAVING AVATARS START HERE
    
    func storeAvatar() {
        // Update generatedAVatar with the user's current selection of variables
        StoredValues.set(key: StoredValuesConstants.userAvatar, value: generatedAvatar.getJsonValue())
        // dismiss the avatarCreatorView
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        storeAvatar()
    }
    
    //MARK: END OF AVATAR SAVNG FUNCTIONS
}
