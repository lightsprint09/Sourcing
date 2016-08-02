//
//  Copyright (C) 2016 Lukas Schmidt.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//
//
//  ArrayDataProvider.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//

import Foundation

public class ArrayDataProvider<Object>: NSObject, DataProviding {
    
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