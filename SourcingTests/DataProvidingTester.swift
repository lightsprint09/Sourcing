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
//  DataProvidingTester.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 08.08.16.
//
import Foundation
import XCTest
import Sourcing

struct DataProviderExpection<Object: Equatable> {
    let rowsAtSection: (numberOfItems: Int, atSection: Int)
    let sections: Int
    let objectIndexPath: (object: Object, atIndexPath: NSIndexPath)
    let notContainingObject: Object
}

class DataProvidingTester<Provider: DataProviding where Provider.Object: Equatable>{
    let dataProvider: Provider
    let providerConfiguration: DataProviderExpection<Provider.Object>
    
    init(dataProvider: Provider, providerConfiguration: DataProviderExpection<Provider.Object>) {
        self.dataProvider = dataProvider
        self.providerConfiguration = providerConfiguration
    }
    
    func test() {
        XCTAssertEqual(dataProvider.numberOfSections(), providerConfiguration.sections)
        XCTAssertEqual(dataProvider.numberOfItemsInSection(providerConfiguration.rowsAtSection.atSection), providerConfiguration.rowsAtSection.numberOfItems)
        XCTAssertEqual(dataProvider.objectAtIndexPath(providerConfiguration.objectIndexPath.atIndexPath), providerConfiguration.objectIndexPath.object)
        XCTAssertEqual(dataProvider.indexPathForObject(providerConfiguration.objectIndexPath.object), providerConfiguration.objectIndexPath.atIndexPath)
        
        XCTAssertEqual(dataProvider.indexPathForObject(providerConfiguration.notContainingObject), nil)
    }
}