/*
  © Copyright 2022, Little Green Viper Software Development LLC
 
 Version: 1.0.2
 
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
import RVS_GeneralObserver

/* ###################################################################################################################################### */
// MARK: - This is the Protocol that Obesrvers of the Views Must Use -
/* ###################################################################################################################################### */
/**
 This protocol allows other objects to register as observers, and receive messages from the image.
 */
public protocol LGV_UICleantimeImageViewObserver: RVS_GeneralObserverSubTrackerProtocol {
    /* ################################################################## */
    /**
     This is called when the images have completed rendering.
     
     - parameter view: The completed UIImageView
     */
    func renderingComplete(view inImageView: LGV_UICleantimeImageViewBase)
}

/* ###################################################################################################################################### */
// MARK: Defaults Do Nothing
/* ###################################################################################################################################### */
extension LGV_UICleantimeImageViewObserver {
    /* ################################################################## */
    /**
     This is called when the images have completed rendering.
     
     - parameter view: The completed UIImageView
     */
    func renderingComplete(view: LGV_UICleantimeImageViewBase) { }
}

/* ###################################################################################################################################### */
// MARK: - Cleantime Display View Base -
/* ###################################################################################################################################### */
/**
 This is a protocol that describes the base class. We use it to make sure that we can override the generatedImage func easily, and allows us to cast to a protocol.
 */
protocol LGV_UICleantimeImageViewBaseProtocol: RVS_GeneralObservableProtocol {
    /* ################################################################## */
    /**
     The total number of days to display.
     */
    var totalDays: Int { get set }

    /* ################################################################## */
    /**
     The total number of months to display (including years).
     */
    var totalMonths: Int { get set }

    /* ################################################################## */
    /**
     This returns the dynamically-generated  image.
     */
    var generatedImage: UIImage? { get }
}

/* ###################################################################################################################################### */
// MARK: - Cleantime Medallion Display View -
/* ###################################################################################################################################### */
/**
 This is a view class that will display a "cleantime" commemoration medallion.
 */
@IBDesignable
open class LGV_UICleantimeImageViewBase: UIImageView, LGV_UICleantimeImageViewBaseProtocol {
    /* ################################################################## */
    /**
     This returns the dynamically-generated  image. The base class is nil.
     This needs to be declared (as opposed to being defined as a protocol default).
     This is why: https://littlegreenviper.com/miscellany/swiftwater/the-curious-case-of-the-protocol-default/
     This operates asynchronously, in the main thread.
     */
    open var generatedImage: UIImage? { nil }

    /* ################################################################## */
    /**
     Just make sure that we release all subscribers (belt and suspenders).
     This has to be implemented in the main declaration.
     */
    deinit {
        unsubscribeAll()
    }

    /* ################################################################################################################################## */
    // MARK: Not Private, But Not Open to the World. RVS_GeneralObservableProtocol Conformance. These must be declared public.
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is a unique UUID, for use by observers.
     Do not use this, or change it.
     */
    public var uuid: UUID = UUID()
    
    /* ################################################################## */
    /**
     This is an Array of subscribers.
     Do not use this, or change it.
     */
    public var observers: [RVS_GeneralObserverProtocol] = []

    /* ################################################################################################################################## */
    // MARK: Open to the World
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The total number of days to display.
     */
    @IBInspectable open var totalDays: Int = 0 { didSet { image = nil } }
    
    /* ################################################################## */
    /**
     The total number of months to display (including years).
     */
    @IBInspectable open var totalMonths: Int = 0 { didSet { image = nil } }
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension LGV_UICleantimeImageViewBase {
    /* ################################################################## */
    /**
     Called when the view is laid out.
     
     We use this to create the image. It starts the image drawing (asynchronously, but in the main thread).
     */
    override public func layoutSubviews() {
        super.layoutSubviews()
        if let cachedImage = image {
            newImage(cachedImage)
        } else {
            DispatchQueue.main.async { [weak self] in self?.newImage(self?.generatedImage) }
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension LGV_UICleantimeImageViewBase {
    /* ################################################################## */
    /**
     This is called after rendering is complete.
     It sets the image, triggers a redraw, and also calls the observers.
     
     - parameter inImage: The image to be set as the view's image.
     */
    func newImage(_ inImage: UIImage?) {
        image = inImage
        observers.forEach { ($0 as? LGV_UICleantimeImageViewObserver)?.renderingComplete(view: self) }
    }
}
#endif
