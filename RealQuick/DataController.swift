//
//  DataController.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/10/23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "RealQuick")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    static var preview: DataController = {
        let dataController = DataController()
        let viewContext = dataController.container.viewContext
            
        return dataController
    }()
}

