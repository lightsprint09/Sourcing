//
//  AnyDataProvider.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.01.17.
//  Copyright © 2017 Lukas Schmidt. All rights reserved.
//

import Foundation

public class DataProvider<Object>: DataProviding {
    
    private let objectAtIndexPath: (_ atIndexPath: IndexPath) -> Object
    private let numberOfItems: (_ inSextion: Int) -> Int
    private let numberOfSectionsCallback: () -> Int
    
    public let sectionIndexTitles: Array<String>?
    
    init<DataProvider: DataProviding>(dataProvider: DataProvider) where Object == DataProvider.Object {
        objectAtIndexPath = { indexPath in
            return dataProvider.object(at: indexPath)
        }
        numberOfItems = { section in
            return dataProvider.numberOfItems(inSection: section)
        }
        numberOfSectionsCallback = dataProvider.numberOfSections
        sectionIndexTitles = dataProvider.sectionIndexTitles
    }
    
    public func object(at indexPath: IndexPath) -> Object {
        return objectAtIndexPath(indexPath)
    }
    
    public func numberOfItems(inSection section: Int) -> Int {
        return numberOfItems(section)
    }
    
    public func numberOfSections() -> Int {
        return numberOfSectionsCallback()
    }
}
