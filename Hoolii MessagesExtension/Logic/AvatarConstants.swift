//
//  AvatarConstants.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/14/23.
//

import UIKit

struct AvatarConstants {
    static let hairOption0 = AvatarImageCollection()
    static let hairOption1 = AvatarImageCollection().addHair(front: "Female hair 1 front", back: "Female hair 1 back", hairShift: 0.02)
    static let hairOption2 = AvatarImageCollection().addHair(front: "Female hair 2 front", back: "Female hair 2 back")
    static let hairOption3 = AvatarImageCollection().addHair(front: "Female hair 3 front", back: "Female hair 3 back", hairShift: 0.05)
    static let hairOption4 = AvatarImageCollection().addHair(front: "Female hair 4 front", back: "Female hair 4 back")
    static let hairOption5 = AvatarImageCollection().addHair(front: "Female hair 5 front", back: "Female hair 5 back", hairShift: 0.05)
    static let hairOption6 = AvatarImageCollection().addHair(front: "Female hair 6 front", back: "Female hair 6 back", hairShift: 0.1)
    static let hairOption7 = AvatarImageCollection().addHair(front: "", back: "Female hair 7", hairShift: -0.055)
    static let hairOption8 = AvatarImageCollection().addHair(front: "Female hair 8 front", back: "Female hair 8 back", hairShift: -0.05)
    static let hairOption9 = AvatarImageCollection().addHair(front: "Female hair 9 front", midFront: "Female hair 9 front highlight", midBack: "Female hair 9 front hairtie", back: "Female hair 9 back", hairShift: -0.07)
    static let hairOption10 = AvatarImageCollection().addHair("Female hair 10", hairShift: 0.075)
    static let hairOption11 = AvatarImageCollection().addHair("Female hair 11", hairShift: -0.07)
    static let hairOption12 = AvatarImageCollection().addHair(front: "Female hair 12 front", back: "Female hair 12 back")
    static let hairOption13 = AvatarImageCollection().addHair("Female hair 13", hairShift: -0.07)
    static let hairOption14 = AvatarImageCollection().addHair(front: "Female hair 14 front", back: "Female hair 14 back")
    static let hairOption15 = AvatarImageCollection().addHair("Female hair 15", hairShift: -0.03)
    static let hairOption16 = AvatarImageCollection().addHair("Male hair 1", hairShift: -0.05)
    static let hairOption17 = AvatarImageCollection().addHair("Male hair 2")
    static let hairOption18 = AvatarImageCollection().addHair("Male hair 3")
    static let hairOption19 = AvatarImageCollection().addHair("Male hair 4", hairShift: -0.07)
    static let hairOption20 = AvatarImageCollection().addHair("Male hair 5", hairShift: -0.05)
    static let hairOption21 = AvatarImageCollection().addHair("Male hair 6", hairShift: -0.05)
    static let hairOption22 = AvatarImageCollection().addHair(front: "Male hair 7 front", midFront: "Male hair 7 side", midBack: "", back: "", hairShift: -0.07)
    static let hairOption23 = AvatarImageCollection().addHair("Male hair 8", hairShift: -0.05)
    static let hairOption24 = AvatarImageCollection().addHair(front: "Male hair 9 front", midFront: "Male hair 9 hairtie", midBack: "", back: "Male hair 9 back", hairShift: -0.1)
    static let hairOption25 = AvatarImageCollection().addHair(front: "Male hair 10 front", back: "Male hair 10 back", hairShift: -0.05)
    static let hairOption26 = AvatarImageCollection().addHair(front: "Male hair 11 front", back: "Male hair 11 back", hairShift: -0.05)
    static let hairOption27 = AvatarImageCollection().addHair("Male hair 12", hairShift: -0.05)
    static let hairOption28 = AvatarImageCollection().addHair("Male hair 13", hairShift: -0.05)
    static let hairOption29 = AvatarImageCollection().addHair("Male hair 14", hairShift: 0.07)
    static let hairOption30 = AvatarImageCollection().addHair("Male hair 15", hairShift: -0.05)
    static let hairOption31 = AvatarImageCollection().addHair("Male hair 16", hairShift: -0.05)
    static let hairOptions: [AvatarImageCollection] = [hairOption0, hairOption1, hairOption2, hairOption3, hairOption4, hairOption5, hairOption9, hairOption10, hairOption11, hairOption12, hairOption13, hairOption14, hairOption6, hairOption7, hairOption29, hairOption17, hairOption18, hairOption8, hairOption15, hairOption16, hairOption19, hairOption20, hairOption21, hairOption22, hairOption23, hairOption24, hairOption25, hairOption26, hairOption27, hairOption28, hairOption30, hairOption31]
    
    
    static let chinOption1 = AvatarImageCollection()
    static let chinOption2 = AvatarImageCollection().addChin("Chin 2")
    static let chinOption3 = AvatarImageCollection().addChin("Chin 3")
    static let chinOption4 = AvatarImageCollection().addBeard("Chin 4 Beard")
    static let chinOption5 = AvatarImageCollection().addBeard("Chin 5 Beard")
    static let chinOption6 = AvatarImageCollection().addBeard("Chin 6 Beard", beardShift: 0.085)
    static let chinOption7 = AvatarImageCollection().addBeard("Chin 7 Beard")
    static let chinOption8 = AvatarImageCollection().addBeard("Chin 8 Beard")
    static let chinOption9 = AvatarImageCollection().addBeard("Chin 9 Beard")
    static let chinOption10 = AvatarImageCollection().addBeard("Chin 10 Beard")
    static let chinOptions: [AvatarImageCollection] = [chinOption1, chinOption2, chinOption3, chinOption4, chinOption5, chinOption6, chinOption7, chinOption8, chinOption9, chinOption10]
    
