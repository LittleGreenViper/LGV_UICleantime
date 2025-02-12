/*
  © Copyright 2022-2025, Little Green Viper Software Development LLC
 
 Version: 2.2.0
 
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

import RVS_Generic_Swift_Toolbox
import LGV_Cleantime
import UIKit

/* ###################################################################################################################################### */
// MARK: - String Generator Class (Using Localizable) -
/* ###################################################################################################################################### */
/**
 This is basically a namespace class, providing a static utility for generating a report string.
 
 This is declared as its own class (as opposed to a struct), so it can be subclassed.
 */
open class LGV_UICleantimeDateReportString {
    /* ################################################################## */
    /**
     This allows the class to be instantiated, so the static function can be used.
     */
    required public init() { }
    
    /* ################################################################## */
    /**
     A special static version of the generator. This should work, even if the instance method is overloaded.
     
     - parameter beginDate: The starting date. This must be provided.
     - parameter endDate: The ending date. If not provided, today is assumed.
     - parameter calendar: The calendar to use. If not provided, the current user calendar is specified.
     - returns: A String, denoting NA cleantime.
    */
    public static func naCleantimeText(beginDate inBeginDate: Date?, endDate inEndDate: Date?, calendar inCalendar: Calendar? = Calendar.current) -> String? {
        Self().naCleantimeText(beginDate: inBeginDate, endDate: inEndDate, calendar: inCalendar)
    }
    
    /* ################################################################## */
    /**
     The string generator (as an instance method).
     
     - parameter beginDate: The starting date. This must be provided.
     - parameter endDate: The ending date. If not provided, today is assumed.
     - parameter calendar: The calendar to use. If not provided, the current user calendar is specified.
     - parameter short: OPTIONAL (Default false). If true, then the report is shortened.
     - returns: A String, denoting NA cleantime.
    */
    open func naCleantimeText(beginDate inBeginDate: Date?, endDate inEndDate: Date?, calendar inCalendar: Calendar? = Calendar.current, short inShort: Bool = false) -> String? {
        // Assuming we have everything we need, we calculate the cleantime. Otherwise, just return "Infinity."
        guard let beginDate = inBeginDate,
              let endDate = inEndDate else { return "" }
        
        let cleanTime = LGV_CleantimeDateCalc(startDate: beginDate, endDate: endDate, calendar: inCalendar).cleanTime
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        var ret = inShort ? "" : "SLUG-STATEMENT-IN-RECOVERY-SINCE".localizedVariant + dateFormatter.string(from: beginDate) + "SLUG-ENDING-CHAR".localizedVariant
        
        ret += (inShort ? "" : ("SLUG-STATEMENT-CLEANDATE-SEPARATOR".localizedVariant))
            + (0 >= cleanTime.totalDays ? "SLUG-STATEMENT-NO-CLEANTIME".localizedVariant
               : (1 == cleanTime.totalDays ? "SLUG-PREFIX-CLEANTIME-DAY".localizedVariant
                  : String(format: "SLUG-PREFIX-CLEANTIME-DAYS".localizedVariant, cleanTime.totalDays))) + (inShort ? "" : "SLUG-ENDING-CHAR".localizedVariant)
        
        if 1 > cleanTime.totalDays {
            ret = "SLUG-STATEMENT-NO-CLEANTIME".localizedVariant
        } else if 90 < cleanTime.totalDays {
            ret = inShort ? "" : ret + "SLUG-CLEANTIME-DIVIDER".localizedVariant
            if 0 == cleanTime.months,
               0 == cleanTime.days,
               1 == cleanTime.years {
                ret += inShort ? "SLUG-PREFIX-CLEANTIME-YEAR".localizedVariant : "SLUG-PREFIX-CLEANTIME-YEAR-EXACT".localizedVariant
            } else if 0 == cleanTime.months,
                      0 == cleanTime.days,
                      1 < cleanTime.years {
                ret += (inShort ? String(format: "SLUG-PREFIX-CLEANTIME-YEARS".localizedVariant, cleanTime.years) : String(format: "SLUG-PREFIX-CLEANTIME-YEARS-EXACT".localizedVariant, cleanTime.years))
            } else {
                var retArray: [String] = []
                if 0 < cleanTime.years {
                    if 1 == cleanTime.years {
                        retArray.append("SLUG-PREFIX-CLEANTIME-YEAR".localizedVariant)
                    } else {
                        retArray.append(String(format: "SLUG-PREFIX-CLEANTIME-YEARS".localizedVariant, cleanTime.years))
                    }
                }
                
                if 0 < cleanTime.months {
                    if 1 == cleanTime.months {
                        retArray.append("SLUG-PREFIX-CLEANTIME-MONTH".localizedVariant)
                    } else {
                        retArray.append(String(format: "SLUG-PREFIX-CLEANTIME-MONTHS".localizedVariant, cleanTime.months))
                    }
                }
                
                if 0 < cleanTime.days {
                    if 1 == cleanTime.days {
                        retArray.append("SLUG-PREFIX-CLEANTIME-DAY".localizedVariant)
                    } else {
                        retArray.append(String(format: "SLUG-PREFIX-CLEANTIME-DAYS".localizedVariant, cleanTime.days))
                    }
                }
                
                ret += retArray.joined(separator: "SLUG-JOINING-CHAR".localizedVariant) + (inShort ? "" : "SLUG-ENDING-CHAR".localizedVariant)
            }
        }
        return ret
    }
}

