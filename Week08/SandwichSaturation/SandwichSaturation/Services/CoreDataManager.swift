//
//  CoreDataManager.swift
//  SandwichSaturation
//
//  Created by Shruti Sharma on 7/16/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import Foundation
import CoreData

enum DatabaseError: Error {
  case dataNotSaved
  case databaseNotExist
}

typealias CompletionHandler = (Bool, DatabaseError?) -> Void

class CoreDataManager {
  
  private var modelName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
  
  init() { }
  
  lazy var persistantContainer: NSPersistentContainer = {
    
    guard let modelUrl = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
      fatalError("Databse with name \(modelName) does not exist in the bundle.")
    }
    
    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
      fatalError("Unable to Load Data Model")
    }
    
    let container = NSPersistentContainer(name: modelName)
    container.loadPersistentStores { (storeDescription, error) in
      print("Core Data Stack has been initialized with description: \(storeDescription)")
      if let error = error as NSError? {
        fatalError("Unable to load persistant store. \(error.userInfo)")
      }
    }
    return container
  }()
  
  var context: NSManagedObjectContext {
    return persistantContainer.viewContext
  }
  
  convenience init(modelName: String) {
    self.init()
    self.modelName = modelName
  }
  
  func addManagedObject<M: NSManagedObject>(_ type: M.Type) -> M? {
    
    _ = context
    var modelObject: M?
    if let entity = NSEntityDescription.entity(forEntityName: String(describing: M.self), in: context) {
      modelObject = M(entity: entity, insertInto: context)
    }
    return modelObject
  }
  
  func saveData() {
    
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let error = error as NSError
        print("Unable to save data\(error.userInfo)")
      }
    }
  }
  
  func fetch<M: NSManagedObject>(_ type: M.Type, predicate: NSPredicate?=nil, sort: NSSortDescriptor?=nil) -> [M]? {
    
    var fetched: [M]?
    let entityName = String(describing: type)
    let request = NSFetchRequest<M>(entityName: entityName)
    
    request.predicate = predicate
    request.sortDescriptors = [sort] as? [NSSortDescriptor]
    
    do {
      fetched = try context.fetch(request)
    }
    catch {
      print("Error executing fetch: \(error)")
    }
    return fetched
  }
  
  func delete<M: NSManagedObject>(_ modelObject: M) {
    context.delete(modelObject)
  }
  
}
