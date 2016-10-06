//
//  FontLoader.swift
//  SwiftIconFont
//
//  Created by Sedat Ciftci on 18/03/16.
//  Copyright © 2016 Sedat Gokbek Ciftci. All rights reserved.
//

import UIKit
import CoreText

class FontLoader: NSObject {
    class func loadFont(fontName: String) {
        let bundle = NSBundle(forClass: FontLoader.self)
        var fontURL = NSURL(string:"")
        for filePath : String in bundle.pathsForResourcesOfType("ttf", inDirectory: nil) {
            let filename = NSURL(fileURLWithPath: filePath).lastPathComponent!
            if filename.lowercaseString.rangeOfString(fontName.lowercaseString) != nil {
                fontURL = NSURL(fileURLWithPath: filePath)
                break;
            }
        }

        guard let fontUrlObtained = fontURL else {
            assertionFailure("cannot get font url from \(fontName)")
            return;
        }
        guard let data = NSData(contentsOfURL: fontUrlObtained) else {
            assertionFailure("cannot get data from font url \(fontUrlObtained)")
            return;
        }
        guard let provider = CGDataProviderCreateWithCFData(data) else {
            assertionFailure("cannot get provider from font data of url \(fontUrlObtained)")
            return;
        }
        let font = CGFontCreateWithDataProvider(provider)

        var e: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &e) {
            if let error = e {
                let errorDescription: CFStringRef = CFErrorCopyDescription(error.takeUnretainedValue())
                let nsError = error.takeUnretainedValue() as AnyObject as! NSError
                NSException(name: NSInternalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
            }
        }
    }
}
