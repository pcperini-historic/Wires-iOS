//
//  Headline.swift
//  Wires
//
//  Created by Patrick Perini on 4/28/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import Foundation
import UIKit

struct Headline {
    // MARK: Properties
    let text: String
    let sourceURL: String?
    
    // MARK: Initializers
    init(dictionary: NSDictionary?) {
        self.text = dictionary?["text"] as? String ?? ""
        self.sourceURL = dictionary?["sourceURL"] as? String
    }
    
    // MARK: Accessors
    func readableText(callback: (readableText: String?) -> Void) {
        if self.sourceURL == nil {
            callback(readableText: nil)
            return
        }
        
        let parameters: [NSObject: AnyObject] = [
            "token": WiresAPI.readabilityToken,
            "url": self.sourceURL!,
            "max_pages": 1
        ]
        
        PCHTTPClient.get(WiresAPI.readabilityDomain + "/parser", parameters: parameters) { (response: PCHTTPResponse!) in
            let htmlText = (response.object as? NSDictionary)?["content"] as? String
            if let htmlUTF8 = htmlText!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
                let attributedText = NSAttributedString(data: htmlUTF8,
                    options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
                    documentAttributes: nil,
                    error: nil)
                
                var readableText = attributedText?.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                callback(readableText: readableText)
            } else {
                callback(readableText: nil)
            }
        }
    }
    
    // MARK: Server Accessors
    static func lastHeadline(callback: (lastHeadline: Headline?) -> Void) {
        PCHTTPClient.get(WiresAPI.domain + "/headline") { (response: PCHTTPResponse!) in
            let headline = Headline(dictionary: response.object as? NSDictionary)
            callback(lastHeadline: headline)
        }
    }
}