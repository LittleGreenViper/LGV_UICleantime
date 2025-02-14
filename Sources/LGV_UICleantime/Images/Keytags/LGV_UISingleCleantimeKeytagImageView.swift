/*
  © Copyright 2022-2025, Little Green Viper Software Development LLC
 
 Version: 2.3.0
 
 LICENSE:
 
 MIT License
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import LGV_Cleantime
import UIKit

#if os(iOS) // We don't want this around, if we will be using it in non-IOS contexts.
/* ###################################################################################################################################### */
// MARK: - Single Cleantime Keytag Display View -
/* ###################################################################################################################################### */
/**
 This is a view class that will display a single "cleantime" commemoration keytag, delivered as a [`UIImage`](https://developer.apple.com/documentation/uikit/uiimage),
 which is then set into the [`UIImageView`](https://developer.apple.com/documentation/uikit/uiimageview)[`.image`](https://developer.apple.com/documentation/uikit/uiimageview/1621069-image) property.

 This class uses the [`LGV_CleantimeKeytagDescription`](https://github.com/LittleGreenViper/LGV_Cleantime/blob/master/Sources/LGV_Cleantime/LGV_CleantimeKeytagDescription.swift) struct to get names for the components of the 3-layer ARGB image (transparent PNG).
 
 The tags are all shown with their "backs" visible. This eliminates the issue of dealing with the registered trademark NA logo that appears on the front of each tag.
 
 The tag is composed of three layers of transparent PNG:
 
    1. The image has a ring, on top. This can be "open" or "closed." "Open" means that the top is missing, and is sized to make a "chain" of keytags. Default is "closed."
 
 This ring is placed under the other two layers.
 
    2. The second layer is a "body." This is the blank, colored keytag.
 
    3. The top layer is the "text" layer. This is rendered text for the given keytag. This is the asset that can be localized.

 All layers are the same size (the entire keytag size).
 */
@IBDesignable
open class LGV_UISingleCleantimeKeytagImageView: LGV_UICleantimeImageViewBase {
    /* ################################################################################################################################## */
    // MARK: - Cleantime Keytag Ring Resource Names -
    /* ################################################################################################################################## */
    /**
     This enum has the names for all of the various keytag ring visual resources.
     It is string, because we use the values to get images from the bundle.
     */
    public enum KeytagResourceNamesRing: String {
        /* ########################################################## */
        /**
         This should not happen. It's an error.
         */
        case none = ""

        /* ########################################################## */
        /**
         This means that the ring is "closed" at the top.
         */
        case ring_Closed

        /* ########################################################## */
        /**
         This means that the ring is "open" at the top.
         */
        case ring_Open
    }

    /* ################################################################################################################################## */
    // MARK: Public Instance Property
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     True (default) if the ring is closed on top.
     If it is changed, the cached image is deleted, forcing a recalculation.
     */
    @IBInspectable open var isRingClosed: Bool = true {
        didSet {
            if isRingClosed != oldValue {
                DispatchQueue.main.async {
                    self.image = nil
                    self.setNeedsLayout()
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     This returns a dynamically-generated keytag image.
     This needs to be implemented in the main class declaration.
     */
    public override var generatedImage: UIImage? {
        LGV_KeytagImageGenerator(isRingClosed: isRingClosed, totalDays: totalDays, totalMonths: totalMonths).generatedImage
    }
}
#endif

/* ###################################################################################################################################### */
// MARK: - Single Cleantime Keytag Image Generator -
/* ###################################################################################################################################### */
/**
 This is specified as a separate class, so it can be used by the Watch.
 */
open class LGV_KeytagImageGenerator {
    /* ################################################################################################################################## */
    // MARK: - Cleantime Keytag Ring Resource Names -
    /* ################################################################################################################################## */
    /**
     This enum has the names for all of the various keytag ring visual resources.
     It is string, because we use the values to get images from the bundle.
     */
    public enum KeytagResourceNamesRing: String {
        /* ########################################################## */
        /**
         This should not happen. It's an error.
         */
        case none = ""

        /* ########################################################## */
        /**
         This means that the ring is "closed" at the top.
         */
        case ring_Closed

        /* ########################################################## */
        /**
         This means that the ring is "open" at the top.
         */
        case ring_Open
    }

    /* ################################################################## */
    /**
     True (default) if the ring is closed on top.
     If it is changed, the cached image is deleted, forcing a recalculation.
     */
    public var isRingClosed: Bool = true
    
    /* ################################################################## */
    /**
     The total number of days to display.
     If it is changed, the cached image is deleted, forcing a recalculation.
     */
    public var totalDays: Int = 0
    
    /* ################################################################## */
    /**
     The total number of months to display (including years).
     If it is changed, the cached image is deleted, forcing a recalculation.
     */
    public var totalMonths: Int = 0

    /* ################################################################## */
    /**
     This returns a dynamically-generated keytag image.
     This needs to be implemented in the main class declaration.
     */
    public var generatedImage: UIImage? {
        guard let keyTagDescription = LGV_CleantimeKeytagDescription.getLastTagThatApplies(totalDays: totalDays, totalMonths: totalMonths),
           let bodyImage = UIImage(named: keyTagDescription.bodyImage.rawValue),
           let textImage = UIImage(named: keyTagDescription.textImage.rawValue),
           let ringImage = UIImage(named: (isRingClosed ? KeytagResourceNamesRing.ring_Closed : KeytagResourceNamesRing.ring_Open).rawValue) else { return nil }
        
        let imageSize = bodyImage.size
        let boundRect = CGRect(origin: .zero, size: imageSize)
        #if DEBUG
            print("Drawing single keytag into \(boundRect).")
        #endif
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        defer { UIGraphicsEndImageContext() }
        ringImage.draw(in: boundRect, blendMode: .normal, alpha: 1)
        bodyImage.draw(in: boundRect, blendMode: .normal, alpha: 1)
        textImage.draw(in: boundRect, blendMode: .normal, alpha: 1)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /* ################################################################## */
    /**
     Main initializer.
     
     - parameter isRingClosed: True, if the ring is "closed."
     - parameter totalDays: The total number of days, represented by the keytag.
     - parameter totalMonths: The total number of months, represented by the keytag.
     */
    public init(isRingClosed inIsRingClosed: Bool, totalDays inTotalDays: Int, totalMonths inTotalMonths: Int) {
        isRingClosed = inIsRingClosed
        totalDays = inTotalDays
        totalMonths = inTotalMonths
    }
}
