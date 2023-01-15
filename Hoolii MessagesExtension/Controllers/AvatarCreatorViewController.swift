//
//  AvatarCreatorViewController.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 12/15/22.
//

import UIKit

 // MARK: VARIABLE DECLARATION START
class AvatarCreatorViewController: AppViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Outlets for display of Avatar
    @IBOutlet weak var avatarOptions: AvatarOptions!
    @IBOutlet weak var colorOptionsStack: UIStackView!
    @IBOutlet weak var avatarContainerImgView: UIView!
    
    @IBOutlet weak var avatarBackgroundImageView: UIImageView!
    @IBOutlet weak var backHairImgView: UIImageView!
    @IBOutlet weak var headImgView: UIImageView!
    @IBOutlet weak var earImgView: UIImageView!
    @IBOutlet weak var chinImgView: UIImageView!
    @IBOutlet weak var beardImgView: UIImageView!
    @IBOutlet weak var noseImgView: UIImageView!
    @IBOutlet weak var mouthImgView: UIImageView!
    @IBOutlet weak var eyeImgView: UIImageView!
    @IBOutlet weak var glassFrameImgVIew: UIImageView!
    @IBOutlet weak var glassLensImgView: UIImageView!
    @IBOutlet weak var eyebrowImgView: UIImageView!
    @IBOutlet weak var sideHairImgView: UIImageView!
    @IBOutlet weak var frontHairImgView: UIImageView!
    @IBOutlet weak var hairTieImgView: UIImageView!
    
    // Outlets for Skin/Hair Color Selectors
    @IBOutlet weak var colorImage1: UIImageView!
    @IBOutlet weak var colorImage2: UIImageView!
    @IBOutlet weak var colorImage3: UIImageView!
    @IBOutlet weak var colorImage4: UIImageView!
    @IBOutlet weak var colorImage5: UIImageView!
    @IBOutlet weak var colorImage6: UIImageView!
    @IBOutlet weak var colorImage7: UIImageView!
    @IBOutlet weak var colorImage8: UIImageView!
    @IBOutlet weak var colorImage9: UIImageView!
    @IBOutlet weak var colorImage10: UIImageView!
    @IBOutlet weak var colorImage11: UIImageView!
    @IBOutlet weak var colorImage12: UIImageView!
    @IBOutlet weak var colorImage13: UIImageView!
    @IBOutlet weak var colorImage14: UIImageView!
    @IBOutlet weak var colorImage15: UIImageView!
    @IBOutlet weak var colorImage16: UIImageView!
    @IBOutlet weak var colorImage17: UIImageView!
    
    
    // Outlet for element table
    @IBOutlet weak var elemCollectionView: UICollectionView!
    
    // Declaration of static variables used in AvatarCreator Exclusively
    var hairColor = UIColor.black
    var skinTone = UIColor.gray
    var currFacialFeature: Int = 0
    var itemIndex = 0
    var facialFeatureIconIndex: Int = 0
    
    // Define the actual avatar variable being made/stored
    
    var generatedAvatar: Avatar = Avatar(chinIndex: 0, earIndex: 0, browIndex: 0, glassIndex: 0, mouthIndex: 0, noseIndex: 0, hairIndex: 0, skinTone: 0, hairColor: 0, backgroundIndex: 0)
    
