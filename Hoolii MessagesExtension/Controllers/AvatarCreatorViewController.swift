//
//  AvatarCreatorViewController.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 12/15/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var midgroundImageView: UIImageView!
    @IBOutlet weak var cellHairTieImageView: UIImageView!
    @IBOutlet weak var cellSideGroundImageView: UIImageView!
    @IBOutlet weak var subforegroundImageView: UIImageView!
    @IBOutlet weak var foregroundImageView: UIImageView!
    
    
    
}


class AvatarCreatorViewController: AppViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let chinArray = ["Chin 1.svg", "Chin 2.svg", "Chin 3.svg", "Chin 4 Beard.svg", "Chin 5 Beard.svg", "Chin 6 Beard.svg", "Chin 7 Beard.svg", "Chin 8 Beard.svg", "Chin 9 Beard.svg", "Chin 10 Beard.svg"]
    
    let earArray = ["transparent", "Ears 2.svg", "Ears 3.svg", "Ears 4.svg", "Ears 5.svg"]
    
    let browArray = ["Eyebrows 1.svg", "Eyebrows 2.svg", "Eyebrows 3.svg", "Eyebrows 4.svg", "Eyebrows 5.svg"]
    
    let lensArray = ["transparent","Eyes Glasses 2 lense.svg","Eyes Glasses 3 lense.svg", "Eyes Glasses 4 lense.svg", "Eyes Glasses 5 lense.svg"]
    let frameArray = ["transparent","Eyes Glasses 2.svg","Eyes Glasses 3.svg", "Eyes Glasses 4.svg", "Eyes Glasses 5.svg"]
    
    let frontHairArray = ["Male hair 1", "Male hair 2", "Male hair 3", "Male hair 4", "Male hair 5", "Male hair 6", "Male hair 7 front", "Male hair 8", "Male hair 9 front", "Male hair 10 front", "Male hair 11 front", "Male hair 12", "Male hair 13", "Male hair 14", "Male hair 15", "Male hair 16", "Female hair 1 front","Female hair 2 front", "Female hair 3 front", "Female hair 4 front", "Female hair 5 front", "Female hair 6 front", "transparent", "Female hair 8 front", "Female hair 9 front", "Female hair 10", "Female hair 11", "Female hair 12 front", "Female hair 13", "Female hair 14 front", "Female hair 15"]
    
    let backHairArray = ["transparent","transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "Male hair 9 back", "Male hair 10 back", "Male hair 11 back", "transparent", "transparent", "transparent", "transparent", "transparent", "Female hair 1 back", "Female hair 2 back", "Female hair 3 back", "Female hair 4 back", "Female hair 5 back", "Female hair 6 back", "Female hair 7", "Female hair 8 back", "Female hair 9 back", "transparent", "transparent", "Female hair 12 back", "transparent", "Female hair 14 back", "transparent" ]
    
    let hairSideArray = ["transparent","transparent", "transparent", "transparent", "transparent", "transparent", "Male hair 7 side", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "Female hair 9 front highlight", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent"]
    
    let hairTieArray = ["transparent","transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "Male hair 9 hairtie", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "Female hair 9 front hairtie", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent"]
    
    let mouthArray = ["Mouth 1.png","Mouth 2.png", "Mouth 3.png", "Mouth 4.png", "Mouth 5.png"]
    
    let noseArray = ["Nose 1.png","Nose 2.png", "Nose 3.png", "Nose 4.png", "Nose 5.png"]
    
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
    
    
    @IBOutlet weak var elemSlctrSgmnt: UISegmentedControl!
    @IBOutlet weak var elemValLabel: UILabel!
    @IBOutlet weak var elemChoiceSlider: UISlider!
    
    // Outlet for element selector of Images
    @IBOutlet weak var selectFaceImgView: UIImageView!
    @IBOutlet weak var selectEyeImgView: UIImageView!
    @IBOutlet weak var selectNoseImgView: UIImageView!
    @IBOutlet weak var selectBrowImgView: UIImageView!
    @IBOutlet weak var selectMouthImgView: UIImageView!
    @IBOutlet weak var selectHairImgView: UIImageView!
    @IBOutlet weak var selectFemHairImgView: UIImageView!
    @IBOutlet weak var selectEarImgView: UIImageView!
    
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
    static var eyeIndex = 0
    static var noseIndex = 0
    static var browsIndex = 0
    static var mouthIndex = 0
    static var hairIndex = 0
    static var hairColorIndex = 0
    static var skinToneIndex = 0
    // avatar index: [Chin, Ear, Glasses, Nose, Brows, Mouth, Hair, Hair Color, Skin Tone
    static var avatarIndexArray = [0,0,0,0,0,0,0,0,0]
    
    
    override func viewDidLoad() {
        // Function loaded: set all initial colors for elements
        super.viewDidLoad()
        let sliderMax = Float((chinArray.count - 1))
        elemChoiceSlider.maximumValue = sliderMax
        initColors()
        
        // Enable gesture recognition for facial feature selection
        for imageView in [selectFaceImgView, selectEyeImgView, selectNoseImgView, selectBrowImgView, selectMouthImgView, selectEarImgView, selectHairImgView, selectFemHairImgView] {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapFunct(tapGestureRecognizer:)))
            imageView?.isUserInteractionEnabled = true
            imageView?.addGestureRecognizer(tapGestureRecognizer)
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
                resetFeatureSelectedColor(newFeature: 0)
                selectFaceImgView.backgroundColor = AppColors.featureColorArray[1]
                // Generate new cells for the collection view
                AvatarCreatorViewController.cellBackgroundArray = Array(repeating: "Ear 1 + Head", count: 10)
                AvatarCreatorViewController.cellMidGroundArray = Array(repeating: "transparent", count: 10)
                AvatarCreatorViewController.cellSidegroundArray = Array(repeating: "transparent", count: chinArray.count)
                AvatarCreatorViewController.cellHairTieArray = Array(repeating: "transparent", count: chinArray.count)
                AvatarCreatorViewController.cellSubforegroundArray =   ["Chin 1.svg", "Chin 2.svg", "Chin 3.svg", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2"]
                AvatarCreatorViewController.cellForeGroundArray = ["transparent", "transparent", "transparent", "Chin 4 Beard.svg", "Chin 5 Beard.svg", "Chin 6 Beard.svg", "Chin 7 Beard.svg", "Chin 8 Beard.svg", "Chin 9 Beard.svg", "Chin 10 Beard.svg"]
                elemCollectionView.reloadData()
            } else if featureTapped == selectEyeImgView {
                // color in button
                resetFeatureSelectedColor(newFeature: 1)
                selectEyeImgView.backgroundColor = AppColors.featureColorArray[1]
                // generate new cells in collection view
                AvatarCreatorViewController.cellBackgroundArray = Array(repeating: "Ear 1 + Head", count: frameArray.count)
                AvatarCreatorViewController.cellMidGroundArray = Array(repeating: chinArray[(AvatarCreatorViewController.chinIndex) % 3], count: frameArray.count)
                AvatarCreatorViewController.cellSidegroundArray = Array(repeating: "transparent", count: lensArray.count)
                AvatarCreatorViewController.cellHairTieArray = Array(repeating: "transparent", count: lensArray.count)
                AvatarCreatorViewController.cellForeGroundArray = frameArray
                AvatarCreatorViewController.cellSubforegroundArray = lensArray
                elemCollectionView.reloadData()
                
            } else if featureTapped == selectNoseImgView {
                // Color in button
                resetFeatureSelectedColor(newFeature: 2)
                selectNoseImgView.backgroundColor = AppColors.featureColorArray[1]
                // generate new cells in collection view
                AvatarCreatorViewController.cellBackgroundArray = Array(repeating: "Ear 1 + Head", count: frameArray.count)
                AvatarCreatorViewController.cellMidGroundArray = Array(repeating: chinArray[(AvatarCreatorViewController.chinIndex) % 3], count: frameArray.count)
                AvatarCreatorViewController.cellSidegroundArray = Array(repeating: "transparent", count: noseArray.count)
                AvatarCreatorViewController.cellHairTieArray = Array(repeating: "transparent", count: noseArray.count)
                AvatarCreatorViewController.cellSubforegroundArray = Array(repeating: "transparent", count: noseArray.count)
                AvatarCreatorViewController.cellForeGroundArray = noseArray
                elemCollectionView.reloadData()
                
            } else if featureTapped == selectBrowImgView {
                // update button color
                resetFeatureSelectedColor(newFeature: 3)
                selectBrowImgView.backgroundColor = AppColors.featureColorArray[1]
                // Generate new cells in collection view
                AvatarCreatorViewController.cellBackgroundArray = Array(repeating: "Ear 1 + Head", count: browArray.count)
                AvatarCreatorViewController.cellMidGroundArray = Array(repeating: chinArray[(AvatarCreatorViewController.chinIndex) % 3], count: browArray.count)
                AvatarCreatorViewController.cellSidegroundArray = Array(repeating: "transparent", count: browArray.count)
                AvatarCreatorViewController.cellHairTieArray = Array(repeating: "transparent", count: browArray.count)
                AvatarCreatorViewController.cellSubforegroundArray = Array(repeating: "transparent", count: browArray.count)
                AvatarCreatorViewController.cellForeGroundArray = browArray
                elemCollectionView.reloadData()
                
            } else if featureTapped == selectMouthImgView {
                // update button Color
                resetFeatureSelectedColor(newFeature: 4)
                selectMouthImgView.backgroundColor = AppColors.featureColorArray[1]
                // Generate new cells in collection view
                AvatarCreatorViewController.cellBackgroundArray = Array(repeating: "Ear 1 + Head", count: mouthArray.count)
                AvatarCreatorViewController.cellMidGroundArray = Array(repeating: chinArray[(AvatarCreatorViewController.chinIndex) % 3], count: mouthArray.count)
                AvatarCreatorViewController.cellSidegroundArray = Array(repeating: "transparent", count: mouthArray.count)
                AvatarCreatorViewController.cellHairTieArray = Array(repeating: "transparent", count: mouthArray.count)
                AvatarCreatorViewController.cellSubforegroundArray = Array(repeating: "transparent", count: mouthArray.count)
                AvatarCreatorViewController.cellForeGroundArray = mouthArray
                elemCollectionView.reloadData()
            } else if featureTapped == selectEarImgView {
                // Update Button Color
                resetFeatureSelectedColor(newFeature: 5)
                selectEarImgView.backgroundColor = AppColors.featureColorArray[1]
               //  Generate new cells in collection view
                AvatarCreatorViewController.cellBackgroundArray = Array(repeating: "Ear 1 + Head", count: earArray.count)
                AvatarCreatorViewController.cellMidGroundArray = Array(repeating: chinArray[(AvatarCreatorViewController.chinIndex) % 3], count: earArray.count)
                AvatarCreatorViewController.cellSidegroundArray = Array(repeating: "transparent", count: earArray.count)
                AvatarCreatorViewController.cellHairTieArray = Array(repeating: "transparent", count: earArray.count)
                AvatarCreatorViewController.cellSubforegroundArray = Array(repeating: "transparent", count: earArray.count)
                AvatarCreatorViewController.cellForeGroundArray = earArray
                elemCollectionView.reloadData()
            } else if featureTapped == selectHairImgView {
                // Update Button Color
                resetFeatureSelectedColor(newFeature: 6)
                selectHairImgView.backgroundColor = AppColors.featureColorArray[1]
                // Generate new cells in collection view
                AvatarCreatorViewController.cellBackgroundArray = backHairArray
                AvatarCreatorViewController.cellMidGroundArray = Array(repeating: "Ear 1 + Head", count: backHairArray.count)
                AvatarCreatorViewController.cellSidegroundArray = hairSideArray
                AvatarCreatorViewController.cellHairTieArray = hairTieArray
                AvatarCreatorViewController.cellSubforegroundArray = Array(repeating: chinArray[(AvatarCreatorViewController.chinIndex) % 3], count: frontHairArray.count)
                AvatarCreatorViewController.cellForeGroundArray = frontHairArray
                elemCollectionView.reloadData()
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
    
    
    @IBAction func elemSliderMoved(_ sender: UISlider) {
        let elem = String(format: "%.0f", sender.value)
        let elemInt = Int(elem) ?? 0
        
        let index = AvatarCreatorViewController.currFacialFeature
        
        switch index {
        case 0:
            chinImgView.image = UIImage(imageLiteralResourceName: chinArray[elemInt])
            if(elemInt >= 3){
                chinImgView.image = UIImage(imageLiteralResourceName: chinArray[1])
                beardImgView.image = UIImage(imageLiteralResourceName: chinArray[elemInt])
                mouthImgView.image = UIImage(imageLiteralResourceName: mouthArray[0])
            } else {
                beardImgView.image = UIImage(imageLiteralResourceName: "transparent")
            }
        case 1:
            earImgView.image = UIImage(imageLiteralResourceName: earArray[elemInt])
        case 2:
            glassLensImgView.image = UIImage(imageLiteralResourceName: lensArray[elemInt])
            glassFrameImgVIew.image = UIImage(imageLiteralResourceName: frameArray[elemInt] )
        case 3:
            eyebrowImgView.image = UIImage(imageLiteralResourceName: browArray[elemInt])
        case 4:
            mouthImgView.image = UIImage(imageLiteralResourceName: mouthArray[elemInt])
        case 5:
            noseImgView.image = UIImage(imageLiteralResourceName: noseArray[elemInt])
        case 6:
            backHairImgView.image = UIImage(imageLiteralResourceName: backHairArray[elemInt])
            sideHairImgView.image = UIImage(imageLiteralResourceName: hairSideArray[elemInt])
            hairTieImgView.image = UIImage(imageLiteralResourceName: hairTieArray[elemInt])
            frontHairImgView.image = UIImage(imageLiteralResourceName: frontHairArray[elemInt])
        default:
            break
        }
        print(elemInt)
    }
    
    func resetFeatureSelectedColor(newFeature: Int) {
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
        // then update the slider's min and max values (temporary)
        updateSlider()
    }
    
    // METHODS/VARS FOR UPKEEP OF COLLECTION VIEW
    
    static var cellBackgroundArray: [String] = ["Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head", "Ear 1 + Head"]
    static var cellMidGroundArray = Array(repeating: "transparent", count: 10)
    static var cellSidegroundArray = Array(repeating: "transparent", count: 10)
    static var cellHairTieArray =    Array(repeating: "transparent", count: 10)
    static var cellSubforegroundArray =   ["Chin 1.svg", "Chin 2.svg", "Chin 3.svg", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2", "Chin 2"]
    static var cellForeGroundArray: [String] = ["transparent", "transparent", "transparent", "Chin 4 Beard.svg", "Chin 5 Beard.svg", "Chin 6 Beard.svg", "Chin 7 Beard.svg", "Chin 8 Beard.svg", "Chin 9 Beard.svg", "Chin 10 Beard.svg"]
    
    
    
    // Returns the number of sections in the view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // returns the number of images that cells are being made from
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AvatarCreatorViewController.cellForeGroundArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        cell.backgroundColor = .green
        cell.foregroundImageView.tag = indexPath.item
        
        cell.backgroundImageView.image = UIImage(named: AvatarCreatorViewController.cellBackgroundArray[indexPath.item])
        cell.midgroundImageView.image = UIImage(named: AvatarCreatorViewController.cellMidGroundArray[indexPath.item])
        cell.cellSideGroundImageView.image = UIImage(named: AvatarCreatorViewController.cellSidegroundArray[indexPath.item])
        cell.cellHairTieImageView.image = UIImage(named: AvatarCreatorViewController.cellHairTieArray[indexPath.item])
        cell.subforegroundImageView.image = UIImage(named: AvatarCreatorViewController.cellSubforegroundArray[indexPath.item])
        cell.foregroundImageView.image = UIImage(named: AvatarCreatorViewController.cellForeGroundArray[indexPath.item])
        // add a tap gesture recognizer to the foreground image view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        cell.foregroundImageView.addGestureRecognizer(tapGestureRecognizer)
        cell.foregroundImageView.isUserInteractionEnabled = true
        
        return cell
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // get the index of the image that was tapped using the tag property
        let index = sender.view?.tag
        print("Image at index \(index) was tapped")
        let elemIndex: Int = index!
        updateAvatar(elemIndex: elemIndex)
    }
    
    
    
    
    // COLLECTION VIEW METHODS END HERE
    
    
    
    
    
    
    func updateSlider() {
        let index = AvatarCreatorViewController.currFacialFeature
        if (index == 0) {
            print("Chin")
            elemChoiceSlider.value = 0
            let sliderMax = Float((chinArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
        }
        if (index == 1) {
            print("Eyes")
            elemChoiceSlider.value = 0
            let sliderMax = Float((frameArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
            
        }
        if (index == 2) {
            print("Nose")
            elemChoiceSlider.value = 0
            let sliderMax = Float((noseArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
            
        }
        if (index == 3) {
            print("Brows")
            elemChoiceSlider.value = 0
            let sliderMax = Float((browArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
        }
        if (index == 4) {
            print("Mouth")
            elemChoiceSlider.value = 0
            let sliderMax = Float((mouthArray.count-1))
            elemChoiceSlider.maximumValue = sliderMax
            
        }
        if (index == 5) {
            print("Ears")
            elemChoiceSlider.value = 0
            let sliderMax = Float((earArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
        }
        if (index == 6) {
            print("Hair")
            elemChoiceSlider.value = 0
            let sliderMax = Float((frontHairArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
        }
        
    }
    
    func changeColor(elemIndex: Int, newColor: UIColor, staticIndex: Int) {
        if (elemIndex < 6) {
            // in this case, user is modifying facial features
            headImgView.tintColor = newColor
            chinImgView.tintColor = newColor
            AvatarCreatorViewController.skinTone = newColor
            AvatarCreatorViewController.avatarIndexArray[8] = staticIndex
        } else {
            // user is changing hair color
            backHairImgView.tintColor = newColor
            frontHairImgView.tintColor = newColor
            sideHairImgView.tintColor = newColor
            // check for beard to recolor
            if(beardImgView.image != UIImage(imageLiteralResourceName: "transparent")) {
                beardImgView.tintColor = newColor
            }
            AvatarCreatorViewController.hairColor = newColor
            AvatarCreatorViewController.avatarIndexArray[7] = staticIndex
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
            chinImgView.image = UIImage(named: chinArray[elemIndex])
            AvatarCreatorViewController.chinIndex = elemIndex
            if(elemIndex >= 3){
                chinImgView.image = UIImage(named: chinArray[1])
                beardImgView.image = UIImage(named: chinArray[elemIndex])
                mouthImgView.image = UIImage(named: mouthArray[0])
            } else {
                beardImgView.image = UIImage(named: "transparent")
            }
            
        case 1: // CUSTOMIZATION OF EYES
            glassLensImgView.image = UIImage(named: lensArray[elemIndex])
            glassFrameImgVIew.image = UIImage(named: frameArray[elemIndex] )
            AvatarCreatorViewController.eyeIndex = elemIndex
            
        case 2: // CUSTOMIZATION OF NOSE
            noseImgView.image = UIImage(named: noseArray[elemIndex])
            AvatarCreatorViewController.noseIndex = elemIndex
        case 3: // CUSTOMIZATION OF EYEBROWS
            eyebrowImgView.image = UIImage(named: browArray[elemIndex])
            AvatarCreatorViewController.browsIndex = elemIndex
        case 4: // CUSTOMIZATION OF MOUTH SHAPE
            mouthImgView.image = UIImage(named: mouthArray[elemIndex])
            AvatarCreatorViewController.mouthIndex = elemIndex
        case 5: // CUSTOMIZATION OF EARS
            earImgView.image = UIImage(named: earArray[elemIndex])
            AvatarCreatorViewController.earIndex = elemIndex
        case 6: // CUSTOMIZATION OF HAIR
            backHairImgView.image = UIImage(named: backHairArray[elemIndex])
            hairTieImgView.image = UIImage(named: hairTieArray[elemIndex])
            frontHairImgView.image = UIImage(named: frontHairArray[elemIndex])
            sideHairImgView.image = UIImage(named: hairSideArray[elemIndex])
            AvatarCreatorViewController.hairIndex = elemIndex
        default:
            break
        }
        print(elemIndex)
    }
    
    
    func saveAvatar() -> [Int] {
        return AvatarCreatorViewController.avatarIndexArray
    }
    
    func restoreAvatar(avatarArray: [Int]) {
        for(index, element) in avatarArray.enumerated() {
            // rebuild the facial features
            if(index < 7) {
                AvatarCreatorViewController.currFacialFeature = index
                updateAvatar(elemIndex: element)
            } else if (index == 7) {
                // restore the Hair Color
                changeColor(elemIndex: 0, newColor: AppColors.skintoneArray[element], staticIndex: element)
            } else if (index == 8) {
                //restore the hair color
                changeColor(elemIndex: 10, newColor: AppColors.skintoneArray[element], staticIndex: element)
            }
        }
    }
    
    
    
} // end of AvatarViewCreator Class




