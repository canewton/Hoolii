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


class AvatarCreatorViewController: AppViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static let chinArray = ["Chin 1.svg", "Chin 2.svg", "Chin 3.svg", "Chin 4 Beard.svg", "Chin 5 Beard.svg", "Chin 6 Beard.svg", "Chin 7 Beard.svg", "Chin 8 Beard.svg", "Chin 9 Beard.svg", "Chin 10 Beard.svg"]
    
    static let earArray = ["transparent", "Ears 2.svg", "Ears 3.svg", "Ears 4.svg", "Ears 5.svg"]
    
    static let browArray = ["Eyebrows 1.svg", "Eyebrows 2.svg", "Eyebrows 3.svg", "Eyebrows 4.svg", "Eyebrows 5.svg"]
    
    static let lensArray = ["transparent","Eyes Glasses 2 lense.svg","Eyes Glasses 3 lense.svg", "Eyes Glasses 4 lense.svg", "Eyes Glasses 5 lense.svg"]
    static let frameArray = ["transparent","Eyes Glasses 2.svg","Eyes Glasses 3.svg", "Eyes Glasses 4.svg", "Eyes Glasses 5.svg"]
    
    static let frontHairArray = ["Male hair 1", "Male hair 2", "Male hair 3", "Male hair 4", "Male hair 5", "Male hair 6", "Male hair 7 front", "Male hair 8", "Male hair 9 front", "Male hair 10 front", "Male hair 11 front", "Male hair 12", "Male hair 13", "Male hair 14", "Male hair 15", "Male hair 16", "Female hair 1 front","Female hair 2 front", "Female hair 3 front", "Female hair 4 front", "Female hair 5 front", "Female hair 6 front", "transparent", "Female hair 8 front", "Female hair 9 front", "Female hair 10", "Female hair 11", "Female hair 12 front", "Female hair 13", "Female hair 14 front", "Female hair 15"]
    
    static let backHairArray = ["transparent","transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "Male hair 9 back", "Male hair 10 back", "Male hair 11 back", "transparent", "transparent", "transparent", "transparent", "transparent", "Female hair 1 back", "Female hair 2 back", "Female hair 3 back", "Female hair 4 back", "Female hair 5 back", "Female hair 6 back", "Female hair 7", "Female hair 8 back", "Female hair 9 back", "transparent", "transparent", "Female hair 12 back", "transparent", "Female hair 14 back", "transparent" ]
    
    static let hairSideArray = ["transparent","transparent", "transparent", "transparent", "transparent", "transparent", "Male hair 7 side", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "Female hair 9 front highlight", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent"]
    
    static let hairTieArray = ["transparent","transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "Male hair 9 hairtie", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "Female hair 9 front hairtie", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent"]
    
    static let mouthArray = ["Mouth 1.png","Mouth 2.png", "Mouth 3.png", "Mouth 4.png", "Mouth 5.png"]
    
    static let noseArray = ["Nose 1.png","Nose 2.png", "Nose 3.png", "Nose 4.png", "Nose 5.png"]
    
    // Outlets for display of Avatar
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
    static var hairColor = UIColor.black
    static var skinTone = UIColor.gray
    static var currFacialFeature: Int = 0
    static var itemIndex = 0
    
    // Declaration of static variables used in saving/reconstructing avatar
    static var chinIndex = 0
    static var earIndex = 0
    static var browsIndex = 0
    static var eyeIndex = 0
    static var noseIndex = 0
    static var mouthIndex = 0
    static var hairIndex = 0
    static var hairColorIndex = 0
    static var skinToneIndex = 0
    
    // avatar index: [Chin, Ear, Glasses, Nose, Brows, Mouth, Hair, Hair Color, Skin Tone
    static var avatarIndexArray = [0,0,0,0,0,0,0,0,0]
    
    
    override func viewDidLoad() {
        // Function loaded: set all initial colors for elements
        super.viewDidLoad()
        initColors()
        
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
    
    // Change the facial feature the user is modifying based on which image is tapped
    @objc func tapFunct(tapGestureRecognizer:UITapGestureRecognizer){
        if let featureTapped = tapGestureRecognizer.view as? UIImageView {
            if featureTapped == selectFaceImgView {
                // Color in the button
                updateFeatureSelection(newFeature: 0)
                selectFaceImgView.backgroundColor = AppColors.featureColorArray[1]
                // Generate new cells for the collection view
                AvatarCreatorViewController.cellBackHairArray = Array(repeating: "transparent",count: AvatarCreatorViewController.chinArray.count)
                AvatarCreatorViewController.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarCreatorViewController.chinArray.count)
                AvatarCreatorViewController.cellChinArray = ["Chin 1.svg", "Chin 2.svg", "Chin 3.svg", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2"]
                AvatarCreatorViewController.cellSideHairArray = Array(repeating: "transparent", count: AvatarCreatorViewController.chinArray.count)
                AvatarCreatorViewController.cellBackFeatureArray = Array(repeating: "transparent", count: AvatarCreatorViewController.chinArray.count)
                AvatarCreatorViewController.cellFrontFeatureArray = ["transparent", "transparent", "transparent", "Chin 4 Beard.svg", "Chin 5 Beard.svg", "Chin 6 Beard.svg", "Chin 7 Beard.svg", "Chin 8 Beard.svg", "Chin 9 Beard.svg", "Chin 10 Beard.svg"]
            } else if featureTapped == selectEyeImgView {
                // color in button
                updateFeatureSelection(newFeature: 1)
                selectEyeImgView.backgroundColor = AppColors.featureColorArray[1]
                // generate new cells in collection view
                AvatarCreatorViewController.cellBackHairArray = Array(repeating: "transparent", count: AvatarCreatorViewController.lensArray.count)
                AvatarCreatorViewController.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarCreatorViewController.frameArray.count)
                AvatarCreatorViewController.cellChinArray = Array(repeating: AvatarCreatorViewController.chinArray[(AvatarCreatorViewController.chinIndex) % 3], count: AvatarCreatorViewController.frameArray.count)
                AvatarCreatorViewController.cellSideHairArray = Array(repeating: "transparent", count: AvatarCreatorViewController.lensArray.count)
                AvatarCreatorViewController.cellFrontFeatureArray = AvatarCreatorViewController.frameArray
                AvatarCreatorViewController.cellBackFeatureArray = AvatarCreatorViewController.lensArray
                
            } else if featureTapped == selectNoseImgView {
                // Color in button
                updateFeatureSelection(newFeature: 2)
                selectNoseImgView.backgroundColor = AppColors.featureColorArray[1]
                // generate new cells in collection view
                AvatarCreatorViewController.cellBackHairArray = Array(repeating: "transparent", count: AvatarCreatorViewController.noseArray.count)
                AvatarCreatorViewController.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarCreatorViewController.frameArray.count)
                AvatarCreatorViewController.cellChinArray = Array(repeating: AvatarCreatorViewController.chinArray[(AvatarCreatorViewController.chinIndex) % 3], count: AvatarCreatorViewController.frameArray.count)
                AvatarCreatorViewController.cellSideHairArray = Array(repeating: "transparent", count: AvatarCreatorViewController.noseArray.count)
                AvatarCreatorViewController.cellBackFeatureArray = Array(repeating: "transparent", count: AvatarCreatorViewController.noseArray.count)
                AvatarCreatorViewController.cellFrontFeatureArray = AvatarCreatorViewController.noseArray
                
            } else if featureTapped == selectBrowImgView {
                // update button color
                updateFeatureSelection(newFeature: 3)
                selectBrowImgView.backgroundColor = AppColors.featureColorArray[1]
                // Generate new cells in collection view
                AvatarCreatorViewController.cellBackHairArray =  Array(repeating: "transparent", count: AvatarCreatorViewController.browArray.count)
                AvatarCreatorViewController.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarCreatorViewController.browArray.count)
                AvatarCreatorViewController.cellChinArray = Array(repeating: AvatarCreatorViewController.chinArray[(AvatarCreatorViewController.chinIndex) % 3], count: AvatarCreatorViewController.browArray.count)
                AvatarCreatorViewController.cellSideHairArray = Array(repeating: "transparent", count: AvatarCreatorViewController.browArray.count)
                AvatarCreatorViewController.cellBackFeatureArray = Array(repeating: "transparent", count: AvatarCreatorViewController.browArray.count)
                AvatarCreatorViewController.cellFrontFeatureArray = AvatarCreatorViewController.browArray
                
            } else if featureTapped == selectMouthImgView {
                // update button Color
                updateFeatureSelection(newFeature: 4)
                selectMouthImgView.backgroundColor = AppColors.featureColorArray[1]
                // Generate new cells in collection view
                AvatarCreatorViewController.cellBackHairArray = Array(repeating: "transparent", count: AvatarCreatorViewController.mouthArray.count)
                AvatarCreatorViewController.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarCreatorViewController.mouthArray.count)
                AvatarCreatorViewController.cellChinArray = Array(repeating: AvatarCreatorViewController.chinArray[(AvatarCreatorViewController.chinIndex) % 3], count: AvatarCreatorViewController.mouthArray.count)
                AvatarCreatorViewController.cellSideHairArray = Array(repeating: "transparent", count: AvatarCreatorViewController.mouthArray.count)
                AvatarCreatorViewController.cellBackFeatureArray = Array(repeating: "transparent", count: AvatarCreatorViewController.mouthArray.count)
                AvatarCreatorViewController.cellFrontFeatureArray = AvatarCreatorViewController.mouthArray
                
            } else if featureTapped == selectEarImgView {
                // Update Button Color
                updateFeatureSelection(newFeature: 5)
                selectEarImgView.backgroundColor = AppColors.featureColorArray[1]
                //  Generate new cells in collection view
                AvatarCreatorViewController.cellBackHairArray =  Array(repeating: "transparent", count: AvatarCreatorViewController.earArray.count)
                AvatarCreatorViewController.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarCreatorViewController.earArray.count)
                AvatarCreatorViewController.cellChinArray = Array(repeating: AvatarCreatorViewController.chinArray[(AvatarCreatorViewController.chinIndex) % 3], count: AvatarCreatorViewController.earArray.count)
                AvatarCreatorViewController.cellSideHairArray = Array(repeating: "transparent", count: AvatarCreatorViewController.earArray.count)
                AvatarCreatorViewController.cellBackFeatureArray = Array(repeating: "transparent", count: AvatarCreatorViewController.earArray.count)
                AvatarCreatorViewController.cellFrontFeatureArray = AvatarCreatorViewController.earArray
                
            } else if featureTapped == selectHairImgView {
                // Update Button Color
                updateFeatureSelection(newFeature: 6)
                selectHairImgView.backgroundColor = AppColors.featureColorArray[1]
                // Generate new cells in collection view
                AvatarCreatorViewController.cellBackHairArray = AvatarCreatorViewController.backHairArray
                AvatarCreatorViewController.cellHeadTopArray = Array(repeating: "Ear 1 + Head", count: AvatarCreatorViewController.backHairArray.count)
                AvatarCreatorViewController.cellChinArray =  Array(repeating: AvatarCreatorViewController.chinArray[(AvatarCreatorViewController.chinIndex) % 3], count: AvatarCreatorViewController.frontHairArray.count)
                AvatarCreatorViewController.cellSideHairArray = AvatarCreatorViewController.hairSideArray
                AvatarCreatorViewController.cellBackFeatureArray = AvatarCreatorViewController.hairTieArray
                AvatarCreatorViewController.cellFrontFeatureArray = AvatarCreatorViewController.frontHairArray
            }
            elemCollectionView.reloadData()
        }
    }
    

    @objc func colorTapped(colorTapRecognizer: UITapGestureRecognizer) {
        if let colorTapped = colorTapRecognizer.view as? UIImageView {
            if colorTapped == colorImage1 {
                
            }
            
        }
        
    }
    

    func swapColorSet() {
        if(AvatarCreatorViewController.currFacialFeature < 6) {
            // Case 1: Skin tone
            replaceColorInImages(colorArray: AppColors.skintoneArray)
            
        }
    }// End of swapColorsSet
    
    
    // Changes the colors of the various skin/hair/background color selectors
    func replaceColorInImages(colorArray: [UIColor]) {
        let imageViews = [colorImage1, colorImage2, colorImage3, colorImage4, colorImage5, colorImage6, colorImage7, colorImage8, colorImage9, colorImage10, colorImage11, colorImage12, colorImage13, colorImage14, colorImage15, colorImage16, colorImage17]
        var index = 0
        for imageView in imageViews {
            if (index < colorArray.count) {
                imageView?.backgroundColor = colorArray[index]
                index += 1
            } else {
                imageView?.isHidden = true
            }
        }
    }
    
    
    
    // USER TOUCHED SKIN/HAIR COLOR BUTTONS
    @IBAction func colorBut1Pressed(_ sender: UIButton) {
        let index = AvatarCreatorViewController.currFacialFeature
        changeColor(elemIndex: index, newColor: AppColors.skintoneArray[0], staticIndex: 0)
    }
    
    @IBAction func colorBut2Pressed(_ sender: UIButton) {
        let index  = AvatarCreatorViewController.currFacialFeature
        changeColor(elemIndex: index, newColor: AppColors.skintoneArray[1], staticIndex: 1)
    }
    
    @IBAction func colorBut3Pressed(_ sender: UIButton) {
        let index  = AvatarCreatorViewController.currFacialFeature
        changeColor(elemIndex: index, newColor: AppColors.skintoneArray[2], staticIndex: 2)
    }
    
    
    @IBAction func colorBut4Pressed(_ sender: UIButton) {
        let index  = AvatarCreatorViewController.currFacialFeature
        changeColor(elemIndex: index, newColor: AppColors.skintoneArray[3], staticIndex: 3)
    }
    
    @IBAction func colorBut5Pressed(_ sender: UIButton) {
        let index  = AvatarCreatorViewController.currFacialFeature
        changeColor(elemIndex: index, newColor: AppColors.skintoneArray[4], staticIndex: 4)
    }
    
    
    @IBAction func colorBut6Pressed(_ sender: UIButton) {
        let index  = AvatarCreatorViewController.currFacialFeature
        changeColor(elemIndex: index, newColor: AppColors.skintoneArray[5],staticIndex: 5)
    }
    
    @IBAction func colorBut7Pressed(_ sender: UIButton) {
        let index  = AvatarCreatorViewController.currFacialFeature
        changeColor(elemIndex: index, newColor: AppColors.skintoneArray[6], staticIndex: 6)
    }
    
    @IBAction func colorBut8Pressed(_ sender: UIButton) {
        let index  = AvatarCreatorViewController.currFacialFeature
        changeColor(elemIndex: index, newColor: AppColors.skintoneArray[7], staticIndex: 7)
    }
    
    @IBAction func colorBut9Pressed(_ sender: UIButton) {
        let index  = AvatarCreatorViewController.currFacialFeature
        changeColor(elemIndex: index, newColor: AppColors.skintoneArray[8], staticIndex: 8)
    }
    
    @IBAction func colorBut10Pressed(_ sender: UIButton) {
        let index  = AvatarCreatorViewController.currFacialFeature
        changeColor(elemIndex: index, newColor: AppColors.skintoneArray[9], staticIndex: 9)
    }
    
    @IBAction func colorButton11Pressed(_ sender: UIButton) {
        let index  = AvatarCreatorViewController.currFacialFeature
        changeColor(elemIndex: index, newColor: AppColors.skintoneArray[10], staticIndex: 10)
    }
    
    @IBAction func colorButton12Pressed(_ sender: UIButton) {
        let index  = AvatarCreatorViewController.currFacialFeature
        changeColor(elemIndex: index, newColor: AppColors.skintoneArray[11], staticIndex: 11)
    }
    
        
    func updateFeatureSelection(newFeature: Int) {
        // reset the previous feature's background back to grey
        switch AvatarCreatorViewController.currFacialFeature {
        case 0:
            selectFaceImgView.backgroundColor = AppColors.featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 1:
            selectEyeImgView.backgroundColor = AppColors.featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 2:
            selectNoseImgView.backgroundColor = AppColors.featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 3:
            selectBrowImgView.backgroundColor = AppColors.featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 4:
            selectMouthImgView.backgroundColor = AppColors.featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 5:
            selectEarImgView.backgroundColor = AppColors.featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 6:
            selectHairImgView.backgroundColor = AppColors.featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        default:
            break
        }

    }
    
    // METHODS/VARS FOR UPKEEP OF COLLECTION VIEW
    
    
    static var cellBackHairArray: [String] = Array(repeating: "transparent", count: 10)
    static var cellHeadTopArray = ["Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head"]
    static var cellChinArray = ["Chin 1.svg", "Chin 2.svg", "Chin 3.svg", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2"]
    static var cellSideHairArray =    Array(repeating: "transparent", count: 10)
    static var cellBackFeatureArray = Array(repeating: "transparent", count: 10)
    static var cellFrontFeatureArray: [String] = ["transparent", "transparent", "transparent", "Chin 4 Beard.svg", "Chin 5 Beard.svg", "Chin 6 Beard.svg", "Chin 7 Beard.svg", "Chin 8 Beard.svg", "Chin 9 Beard.svg", "Chin 10 Beard.svg"]
    
    
    
    // Returns the number of sections in the view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // returns the number of images that cells are being made from
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AvatarCreatorViewController.cellFrontFeatureArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        cell.backgroundColor = .green
        cell.cellFrontFeatureView.tag = indexPath.item
        
        cell.cellBackHairView.image = UIImage(named: AvatarCreatorViewController.cellBackHairArray[indexPath.item])?.withTintColor(AppColors.hairColorArray[AvatarCreatorViewController.hairColorIndex])
        cell.cellHeadEarView.image = UIImage(named: AvatarCreatorViewController.cellHeadTopArray[indexPath.item])?.withTintColor(AppColors.skintoneArray[AvatarCreatorViewController.skinToneIndex])
        cell.cellChinImageView.image = UIImage(named: AvatarCreatorViewController.cellSideHairArray[indexPath.item])?.withTintColor(AppColors.skintoneArray[AvatarCreatorViewController.skinToneIndex])
        cell.cellSideGroundImageView.image = UIImage(named: AvatarCreatorViewController.cellChinArray[indexPath.item])?.withTintColor(AppColors.hairColorArray[AvatarCreatorViewController.hairColorIndex])
        cell.cellBackFeatureView.image = UIImage(named: AvatarCreatorViewController.cellBackFeatureArray[indexPath.item])?.withTintColor(AppColors.hairColorArray[AvatarCreatorViewController.hairColorIndex])
        cell.cellFrontFeatureView.image = UIImage(named: AvatarCreatorViewController.cellFrontFeatureArray[indexPath.item])?.withTintColor(AppColors.hairColorArray[AvatarCreatorViewController.hairColorIndex])
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
    
    
    
    
    // COLLECTION VIEW METHODS END HERE
    
    
    func changeColor(newColor: UIColor, colorIndex: Int) {
        if (AvatarCreatorViewController.currFacialFeature < 6) {
            // in this case, user is modifying facial features
            headImgView.tintColor = AppColors.skintoneArray[colorIndex]
            chinImgView.tintColor = AppColors.skintoneArray[colorIndex]
            AvatarCreatorViewController.skinTone = AppColors.skintoneArray[colorIndex]
            AvatarCreatorViewController.skinToneIndex = colorIndex
        } else if (AvatarCreatorViewController.currFacialFeature == 6) {
            // user is changing hair color
            backHairImgView.tintColor = AppColors.hairColorArray[colorIndex]
            frontHairImgView.tintColor = AppColors.hairColorArray[colorIndex]
            sideHairImgView.tintColor = AppColors.hairColorArray[colorIndex]
            // check for beard to recolor
            if(beardImgView.image != UIImage(imageLiteralResourceName: "transparent")) {
                beardImgView.tintColor = AppColors.hairColorArray[colorIndex]
            }
            AvatarCreatorViewController.hairColor = AppColors.hairColorArray[colorIndex]
            AvatarCreatorViewController.hairColorIndex = colorIndex
        } else if (AvatarCreatorViewController.currFacialFeature > 6) {
            // User is changing the background color
            
        }
        
    }
    
    // Initialize the starting hair and skin tones to the first available options
    func initColors(){
        // Initialize facial details w/ default vals
        changeColor(elemIndex: 0, newColor: AppColors.skintoneArray[1], staticIndex: 0)
        // Initialize hair with default color
        changeColor(elemIndex: 7, newColor: UIColor.black, staticIndex: 0)
    }
    
    // Choose the appropriate customization option given its index
    func updateAvatar(elemIndex: Int) {
        let index = AvatarCreatorViewController.currFacialFeature
        switch index {
            
        case 0: // CUSTOMIZATION OF CHIN/BEARD
            chinImgView.image = UIImage(named: AvatarCreatorViewController.chinArray[elemIndex])
            AvatarCreatorViewController.chinIndex = elemIndex
            if(elemIndex >= 3){
                chinImgView.image = UIImage(named: AvatarCreatorViewController.chinArray[1])
                beardImgView.image = UIImage(named: AvatarCreatorViewController.chinArray[elemIndex])
                mouthImgView.image = UIImage(named: AvatarCreatorViewController.mouthArray[0])
            } else {
                beardImgView.image = UIImage(named: "transparent")
            }
            
        case 1: // CUSTOMIZATION OF EYES
            glassLensImgView.image = UIImage(named: AvatarCreatorViewController.lensArray[elemIndex])
            glassFrameImgVIew.image = UIImage(named: AvatarCreatorViewController.frameArray[elemIndex] )
            AvatarCreatorViewController.eyeIndex = elemIndex
            
        case 2: // CUSTOMIZATION OF NOSE
            noseImgView.image = UIImage(named: AvatarCreatorViewController.noseArray[elemIndex])
            AvatarCreatorViewController.noseIndex = elemIndex
        case 3: // CUSTOMIZATION OF EYEBROWS
            eyebrowImgView.image = UIImage(named: AvatarCreatorViewController.browArray[elemIndex])
            AvatarCreatorViewController.browsIndex = elemIndex
        case 4: // CUSTOMIZATION OF MOUTH SHAPE
            mouthImgView.image = UIImage(named: AvatarCreatorViewController.mouthArray[elemIndex])
            AvatarCreatorViewController.mouthIndex = elemIndex
        case 5: // CUSTOMIZATION OF EARS
            earImgView.image = UIImage(named: AvatarCreatorViewController.earArray[elemIndex])
            AvatarCreatorViewController.earIndex = elemIndex
        case 6: // CUSTOMIZATION OF HAIR
            backHairImgView.image = UIImage(named: AvatarCreatorViewController.backHairArray[elemIndex])
            hairTieImgView.image = UIImage(named: AvatarCreatorViewController.hairTieArray[elemIndex])
            frontHairImgView.image = UIImage(named: AvatarCreatorViewController.frontHairArray[elemIndex])
            sideHairImgView.image = UIImage(named: AvatarCreatorViewController.hairSideArray[elemIndex])
            AvatarCreatorViewController.hairIndex = elemIndex
        default:
            break
        }
        print(elemIndex)
    }
    
    // Given an avatar object, reproduce the user's avatar offscreen with a given size and return it as a UIImage
    static func recreateAvatar(size: CGSize, avatarIndices: Avatar) -> UIImage {
        // Create all of the images
        let backHairImage = UIImage(named: AvatarCreatorViewController.backHairArray[avatarIndices.hairIndex])?.withTintColor(AppColors.skintoneArray[avatarIndices.skinTone])
        let headImage = UIImage(named: "Ear 1 + Head")?.withTintColor(AppColors.skintoneArray[avatarIndices.skinTone])
        let earImage = UIImage(named: AvatarCreatorViewController.earArray[avatarIndices.earIndex])
        // Consider exceptions for beards
        var chinImage = UIImage(named: AvatarCreatorViewController.chinArray[avatarIndices.chinIndex])?.withTintColor(AppColors.skintoneArray[avatarIndices.skinTone])
        var beardImage = UIImage(named: "transparent")
        var mouthImage = UIImage(named: AvatarCreatorViewController.mouthArray[avatarIndices.mouthIndex])
        if (avatarIndices.chinIndex > 2) {
            chinImage = UIImage(named: AvatarCreatorViewController.chinArray[1])?.withTintColor(AppColors.skintoneArray[avatarIndices.skinTone])
            beardImage = UIImage(named: AvatarCreatorViewController.chinArray[avatarIndices.chinIndex])
            mouthImage = UIImage(named: AvatarCreatorViewController.mouthArray[0])
        }
        let noseImage = UIImage(named: AvatarCreatorViewController.noseArray[avatarIndices.noseIndex])
        let eyeImage = UIImage(named: "Eyes 1")
        let browImage = UIImage(named: AvatarCreatorViewController.browArray[avatarIndices.browIndex])
        let lensImage = UIImage(named:AvatarCreatorViewController.lensArray[avatarIndices.glassIndex])
        let sideHairImage = UIImage(named:AvatarCreatorViewController.hairSideArray[avatarIndices.hairIndex])
        let frontHairImage = UIImage(named:AvatarCreatorViewController.frontHairArray[avatarIndices.hairIndex])
        let hairTieImage = UIImage(named: AvatarCreatorViewController.hairTieArray[avatarIndices.hairIndex])
        let frameImage = UIImage(named: AvatarCreatorViewController.frameArray[avatarIndices.glassIndex])
        
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
        
    func saveAvatar(newAvatar: inout Avatar) {
        // Updates all of the avatar's indices to reflect user's current selection 
        newAvatar.chinIndex = AvatarCreatorViewController.chinIndex
        newAvatar.earIndex = AvatarCreatorViewController.earIndex
        newAvatar.browIndex = AvatarCreatorViewController.browsIndex
        newAvatar.glassIndex = AvatarCreatorViewController.eyeIndex
        newAvatar.mouthIndex = AvatarCreatorViewController.mouthIndex
        newAvatar.noseIndex = AvatarCreatorViewController.noseIndex
        newAvatar.hairIndex = AvatarCreatorViewController.hairIndex
        newAvatar.skinTone = AvatarCreatorViewController.skinToneIndex
        newAvatar.hairColor = AvatarCreatorViewController.hairColorIndex
    }
    
} // end of AvatarViewCreator Class