// MARK: VARIABLE DECLARATION END
    
    
    override func viewDidLoad() {
        // Function loaded: set all initial colors for elements
        super.viewDidLoad()
        initColors()
        avatarBackgroundImageView.layer.cornerRadius = 109.5
        avatarBackgroundImageView.clipsToBounds = true
        
        avatarBackgroundImageView.clipsToBounds = true
        
        avatarOptions.displayFacialFeatureOptionsCallback = displayFacialFeatureOptions
        setUpColorStack(colors: AppColors.skintoneArray)
        
        // declare delegate and source for collection
        elemCollectionView.dataSource = self
        elemCollectionView.delegate = self
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
    
    func displayFacialFeatureOptions(index: Int) {
        facialFeatureIconIndex = index
        elemCollectionView.reloadData()
    }
    
    // Dismiss screen if user presses back button to return to profile creation
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // MARK: COLOR SELECTION METHODS BEGIN HERE
    func colorTapped(color: UIColor) {
        headImgView.tintColor = color
        chinImgView.tintColor = color
    }
    
    
    // Change colors of hair/skin/background color selector image views based on current feature user has selected
    func swapColorSet() {
        if(currFacialFeature < 6) {
            // Case 1: Skin tone
            replaceColorInImages(colorArray: AppColors.skintoneArray)
        } else if (currFacialFeature == 6) {
            // Case two: Hair Color
            replaceColorInImages(colorArray: AppColors.hairColorArray)
        } else if (currFacialFeature > 6) {
            // Case Three: background Color
            replaceColorInImages(colorArray: AppColors.backgroundColorArray)
        }
    }// End of swapColorsSet
    
    
    // Changes the colors of the various skin/hair/background color selectors
    func replaceColorInImages(colorArray: [UIColor]) {
        let imageViews = [colorImage1, colorImage2, colorImage3, colorImage4, colorImage5, colorImage6, colorImage7, colorImage8, colorImage9, colorImage10, colorImage11, colorImage12, colorImage13, colorImage14, colorImage15, colorImage16, colorImage17]
        var index = 0
        for imageView in imageViews {
            if (index < colorArray.count) {
                imageView?.isHidden = false
                imageView?.backgroundColor = colorArray[index]
                // Add shadows to the images
                imageView?.layer.shadowColor = UIColor.gray.cgColor
                imageView?.layer.shadowOpacity = 0.5
                imageView?.layer.shadowRadius = 4
                imageView?.layer.shadowOffset = CGSize(width: 0, height: 4)
                index += 1
            } else {
                // hide both the image and its shadow
                imageView?.isHidden = true
                imageView?.layer.shadowOpacity = 0.0
            }
        }
    }
    
    // This function changes the color of the avatar based on the Index of the feature and color provided to it
    func changeColor(colorIndex: Int, featureChanged: Int) {
        if (featureChanged < 6) {
            // in this case, user is modifying facial features
            headImgView.tintColor = AppColors.skintoneArray[colorIndex]
            chinImgView.tintColor = AppColors.skintoneArray[colorIndex]
            skinTone = AppColors.skintoneArray[colorIndex]
            generatedAvatar.skinTone = colorIndex
        } else if (featureChanged == 6) {
            // user is changing hair color
            backHairImgView.tintColor = AppColors.hairColorArray[colorIndex]
            frontHairImgView.tintColor = AppColors.hairColorArray[colorIndex]
            sideHairImgView.tintColor = AppColors.hairColorArray[colorIndex]
            // check for beard to recolor
            if(beardImgView.image != UIImage(imageLiteralResourceName: "transparent")) {
                beardImgView.tintColor = AppColors.hairColorArray[colorIndex]
            }
            hairColor = AppColors.hairColorArray[colorIndex]
            generatedAvatar.hairColor = colorIndex
        } else if (featureChanged > 6) {
            // User is changing the background color
            avatarBackgroundImageView.backgroundColor = AppColors.backgroundColorArray[colorIndex]
            generatedAvatar.backgroundIndex = colorIndex
        }
        
    }
    
    // Initialize the starting hair and skin tones to the first available options
    func initColors(){
        // Initialize facial details w/ default vals
        changeColor(colorIndex: 0, featureChanged: 0)
        // Initialize hair with default color
        changeColor(colorIndex: 0, featureChanged: 6)
        swapColorSet()
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
        let avatarOption = AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].options[indexPath.item]
        cell.addSubview(avatarOption)
        avatarOption.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        avatarOption.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        avatarOption.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        avatarOption.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        avatarOption.tapCallback = tapAvatarOption
        
        return cell
    }
    
    func tapAvatarOption(facialFeature: FacialFeatureOption) {
        switch AvatarConstants.facialFeatureSelectionList[facialFeatureIconIndex].iconName {
        case "Hair":
            backHairImgView.image = facialFeature.hairBack.image
            frontHairImgView.image = facialFeature.hairFront.image
        case "Head":
            chinImgView.image = facialFeature.chin.image
            beardImgView.image = facialFeature.beard.image
        case "Brows":
            eyebrowImgView.image = facialFeature.brows.image
        case "Nose":
            noseImgView.image = facialFeature.nose.image
        case "Ears":
            earImgView.image = facialFeature.ears.image
        case "Eyes":
            eyeImgView.image = facialFeature.eyes.image
            glassFrameImgVIew.image = facialFeature.glasses.image
        case "Mouth":
            mouthImgView.image = facialFeature.mouth.image
        default:
            return
        }
    }
    
    //MARK: COLLECTION VIEW METHODS END HERE
    
    
    //MARK: METHODS FOR SAVING/RESTORING AVATARS START HERE
    // Given an avatar object, reproduce the user's avatar offscreen with a given size and return it as a UIImage
    static func recreateAvatar(size: CGSize, avatarIndices: Avatar) -> UIImage {
        // Create all of the images
        let backHairImage = UIImage(named: AvatarConstants.backHairArray[avatarIndices.hairIndex])?.withTintColor(AppColors.skintoneArray[avatarIndices.skinTone])
        let headImage = UIImage(named: "Ear 1 + Head")?.withTintColor(AppColors.skintoneArray[avatarIndices.skinTone])
        let earImage = UIImage(named: AvatarConstants.earArray[avatarIndices.earIndex])
        // Consider exceptions for beards
        var chinImage = UIImage(named: AvatarConstants.chinArray[avatarIndices.chinIndex])?.withTintColor(AppColors.skintoneArray[avatarIndices.skinTone])
        var beardImage = UIImage(named: "transparent")
        var mouthImage = UIImage(named: AvatarConstants.mouthArray[avatarIndices.mouthIndex])
        if (avatarIndices.chinIndex > 2) {
            chinImage = UIImage(named: AvatarConstants.chinArray[1])?.withTintColor(AppColors.skintoneArray[avatarIndices.skinTone])
            beardImage = UIImage(named: AvatarConstants.chinArray[avatarIndices.chinIndex])
            mouthImage = UIImage(named: AvatarConstants.mouthArray[0])
        }
        let noseImage = UIImage(named: AvatarConstants.noseArray[avatarIndices.noseIndex])
        let eyeImage = UIImage(named: "Eyes 1")
        let browImage = UIImage(named: AvatarConstants.browArray[avatarIndices.browIndex])
        let lensImage = UIImage(named:AvatarConstants.lensArray[avatarIndices.glassIndex])
        let sideHairImage = UIImage(named:AvatarConstants.hairSideArray[avatarIndices.hairIndex])
        let frontHairImage = UIImage(named:AvatarConstants.frontHairArray[avatarIndices.hairIndex])
        let hairTieImage = UIImage(named: AvatarConstants.hairTieArray[avatarIndices.hairIndex])
        let frameImage = UIImage(named: AvatarConstants.frameArray[avatarIndices.glassIndex])
        
        // create Image context offscreen
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // draw images into context
        backHairImage?.draw(at: .zero)
        headImage?.draw(at: .zero)
        earImage?.draw(at: .zero)
        chinImage?.draw(at: .zero)
        beardImage?.draw(at: .zero)
        noseImage?.draw(at: .zero)
        mouthImage?.draw(at: .zero)
        eyeImage?.draw(at: .zero)
        browImage?.draw(at: .zero)
        lensImage?.draw(at: .zero)
        sideHairImage?.draw(at: .zero)
        frontHairImage?.draw(at: .zero)
        hairTieImage?.draw(at: .zero)
        frameImage?.draw(at: .zero)
        
        // Obtain image and end context
        let avatarImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        // Return avatar image
        return avatarImage!
    }
    
    func storeAvatar() {
        // Update generatedAVatar with the user's current selection of variables
        StoredValues.set(key: StoredValuesConstants.userAvatar, value: generatedAvatar.getJsonValue())
        // dismiss the avatarCreatorView
        self.dismiss(animated: true)
    }
    //MARK: END OF AVATAR SAVNG/RESTORATION FUNCTIONS
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        storeAvatar()
    }
    
    
} // MARK: end of AvatarViewCreator Class




