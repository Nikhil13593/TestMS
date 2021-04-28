//
//  CoreDataMainStack.swift
//  TestMediSage
//
//  Created by NIKHIL KISHOR PATIL on 27/04/21.
//

import Foundation
import CoreData

class CoreDataMainStack {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
               print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}

// MARK: CoreData Internal
extension CoreDataMainStack {
    func saveContext () {
        guard mainContext.hasChanges else { return }
        
        do {
            try mainContext.save()
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
