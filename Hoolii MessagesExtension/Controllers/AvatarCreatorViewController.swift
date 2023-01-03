//
//  AvatarCreatorViewController.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 12/15/22.
//

import UIKit

class AvatarCreatorViewController: AppViewController {
    
    let chinArray = ["Chin 1.svg", "Chin 2.svg", "Chin 3.svg", "Chin 4 Beard.svg", "Chin 5 Beard.svg", "Chin 6 Beard.svg", "Chin 7 Beard.svg", "Chin 8 Beard.svg", "Chin 9 Beard.svg", "Chin 10 Beard.svg"]
    
    let earArray = ["transparent", "Ears 2.svg", "Ears 3.svg", "Ears 4.svg", "Ears 5.svg"]
    
    let browArray = ["Eyebrows 1.svg", "Eyebrows 2.svg", "Eyebrows 3.svg", "Eyebrows 4.svg", "Eyebrows 5.svg"]
    
    let lensArray = ["transparent","Eyes Glasses 2 lense.svg","Eyes Glasses 3 lense.svg", "Eyes Glasses 4 lense.svg", "Eyes Glasses 5 lense.svg"]
    let frameArray = ["transparent","Eyes Glasses 2.svg","Eyes Glasses 3.svg", "Eyes Glasses 4.svg", "Eyes Glasses 5.svg"]
    
    let maleFrontArray = ["Male hair 1", "Male hair 2", "Male hair 3", "Male hair 4", "Male hair 5", "Male hair 6", "Male hair 7 front", "Male hair 8", "Male hair 9 front", "Male hair 10 front", "Male hair 11 front", "Male hair 12", "Male hair 13", "Male hair 14", "Male hair 15", "Male hair 16"]
    let maleBackArray = ["transparent","transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "Male hair 9 back", "Male hair 10 back", "Male hair 11 back", "transparent", "transparent", "transparent", "transparent", "transparent"]
    let maleSideArray = ["transparent","transparent", "transparent", "transparent", "transparent", "transparent", "Male hair 7 side", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent"]
    let maleHairtieArray = ["transparent","transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "Male hair 9 hairtie", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent"]
    
    let femFrontArray = ["Female hair 1 front","Female hair 2 front", "Female hair 3 front", "Female hair 4 front", "Female hair 5 front", "Female hair 6 front", "transparent", "Female hair 8 front", "Female hair 9 front", "Female hair 10", "Female hair 11", "Female hair 12 front", "Female hair 13", "Female hair 14 front", "Female hair 15"]
    let femBackArray = ["Female hair 1 back", "Female hair 2 back", "Female hair 3 back", "Female hair 4 back", "Female hair 5 back", "Female hair 6 back", "Female hair 7", "Female hair 8 back", "Female hair 9 back", "transparent", "transparent", "Female hair 12 back", "transparent", "Female hair 14 back", "transparent"]
    let femSideArray = ["transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "Female hair 9 front highlight", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent"]
    let femHairtieArray = ["transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent", "Female hair 9 front hairtie", "transparent", "transparent", "transparent", "transparent", "transparent", "transparent"]
    
    let mouthArray = ["Mouth 1.png","Mouth 2.png", "Mouth 3.png", "Mouth 4.png", "Mouth 5.png"]
    
    let noseArray = ["Nose 1.png","Nose 2.png", "Nose 3.png", "Nose 4.png", "Nose 5.png"]
    
    let skintoneArray = [
        UIColor(red: 63/255.0, green: 39/255.0, blue: 27/255.0, alpha: 1.0),
        
        UIColor(red: 103/255.0, green: 70/255.0, blue: 51/255.0, alpha: 1.0),
        
        UIColor(red: 121/255.0, green: 78/255.0, blue: 69/255.0, alpha: 1.0),
        
        UIColor(red: 122/255.0, green: 82/255.0, blue: 56/255.0, alpha: 1.0),
        
        UIColor(red: 131/255.0, green: 90/255.0, blue: 68/255.0, alpha: 1.0),
        
        UIColor(red: 214/255.0, green: 160/255.0, blue: 122/255.0, alpha: 1.0),
        
        UIColor(red: 214/255.0, green: 163/255.0, blue: 132/255.0, alpha: 1.0),
        
        UIColor(red: 240/255.0, green: 194/255.0, blue: 168/255.0, alpha: 1.0),
        
        UIColor(red: 230/255.0, green: 186/255.0, blue: 157/255.0, alpha: 1.0),
        
        UIColor(red: 245/255.0, green: 211/255.0, blue: 183/255.0, alpha: 1.0),
        
        UIColor(red: 247/255.0, green: 217/255.0, blue: 189/255.0, alpha: 1.0),
        
        UIColor(red: 253/255.0, green: 225/255.0, blue: 204/255.0, alpha: 1.0),
    ]
    
    let featureColorArray = [
        UIColor(red: 239/255.0, green: 248/253.0, blue: 245/255.0, alpha: 1.0),
        UIColor(red: 142/255.0, green: 227/255.0, blue: 202/255.0, alpha: 1.0)
    ]
    
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
    @IBOutlet weak var selectMaleHairImgView: UIImageView!
    @IBOutlet weak var selectFemHairImgView: UIImageView!
    @IBOutlet weak var selectEarImgView: UIImageView!
    
    
    // Declaration of static variab;es
    static var hairColor = UIColor.black
    static var skinTone = UIColor.gray
    static var currFacialFeature = 0;
    static var itemIndex = 0;
    
    
    override func viewDidLoad() {
        // Function loaded: set all initial colors for elements
        super.viewDidLoad()
        let sliderMax = Float((chinArray.count - 1))
        elemChoiceSlider.maximumValue = sliderMax
        initColors()
        
        // Enable gesture recognition for facial feature selection
        for imageView in [selectFaceImgView, selectEyeImgView, selectNoseImgView, selectBrowImgView, selectMouthImgView, selectEarImgView, selectMaleHairImgView, selectFemHairImgView] {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapFunct(tapGestureRecognizer:)))
            imageView?.isUserInteractionEnabled = true
            imageView?.addGestureRecognizer(tapGestureRecognizer)
        }
        
    }
    
