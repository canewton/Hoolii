//
//  AvatarConstants.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/14/23.
//

import UIKit

class AvatarConstants {
    static let hairOption0 = FacialFeatureOption.instanceFromNib().addHair(nil)
    static let hairOption1 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Female hair 1 front"), back: UIImage(named: "Female hair 1 back"), hairShift: 0.02)
    static let hairOption2 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Female hair 2 front"), back: UIImage(named: "Female hair 2 back"))
    static let hairOption3 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Female hair 3 front"), back: UIImage(named: "Female hair 3 back"), hairShift: 0.05)
    static let hairOption4 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Female hair 4 front"), back: UIImage(named: "Female hair 4 back"))
    static let hairOption5 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Female hair 5 front"), back: UIImage(named: "Female hair 5 back"), hairShift: 0.05)
    static let hairOption6 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Female hair 6 front"), back: UIImage(named: "Female hair 6 back"), hairShift: 0.1)
    static let hairOption7 = FacialFeatureOption.instanceFromNib().addHair(front: nil, back: UIImage(named: "Female hair 7"), hairShift: -0.055)
    static let hairOption8 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Female hair 8 front"), back: UIImage(named: "Female hair 8 back"), hairShift: -0.05)
    static let hairOption9 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Female hair 9 front"), midFront: UIImage(named: "Female hair 9 front highlight"), midBack: UIImage(named: "Female hair 9 front hairtie"), back: UIImage(named: "Female hair 9 back"), hairShift: -0.07)
    static let hairOption10 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Female hair 10"), hairShift: 0.075)
    static let hairOption11 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Female hair 11"), hairShift: -0.07)
    static let hairOption12 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Female hair 12 front"), back: UIImage(named: "Female hair 12 back"))
    static let hairOption13 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Female hair 13"), hairShift: -0.07)
    static let hairOption14 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Female hair 14 front"), back: UIImage(named: "Female hair 14 back"))
    static let hairOption15 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Female hair 15"), hairShift: -0.03)
    static let hairOption16 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Male hair 1"), hairShift: -0.05)
    static let hairOption17 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Male hair 2"))
    static let hairOption18 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Male hair 3"))
    static let hairOption19 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Male hair 4"), hairShift: -0.07)
    static let hairOption20 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Male hair 5"), hairShift: -0.05)
    static let hairOption21 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Male hair 6"), hairShift: -0.05)
    static let hairOption22 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Male hair 7 front"), midFront: UIImage(named: "Male hair 7 side"), midBack: nil, back: nil, hairShift: -0.07)
    static let hairOption23 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Male hair 8"), hairShift: -0.05)
    static let hairOption24 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Male hair 9 front"), midFront: UIImage(named: "Male hair 9 hairtie"), midBack: nil, back: UIImage(named: "Male hair 9 back"), hairShift: -0.1)
    static let hairOption25 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Male hair 10 front"), back: UIImage(named: "Male hair 10 back"), hairShift: -0.05)
    static let hairOption26 = FacialFeatureOption.instanceFromNib().addHair(front: UIImage(named: "Male hair 11 front"), back: UIImage(named: "Male hair 11 back"), hairShift: -0.05)
    static let hairOption27 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Male hair 12"), hairShift: -0.05)
    static let hairOption28 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Male hair 13"), hairShift: -0.05)
    static let hairOption29 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Male hair 14"), hairShift: 0.07)
    static let hairOption30 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Male hair 15"), hairShift: -0.05)
    static let hairOption31 = FacialFeatureOption.instanceFromNib().addHair(UIImage(named: "Male hair 16"), hairShift: -0.05)
    static let hairOptions: [FacialFeatureOption] = [hairOption0, hairOption1, hairOption2, hairOption3, hairOption4, hairOption5, hairOption6, hairOption7, hairOption8, hairOption9, hairOption10, hairOption11, hairOption12, hairOption13, hairOption14, hairOption15, hairOption16, hairOption17, hairOption18, hairOption19, hairOption20, hairOption21, hairOption22, hairOption23, hairOption24, hairOption25, hairOption26, hairOption27, hairOption28, hairOption29, hairOption30, hairOption31]
    
    
    static let chinOption1 = FacialFeatureOption.instanceFromNib()
    static let chinOption2 = FacialFeatureOption.instanceFromNib().addChin(UIImage(named: "Chin 2"))
    static let chinOption3 = FacialFeatureOption.instanceFromNib().addChin(UIImage(named: "Chin 3"))
    static let chinOption4 = FacialFeatureOption.instanceFromNib().addBeard(UIImage(named: "Chin 4 Beard"))
    static let chinOption5 = FacialFeatureOption.instanceFromNib().addBeard(UIImage(named: "Chin 5 Beard"))
    static let chinOption6 = FacialFeatureOption.instanceFromNib().addBeard(UIImage(named: "Chin 6 Beard"), beardShift: 0.085)
    static let chinOption7 = FacialFeatureOption.instanceFromNib().addBeard(UIImage(named: "Chin 7 Beard"))
    static let chinOption8 = FacialFeatureOption.instanceFromNib().addBeard(UIImage(named: "Chin 8 Beard"))
    static let chinOption9 = FacialFeatureOption.instanceFromNib().addBeard(UIImage(named: "Chin 9 Beard"))
    static let chinOption10 = FacialFeatureOption.instanceFromNib().addBeard(UIImage(named: "Chin 10 Beard"))
    static let chinOptions: [FacialFeatureOption] = [chinOption1, chinOption2, chinOption3, chinOption4, chinOption5, chinOption6, chinOption7, chinOption8, chinOption9, chinOption10]
    
