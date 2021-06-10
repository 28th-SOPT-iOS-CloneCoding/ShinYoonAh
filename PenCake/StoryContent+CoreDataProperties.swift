//
//  StoryContent+CoreDataProperties.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/10.
//
//

import Foundation
import CoreData


extension StoryContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoryContent> {
        return NSFetchRequest<StoryContent>(entityName: "StoryContent")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var page: StoryPage?

}

extension StoryContent : Identifiable {

}
