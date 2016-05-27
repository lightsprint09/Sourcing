//
//  ArrayDataProvider.swift
//  Burgess
//
//  Created by Lukas Schmidt on 11.04.16.
//  Copyright © 2016 Digital Workroom. All rights reserved.
//

import Foundation

public class ArrayDataProvider<Object>: NSObject, DataProvider {
    
    private(set) var data: Array<Array<Object>>
    private let dataProviderDidUpdate: (([DataProviderUpdate<Object>]?) ->())?
    
    public init(rows: Array<Object>, dataProviderDidUpdate: (([DataProviderUpdate<Object>]?) ->())? = nil) {
        self.data = [rows]
        self.dataProviderDidUpdate = dataProviderDidUpdate
        super.init()
    }
    
    public init(sections: Array<Array<Object>>, dataProviderDidUpdate: (([DataProviderUpdate<Object>]?) ->())? = nil) {
        self.data = sections
        self.dataProviderDidUpdate = dataProviderDidUpdate
        super.init()
    }
    
    public func reconfigureData(array: Array<Object>) {
        self.data = [array]
        dataProviderDidUpdate?(nil)
    }
    
    public func reconfigureData(array: Array<Array<Object>>) {
        self.data = array
        dataProviderDidUpdate?(nil)
    }
    
    public func objectAtIndexPath(indexPath: NSIndexPath) -> Object {
        return data[indexPath.section][indexPath.item]
    }
    
    public func numberOfItemsInSection(section: Int) -> Int {
        return data[section].count
    }
    
    public func numberOfSections() -> Int {
        return  data.count
    }
    
    public func indexPathForObject(object: Object) -> NSIndexPath? {
        
        return nil
    }
}