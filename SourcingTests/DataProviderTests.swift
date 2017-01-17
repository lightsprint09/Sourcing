//
//  DataProviderTest.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.01.17.
//  Copyright © 2017 Lukas Schmidt. All rights reserved.
//

import XCTest
@testable import Sourcing

class DataProvidingTests {
    func testTypeEaresedDataProvider() {
        //Given
        let dataProvider = ArrayDataProvider(sections: [[1, 2], [3, 4]])
        
        //Then
        let indexPath = IndexPath(row: 1, section: 1)
        let dataExpection = DataProviderExpection(rowsAtSection: (numberOfItems: 2, atSection: 1), sections: 2,
                                                  objectIndexPath: (object: 4, atIndexPath: indexPath), notContainingObject: 100)
        let dataProviderTest = DataProvidingTester(dataProvider: dataProvider, providerConfiguration: dataExpection)
        dataProviderTest.validate()
        
        let typeEarsedDataProviderTest = DataProvidingTester(dataProvider: AnyDataProvider(dataProvider: dataProvider), providerConfiguration: dataExpection)
        typeEarsedDataProviderTest.validate()
    }
}
