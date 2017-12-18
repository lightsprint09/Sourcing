//
//  Yacht+CoreDataProperties.swift
//  Burgess
//
//  Created by Lukas Schmidt on 26.03.16.
//  Copyright © 2016 Digital Workroom. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDTrain {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTrain> {
        return NSFetchRequest<CDTrain>(entityName: "CDTrain")
    }

    @NSManaged var id: String
    @NSManaged var name: String
}
