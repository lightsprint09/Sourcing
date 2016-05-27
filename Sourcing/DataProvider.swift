//
//  DataProvider.swift
//  Moody
//
//  Created by Florian on 08/05/15.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import Foundation

public protocol DataProvider: class {
    associatedtype Object
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object
    func numberOfItemsInSection(section: Int) -> Int
    func numberOfSections() -> Int
    
    func indexPathForObject(object: Object) -> NSIndexPath?
}


public  protocol DataProviderDelegate: class {
    associatedtype Object
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?)
}


public  enum DataProviderUpdate<Object> {
    case Insert(NSIndexPath)
    case Update(NSIndexPath, Object)
    case Move(NSIndexPath, NSIndexPath)
    case Delete(NSIndexPath)
    
    case InsertSection(Int)
    case DeleteSection(Int)
}

