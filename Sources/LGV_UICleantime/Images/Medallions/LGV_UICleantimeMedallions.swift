/*
  © Copyright 2022, Little Green Viper Software Development LLC
 
 Version: 1.1.6
 
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

/* ###################################################################################################################################### */
// MARK: - UIImage Extension -
/* ###################################################################################################################################### */
/**
 This adds a simple image manipulation.
 */
fileprivate extension UIImage {
    /* ################################################################## */
    /**
     This allows an image to be resized, given both a width and a height, or just one of the dimensions.
     
     - parameters:
         - toNewWidth: The width (in pixels) of the desired image. If not provided, a scale will be determined from the toNewHeight parameter.
         - toNewHeight: The height (in pixels) of the desired image. If not provided, a scale will be determined from the toNewWidth parameter.
     
     - returns: A new image, with the given dimensions. May be nil, if no width or height was supplied, or if there was an error.
     */
    func resized(toNewWidth inNewWidth: CGFloat? = nil, toNewHeight inNewHeight: CGFloat? = nil) -> UIImage? {
        guard nil == inNewWidth,
              nil == inNewHeight else {
            var scaleX: CGFloat = (inNewWidth ?? size.width) / size.width
            var scaleY: CGFloat = (inNewHeight ?? size.height) / size.height

            scaleX = nil == inNewWidth ? scaleY : scaleX
            scaleY = nil == inNewHeight ? scaleX : scaleY

            let destinationSize = CGSize(width: size.width * scaleX, height: size.height * scaleY)
            let destinationRect = CGRect(origin: .zero, size: destinationSize)

            UIGraphicsBeginImageContextWithOptions(destinationSize, false, 0)
            defer { UIGraphicsEndImageContext() }   // This makes sure that we get rid of the offscreen context.
            draw(in: destinationRect, blendMode: .normal, alpha: 1)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        
        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: - Single Cleantime Medallion Display Image -
/* ###################################################################################################################################### */
/**
 This is a view class that will display a single "cleantime" commemoration medallion.
 
 The medallion is composed of two parts: A "base," which is a "blank" medallion, and a set of Roman numerals, composed as a transparent bitmap image, over the "base," in the center.
 
 Resizing of the Roman numerals is a dynamic process, as they need to fit within a central "diamond."
 */
@IBDesignable
open class LGV_UISingleCleantimeMedallionImageView: LGV_UICleantimeImageViewBase {
    /* ################################################################################################################################## */
    // MARK: Private Property
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     If the center image has a "wide" aspect, then it will need to fit in a diamond that has this size relation to the main image.
     */
    private static let _centerWideSizeCoefficient = CGFloat(0.43)

    /* ################################################################## */
    /**
     This is the aspect threshold, for determining whether or not an image is "wide."
     */
    private static let _centerWideAspectThreshold = CGFloat(0.9)

    /* ################################################################## */
    /**
     This is the aspect threshold, for determining whether or not an image is to be compressed.
     */
    private static let _centerWideAspectCompressionThreshold = CGFloat(0.5)

    /* ################################################################## */
    /**
     This is how much to compress.
     */
    private static let _centerWideAspectCompressionCoefficient = CGFloat(0.5)

    /* ################################################################## */
    /**
     In some cases, we will want to join images together. We do so, by removing this precentage of the height, from the joining edges.
     */
    private static let _cropInsetForClumping = CGFloat(0.07)
    
    /* ################################################################## */
    /**
     The background doesn't change, so we only need to render it once.
     */
    private var _cachedBackground: UIImage?
    
    /* ################################################################## */
    /**
     The foreground changes more frequently, but we can still cache it.
     */
    private var _cachedForeground: UIImage?
    
    /* ################################################################## */
    /**
     This returns the dynamically-generated medallion  image.
     This needs to be implemented in the main class declaration.
     */
    public override var generatedImage: UIImage? {
        super.image = _medallionImage
        
        return super.image
    }
}

/* ###################################################################################################################################### */
// MARK: Private Static Methods
/* ###################################################################################################################################### */
extension LGV_UISingleCleantimeMedallionImageView {
    /* ################################################################## */
    /**
     This will return a size that will fit into the center diamond.
     
     - parameter from: The current size of the image to be fitted into the center.
     - parameter in: The main image rect.
     - returns: A new size for the image.
     */
    private static func _calculateCenterSize(from inSize: CGSize, in inMainSize: CGSize) -> CGSize {
        let aspect = inSize.height / inSize.width
        var ret = inSize
        
        if Self._centerWideAspectThreshold > aspect {
            let fitSize = CGSize(width: inMainSize.width * _centerWideSizeCoefficient, height: inMainSize.height * _centerWideSizeCoefficient)
            ret.width = fitSize.width - (ret.width * aspect)
            ret.height = ret.width * aspect
        }
        
        return ret
    }
}

/* ###################################################################################################################################### */
// MARK: Private Computed Properties
/* ###################################################################################################################################### */
private extension LGV_UISingleCleantimeMedallionImageView {
    /* ################################################################## */
    /**
     This builds and returns a new medallion image, reflecting the number of years in the cleantime.
     */
    private var _medallionImage: UIImage? {
        #if DEBUG
            print("Drawing medallion into \(bounds) (\(frame)).")
        #endif
        
        guard let coinbase = _cachedBackground ?? UIImage(named: "CoinBlank") else { return nil }
        
        _cachedBackground = coinbase
        
        UIGraphicsBeginImageContextWithOptions(coinbase.size, false, 0)
        coinbase.draw(in: CGRect(origin: .zero, size: coinbase.size), blendMode: .normal, alpha: 1)
        
        if let centerImage = _cachedForeground ?? _centerImage {
            _cachedForeground = centerImage
            let newSize = Self._calculateCenterSize(from: centerImage.size, in: coinbase.size)
            if let centerImage = centerImage.resized(toNewWidth: newSize.width, toNewHeight: newSize.height) {
                var centerFrame = CGRect(origin: .zero, size: newSize)
                centerFrame.origin.x = (coinbase.size.width - newSize.width) / 2
                centerFrame.origin.y = (coinbase.size.height - newSize.height) / 2
                centerImage.draw(in: centerFrame, blendMode: .normal, alpha: 1)
            }
        }
    
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /* ################################################################## */
    /**
     This returns the center image.
     
     This can be the "Infinity" symbol (dates after today, or before Jan 1, 1950), "18" (18 months), or Roman numerals, denoiting the year.
     Wide numeral sets will be compressed horizontally.
     */
    private var _centerImage: UIImage? {
        guard nil == _cachedForeground else { return _cachedForeground }
    
        // Assuming we have everything we need, we calculate the cleantime. Otherwise, just return "Infinity."
        guard 0 <= totalMonths else { return UIImage(named: "Infinity") }
        
        // Low-hanging fruit: Eighteen month coin.
        if (18..<24).contains(totalMonths) {
            _cachedForeground = UIImage(named: "18")
            #if DEBUG
                print("18 Months.")
            #endif
        } else if (12..<18).contains(totalMonths) {
            #if DEBUG
                print("One Year.")
            #endif
            _cachedForeground = UIImage(named: "I")
        } else if !Int(totalMonths / 12).romanNumeral.isEmpty {
            let romanNumerals = Int(totalMonths / 12).romanNumeral
            #if DEBUG
                print("Fetching images for \(romanNumerals)")
            #endif
            
            var numerals = [UIImage]()
            
            romanNumerals.forEach {
                let imageName = "\($0)"
                #if DEBUG
                    print("Fetching \(imageName)")
                #endif
                
                if let numeral = UIImage(named: imageName) {
                    numerals.append(numeral)
                }
            }
            
            var contextBounds = CGRect.zero
            numerals.forEach {
                contextBounds.size.height = max(contextBounds.size.height, $0.size.height)
                contextBounds.size.width += $0.size.width
            }
            
            if 1 < numerals.count {
                let tempImages = numerals
                numerals = []
                
                contextBounds.size.width = 0

                let shaveIt = Self._cropInsetForClumping * contextBounds.size.height
                var prevCrop = CGFloat(0)
                var nextCrop = shaveIt
                for image in tempImages.enumerated() {
                    if image.offset == (tempImages.count - 1) {
                        nextCrop = 0
                    } else {
                        prevCrop = shaveIt
                    }
                    
                    let destRect = CGRect(x: prevCrop, y: 0, width: image.element.size.width - (prevCrop + nextCrop), height: contextBounds.size.height)
                    
                    if let destImage = image.element.cgImage?.cropping(to: destRect) {
                        contextBounds.size.width += destRect.size.width
                        numerals.append(UIImage(cgImage: destImage))
                    }
                }
            }
            
            #if DEBUG
                print("The necessary rect is \(contextBounds)")
            #endif
            
            UIGraphicsBeginImageContextWithOptions(contextBounds.size, false, 0.0)
            
            var currentX = CGFloat(0)
            
            numerals.forEach {
                $0.draw(at: CGPoint(x: currentX, y: 0))
                currentX += $0.size.width
            }
            
            if let centerImage = UIGraphicsGetImageFromCurrentImageContext() {
                let aspect = centerImage.size.height / centerImage.size.width
                
                if Self._centerWideAspectCompressionThreshold > aspect {
                    let newSize = CGSize(width: centerImage.size.width * Self._centerWideAspectCompressionCoefficient, height: centerImage.size.height)
                    _cachedForeground = centerImage.resized(toNewWidth: newSize.width, toNewHeight: newSize.height)
                } else {
                    _cachedForeground = centerImage
                }
            }
            
            UIGraphicsEndImageContext()
        }
        
        return _cachedForeground
    }
}

/* ###################################################################################################################################### */
// MARK: Public Instance Computed Properties
/* ###################################################################################################################################### */
extension LGV_UISingleCleantimeMedallionImageView {
    /* ################################################################## */
    /**
     This returns the medallion  image. It may be cached. Clearing it, reverts the image to the background image.
     */
    public override var image: UIImage? {
        get { super.image ?? generatedImage }
        
        set {
            if nil == newValue {
                _cachedForeground = nil
                super.image = _cachedBackground
            }
            
            super.image = newValue
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Multiple Cleantime Medallion Display Image -
/* ###################################################################################################################################### */
/**
 This is a view class that will display a whole set of cleantime medallions, in a matrix. Each medallion is an image generated by an instance of `LGV_UISingleCleantimeMedallionImageView`.
 */
@IBDesignable
open class LGV_UICleantimeMultipleMedallionsImageView: LGV_UICleantimeImageViewBase {
    /* ################################################################## */
    /**
     Contains cached drawn medallions.
     */
    private var _cachedMedallions: UIImage?

    /* ################################################################## */
    /**
     This returns a generated matrix of medallions.
     */
    public override var generatedImage: UIImage? {
        guard nil == _cachedMedallions else { return _cachedMedallions }
        
        let totalYears = Int(totalMonths / 12)
        
        if 0 < totalYears {
            var medallionDescriptions: [Int] = []
            medallionDescriptions.append(12)
            if 18 <= totalMonths {
                medallionDescriptions.append(18)
            }
            
            if 1 < totalYears {
                for i in 2...totalYears {
                    medallionDescriptions.append(i * 12)
                }
            }
            
            if let imageSize = LGV_UISingleCleantimeMedallionImageView().image?.size {
                // This trick will give us the "squarest" possible matrix, given the number of medallions.
                let rowMax = Int(CGFloat(medallionDescriptions.count).squareRoot())
                let columns = min(maxColumns, rowMax, medallionDescriptions.count)
                let rows = (medallionDescriptions.count + (columns - 1)) / columns
                
                UIGraphicsBeginImageContextWithOptions(CGSize(width: imageSize.width * CGFloat(columns), height: imageSize.height * CGFloat(rows)), false, 0)
                var index = 0
                var newOriginPoint = CGPoint.zero
                for _ in 0..<rows {
                    newOriginPoint.x = 0
                    for _ in 0..<columns {
                        if index < medallionDescriptions.count {
                            let currentMedallion = LGV_UISingleCleantimeMedallionImageView()
                            currentMedallion.totalMonths = medallionDescriptions[index]
                            if let medallionImage = currentMedallion.generatedImage {
                                medallionImage.draw(in: CGRect(origin: newOriginPoint, size: imageSize))
                            }
                            newOriginPoint.x += imageSize.width
                            index += 1
                        } else {
                            break
                        }
                    }
                    newOriginPoint.y += imageSize.height
                }
                
                _cachedMedallions = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
        
        return _cachedMedallions
    }
    
    /* ################################################################## */
    /**
     Called when the view is laid out.
     
     We use this to force the images to be recreated.
     */
    public override func layoutSubviews() {
        _cachedMedallions = nil // Make sure that we reset the cache, so it is rebuilt.
        super.layoutSubviews()
    }
    
    /* ################################################################## */
    /**
     This is the maximum number of columns to display. Its default is 4.
     */
    @IBInspectable open var maxColumns: Int = 4
}
#endif
