//
//  AvatarCreatorViewController.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 12/15/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellBackHairView: UIImageView!
    @IBOutlet weak var cellHeadEarView: UIImageView!
    @IBOutlet weak var cellChinImageView: UIImageView!
    @IBOutlet weak var cellSideGroundImageView: UIImageView!
    @IBOutlet weak var cellBackFeatureView: UIImageView!
    @IBOutlet weak var cellFrontFeatureView: UIImageView!
}

 // MARK: VARIABLE DECLARATION START
class AvatarCreatorViewController: AppViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Outlets for display of Avatar
    @IBOutlet weak var avatarContainerImgView: UIView!
    @IBOutlet weak var facialFeatureStackView: UIStackView!
    
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
    
    // Outlet for element selector of Images
    @IBOutlet weak var selectFaceImgView: UIImageView!
    @IBOutlet weak var selectEyeImgView: UIImageView!
    @IBOutlet weak var selectNoseImgView: UIImageView!
    @IBOutlet weak var selectBrowImgView: UIImageView!
    @IBOutlet weak var selectMouthImgView: UIImageView!
    @IBOutlet weak var selectHairImgView: UIImageView!
    @IBOutlet weak var selectEarImgView: UIImageView!
    @IBOutlet weak var selectBackgroundImgView: UIImageView!
    
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
    
    // Define the actual avatar variable being made/stored
    
    var generatedAvatar: Avatar = Avatar(chinIndex: 0, earIndex: 0, browIndex: 0, glassIndex: 0, mouthIndex: 0, noseIndex: 0, hairIndex: 0, skinTone: 0, hairColor: 0, backgroundIndex: 0)
    
