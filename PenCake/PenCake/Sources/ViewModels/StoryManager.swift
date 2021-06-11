//
//  StoryManager.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/10.
//

import Foundation
import CoreData

class StoryManager {
    static var shared: StoryManager = StoryManager()
    
    var storyContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StoryStorage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.storyContainer.viewContext
    }
    
    // 저장된 데이터 fetch하는 법
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    // Page 저장하는 법
    @discardableResult
    func insertPage(story: Story) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Page", in: self.context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            
            managedObject.setValue(story.title, forKey: "title")
            managedObject.setValue(story.subtitle, forKey: "subtitle")
            managedObject.setValue(story.id, forKey: "id")
            
            do {
                try self.context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    // content 저장하는 법
    @discardableResult
    func insertContent(content: Content) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Contents", in: self.context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            
            managedObject.setValue(content.title, forKey: "title")
            managedObject.setValue(content.content, forKey: "content")
            managedObject.setValue(content.date, forKey: "date")
            
            do {
                try self.context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    // 특정 object 삭제
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        do {
            try context.save()
            return true
        } catch {
            print("잘못됐어 뭔가 잘못됐어")
            return false
        }
    }
    
    // 전체 삭제
    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.context.execute(delete)
            return true
        } catch {
            return false
        }
    }
    
    // 갯수 가져오기
    func count<T: NSManagedObject>(request: NSFetchRequest<T>) -> Int? {
        do {
            let count = try self.context.count(for: request)
            return count
        } catch {
            return nil
        }
    }
}
