//
//  Yacht.swift
//  Burgess
//
//  Created by Lukas Schmidt on 26.03.16.
//  Copyright © 2016 Digital Workroom. All rights reserved.
//

import Foundation
import CoreData

class CDTrain: NSManagedObject {
    
    private static let entityName = String(describing: CDTrain.self)
    
    public class func newObject(in managedContext: NSManagedObjectContext) -> CDTrain {
        // swiftlint:disable force_unwrapping
        let entityDesc = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        return CDTrain(entity: entityDesc, insertInto: managedContext)
    }
}
