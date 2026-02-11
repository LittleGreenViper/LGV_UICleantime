// swift-tools-version:5.9

/*
  © Copyright 2022-2026, Little Green Viper Software Development LLC 
 
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
    name: "LGV_UICleantime",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14),
        .watchOS(.v10),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "LGV_UICleantime",
            targets: ["LGV_UICleantime"]
        )],
    dependencies: [
        .package(url: "git@github.com:RiftValleySoftware/RVS_Generic_Swift_Toolbox.git",
                 from: "1.16.4"),
        .package(url: "git@github.com:RiftValleySoftware/RVS_GeneralObserver.git",
                 from: "1.1.5"),
        .package(url: "git@github.com:LittleGreenViper/LGV_Cleantime.git",
                 from: "1.4.9")
    ],
    targets: [
        .target(name: "LGV_UICleantime",    
                dependencies: [
                    .product(name: "RVS_Generic_Swift_Toolbox",
                             package: "RVS_Generic_Swift_Toolbox"),
                    .product(name: "RVS_GeneralObserver",
                             package: "RVS_GeneralObserver"),
                    .product(name: "LGV_Cleantime",
                             package: "LGV_Cleantime")]
                )
    ]
)
