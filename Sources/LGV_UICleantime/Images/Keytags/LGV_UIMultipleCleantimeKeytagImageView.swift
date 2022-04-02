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
 This is a view class that will display a "cleantime" commemoration set of keytags.
 */
@IBDesignable
open class LGV_UIMultipleCleantimeKeytagImageView: LGV_UICleantimeImageViewBase {
    /* ################################################################################################################################## */
    // MARK: Private Property
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is used to determine how far each tag in a vertical line is shifted down from the one above.
     */
    private static let _verticalOrientationOffsetCoefficient = CGFloat(0.315)
    
    /* ################################################################## */
    /**
     This is used to determine how far each tag in a horizontal matrix is shifted down from the one above.
     */
    private static let _horizontalTopOrientationOffsetCoefficient = CGFloat(0.72)
    
    /* ################################################################## */
    /**
     This is used to determine how far each tag in a horizontal matrix is shifted sideways from the previous one.
     */
    private static let _horizontalSideOrientationOffsetCoefficient = CGFloat(0.75)
    
    /* ################################################################## */
    /**
     Contains cached drawn tags.
     */
    private var _cachedVerticalKeytags: UIImage?
    
    /* ################################################################## */
    /**
     Contains cached drawn tags.
     */
    private var _cachedHorizontalKeytags: UIImage?

    /* ################################################################################################################################## */
    // MARK: Open to the World
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     If true (default), the the keytags are arranged as a long vertical strip. If false, they are laid out in horizontal rows.
     */
    @IBInspectable public var keytagsAreAVerticalStrip: Bool = true {
        didSet {
            if oldValue != keytagsAreAVerticalStrip {
                DispatchQueue.main.async {
                    self.image = nil
                    self.setNeedsLayout()
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     This is the maximum number of columns to display. Its default is 8.
     */
    @IBInspectable public var maxColumns: Int = 8
    
    /* ################################################################## */
    /**
     This returns the dynamically-generated keytag set image.
     */
    override public var generatedImage: UIImage? { _generateKeytagImages }
}

/* ###################################################################################################################################### */
// MARK: Private Instance Computed Properties
/* ###################################################################################################################################### */
extension LGV_UIMultipleCleantimeKeytagImageView {
    /* ################################################################## */
    /**
     This handles drawing all the keytags into the scrolled view.
     */
    private var _generateKeytagImages: UIImage? { keytagsAreAVerticalStrip ? _cachedVerticalKeytags ?? _verticalKeytags : _cachedHorizontalKeytags ?? _horizontalKeytags }
    
    /* ################################################################## */
    /**
     Called to draw a long, vertical strip.
     */
    private var _verticalKeytags: UIImage? {
        #if DEBUG
            print("Drawing Vertical keytags.")
        #endif

        if var ringImage = UIImage(named: LGV_UISingleCleantimeKeytagImageView.KeytagResourceNamesRing.ring_Closed.rawValue) {
            let keytagDescriptions = LGV_CleantimeKeytagDescription.getTheFullMonty(totalDays: totalDays, totalMonths: totalMonths)
            
            var topOffset = CGFloat(0)
            var imageSize = ringImage.size
            let offsetIncrement = (imageSize.height * Self._verticalOrientationOffsetCoefficient)
            imageSize.height += offsetIncrement * CGFloat(keytagDescriptions.count - 1)
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            keytagDescriptions.forEach {
                _drawAKeytagImage(for: $0, putARingOnIt: ringImage, in: CGRect(origin: CGPoint(x: 0, y: topOffset), size: ringImage.size))
                if 0 == topOffset {
                    ringImage = UIImage(named: LGV_UISingleCleantimeKeytagImageView.KeytagResourceNamesRing.ring_Open.rawValue) ?? ringImage
                }
                
                topOffset += offsetIncrement
            }
            
            _cachedVerticalKeytags = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return _cachedVerticalKeytags
    }
    
    /* ################################################################## */
    /**
     Called to draw a wide set of lines.
     */
    private var _horizontalKeytags: UIImage? {
        #if DEBUG
            print("Drawing Horizontal keytags.")
        #endif
        
        if  let ringImage = UIImage(named: LGV_UISingleCleantimeKeytagImageView.KeytagResourceNamesRing.ring_Closed.rawValue) {
            let keytagDescriptions = LGV_CleantimeKeytagDescription.getTheFullMonty(totalDays: totalDays, totalMonths: totalMonths)
            if !keytagDescriptions.isEmpty {
                let topOffsetIncrement = (ringImage.size.height * Self._horizontalTopOrientationOffsetCoefficient)
                let sideOffsetIncrement = (ringImage.size.width * Self._horizontalSideOrientationOffsetCoefficient)
                // This trick will give us the "squarest" possible matrix, given the number of tags.
                let rowMax = Int((CGFloat(keytagDescriptions.count) * ((ringImage.size.height - topOffsetIncrement) / (ringImage.size.width - sideOffsetIncrement))).squareRoot())
                let columns = min(maxColumns, rowMax, keytagDescriptions.count)
                let rows = (keytagDescriptions.count + (columns - 1)) / columns
                
                let imageWidth = (sideOffsetIncrement * CGFloat(columns - 1)) + ringImage.size.width
                let imageHeight = (topOffsetIncrement * CGFloat(rows - 1)) + ringImage.size.height

                UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0)
                var index = 0
                var topOffset = CGFloat(0)
                for _ in 0..<rows {
                    var sideOffset = CGFloat(0)
                    for _ in 0..<columns {
                        if index < keytagDescriptions.count {
                            _drawAKeytagImage(for: keytagDescriptions[index], putARingOnIt: ringImage, in: CGRect(origin: CGPoint(x: sideOffset, y: topOffset), size: ringImage.size))
                        }
                        index += 1
                        sideOffset += sideOffsetIncrement
                    }
                    topOffset += topOffsetIncrement
                }
                
                _cachedHorizontalKeytags = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
        
        return _cachedHorizontalKeytags
    }
}

/* ###################################################################################################################################### */
// MARK: Private Instance Methods
/* ###################################################################################################################################### */
extension LGV_UIMultipleCleantimeKeytagImageView {
    /* ################################################################## */
    /**
     This draws one keytag into the given rect, in the current context.
     - parameter for: The description of the keytag to be drawn.
     - parameter putARingOnIt: An image for the ring. This should be the full size of the entire image.
     - parameter in: The rect in which to draw the image. It should be the size of the entire keytag.
     */
    private func _drawAKeytagImage(for inDescription: LGV_CleantimeKeytagDescription, putARingOnIt inRingImage: UIImage?, in inRect: CGRect) {
        if nil != inRingImage,
           let bodyImage = UIImage(named: inDescription.bodyImage.rawValue),
           let textImage = UIImage(named: inDescription.textImage.rawValue) {
            #if DEBUG
                print("Drawing keytag into \(inRect).")
            #endif
            inRingImage?.draw(in: inRect, blendMode: .normal, alpha: 1)
            bodyImage.draw(in: inRect, blendMode: .normal, alpha: 1)
            textImage.draw(in: inRect, blendMode: .normal, alpha: 1)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension LGV_UIMultipleCleantimeKeytagImageView {
    /* ################################################################## */
    /**
     Called when the view is laid out.
     
     We use this to force the images to be recreated.
     */
    public override func layoutSubviews() {
        _cachedVerticalKeytags = nil
        _cachedHorizontalKeytags = nil
        super.layoutSubviews()
    }
}
#endif
