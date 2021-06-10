//
//  StoryPage+CoreDataProperties.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/10.
//
//

import Foundation
import CoreData


extension StoryPage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoryPage> {
        return NSFetchRequest<StoryPage>(entityName: "StoryPage")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var contents: NSOrderedSet?

}

// MARK: Generated accessors for contents
extension StoryPage {

    @objc(insertObject:inContentsAtIndex:)
    @NSManaged public func insertIntoContents(_ value: StoryContent, at idx: Int)

    @objc(removeObjectFromContentsAtIndex:)
    @NSManaged public func removeFromContents(at idx: Int)

    @objc(insertContents:atIndexes:)
    @NSManaged public func insertIntoContents(_ values: [StoryContent], at indexes: NSIndexSet)

    @objc(removeContentsAtIndexes:)
    @NSManaged public func removeFromContents(at indexes: NSIndexSet)

    @objc(replaceObjectInContentsAtIndex:withObject:)
    @NSManaged public func replaceContents(at idx: Int, with value: StoryContent)

    @objc(replaceContentsAtIndexes:withContents:)
    @NSManaged public func replaceContents(at indexes: NSIndexSet, with values: [StoryContent])

    @objc(addContentsObject:)
    @NSManaged public func addToContents(_ value: StoryContent)

    @objc(removeContentsObject:)
    @NSManaged public func removeFromContents(_ value: StoryContent)

    @objc(addContents:)
    @NSManaged public func addToContents(_ values: NSOrderedSet)

    @objc(removeContents:)
    @NSManaged public func removeFromContents(_ values: NSOrderedSet)

}

extension StoryPage : Identifiable {

}