    // Dismiss screen if user presses back button to return to profile creation
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // Change the facial feature the user is modifying based on which image is tapped
    @objc func tapFunct(tapGestureRecognizer:UITapGestureRecognizer){
        if let featureTapped = tapGestureRecognizer.view as? UIImageView {
            if featureTapped == selectFaceImgView {
                resetFeatureSelectedColor(newFeature: 0)
                selectFaceImgView.backgroundColor = featureColorArray[1]
            } else if featureTapped == selectEyeImgView {
                resetFeatureSelectedColor(newFeature: 1)
                selectEyeImgView.backgroundColor = featureColorArray[1]
            } else if featureTapped == selectNoseImgView {
                resetFeatureSelectedColor(newFeature: 2)
                selectNoseImgView.backgroundColor = featureColorArray[1]
            } else if featureTapped == selectBrowImgView {
                resetFeatureSelectedColor(newFeature: 3)
                selectBrowImgView.backgroundColor = featureColorArray[1]
            } else if featureTapped == selectMouthImgView {
                resetFeatureSelectedColor(newFeature: 4)
                selectMouthImgView.backgroundColor = featureColorArray[1]
            } else if featureTapped == selectEarImgView {
                resetFeatureSelectedColor(newFeature: 5)
                selectEarImgView.backgroundColor = featureColorArray[1]
            } else if featureTapped == selectMaleHairImgView {
                resetFeatureSelectedColor(newFeature: 6)
                selectMaleHairImgView.backgroundColor = featureColorArray[1]
            } else if featureTapped == selectFemHairImgView {
                resetFeatureSelectedColor(newFeature: 7)
                selectFemHairImgView.backgroundColor = featureColorArray[1]
            }
        }
    }
    
    
    @IBAction func elemSelected(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if (index == 0) {
            print("Chin")
            elemChoiceSlider.value = 0
            let sliderMax = Float((chinArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
        }
        if (index == 1) {
            print("Ears")
            elemChoiceSlider.value = 0
            let sliderMax = Float((earArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
        }
        if (index == 2) {
            print("Eyes")
            elemChoiceSlider.value = 0
            let sliderMax = Float((frameArray.count - 1))
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
            print("Nose")
            elemChoiceSlider.value = 0
            let sliderMax = Float((noseArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
            
        }
        if (index == 6) {
            print("M. Hair")
            elemChoiceSlider.value = 0
            let sliderMax = Float((maleFrontArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
        }
        if (index == 7) {
            print("F. Hair")
            elemChoiceSlider.value = 0
            let sliderMax = Float((femFrontArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
        }
    }
    
    
    // USER TOUCHED SKIN/HAIR COLOR BUTTONS
    @IBAction func colorBut1Pressed(_ sender: UIButton) {
        let index = elemSlctrSgmnt.selectedSegmentIndex
        changeColor(elemIndex: index, newColor: skintoneArray[0])
    }
    
    @IBAction func colorBut2Pressed(_ sender: UIButton) {
        let index  = elemSlctrSgmnt.selectedSegmentIndex
        changeColor(elemIndex: index, newColor: skintoneArray[1])
    }
    
    @IBAction func colorBut3Pressed(_ sender: UIButton) {    let index  = elemSlctrSgmnt.selectedSegmentIndex
        changeColor(elemIndex: index, newColor: skintoneArray[2])
    }
    
    
    @IBAction func colorBut4Pressed(_ sender: UIButton) {
        let index  = elemSlctrSgmnt.selectedSegmentIndex
        changeColor(elemIndex: index, newColor: skintoneArray[3])
    }
    
    @IBAction func colorBut5Pressed(_ sender: UIButton) {
        let index  = elemSlctrSgmnt.selectedSegmentIndex
        changeColor(elemIndex: index, newColor: skintoneArray[4])
    }
    
    
    @IBAction func colorBut6Pressed(_ sender: UIButton) {
        let index  = elemSlctrSgmnt.selectedSegmentIndex
        changeColor(elemIndex: index, newColor: skintoneArray[5])
    }
    
    @IBAction func colorBut7Pressed(_ sender: UIButton) {
        let index  = elemSlctrSgmnt.selectedSegmentIndex
        changeColor(elemIndex: index, newColor: skintoneArray[6])
    }
    
    @IBAction func colorBut8Pressed(_ sender: UIButton) {
        let index  = elemSlctrSgmnt.selectedSegmentIndex
        changeColor(elemIndex: index, newColor: skintoneArray[7])
    }
    
    @IBAction func colorBut9Pressed(_ sender: UIButton) {
        let index  = elemSlctrSgmnt.selectedSegmentIndex
        changeColor(elemIndex: index, newColor: skintoneArray[8])
    }
    
    @IBAction func colorBut10Pressed(_ sender: UIButton) {
        let index  = elemSlctrSgmnt.selectedSegmentIndex
        changeColor(elemIndex: index, newColor: skintoneArray[9])
    }
    
    @IBAction func colorButton11Pressed(_ sender: UIButton) {
        let index  = elemSlctrSgmnt.selectedSegmentIndex
        changeColor(elemIndex: index, newColor: skintoneArray[10])
    }
    
    @IBAction func colorButton12Pressed(_ sender: UIButton) {
        let index  = elemSlctrSgmnt.selectedSegmentIndex
        changeColor(elemIndex: index, newColor: skintoneArray[11])
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
            backHairImgView.image = UIImage(imageLiteralResourceName: maleBackArray[elemInt])
            sideHairImgView.image = UIImage(imageLiteralResourceName: maleSideArray[elemInt])
            hairTieImgView.image = UIImage(imageLiteralResourceName: maleHairtieArray[elemInt])
            frontHairImgView.image = UIImage(imageLiteralResourceName: maleFrontArray[elemInt])
        case 7:
            backHairImgView.image = UIImage(imageLiteralResourceName: femBackArray[elemInt])
            sideHairImgView.image = UIImage(imageLiteralResourceName: femSideArray[elemInt])
            hairTieImgView.image = UIImage(imageLiteralResourceName: femHairtieArray[elemInt])
            frontHairImgView.image = UIImage(imageLiteralResourceName: femFrontArray[elemInt])
        default:
            break
        }
        print(elemInt)
    }
    
    func resetFeatureSelectedColor(newFeature: Int) {
        // reset the previous feature's background back to grey
        switch AvatarCreatorViewController.currFacialFeature {
        case 0:
            selectFaceImgView.backgroundColor = featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 1:
            selectEyeImgView.backgroundColor = featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 2:
            selectNoseImgView.backgroundColor = featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 3:
            selectBrowImgView.backgroundColor = featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 4:
            selectMouthImgView.backgroundColor = featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 5:
            selectEarImgView.backgroundColor = featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 6:
            selectMaleHairImgView.backgroundColor = featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        case 7:
            selectFemHairImgView.backgroundColor = featureColorArray[0]
            AvatarCreatorViewController.currFacialFeature  = newFeature
        default:
            break
        }
        // then update the slider's min and max values (temporary)
        updateSlider()
    }
    
    func updateSlider() {
        let index = AvatarCreatorViewController.currFacialFeature
        if (index == 0) {
            print("Chin")
            elemChoiceSlider.value = 0
            let sliderMax = Float((chinArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
        }
        if (index == 1) {
            print("Ears")
            elemChoiceSlider.value = 0
            let sliderMax = Float((earArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
        }
        if (index == 2) {
            print("Eyes")
            elemChoiceSlider.value = 0
            let sliderMax = Float((frameArray.count - 1))
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
            print("Nose")
            elemChoiceSlider.value = 0
            let sliderMax = Float((noseArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
            
        }
        if (index == 6) {
            print("M. Hair")
            elemChoiceSlider.value = 0
            let sliderMax = Float((maleFrontArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
        }
        if (index == 7) {
            print("F. Hair")
            elemChoiceSlider.value = 0
            let sliderMax = Float((femFrontArray.count - 1))
            elemChoiceSlider.maximumValue = sliderMax
        }
    }
    
    func changeColor(elemIndex: Int, newColor: UIColor) {
        if (elemIndex < 6) {
            // in this case, user is modifying facial features
            headImgView.tintColor = newColor
            chinImgView.tintColor = newColor
            AvatarCreatorViewController.skinTone = newColor
        } else {
            // user is changing hair color
            backHairImgView.tintColor = newColor
            frontHairImgView.tintColor = newColor
            // check for beard to recolor
            if(beardImgView.image != UIImage(imageLiteralResourceName: "transparent")) {
                beardImgView.tintColor = newColor
            }
            AvatarCreatorViewController.hairColor = newColor
        }
        
    }
    
    func initColors(){
        // Initialize facial details w/ default vals
        changeColor(elemIndex: 0, newColor: skintoneArray[1])
        // Initialize hair with default color
        changeColor(elemIndex: 7, newColor: UIColor.black)
    }
    
    
    
    
    
}
