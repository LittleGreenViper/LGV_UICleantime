// swift-tools-version:5.5

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

import PackageDescription

let package = Package(
    name: "UICleantime",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14),    // This needs to be here, even though we don't compile for tvOS.
        .macOS(.v11)    // This needs to be here, even though we don't compile for MacOS.
    ],
    products: [
        .library(
            name: "LGV-UICleantime",
            targets: ["LGV_UICleantime"]
        )],
    dependencies: [
        .package(name: "RVS_Generic_Swift_Toolbox",
                 url: "git@github.com:RiftValleySoftware/RVS_Generic_Swift_Toolbox.git",
                 from: "1.6.6"),
        .package(name: "RVS_GeneralObserver",
                 url: "git@github.com:RiftValleySoftware/RVS_GeneralObserver.git",
                 from: "1.0.8"),
        .package(name: "LGV_Cleantime",
                 url: "git@github.com:LittleGreenViper/LGV_Cleantime.git",
                 from: "1.3.2")
    ],
    targets: [
        .target(name: "LGV_UICleantime",
                dependencies: [
                    .product(name: "RVS-Generic-Swift-Toolbox",
                             package: "RVS_Generic_Swift_Toolbox"),
                    .product(name: "RVS-GeneralObserver",
                             package: "RVS_GeneralObserver"),
                    .product(name: "LGV_Cleantime",
                             package: "LGV_Cleantime")]
                )
    ]
)
