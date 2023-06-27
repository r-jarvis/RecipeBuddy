//
//  Favorite+CoreDataProperties.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/22/23.
//
//

import Foundation
import CoreData
import UIKit

public extension Favorite {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged var id: Int64
    @NSManaged var image: String
    @NSManaged var title: String
}

extension Favorite : Identifiable { }
