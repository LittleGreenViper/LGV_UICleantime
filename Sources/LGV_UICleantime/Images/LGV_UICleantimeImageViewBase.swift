/*
  © Copyright 2022-2025, Little Green Viper Software Development LLC
 
 Version: 2.4.3
 
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

import RVS_GeneralObserver
import UIKit

#if os(iOS) // We don't want this around, if we will be using it in non-IOS contexts.
/* ###################################################################################################################################### */
// MARK: - This is the Protocol that Obesrvers of the Views Must Use -
/* ###################################################################################################################################### */
/**
 This protocol allows other objects to register as observers, and receive messages from the image view.
 
 There is only one message that the image view will send:
 
    - [`renderingComplete(view inImageView: LGV_UICleantimeImageViewBase)`](https://github.com/LittleGreenViper/LGV_UICleantime/blob/master/Sources/LGV_UICleantime/Images/LGV_UICleantimeImageViewBase.swift#L33).
 
 The images are generated in a separate thread _(sort of -it's the main thread)_, and this is called when rendering is complete.
 
 Note that this class extends [the `RVS_GeneralObserverSubTrackerProtocol` protocol](https://github.com/RiftValleySoftware/RVS_GeneralObserver/blob/master/Sources/RVS_GeneralObserver/RVS_GeneralObserver_Protocols.swift#L378).
 This means that the observer needs to be a class _(not a struct)_, and should define a couple of instance properties:
 
    - [`uuid: UUID`](https://github.com/RiftValleySoftware/RVS_GeneralObserver/blob/master/Sources/RVS_GeneralObserver/RVS_GeneralObserver_Protocols.swift#L273)
    - [`subscriptions: [RVS_GeneralObservableProtocol]`](https://github.com/RiftValleySoftware/RVS_GeneralObserver/blob/master/Sources/RVS_GeneralObserver/RVS_GeneralObserver_Protocols.swift#L383)
 */
public protocol LGV_UICleantimeImageViewObserverProtocol: RVS_GeneralObserverSubTrackerProtocol {
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
extension LGV_UICleantimeImageViewObserverProtocol {
    /* ################################################################## */
    /**
     This is called when the images have completed rendering.
     
     - parameter view: The completed UIImageView
     */
    func renderingComplete(view: LGV_UICleantimeImageViewBase) { }
}
#endif

/* ###################################################################################################################################### */
// MARK: - Cleantime Display View Base -
/* ###################################################################################################################################### */
/**
 This is a protocol that describes the base class. We use it to make sure that we can override the generatedImage func easily, and allows us to cast to a protocol.
 */
public protocol LGV_UICleantimeImageViewBaseProtocol: RVS_GeneralObservableProtocol {
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
    
    /* ################################################################## */
    /**
     This allows us to directly assign a rendering callback.
     */
    var renderingCallback: ((UIImage?) -> Void)? {get set}
}

#if os(iOS) // We don't want this around, if we will be using it in non-IOS contexts.
/* ###################################################################################################################################### */
// MARK: - Base Class for All Views -
/* ###################################################################################################################################### */
/**
 This class extends [`UIImageView`](https://developer.apple.com/documentation/uikit/uiimageview), and provides common functionality for the
 keytag and medallion image generators.
 
 The heart of the generator, is the `generatedImage: UIImage?` computed property. It will actually compose the images.
 
 The way to use the classes, is to treat them just like any [`UIImageView`](https://developer.apple.com/documentation/uikit/uiimageview).
 Instead of an image being externally applied, the image is generated by the view, itself.
 
 `generatedImage` can take quite some time, so it is dispatched to a separate (but main) thread, with observers being called when it is done (and a redraw happens, anyway).
 
 The [`UIImageView`](https://developer.apple.com/documentation/uikit/uiimageview)[`.image`](https://developer.apple.com/documentation/uikit/uiimageview/1621069-image) property
 is used as a "cache" for the generated image, with recalculation being applied, as necessary.
 
 The class can be created by Interface Builder, or programmatically. There are two main inspectable properties:
 
    - `totalDays: Int` This is the total number of days in the cleantime being represented. This is only used by the keytag renderers.
    - `totalMonths: Int` This is the total number of months (including years), in the cleantime being represented. This is used by both keytag and medallion renderers. Medallions use only this property.
 
 This does not do an actual cleantime calculation. It leaves that to the caller.
 
 */
@IBDesignable
open class LGV_UICleantimeImageViewBase: UIImageView, LGV_UICleantimeImageViewBaseProtocol {
    /* ################################################################## */
    /**
     This returns the dynamically-generated image. The base class returns nil.
     This needs to be declared as an instance property (as opposed to being defined as a protocol default).
     [This is why.](https://littlegreenviper.com/miscellany/swiftwater/the-curious-case-of-the-protocol-default/)
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
    public private(set) var uuid: UUID = UUID()
    
    /* ################################################################## */
    /**
     This allows us to directly assign a rendering callback.
     */
    public var renderingCallback: ((UIImage?) -> Void)?
    
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
     If it is changed, the cached image is deleted, forcing a recalculation.
     */
    @IBInspectable open var totalDays: Int = 0 { didSet { image = nil } }
    
    /* ################################################################## */
    /**
     The total number of months to display (including years).
     If it is changed, the cached image is deleted, forcing a recalculation.
     */
    @IBInspectable open var totalMonths: Int = 0 { didSet { image = nil } }
}

/* ###################################################################################################################################### */
// MARK: Private Callbacks
/* ###################################################################################################################################### */
extension LGV_UICleantimeImageViewBase {
    /* ################################################################## */
    /**
     This is called after rendering is complete.
     It sets the image, triggers a redraw, and also calls the observers.
     
     - parameter inImage: The image to be set as the view's image.
     */
    private func _newImage(_ inImage: UIImage?) {
        image = inImage // Doing this will set a redraw.
        renderingCallback?(inImage)
        observers.forEach { ($0 as? LGV_UICleantimeImageViewObserverProtocol)?.renderingComplete(view: self) }
    }
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
        // If we have a cache, we just go straight to the callback.
        if let cachedImage = image {
            _newImage(cachedImage)
        } else {    // Otherwise, we tell the instance to create new images. This will initiate a method call on the main thread, with a callback when done.
            DispatchQueue.main.async { [weak self] in self?._newImage(self?.generatedImage) }
        }
    }
}
#endif
