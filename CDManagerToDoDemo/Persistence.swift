//
//  Persistence.swift
//  CDManagerToDoDemo
//
//  Created by Abdallah Edres on 21/11/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    var context: NSManagedObjectContext { container.viewContext }

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<3 {
            let newItem = ToDoTask(context: viewContext)
            newItem.title = "Task \(i)"
        }
        do {
            try viewContext.save()
        } catch {
             let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CDManagerToDoDemo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
  
}
