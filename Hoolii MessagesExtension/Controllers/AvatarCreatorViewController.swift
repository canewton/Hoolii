//
//  AvatarCreatorViewController.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 12/15/22.
//

import UIKit

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

class AvatarCreatorViewController: AppViewController, ViewControllerWithIdentifier, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
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
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var editTextIcon: UIImageView!
    @IBOutlet weak var screenLabel: UILabel!
    
    @IBOutlet weak var avatarOptionsHeight: NSLayoutConstraint!
    @IBOutlet weak var backgroundHeight: NSLayoutConstraint!
    @IBOutlet weak var mainProfileViewHeight: NSLayoutConstraint!
    @IBOutlet weak var colorScrollHeight: NSLayoutConstraint!
    @IBOutlet weak var colorScrollSpacingHeight: NSLayoutConstraint!
    
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
    var editNameCallback: (() -> Void)!
    var editProfileCallback: (() -> Void)!
    
    // For onboarding
    var prevController: UIViewController!
    var dismissCallback: (() -> Void)!
    
    // Define the actual avatar variable being made/stored
    var generatedAvatar: Avatar = Avatar()
    
    // MARK: VARIABLE DECLARATION END
    
    
    override func viewDidLoad() {
        // Function loaded: set all initial colors for elements
        super.viewDidLoad()
        
        MessagesViewController.currViewController = self

        let firstName: String = StoredValues.get(key: StoredValuesConstants.firstName) ?? ""
        let lastName: String = StoredValues.get(key: StoredValuesConstants.lastName) ?? ""
        let fullName: String = "\(firstName) \(lastName)"
        if fullName.trimmingCharacters(in: .whitespaces) != "" {
            nameTextField.text = fullName
        } else {
            nameTextField.text = "Enter First and Last Name Here"
        }
        
        let storedAvatar = StoredValues.get(key: StoredValuesConstants.userAvatar)
        if storedAvatar != nil {
            generatedAvatar = Avatar(jsonValue: storedAvatar!)
            avatarContent = AvatarImageCollection(avatar: generatedAvatar)
            backgroundColor.backgroundColor = AppColors.backgroundColorArray[generatedAvatar.backgroundIndex]
        } else {
            avatarContent = AvatarImageCollection().addHair(front: AvatarConstants.hairOption8.hairFront, back: AvatarConstants.hairOption8.hairBack).addMouth(AvatarConstants.mouthOption1.mouth).addEyes(AvatarConstants.eyeOption1.eyes).addNose(AvatarConstants.noseOption1.nose)
            backgroundColor.backgroundColor = AppColors.backgroundColorArray[0]
        }
        
        if StoredValues.isKeyNil(key: StoredValuesConstants.hasBeenOnboarded) {
            screenLabel.text = "Create A New Profile"
        } else {
            screenLabel.text = "Edit Profile"
        }
        
        mainProfileViewHeight.constant = view.bounds.height * 1.0/1000.0 * 200
        backgroundHeight.constant = view.bounds.height * 1.0/1000.0 * 100
        colorScrollSpacingHeight.constant = view.bounds.height * 1.0/1000.0 * 12
        
        avatarDisplay = FacialFeatureOption.instanceFromNib(images: avatarContent)
        avatarView.addSubview(avatarDisplay)
        avatarDisplay.translatesAutoresizingMaskIntoConstraints = false
        avatarDisplay.topAnchor.constraint(equalTo: avatarView.topAnchor).isActive = true
        avatarDisplay.leftAnchor.constraint(equalTo: avatarView.leftAnchor).isActive = true
        avatarDisplay.rightAnchor.constraint(equalTo: avatarView.rightAnchor).isActive = true
        avatarDisplay.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor).isActive = true
        
        avatarOptions.displayFacialFeatureOptionsCallback = displayFacialFeatureOptions
        setUpColorStack(colors: AppColors.skintoneArray)
        configureBottomBar()
        
        backgroundColor.layer.cornerRadius = backgroundHeight.constant/2
        
        // declare delegate and source for collection
        elemCollectionView.dataSource = self
        elemCollectionView.delegate = self
        elemCollectionView.register(UINib(nibName: "FacialFeatureOption", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        avatarDisplay.setHairColor(color: AppColors.hairColorArray[generatedAvatar.hairColor])
        avatarDisplay.setSkinColor(color: AppColors.skintoneArray[generatedAvatar.skinTone])
        
        displayFacialFeatureOptions(index: 0)
        nameTextField.delegate = self
        nameTextField.autocapitalizationType = .words
        
        if nameTextField.text?.trimmingCharacters(in: .whitespaces) == "Enter First and Last Name Here" {
            saveAvatarButton.isEnabled = false
        }
        
        let editTextTap = UITapGestureRecognizer(target: self, action: #selector(editTextOnTap(gesture:)))
        editTextIcon.isUserInteractionEnabled = true
        editTextIcon.addGestureRecognizer(editTextTap)
    }
    
    @objc func editTextOnTap(gesture: UITapGestureRecognizer) {
        nameTextField.becomeFirstResponder()
        let newPosition = nameTextField.endOfDocument
        nameTextField.selectedTextRange = nameTextField.textRange(from: newPosition, to: newPosition)
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func onEditNameBegin(_ sender: Any) {
        if nameTextField.text?.trimmingCharacters(in: .whitespaces) == "Enter First and Last Name Here" {
            nameTextField.text = ""
        }
    }
    
    @IBAction func onEditNameEnd(_ sender: Any) {
        if nameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
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
            colorScrollHeight.constant = view.bounds.height * 1/900 * 40
            let colorView = AvatarColorOption(color: colors[i], colorIndex: i, unselectedHeight: colorScrollHeight.constant, selectedHeight: colorScrollHeight.constant * 3.0/4.0)
            colorOptionsStack.addArrangedSubview(colorView)
            colorView.centerYAnchor.constraint(equalTo: colorOptionsStack.centerYAnchor).isActive = true
            colorView.callback = colorTapped
        }
    }
    
    func configureBottomBar() {
        if traitCollection.userInterfaceStyle == .light {
            bottomBar.layer.shadowColor = AppColors.shadowColor.cgColor
            bottomBar.layer.shadowOpacity = 0.4
            bottomBar.layer.shadowOffset = .zero
            bottomBar.layer.shadowRadius = 10
        } else {
            bottomBar.layer.shadowColor = UIColor.systemGray.cgColor
            bottomBar.layer.shadowOpacity = 0.2
            bottomBar.layer.shadowOffset = .zero
            bottomBar.layer.shadowRadius = 2
            bottomBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        }
        
        saveAvatarButton.setImage(ScaledIcon(name: "checkmark", width: 15, height: 15, color: .label).image, for: .normal)
    }
    
    func displayFacialFeatureOptions(index: Int) {
        collectionViewArr = AvatarConstants.facialFeatureSelectionList[index].options
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
        collectionViewArr = []
        self.dismiss(animated: true)
    }
    
    // MARK: COLOR SELECTION METHODS BEGIN HERE
    func colorTapped(colorIndex: Int) {
        switch AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName {
        case "Hair":
            (colorOptionsStack.arrangedSubviews[generatedAvatar.hairColor] as! AvatarColorOption).deselect()
            avatarContent.hairColor = colorIndex
            avatarDisplay.setHairColor(color: AppColors.hairColorArray[colorIndex])
            generatedAvatar.hairColor = colorIndex
        case "Head":
            (colorOptionsStack.arrangedSubviews[generatedAvatar.skinTone] as! AvatarColorOption).deselect()
            avatarContent.skinTone = colorIndex
            avatarDisplay.setSkinColor(color: AppColors.skintoneArray[colorIndex])
            generatedAvatar.skinTone = colorIndex
        case "Brows":
            (colorOptionsStack.arrangedSubviews[generatedAvatar.hairColor] as! AvatarColorOption).deselect()
            avatarContent.skinTone = colorIndex
            avatarDisplay.setHairColor(color: AppColors.hairColorArray[colorIndex])
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
        return collectionViewArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCollectionViewCell
        cell.data = AvatarCellData(
            images: collectionViewArr[indexPath.item],
            facialFeatureSelection: AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName,
            skinColor: AppColors.skintoneArray[generatedAvatar.skinTone],
            hairColor: AppColors.hairColorArray[generatedAvatar.hairColor],
            avatar: generatedAvatar,
            cellIndex: indexPath.item
        )
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        (cell as! AvatarCollectionViewCell).data = nil
//    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        (cell as! AvatarCollectionViewCell).data = AvatarCellData(
//            images: collectionViewArr[indexPath.item],
//            facialFeatureSelection: AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName,
//            skinColor: AppColors.skintoneArray[generatedAvatar.skinTone],
//            hairColor: AppColors.hairColorArray[generatedAvatar.hairColor],
//            avatar: generatedAvatar,
//            cellIndex: indexPath.item
//        )
//    }
    
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
    
    //MARK: COLLECTION VIEW METHODS END HERE
    
    
    //MARK: METHODS FOR SAVING AVATARS START HERE
    
    func storeAvatar() {
        // Update generatedAVatar with the user's current selection of variables
        StoredValues.set(key: StoredValuesConstants.userAvatar, value: generatedAvatar.getJsonValue())
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        storeAvatar()
        
        changeProfileButtonAvatars(avatar: generatedAvatar)
        
        if editProfileCallback != nil {
            editProfileCallback()
        }
        
//        for _ in 0..<collectionViewArr.count {
//            collectionViewArr.remove(at: 0)
//        }
//        elemCollectionView.reloadData()
        elemCollectionView = nil
        
        if StoredValues.isKeyNil(key: StoredValuesConstants.hasBeenOnboarded) {
            StoredValues.setIfEmpty(key: StoredValuesConstants.hasBeenOnboarded, value: "yes")
            self.dismiss(animated: true, completion: { () -> Void in self.prevController.dismiss(animated: true, completion: self.dismissCallback)})
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func changeProfileButtonAvatars(avatar: Avatar) {
        print(avatar.skinTone)
        ProfileButton.profileIcon.avatarDisplay!.setFromImageCollection(images: AvatarImageCollection(avatar: avatar))
        ProfileButton.profileIcon.backgroundColor = AppColors.backgroundColorArray[avatar.backgroundIndex]
        ProfileButton.profileIcon.avatarDisplay!.setHairColor(color: AppColors.hairColorArray[avatar.hairColor])
        ProfileButton.profileIcon.avatarDisplay!.setSkinColor(color: AppColors.skintoneArray[avatar.skinTone])
        
        ProfileButton.profileIcon.topConstraint.constant = -1 * ProfileButton.profileIcon.avatar!.getShiftConst() * ProfileButton.height + 1
        ProfileButton.profileIcon.bottomConstraint.constant = -1 * ProfileButton.profileIcon.avatar!.getShiftConst() * ProfileButton.height - 1
        ProfileButton.profileIcon.avatar = avatar
    }
    
    //MARK: END OF AVATAR SAVNG FUNCTIONS
}
