//
//  AvatarCreatorViewController.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 12/15/22.
//

import UIKit

class AvatarCreatorViewController: AppViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // MARK: VARIABLE DECLARATION START
    
    // Outlets for display of Avatar
    @IBOutlet weak var avatarOptions: AvatarOptions!
    @IBOutlet weak var colorOptionsStack: UIStackView!
    @IBOutlet weak var avatarContainerImgView: UIView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var saveAvatarButton: ThemedButton!
    @IBOutlet weak var backgroundColor: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var facialFeatureOptionsLabel: UILabel!
    
    // Outlet for element table
    @IBOutlet weak var elemCollectionView: UICollectionView!
    @IBOutlet weak var colorScrollHeight: NSLayoutConstraint!
    
    var currFacialFeature: Int = 0
    var itemIndex = 0
    var facialFeatureIconIndex: Int = 0
    var avatarContent: FacialFeatureOption!
    let colorScrollHeightConstant: CGFloat = 40
    var editNameCallback: (() -> Void)!
    var editProfileCallback: (() -> Void)!
    
    // Define the actual avatar variable being made/stored
    var generatedAvatar: Avatar = Avatar()
    
    // MARK: VARIABLE DECLARATION END
    
    
    override func viewDidLoad() {
        // Function loaded: set all initial colors for elements
        super.viewDidLoad()
        
        StoredValues.setIfEmpty(key: StoredValuesConstants.firstName, value: "")
        StoredValues.setIfEmpty(key: StoredValuesConstants.lastName, value: "")
        
        let firstName: String = StoredValues.get(key: StoredValuesConstants.firstName)!
        let lastName: String = StoredValues.get(key: StoredValuesConstants.lastName)!
        let fullName: String = "\(firstName) \(lastName)"
        if fullName != "" {
            nameTextField.text = fullName
        }
        
        let storedAvatar = StoredValues.get(key: StoredValuesConstants.userAvatar)
        if storedAvatar != nil {
            generatedAvatar = Avatar(jsonValue: storedAvatar!)
            avatarContent = generatedAvatar.toFacialFeatureOption()
        } else {
            avatarContent = FacialFeatureOption.instanceFromNib()
            avatarContent = avatarContent.addHair(front: AvatarConstants.hairOption8.hairFront.image, back: AvatarConstants.hairOption8.hairBack.image).addMouth(AvatarConstants.mouthOption1.mouth.image).addEyes(AvatarConstants.eyeOption1.eyes.image).addNose(AvatarConstants.noseOption1.nose.image)
        }
        
        avatarView.addSubview(avatarContent)
        avatarContent.translatesAutoresizingMaskIntoConstraints = false
        avatarContent.topAnchor.constraint(equalTo: avatarView.topAnchor).isActive = true
        avatarContent.leftAnchor.constraint(equalTo: avatarView.leftAnchor).isActive = true
        avatarContent.rightAnchor.constraint(equalTo: avatarView.rightAnchor).isActive = true
        avatarContent.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor).isActive = true
        
        avatarOptions.displayFacialFeatureOptionsCallback = displayFacialFeatureOptions
        setUpColorStack(colors: AppColors.skintoneArray)
        configureBottomBar()
        backgroundColor.backgroundColor = AppColors.backgroundColorArray[0]
        
        backgroundColor.layer.cornerRadius = 50
        
        // declare delegate and source for collection
        elemCollectionView.dataSource = self
        elemCollectionView.delegate = self
        
        avatarContent.setHairColor(color: AppColors.hairColorArray[generatedAvatar.hairColor])
        avatarContent.setSkinColor(color: AppColors.skintoneArray[generatedAvatar.skinTone])
        
        displayFacialFeatureOptions(index: 0)
        nameTextField.delegate = self
        nameTextField.autocapitalizationType = .words
        
        if nameTextField.text?.trimmingCharacters(in: .whitespaces) == "Enter Full Name Here" {
            saveAvatarButton.isEnabled = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        elemCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func onEditNameBegin(_ sender: Any) {
        if nameTextField.text == "Enter First and Last Name Here" {
            nameTextField.text = ""
        }
    }
    
    @IBAction func onEditNameEnd(_ sender: Any) {
        if nameTextField.text == "" {
            nameTextField.text = "Enter First and Last Name Here"
        }
        
        if nameTextField.text?.trimmingCharacters(in: .whitespaces) != "Enter Full Name Here" {
            saveAvatarButton.isEnabled = true
            
            let fullName = nameTextField.text!.trimmingCharacters(in: .whitespaces)
            var firstName = ""
            var lastName = ""
            var components = fullName.components(separatedBy: " ")
            if components.count > 0 {
                firstName = components.removeFirst()
                lastName = ""
                for i in 0..<(components.count) {
                    lastName += "\(components[i]) "
                }
                lastName = lastName.trimmingCharacters(in: .whitespaces)
            }
            
            let firstNameUppercased = firstName.uppercased()
            let lastNameUppercased = lastName.uppercased()
            var initials = ""
            
            if firstNameUppercased.count > 0 {
                let firstNameIndex = firstNameUppercased.index(firstNameUppercased.startIndex, offsetBy: 1)
                initials += firstNameUppercased.prefix(upTo: firstNameIndex)
            }
            if lastNameUppercased.count > 0 {
                let lastNameIndex = lastNameUppercased.index(lastNameUppercased.startIndex, offsetBy: 1)
                initials += lastNameUppercased.prefix(upTo: lastNameIndex)
            }
            
            StoredValues.set(key: StoredValuesConstants.firstName, value: firstName)
            StoredValues.set(key: StoredValuesConstants.lastName, value: lastName)
            StoredValues.set(key: StoredValuesConstants.initials, value: initials)
            
            if editNameCallback != nil {
                editNameCallback()
            }
            
        } else {
            saveAvatarButton.isEnabled = false
        }
    }
    
   /**
    * Called when the user click on the view (outside the UITextField).
    */
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setUpColorStack(colors: [UIColor]) {
        for _ in 0..<colorOptionsStack.subviews.count {
            colorOptionsStack.subviews[0].removeFromSuperview()
        }
        
        for i in 0..<colors.count {
            let colorView = AvatarColorOption(color: colors[i], colorIndex: i)
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
            (colorOptionsStack.arrangedSubviews[generatedAvatar.hairColor] as! AvatarColorOption).selectWithoutAnimation()
        case "Head":
            colorScrollHeight.constant = colorScrollHeightConstant
            setUpColorStack(colors: AppColors.skintoneArray)
            (colorOptionsStack.arrangedSubviews[generatedAvatar.skinTone] as! AvatarColorOption).selectWithoutAnimation()
        case "Brows":
            colorScrollHeight.constant = colorScrollHeightConstant
            setUpColorStack(colors: AppColors.hairColorArray)
            (colorOptionsStack.arrangedSubviews[generatedAvatar.hairColor] as! AvatarColorOption).selectWithoutAnimation()
        case "Background":
            colorScrollHeight.constant = colorScrollHeightConstant
            setUpColorStack(colors: AppColors.backgroundColorArray)
            (colorOptionsStack.arrangedSubviews[generatedAvatar.backgroundIndex] as! AvatarColorOption).selectWithoutAnimation()
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
    func colorTapped(colorIndex: Int) {
        switch AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName {
        case "Hair":
            (colorOptionsStack.arrangedSubviews[generatedAvatar.hairColor] as! AvatarColorOption).deselect()
            avatarContent.setHairColor(color: AppColors.hairColorArray[colorIndex])
            generatedAvatar.hairColor = colorIndex
        case "Head":
            (colorOptionsStack.arrangedSubviews[generatedAvatar.skinTone] as! AvatarColorOption).deselect()
            avatarContent.setSkinColor(color: AppColors.skintoneArray[colorIndex])
            generatedAvatar.skinTone = colorIndex
        case "Brows":
            (colorOptionsStack.arrangedSubviews[generatedAvatar.hairColor] as! AvatarColorOption).deselect()
            avatarContent.setHairColor(color: AppColors.hairColorArray[colorIndex])
            generatedAvatar.hairColor = colorIndex
        case "Background":
            (colorOptionsStack.arrangedSubviews[generatedAvatar.backgroundIndex] as! AvatarColorOption).deselect()
            backgroundColor.backgroundColor = AppColors.backgroundColorArray[colorIndex]
            generatedAvatar.backgroundIndex = colorIndex
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
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.gray.cgColor
        
        if AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName == "Hair" && generatedAvatar.hairIndex == indexPath.item {
            cell.layer.borderWidth = 2
        } else if AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName == "Head" && generatedAvatar.chinIndex == indexPath.item {
            cell.layer.borderWidth = 2
        } else if AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName == "Brows" && generatedAvatar.browIndex == indexPath.item {
            cell.layer.borderWidth = 2
        } else if AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName == "Nose" && generatedAvatar.noseIndex == indexPath.item {
            cell.layer.borderWidth = 2
        } else if AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName == "Ears" && generatedAvatar.earIndex == indexPath.item {
            cell.layer.borderWidth = 2
        } else if AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName == "Eyes" && generatedAvatar.glassIndex == indexPath.item {
            cell.layer.borderWidth = 2
        } else if AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName == "Mouth" && generatedAvatar.mouthIndex == indexPath.item {
            cell.layer.borderWidth = 2
        } else {
            cell.layer.borderWidth = 0
        }
        
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
        
        avatarOption.setSkinColor(color: AppColors.skintoneArray[generatedAvatar.skinTone])
        avatarOption.setHairColor(color: AppColors.hairColorArray[generatedAvatar.hairColor])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<collectionView.subviews.count {
            collectionView.subviews[i].layer.borderWidth = 0
        }
        
        let cell = collectionView.cellForItem(at: indexPath)!
        let facialFeature = cell.subviews[0] as! FacialFeatureOption
        collectionView.cellForItem(at: indexPath)!.layer.borderWidth = 2
        
        switch AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName {
        case "Hair":
            avatarContent.hairBack.image = facialFeature.hairBack.image
            avatarContent.hairFront.image = facialFeature.hairFront.image
            avatarContent.hairMidBack.image = facialFeature.hairMidBack.image
            avatarContent.hairMidFront.image = facialFeature.hairMidFront.image
            generatedAvatar.hairIndex = indexPath.item
        case "Head":
            avatarContent.chin.image = facialFeature.chin.image
            avatarContent.beard.image = facialFeature.beard.image
            generatedAvatar.chinIndex = indexPath.item
        case "Brows":
            avatarContent.brows.image = facialFeature.brows.image
            generatedAvatar.browIndex = indexPath.item
        case "Nose":
            avatarContent.nose.image = facialFeature.nose.image
            generatedAvatar.noseIndex = indexPath.item
        case "Ears":
            avatarContent.ears.image = facialFeature.ears.image
            generatedAvatar.earIndex = indexPath.item
        case "Eyes":
            avatarContent.eyes.image = facialFeature.eyes.image
            avatarContent.glasses.image = facialFeature.glasses.image
            generatedAvatar.glassIndex = indexPath.item
        case "Mouth":
            avatarContent.mouth.image = facialFeature.mouth.image
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
    
    //MARK: COLLECTION VIEW METHODS END HERE
    
    
    //MARK: METHODS FOR SAVING AVATARS START HERE
    
    func storeAvatar() {
        // Update generatedAVatar with the user's current selection of variables
        StoredValues.set(key: StoredValuesConstants.userAvatar, value: generatedAvatar.getJsonValue())
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        storeAvatar()
        if editProfileCallback != nil {
            editProfileCallback()
        }
        
        // dismiss the avatarCreatorView
        self.dismiss(animated: true)
    }
    
    //MARK: END OF AVATAR SAVNG FUNCTIONS
}
