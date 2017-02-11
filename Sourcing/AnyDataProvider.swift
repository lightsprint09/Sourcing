//
//  AnyDataProvider.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.01.17.
//  Copyright © 2017 Lukas Schmidt. All rights reserved.
//

import Foundation

final public class AnyDataProvider<Object>: DataProviding {
    /// Closure which gets called, when a data inside the provider changes and those changes should be propagated to the datasource.
    /// **Warning:** Only set this when you are updating the datasource.
    public var whenDataProviderChanged: ProcessUpdatesCallback<Object>? {
        didSet {
            setwhenDataProviderChanged(whenDataProviderChanged)
        }
    }

    private let objectAtIndexPath: (_ atIndexPath: IndexPath) -> Object
    private let numberOfItems: (_ inSextion: Int) -> Int
    private let numberOfSectionsCallback: () -> Int
    
    private let prefetchItemsAtIndexPaths: ([IndexPath]) -> Void
    private let cancelPrefetchingForItemsAtIndexPaths: ([IndexPath]) -> Void
    
    private let setwhenDataProviderChanged: (ProcessUpdatesCallback<Object>?) -> Void
    
    public let sectionIndexTitles: Array<String>?
    
    init<DataProvider: DataProviding>(dataProvider: DataProvider) where Object == DataProvider.Object {
        objectAtIndexPath = { indexPath in
            return dataProvider.object(at: indexPath)
        }
        numberOfItems = { section in
            return dataProvider.numberOfItems(inSection: section)
        }
        numberOfSectionsCallback = {
            return dataProvider.numberOfSections()
        }
        prefetchItemsAtIndexPaths = { indexPaths in
            dataProvider.prefetchItems(at: indexPaths)
        }
        cancelPrefetchingForItemsAtIndexPaths = { indexPaths in
            dataProvider.cancelPrefetchingForItems(at: indexPaths)
        }
        sectionIndexTitles = dataProvider.sectionIndexTitles
        setwhenDataProviderChanged = { whenDataProviderChanged in
            dataProvider.whenDataProviderChanged = whenDataProviderChanged
        }
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
    
    public func prefetchItems(at indexPaths: [IndexPath]) {
        prefetchItemsAtIndexPaths(indexPaths)
    }
    
    public func cancelPrefetchingForItems(at indexPaths: [IndexPath]) {
        cancelPrefetchingForItemsAtIndexPaths(indexPaths)
    }
}
