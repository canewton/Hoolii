//
//  ScaledIcon.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/14/22.
//

import Foundation
import UIKit

struct ScaledIcon {
    var imageInput: UIImage
    let targetSize: CGSize
    var image: UIImage = UIImage()
    
    // scale an svg file and add color to it according to the parameters passed in
    init(name: String, width: CGFloat, height: CGFloat, color: UIColor) {
        imageInput = UIImage(named: name)!
        targetSize = CGSize(width: width, height: height)
        
        let widthScaleRatio = targetSize.width / imageInput.size.width
        let heightScaleRatio = targetSize.height / imageInput.size.height
        
        let scaleFactor = min(widthScaleRatio, heightScaleRatio)
        
        let scaledImageSize = CGSize(
            width: imageInput.size.width * scaleFactor,
            height: imageInput.size.height * scaleFactor
        )

        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        image = renderer.image { _ in
            imageInput.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
        image = image.withTintColor(color)
    }
    
    public func getImage() -> UIImage {
        return image
    }
}