// MARK: VARIABLE DECLARATION END
    
    
    override func viewDidLoad() {
        // Function loaded: set all initial colors for elements
        super.viewDidLoad()
        initColors()
        avatarBackgroundImageView.layer.cornerRadius = 109.5
        avatarBackgroundImageView.clipsToBounds = true
        
        selectFaceImgView.backgroundColor = AppColors.featureColorArray[1]
        
        avatarBackgroundImageView.clipsToBounds = true
        
        // Enable gesture recognition for facial feature selection
        for imageView in [selectFaceImgView, selectEyeImgView, selectNoseImgView, selectBrowImgView, selectMouthImgView, selectEarImgView, selectHairImgView, selectBackgroundImgView] {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapFunct(tapGestureRecognizer:)))
            imageView?.isUserInteractionEnabled = true
            imageView?.addGestureRecognizer(tapGestureRecognizer)
        }
        for colorImageView in [colorImage1, colorImage2, colorImage3, colorImage4, colorImage5, colorImage6, colorImage7, colorImage8, colorImage9, colorImage10, colorImage11, colorImage12, colorImage13, colorImage14, colorImage15, colorImage16, colorImage17] {
            let colorTapRecognizer = UITapGestureRecognizer(target:self, action: #selector(colorTapped(colorTapRecognizer:)))
            colorImageView?.isUserInteractionEnabled = true
            colorImageView?.addGestureRecognizer(colorTapRecognizer)
        }
        // declare delegate and source for collection
        elemCollectionView.dataSource = self
        elemCollectionView.delegate = self
    }
    
    // Dismiss screen if user presses back button to return to profile creation
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    //MARK: CHANGING OF AVATAR FEATURES FUNCTIONS HANDLED HERE
    @objc func tapFunct(tapGestureRecognizer:UITapGestureRecognizer){
        if let featureTapped = tapGestureRecognizer.view as? UIImageView {
            if featureTapped == selectFaceImgView {
                // Color in the button
                updateFeatureSelection(newFeature: 0)
                selectFaceImgView.backgroundColor = AppColors.featureColorArray[1]
                // Generate new cells for the collection view
                AvatarConstants.cellBackHairArray = Array(repeating: "transparent",count: AvatarConstants.chinArray.count)
                AvatarConstants.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarConstants.chinArray.count)
                AvatarConstants.cellChinArray = ["Chin 1.svg", "Chin 2.svg", "Chin 3.svg", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2"]
                AvatarConstants.cellSideHairArray = Array(repeating: "transparent", count: AvatarConstants.chinArray.count)
                AvatarConstants.cellBackFeatureArray = Array(repeating: "transparent", count: AvatarConstants.chinArray.count)
                AvatarConstants.cellFrontFeatureArray = ["transparent", "transparent", "transparent", "Chin 4 Beard.svg", "Chin 5 Beard.svg", "Chin 6 Beard.svg", "Chin 7 Beard.svg", "Chin 8 Beard.svg", "Chin 9 Beard.svg", "Chin 10 Beard.svg"]
            } else if featureTapped == selectEyeImgView {
                // color in button
                updateFeatureSelection(newFeature: 1)
                selectEyeImgView.backgroundColor = AppColors.featureColorArray[1]
                // generate new cells in collection view
                AvatarConstants.cellBackHairArray = Array(repeating: "transparent", count: AvatarConstants.lensArray.count)
                AvatarConstants.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarConstants.frameArray.count)
                AvatarConstants.cellChinArray = Array(repeating: AvatarConstants.chinArray[(generatedAvatar.chinIndex) % 3], count: AvatarConstants.frameArray.count)
                AvatarConstants.cellSideHairArray = Array(repeating: "transparent", count: AvatarConstants.lensArray.count)
                AvatarConstants.cellFrontFeatureArray = AvatarConstants.frameArray
                AvatarConstants.cellBackFeatureArray = AvatarConstants.lensArray
                
            } else if featureTapped == selectNoseImgView {
                // Color in button
                updateFeatureSelection(newFeature: 2)
                selectNoseImgView.backgroundColor = AppColors.featureColorArray[1]
                // generate new cells in collection view
                AvatarConstants.cellBackHairArray = Array(repeating: "transparent", count: AvatarConstants.noseArray.count)
                AvatarConstants.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarConstants.frameArray.count)
                AvatarConstants.cellChinArray = Array(repeating: AvatarConstants.chinArray[(generatedAvatar.chinIndex) % 3], count: AvatarConstants.frameArray.count)
                AvatarConstants.cellSideHairArray = Array(repeating: "transparent", count: AvatarConstants.noseArray.count)
                AvatarConstants.cellBackFeatureArray = Array(repeating: "transparent", count: AvatarConstants.noseArray.count)
                AvatarConstants.cellFrontFeatureArray = AvatarConstants.noseArray
                
            } else if featureTapped == selectBrowImgView {
                // update button color
                updateFeatureSelection(newFeature: 3)
                selectBrowImgView.backgroundColor = AppColors.featureColorArray[1]
                // Generate new cells in collection view
                AvatarConstants.cellBackHairArray =  Array(repeating: "transparent", count: AvatarConstants.browArray.count)
                AvatarConstants.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarConstants.browArray.count)
                AvatarConstants.cellChinArray = Array(repeating: AvatarConstants.chinArray[(generatedAvatar.chinIndex) % 3], count: AvatarConstants.browArray.count)
                AvatarConstants.cellSideHairArray = Array(repeating: "transparent", count: AvatarConstants.browArray.count)
                AvatarConstants.cellBackFeatureArray = Array(repeating: "transparent", count: AvatarConstants.browArray.count)
                AvatarConstants.cellFrontFeatureArray = AvatarConstants.browArray
                
            } else if featureTapped == selectMouthImgView {
                // update button Color
                updateFeatureSelection(newFeature: 4)
                selectMouthImgView.backgroundColor = AppColors.featureColorArray[1]
                // Generate new cells in collection view
                AvatarConstants.cellBackHairArray = Array(repeating: "transparent", count: AvatarConstants.mouthArray.count)
                AvatarConstants.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarConstants.mouthArray.count)
                AvatarConstants.cellChinArray = Array(repeating: AvatarConstants.chinArray[(generatedAvatar.chinIndex) % 3], count: AvatarConstants.mouthArray.count)
                AvatarConstants.cellSideHairArray = Array(repeating: "transparent", count: AvatarConstants.mouthArray.count)
                AvatarConstants.cellBackFeatureArray = Array(repeating: "transparent", count: AvatarConstants.mouthArray.count)
                AvatarConstants.cellFrontFeatureArray = AvatarConstants.mouthArray
                
            } else if featureTapped == selectEarImgView {
                // Update Button Color
                updateFeatureSelection(newFeature: 5)
                selectEarImgView.backgroundColor = AppColors.featureColorArray[1]
                //  Generate new cells in collection view
                AvatarConstants.cellBackHairArray =  Array(repeating: "transparent", count: AvatarConstants.earArray.count)
                AvatarConstants.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarConstants.earArray.count)
                AvatarConstants.cellChinArray = Array(repeating: AvatarConstants.chinArray[(generatedAvatar.chinIndex) % 3], count: AvatarConstants.earArray.count)
                AvatarConstants.cellSideHairArray = Array(repeating: "transparent", count: AvatarConstants.earArray.count)
                AvatarConstants.cellBackFeatureArray = Array(repeating: "transparent", count: AvatarConstants.earArray.count)
                AvatarConstants.cellFrontFeatureArray = AvatarConstants.earArray
                
            } else if featureTapped == selectHairImgView {
                // Update Button Color
                updateFeatureSelection(newFeature: 6)
                selectHairImgView.backgroundColor = AppColors.featureColorArray[1]
                // Generate new cells in collection view
                AvatarConstants.cellBackHairArray = AvatarConstants.backHairArray
                AvatarConstants.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarConstants.backHairArray.count)
                AvatarConstants.cellChinArray =  Array(repeating: AvatarConstants.chinArray[(generatedAvatar.chinIndex) % 3], count: AvatarConstants.frontHairArray.count)
                AvatarConstants.cellSideHairArray = AvatarConstants.hairSideArray
                AvatarConstants.cellBackFeatureArray = AvatarConstants.hairTieArray
                AvatarConstants.cellFrontFeatureArray = AvatarConstants.frontHairArray
            } else if featureTapped == selectBackgroundImgView {
                // Update button color and do nothing else; color changing functionality handled in ChangeColor
                updateFeatureSelection(newFeature: 7)
                selectBackgroundImgView.backgroundColor = AppColors.featureColorArray[1]
            }
            elemCollectionView.reloadData()
            swapColorSet()
        }
    }
    
    
    // Choose the appropriate customization option given its index
    func updateAvatar(elemIndex: Int) {
        let index = currFacialFeature
        switch index {
            
        case 0: // CUSTOMIZATION OF CHIN/BEARD
            chinImgView.image = UIImage(named: AvatarConstants.chinArray[elemIndex])
            generatedAvatar.chinIndex = elemIndex
            if(elemIndex >= 3){
                chinImgView.image = UIImage(named: AvatarConstants.chinArray[1])
                beardImgView.image = UIImage(named: AvatarConstants.chinArray[elemIndex])
                mouthImgView.image = UIImage(named: AvatarConstants.mouthArray[0])
            } else {
                beardImgView.image = UIImage(named: "transparent")
            }
            
        case 1: // CUSTOMIZATION OF EYES
            glassLensImgView.image = UIImage(named: AvatarConstants.lensArray[elemIndex])
            glassFrameImgVIew.image = UIImage(named: AvatarConstants.frameArray[elemIndex] )
            generatedAvatar.glassIndex = elemIndex
            
        case 2: // CUSTOMIZATION OF NOSE
            noseImgView.image = UIImage(named: AvatarConstants.noseArray[elemIndex])
            generatedAvatar.noseIndex = elemIndex
        case 3: // CUSTOMIZATION OF EYEBROWS
            eyebrowImgView.image = UIImage(named: AvatarConstants.browArray[elemIndex])
            generatedAvatar.browIndex = elemIndex
        case 4: // CUSTOMIZATION OF MOUTH SHAPE
            mouthImgView.image = UIImage(named: AvatarConstants.mouthArray[elemIndex])
            generatedAvatar.mouthIndex = elemIndex
        case 5: // CUSTOMIZATION OF EARS
            earImgView.image = UIImage(named: AvatarConstants.earArray[elemIndex])
            generatedAvatar.earIndex = elemIndex
        case 6: // CUSTOMIZATION OF HAIR
            backHairImgView.image = UIImage(named: AvatarConstants.backHairArray[elemIndex])
            hairTieImgView.image = UIImage(named: AvatarConstants.hairTieArray[elemIndex])
            frontHairImgView.image = UIImage(named: AvatarConstants.frontHairArray[elemIndex])
            sideHairImgView.image = UIImage(named: AvatarConstants.hairSideArray[elemIndex])
            generatedAvatar.hairIndex = elemIndex
        default:
            break
        }
        print(elemIndex)
    }
    
    
    
    
    func updateFeatureSelection(newFeature: Int) {
        // reset the previous feature's background back to grey
        switch currFacialFeature {
        case 0:
            selectFaceImgView.backgroundColor = AppColors.featureColorArray[0]
            currFacialFeature = newFeature
        case 1:
            selectEyeImgView.backgroundColor = AppColors.featureColorArray[0]
            currFacialFeature = newFeature
        case 2:
            selectNoseImgView.backgroundColor = AppColors.featureColorArray[0]
            currFacialFeature = newFeature
        case 3:
            selectBrowImgView.backgroundColor = AppColors.featureColorArray[0]
            currFacialFeature = newFeature
        case 4:
            selectMouthImgView.backgroundColor = AppColors.featureColorArray[0]
            currFacialFeature = newFeature
        case 5:
            selectEarImgView.backgroundColor = AppColors.featureColorArray[0]
            currFacialFeature = newFeature
        case 6:
            selectHairImgView.backgroundColor = AppColors.featureColorArray[0]
            currFacialFeature = newFeature
        case 7:
            selectBackgroundImgView.backgroundColor = AppColors.featureColorArray[0]
            currFacialFeature = newFeature
        default:
            break
        }
        
    }
    // MARK: FUNCTIONS FOR CHANGING AVATAR FEATURES END HERE
    
    // MARK: COLOR SELECTION METHODS BEGIN HERE
    @objc func colorTapped(colorTapRecognizer: UITapGestureRecognizer) {
        if let colorTapped = colorTapRecognizer.view as? UIImageView {
            switch colorTapped {
                // Change color of elements based on current feature user has highlighted
            case colorImage1:
                changeColor(colorIndex: 0, featureChanged: currFacialFeature)
            case colorImage2:
                changeColor(colorIndex: 1, featureChanged: currFacialFeature)
            case colorImage3:
                changeColor(colorIndex: 2, featureChanged: currFacialFeature)
            case colorImage4:
                changeColor(colorIndex: 3, featureChanged: currFacialFeature)
            case colorImage5:
                changeColor(colorIndex: 4, featureChanged: currFacialFeature)
            case colorImage6:
                changeColor(colorIndex: 5, featureChanged: currFacialFeature)
            case colorImage7:
                changeColor(colorIndex: 6, featureChanged: currFacialFeature)
            case colorImage8:
                changeColor(colorIndex: 7, featureChanged: currFacialFeature)
            case colorImage9:
                changeColor(colorIndex: 8, featureChanged: currFacialFeature)
            case colorImage10:
                changeColor(colorIndex: 9, featureChanged: currFacialFeature)
            case colorImage11:
                changeColor(colorIndex: 10, featureChanged: currFacialFeature)
            case colorImage12:
                changeColor(colorIndex: 11, featureChanged: currFacialFeature)
            case colorImage13:
                changeColor(colorIndex: 12, featureChanged: currFacialFeature)
            case colorImage14:
                changeColor(colorIndex: 13, featureChanged: currFacialFeature)
            case colorImage15:
                changeColor(colorIndex: 14, featureChanged: currFacialFeature)
            case colorImage16:
                changeColor(colorIndex: 15, featureChanged: currFacialFeature)
            case colorImage17:
                changeColor(colorIndex: 16, featureChanged: currFacialFeature)
            default:
                break
            }
            // regenerate cells to reflect new colors
            elemCollectionView.reloadData()
        }
        
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
        return AvatarConstants.cellFrontFeatureArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        cell.backgroundColor = .green
        cell.cellFrontFeatureView.tag = indexPath.item
        
        cell.cellBackHairView.image = UIImage(named: AvatarConstants.cellBackHairArray[indexPath.item])?.withRenderingMode(.alwaysOriginal)
        
        cell.cellHeadEarView.image = UIImage(named: AvatarConstants.cellHeadTopArray[indexPath.item])?.withRenderingMode(.alwaysOriginal)
        
        cell.cellChinImageView.image = UIImage(named: AvatarConstants.cellSideHairArray[indexPath.item])?.withRenderingMode(.alwaysOriginal)
        cell.cellSideGroundImageView.image = UIImage(named: AvatarConstants.cellChinArray[indexPath.item])?.withRenderingMode(.alwaysOriginal)
        cell.cellBackFeatureView.image = UIImage(named: AvatarConstants.cellBackFeatureArray[indexPath.item])?.withRenderingMode(.alwaysOriginal)
        cell.cellFrontFeatureView.image = UIImage(named: AvatarConstants.cellFrontFeatureArray[indexPath.item])?.withRenderingMode(.alwaysOriginal)
        // add a tap gesture recognizer to the foreground image view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        cell.cellFrontFeatureView.addGestureRecognizer(tapGestureRecognizer)
        cell.cellFrontFeatureView.isUserInteractionEnabled = true
        
        return cell
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // get the index of the image that was tapped using the tag property
        let index = sender.view?.tag
        print("Image at index \(index ?? -1) was tapped")
        let elemIndex: Int = index!
        updateAvatar(elemIndex: elemIndex)
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




