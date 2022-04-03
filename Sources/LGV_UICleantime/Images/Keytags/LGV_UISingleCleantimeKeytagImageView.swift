/*
  © Copyright 2022, Little Green Viper Software Development LLC
 
 Version: 1.0.0
 
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

#if os(iOS) // This prevents the IB errors from showing up, under SPM (From SO Answer: https://stackoverflow.com/a/66334661/879365).
import UIKit
import LGV_Cleantime

/* ###################################################################################################################################### */
// MARK: - Cleantime Keytag Display View -
/* ###################################################################################################################################### */
/**
 This is a view class that will display a single "cleantime" commemoration keytag.
 */
@IBDesignable
open class LGV_UISingleCleantimeKeytagImageView: LGV_UICleantimeImageViewBase {
    /* ################################################################################################################################## */
    // MARK: - Cleantime Keytag Ring Resource Names -
    /* ################################################################################################################################## */
    /**
     This enum has the names for all of the various keytag ring visual resources.
     */
    public enum KeytagResourceNamesRing: String {
        /* ########################################################## */
        /**
         */
        case none = ""

        /* ########################################################## */
        /**
         */
        case ring_Closed

        /* ########################################################## */
        /**
         */
        case ring_Open
    }

    /* ################################################################################################################################## */
    // MARK: Public Instance Property
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     True (default) if the ring is closed on top.
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
    override var generatedImage: UIImage? {
        guard let keyTagDescription = LGV_CleantimeKeytagDescription.getLastTagThatApplies(totalDays: totalDays, totalMonths: totalMonths),
           let bodyImage = UIImage(named: keyTagDescription.bodyImage.rawValue),
           let textImage = UIImage(named: keyTagDescription.textImage.rawValue),
           let ringImage = UIImage(named: (isRingClosed ? KeytagResourceNamesRing.ring_Closed : KeytagResourceNamesRing.ring_Open).rawValue) else { return nil }
        
        let imageSize = bodyImage.size
        let boundRect = CGRect(origin: .zero, size: imageSize)
        #if DEBUG
            print("Drawing keytag into \(boundRect).")
        #endif
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        defer { UIGraphicsEndImageContext() }
        ringImage.draw(in: boundRect, blendMode: .normal, alpha: 1)
        bodyImage.draw(in: boundRect, blendMode: .normal, alpha: 1)
        textImage.draw(in: boundRect, blendMode: .normal, alpha: 1)        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
#endif
