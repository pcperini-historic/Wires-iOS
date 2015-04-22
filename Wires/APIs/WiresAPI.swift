//
//  WiresAPI.swift
//  Wires
//
//  Created by Patrick Perini on 4/21/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import Foundation

class WiresAPI {
    // MARK: Class Properties
    private class var domain: String {
        return "https://serene-plateau-5954.herokuapp.com"
    }
    
    // MARK: Device Handlers
    class func registerDeviceToken(token: String) {
        PCHTTPClient.post(domain, payload: ["token": token], responseHandler: nil)
    }
}