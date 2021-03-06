![The Project Icon](icon.png)

# LGV_UICLEANTIME WIDGET

This is a set of methods and resources that will produce a [UIKit UILabel](https://developer.apple.com/documentation/uikit/uilabel), containing a localizable description of a span of cleantime, or [UIKit UIImage](https://developer.apple.com/documentation/uikit/uiimage/)s, representing keytags or medallions (standard medallions).

[Here is the GitHub repo for the project.](https://github.com/LittleGreenViper/LGV_UICleantime/)

## OVERVIEW

Use these methods and resources to implement a visual, "[skeuomorphic](https://www.techopedia.com/definition/28955/skeuomorphism)," display of the calculations that are generated by the [LGV_Cleantime](https://github.com/LittleGreenViper/LGV_Cleantime/) package (This package depends on that package).

## WHAT PROBLEM DOES THIS SOLVE?

This makes it very easy to provide a visual representation of important NA Recovery milestones. [LGV_Cleantime](https://github.com/LittleGreenViper/LGV_Cleantime/) will calculate them, but this module will display them (only on [iOS](https://apple.com/ios)/[iPadOS](https://apple.com/ipados)).

### Displays

#### Keytags

Keytags are displayed as classic "saddle" keytags (the real ones are made from plastic), with a ring at the top. This ring can be specified as "open," or "closed" (more on that, later)

|Figure 1: The Standard Keytag|Figure 2: With the Top Ring "Open"|
|:----:|:----:|
|![The standard Keytag](img/Figure-01.png)|![The standard Keytag, With Its Ring "Open"](img/Figure-02.png)|

#### Medallions

The medallions are "skeuomorphic" renditions of the standard NA cleantime medallions (front only):

|Figure 3: The Medallion|
|:----:|
|![The standard Medallion](img/Figure-03.png)|

#### Singly, Or In Groups

These can be displayed, either as "one-off," single images, or in arrays, Figures 1-3 show them "singly," while Figures 4-6 show them in arrays:

|Figure 4: A Horizontal Matrix of Keytags|Figure 5: A Vertical Strip of Keytags|Figure 6: A Horizontal Matrix of Medallions|
|:----:|:----:|:----:|
|![A Horizontal Matrix of Keytags](img/Figure-04.png)|![A Vertical Strip of Keytags](img/Figure-05.png)|![A Horizontal Matrix of Medallions](img/Figure-06.png)|

You can see why the top ring is optionally open, in Figure 5.

These are provided as [UIKit `UIImage`](https://developer.apple.com/documentation/uikit/uiimage/)s, embedded in [UIKit `UIImageView`](https://developer.apple.com/documentation/uikit/uiimageview)s. These can be put into scrollers, or other contexts.

## REQUIREMENTS

These classes are [UIKit](https://developer.apple.com/documentation/uikit/)-only ([iOS](https://apple.com/ios)/[iPadOS](https://apple.com/ipados)), and require the [Swift Programming Language](https://apple.com/developer/swift).

### Dependencies

The package is dependent upon the following three packages:

- [LGV_Cleantime](https://github.com/LittleGreenViper/LGV_Cleantime)
- [RVS_GeneralObserver](https://github.com/RiftValleySoftware/RVS_GeneralObserver)
- [RVS_Generic_Swift_Toolbox](https://github.com/RiftValleySoftware/RVS_Generic_Swift_Toolbox)

## IMPLEMENTATION

### Installation

#### [Swift Package Manager (SPM)](https://swift.org/package-manager/):

The URI for the repo is:

- [git@github.com:LittleGreenViper/LGV_UICleantime.git](git@github.com:LittleGreenViper/LGV_UICleantime.git) (SSH), or
- [https://github.com/LittleGreenViper/LGV_UICleantime.git](https://github.com/LittleGreenViper/LGV_UICleantime.git) (HTTPS).

If you want to find out more about SPM, then you might want to [view this series](https://littlegreenviper.com/series/spm/)).
    
### Resources

The package relies on resources that should be provided in a [Localizable.strings](https://github.com/LittleGreenViper/LGV_UICleantime/blob/master/Sources/Resources/Base.lproj/Localizable.strings) file, and [embedded as images](https://github.com/LittleGreenViper/LGV_UICleantime/tree/master/Sources/Resources/Base.lproj/LGV_UICleantime.xcassets) in your app bundle.

These are not being embedded into the package, because it is likely that you will want to mix them with your own localization resources.

### Usage
    
Once you have the package included in your project, you'll need to include the library:

    import LGV_UICleantime
    
The package has four different classes that can be used. One, is a subclass of [`UILabel`](https://developer.apple.com/documentation/uikit/uilabel), and the other three are subclasses of [`UIImageView`](https://developer.apple.com/documentation/uikit/uiimageview):

- [LGV_UICleantimeDisplayTextLabel](https://github.com/LittleGreenViper/LGV_UICleantime/blob/master/Sources/LGV_UICleantime/Text%20Report/LGV_UICleantimeDisplayTextLabel.swift) is a subclass of [`UILabel`](https://developer.apple.com/documentation/uikit/uilabel). It will display a "natural English (or other localization) summary of total cleantime (total days, also years, months, etc.).

- [LGV_UIMultipleCleantimeKeytagImageView](https://github.com/LittleGreenViper/LGV_UICleantime/blob/master/Sources/LGV_UICleantime/Images/Keytags/LGV_UIMultipleCleantimeKeytagImageView.swift) and [LGV_UISingleCleantimeKeytagImageView](https://github.com/LittleGreenViper/LGV_UICleantime/blob/master/Sources/LGV_UICleantime/Images/Keytags/LGV_UISingleCleantimeKeytagImageView.swift) are subclasses of [`UIImageView`](https://developer.apple.com/documentation/uikit/uiimageview), and display keytags, as shown in Figures 1, 2, 4, and 5.

- [LGV_UISingleCleantimeMedallionImageView](https://github.com/LittleGreenViper/LGV_UICleantime/blob/master/Sources/LGV_UICleantime/Images/Medallions/LGV_UICleantimeMedallions.swift#L76) is a subclass of [`UIImageView`](https://developer.apple.com/documentation/uikit/uiimageview), and displays a single medallion (like Figure 3).

- [LGV_UICleantimeMultipleMedallionsImageView](https://github.com/LittleGreenViper/LGV_UICleantime/blob/master/Sources/LGV_UICleantime/Images/Medallions/LGV_UICleantimeMedallions.swift#L329) is also a subclass of [`UIImageView`](https://developer.apple.com/documentation/uikit/uiimageview), and displays a matrix of medallions (as in Figure 6).

### The Test Harness App

The test harness app is designed to demonstrate the various aspects of the package, and provide some sample implementation. It is an [iOS](https://apple.com/ios)/[iPadOS](https://apple.com/ipados) app, and its source code is in the [Tests/LGV_UICleantimeTestHarness](https://github.com/LittleGreenViper/LGV_UICleantime/tree/master/Tests/LGV_UICleantimeTestHarness) subdirectory.

It has four tabs, which illustrate each of the above subclasses:

##### Tab 0: The Text Report Label, and Single Medallion View

|Figure 7: Tab 0 ("Medallion")|Figure 8: Tab 1 ("Keytag")|Figure 9: Tab 2 ("Keytags")|Figure 10: Tab 3 ("Medallions")|
|:----:|:----:|:----:|:----:|
|![Tab0](img/Figure-07.png)|![Tab1](img/Figure-08.png)|![Tab2](img/Figure-09.png)|![Tab3](img/Figure-10.png)|

The Keytags and Medallions tabs have scrollers, which will allow you to scroll the images.

The two keytag tabs have switches, allowing you to change the appearance/layout:

|Figure 11: Keytag Open Top|Figure 12: Vertical Keytag Strip|
|:----:|:----:|
|![The standard Keytag, With Its Ring "Open"](img/Figure-11.png)|![Keytags, Arranged as A Strip](img/Figure-12.png)|

## LICENSE

The code and keytag images are [MIT license](https://opensource.org/licenses/MIT). Use them as you will.

However, the medallion images are renderings of the standard bronze [NA World Services](https://na.org) (NAWS, Inc.) [cleantime commemoration medallions](https://cart-us.na.org/2-keytags-medallions/medallions-bronze/bronze-medallions-bronze). The design of those medallions is copyrighted by NA World Services.

It is important to treat the intellectual property of NA with respect.