    static let browOption1 = AvatarImageCollection().addBrows("Eyebrows 1")
    static let browOption2 = AvatarImageCollection().addBrows("Eyebrows 2")
    static let browOption3 = AvatarImageCollection().addBrows("Eyebrows 3")
    static let browOption4 = AvatarImageCollection().addBrows("Eyebrows 4")
    static let browOption5 = AvatarImageCollection().addBrows("Eyebrows 5")
    static let browOptions: [AvatarImageCollection] = [browOption1, browOption2, browOption3, browOption4, browOption5]
    
    static let eyeOption1 = AvatarImageCollection().addEyes("Eyes 1")
    static let eyeOption2 = AvatarImageCollection().addEyes("Eyes Glasses 2")
    static let eyeOption3 = AvatarImageCollection().addEyes("Eyes Glasses 3")
    static let eyeOption4 = AvatarImageCollection().addEyes("Eyes Glasses 4")
    static let eyeOption5 = AvatarImageCollection().addEyes("Eyes Glasses 5")
    static let eyeOptions: [AvatarImageCollection] = [eyeOption1, eyeOption2, eyeOption3, eyeOption4, eyeOption5]
    
    static let mouthOption1 = AvatarImageCollection().addMouth("Mouth 1")
    static let mouthOption2 = AvatarImageCollection().addMouth("Mouth 2")
    static let mouthOption3 = AvatarImageCollection().addMouth("Mouth 3")
    static let mouthOption4 = AvatarImageCollection().addMouth("Mouth 4")
    static let mouthOption5 = AvatarImageCollection().addMouth("Mouth 5")
    static let mouthOptions: [AvatarImageCollection] = [mouthOption1, mouthOption2, mouthOption3, mouthOption4, mouthOption5]
    
    static let noseOption1 = AvatarImageCollection().addNose("Nose 1")
    static let noseOption2 = AvatarImageCollection().addNose("Nose 2")
    static let noseOption3 = AvatarImageCollection().addNose("Nose 3")
    static let noseOption4 = AvatarImageCollection().addNose("Nose 4")
    static let noseOption5 = AvatarImageCollection().addNose("Nose 5")
    static let noseOptions: [AvatarImageCollection] = [noseOption1, noseOption2, noseOption3, noseOption4, noseOption5]
    
    static let earOption1 = AvatarImageCollection().addEars("")
    static let earOption2 = AvatarImageCollection().addEars("Ears 2")
    static let earOption3 = AvatarImageCollection().addEars("Ears 3")
    static let earOption4 = AvatarImageCollection().addEars("Ears 4")
    static let earOption5 = AvatarImageCollection().addEars("Ears 5")
    static let earOptions: [AvatarImageCollection] = [earOption1, earOption2, earOption3, earOption4, earOption5]
    
    static let facialFeatureSelectionList: [FacialFeatureSelection] = [FacialFeatureSelection(iconName: "Head", options: chinOptions), FacialFeatureSelection(iconName: "Eyes", options: eyeOptions), FacialFeatureSelection(iconName: "Nose", options: noseOptions), FacialFeatureSelection(iconName: "Brows", options: browOptions), FacialFeatureSelection(iconName: "Mouth", options: mouthOptions), FacialFeatureSelection(iconName: "Ears", options: earOptions), FacialFeatureSelection(iconName: "Hair", options: hairOptions), FacialFeatureSelection(iconName: "Background", options: [])]
}
