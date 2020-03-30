//
//  OSLog+Extensions.swift
//  CoreDataDemonstration
//
//  Created by mcs on 2/16/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let backendless = OSLog(subsystem: subsystem, category: "backendless")
    static let coreData = OSLog(subsystem: subsystem, category: "coreData")
}
