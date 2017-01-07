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

/**
 `ArrayDataProvider` provides basic implementation to map arrays to an `DataProvider`.
 */
open class ArrayDataProvider<Object>: NSObject, ArrayDataProviding {
    
    fileprivate(set) open var data: Array<Array<Object>>
    fileprivate let dataProviderDidUpdate: (([DataProviderUpdate<Object>]?) ->())?
    open let sectionIndexTitles: Array<String>?
    
    /**
     Creates an instance of`ArrayDataProvider` with an flat array which results in a single section.
     
     - parameter rows: single section of data.
     - parameter sectionTitle: title for the section. nil by default.
     - parameter dataProviderDidUpdate: handler for recieving updates when datasource chnages. nil by default.
     */
    public convenience init(rows: Array<Object>, sectionTitle: String? = nil, dataProviderDidUpdate: (([DataProviderUpdate<Object>]?) ->())? = nil) {
        let titles: Array<String>? = sectionTitle == nil ? nil : [sectionTitle!]
        self.init(sections: [rows], sectionIndexTitles: titles, dataProviderDidUpdate: dataProviderDidUpdate)
    }
    
    /**
     Creates an instance of`ArrayDataProvider` with an 2D array which results in a multiple sections.
     
     - parameter sections: 2D array.
     - parameter sectionTitles: titles for the sections. nil by default.
     - parameter dataProviderDidUpdate: handler for recieving updates when datasource chnages. nil by default.
     */
    public init(sections: Array<Array<Object>>, sectionIndexTitles: Array<String>? = nil, dataProviderDidUpdate: (([DataProviderUpdate<Object>]?) ->())? = nil) {
        self.data = sections
        self.dataProviderDidUpdate = dataProviderDidUpdate
        self.sectionIndexTitles = sectionIndexTitles
        super.init()
    }
    /**
     Reconfigures the dataSource with new data.
     
     - parameter array: flat array.
     - parameter updates: diff of the new data.
     - parameter causedByUserInteraction: flag if the changes are caused by a user
    */
    open func reconfigureData(_ array: Array<Object>, updates: Array<DataProviderUpdate<Object>>? = nil, causedByUserInteraction: Bool = false) {
        reconfigureData([array], updates: updates, causedByUserInteraction: causedByUserInteraction)
    }
    
    /**
     Reconfigures the dataSource with new data.
     
     - parameter array: 2D array.
     - parameter updates: diff of the new data.
     - parameter causedByUserInteraction: flag if the changes are caused by a user.
     */
    open func reconfigureData(_ array: Array<Array<Object>>, updates: Array<DataProviderUpdate<Object>>? = nil, causedByUserInteraction: Bool = false) {
        self.data = array
        if !causedByUserInteraction {
           dataProviderDidUpdate?(updates)
        }
    }
    
}
