/*
  © Copyright 2022, Little Green Viper Software Development LLC
 
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

import UIKit
import RVS_Generic_Swift_Toolbox
import LGV_Cleantime
import LGV_UICleantime

/* ###################################################################################################################################### */
// MARK: - Main View Controller -
/* ###################################################################################################################################### */
/**
 */
class LGV_UICleantimeTestHarnessMedallionsViewController: LGV_UICleantimeBaseViewController {
    /* ################################################################## */
    /**
     The scroller, containing the display.
    */
    @IBOutlet weak var scrollView: UIScrollView?

    /* ################################################################################################################################## */
    // MARK: Base Class Overrides (In Main Declaration)
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is called when the images have completed rendering.
     
     - parameter view: The completed UIImageView
     */
    override func renderingComplete(view inImageView: LGV_UICleantimeImageViewBase) {
        super.renderingComplete(view: inImageView)
        guard let contentSize = scrollView?.contentSize,
              0 < contentSize.height
        else {
            scrollView?.zoomScale = 1.0
            return
        }

        // This makes sure that the scroller goes to the top of the matrix, if it is resized.
        let intW = inImageView.intrinsicContentSize.width
        let intH = inImageView.intrinsicContentSize.height
        let dispW = inImageView.bounds.size.width
        let scale = intW / dispW
        let differenceInHeight = max(0, (contentSize.height - (intH / scale)) / 2)
        scrollView?.contentOffset.y = differenceInHeight
    }
}

/* ###################################################################################################################################### */
// MARK: UIScrollViewDelegate Conformance
/* ###################################################################################################################################### */
extension LGV_UICleantimeTestHarnessMedallionsViewController: UIScrollViewDelegate {
    /* ################################################################## */
    /**
     This simply sets the image view as a pinch to zoom target.
     */
    func viewForZooming(in: UIScrollView) -> UIView? { cleantime }
}
