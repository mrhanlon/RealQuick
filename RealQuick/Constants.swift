//
//  Constants.swift
//  Real Quick
//
//  Created by Matthew Hanlon on 4/27/23.
//

import Foundation
enum Constants {
    static let databasePath = try! FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: false)
        .appendingPathComponent("realquick-db.sqlite").absoluteString
    
}
