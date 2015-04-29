//
//  Device.swift
//  Wires
//
//  Created by Patrick Perini on 4/28/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import Foundation

struct Device {
    // MARK: Properties
    let token: String
    
    // MARK: Server Mutators
    func register() {
        PCHTTPClient.post(WiresAPI.domain, payload: ["token": token], responseHandler: nil)
    }
}