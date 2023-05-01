//
//  Database.swift
//  Real Quick
//
//  Created by Matthew Hanlon on 4/29/23.
//

import Foundation
import Blackbird

struct Database {
    static let shared = try! Blackbird.Database(path: Constants.databasePath)
}