    static let browOption1 = FacialFeatureOption.instanceFromNib().addBrows(UIImage(named: "Eyebrows 1"))
    static let browOption2 = FacialFeatureOption.instanceFromNib().addBrows(UIImage(named: "Eyebrows 2"))
    static let browOption3 = FacialFeatureOption.instanceFromNib().addBrows(UIImage(named: "Eyebrows 3"))
    static let browOption4 = FacialFeatureOption.instanceFromNib().addBrows(UIImage(named: "Eyebrows 4"))
    static let browOption5 = FacialFeatureOption.instanceFromNib().addBrows(UIImage(named: "Eyebrows 5"))
    static let browOptions: [FacialFeatureOption] = [browOption1, browOption2, browOption3, browOption4, browOption5]
    
    static let eyeOption1 = FacialFeatureOption.instanceFromNib().addEyes(UIImage(named: "Eyes 1"))
    static let eyeOption2 = FacialFeatureOption.instanceFromNib().addEyes(UIImage(named: "Eyes Glasses 2"))
    static let eyeOption3 = FacialFeatureOption.instanceFromNib().addEyes(UIImage(named: "Eyes Glasses 3"))
    static let eyeOption4 = FacialFeatureOption.instanceFromNib().addEyes(UIImage(named: "Eyes Glasses 4"))
    static let eyeOption5 = FacialFeatureOption.instanceFromNib().addEyes(UIImage(named: "Eyes Glasses 5"))
    static let eyeOptions: [FacialFeatureOption] = [eyeOption1, eyeOption2, eyeOption3, eyeOption4, eyeOption5]
    
    static let mouthOption1 = FacialFeatureOption.instanceFromNib().addMouth(UIImage(named: "Mouth 1"))
    static let mouthOption2 = FacialFeatureOption.instanceFromNib().addMouth(UIImage(named: "Mouth 2"))
    static let mouthOption3 = FacialFeatureOption.instanceFromNib().addMouth(UIImage(named: "Mouth 3"))
    static let mouthOption4 = FacialFeatureOption.instanceFromNib().addMouth(UIImage(named: "Mouth 4"))
    static let mouthOption5 = FacialFeatureOption.instanceFromNib().addMouth(UIImage(named: "Mouth 5"))
    static let mouthOptions: [FacialFeatureOption] = [mouthOption1, mouthOption2, mouthOption3, mouthOption4, mouthOption5]
    
    static let noseOption1 = FacialFeatureOption.instanceFromNib().addNose(UIImage(named: "Nose 1"))
    static let noseOption2 = FacialFeatureOption.instanceFromNib().addNose(UIImage(named: "Nose 2"))
    static let noseOption3 = FacialFeatureOption.instanceFromNib().addNose(UIImage(named: "Nose 3"))
    static let noseOption4 = FacialFeatureOption.instanceFromNib().addNose(UIImage(named: "Nose 4"))
    static let noseOption5 = FacialFeatureOption.instanceFromNib().addNose(UIImage(named: "Nose 5"))
    static let noseOptions: [FacialFeatureOption] = [noseOption1, noseOption2, noseOption3, noseOption4, noseOption5]
    
    static let earOption1 = FacialFeatureOption.instanceFromNib().addEars(nil)
    static let earOption2 = FacialFeatureOption.instanceFromNib().addEars(UIImage(named: "Ears 2"))
    static let earOption3 = FacialFeatureOption.instanceFromNib().addEars(UIImage(named: "Ears 3"))
    static let earOption4 = FacialFeatureOption.instanceFromNib().addEars(UIImage(named: "Ears 4"))
    static let earOption5 = FacialFeatureOption.instanceFromNib().addEars(UIImage(named: "Ears 5"))
    static let earOptions: [FacialFeatureOption] = [earOption1, earOption2, earOption3, earOption4, earOption5]
    
    static let facialFeatureSelectionList: [FacialFeatureSelection] = [FacialFeatureSelection(iconName: "Head", options: chinOptions), FacialFeatureSelection(iconName: "Eyes", options: eyeOptions), FacialFeatureSelection(iconName: "Nose", options: noseOptions), FacialFeatureSelection(iconName: "Brows", options: browOptions), FacialFeatureSelection(iconName: "Mouth", options: mouthOptions), FacialFeatureSelection(iconName: "Ears", options: earOptions), FacialFeatureSelection(iconName: "Hair", options: hairOptions), FacialFeatureSelection(iconName: "Background", options: [])]
}