#if os(iOS) // We don't want this around, if we will be using it in non-IOS contexts.
/* ###################################################################################################################################### */
// MARK: - Cleantime Report Label Display View -
/* ###################################################################################################################################### */
/**
 This class extends the [`UILabel`](https://developer.apple.com/documentation/uikit/uilabel) class to display a localizable cleantime "report."
 This report is built, using the [`String(format:)`](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html) builder.
 
 This requires a begin date, and an end date be supplied, and it will generate a text report, in conversational English (by default), using format strings. You can leave the end date, and "today" will be used. Date granularity is 1 day (24 hours).
 
 This creates an instance of [`LGV_CleantimeDateCalc`](https://github.com/LittleGreenViper/LGV_Cleantime/blob/master/Sources/LGV_Cleantime/LGV_CleantimeDateCalc.swift) to calculate the interval, and build the String.
 
 The "engine" is an instance of `LGV_UICleantimeDateReportString`, which is designed to allow subclassing and customization.
 
 It uses localization tokens, and the [`RVS_Generic_Swift_Toolbox`](https://github.com/RiftValleySoftware/RVS_Generic_Swift_Toolbox)
 [`.localizedVariant`](https://github.com/RiftValleySoftware/RVS_Generic_Swift_Toolbox/blob/master/Sources/RVS_Generic_Swift_Toolbox/Extensions/RVS_String_Extensions.swift#L39)
 extension to provide localization.
 
 Users of this class should take the strings in the [`Localizable.strings`](https://github.com/LittleGreenViper/LGV_UICleantime/blob/master/Sources/Resources/Base.lproj/Localizable.strings) file, and add the tokens to their own app localizations.
 
 The way that you use this class in Interface Builder, is drag in an instance of [`UILabel`](https://developer.apple.com/documentation/uikit/uilabel), and set the class to `LGV_UICleantimeDisplayTextLabel`.
 */
@IBDesignable
open class LGV_UICleantimeDisplayTextLabel: UILabel {
    /* ################################################################################################################################## */
    // MARK: Required Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The date signifying the beginning of the period.
     */
    open var beginDate: Date? {
        didSet { DispatchQueue.main.async { self.setNeedsLayout() } }
    }
    
    /* ################################################################## */
    /**
     The last date. This defaults to today.
     */
    open var endDate: Date? = Date() {
        didSet { DispatchQueue.main.async { self.setNeedsLayout() } }
    }
    
    /* ################################################################## */
    /**
     If true, then the display will be the short version.
     */
    open var isShort: Bool = false {
        didSet { DispatchQueue.main.async { self.setNeedsLayout() } }
    }

    /* ################################################################################################################################## */
    // MARK: Optional Overrides
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the instance that generates the text. It can be overridden or set to an instance of a derived subclass of `LGV_UICleantimeDateReportString`
     */
    open var reportStringClassInstance = LGV_UICleantimeDateReportString()
    
    /* ################################################################## */
    /**
     This is text to be displayed if no cleantime.
     */
    open var textToDisplayIfNoDate: String = "SLUG-STATEMENT-NO-CLEANTIME".localizedVariant
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension LGV_UICleantimeDisplayTextLabel {
    /* ################################################################## */
    /**
     Called when the views are to be laid out.
     */
    public override func layoutSubviews() {
        super.layoutSubviews()
        if let beginDate = beginDate,
           let endDate = endDate,
           beginDate < endDate {
            text = reportStringClassInstance.naCleantimeText(beginDate: beginDate, endDate: endDate, short: isShort)
        } else {
            text = textToDisplayIfNoDate
        }
    }
}
#endif
