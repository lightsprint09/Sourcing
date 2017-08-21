//
//  DataProviderTest.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.01.17.
//  Copyright © 2017 Lukas Schmidt. All rights reserved.
//

import XCTest
@testable import Sourcing

class AnyDataProvidingTests: XCTestCase {
    var dataProvider: AnyDataProvider<Int>!
    
    func testNumberOfSections() {
        //Given
        dataProvider = AnyDataProvider(ArrayDataProvider(sections: [[1, 2], [3, 4]]))
        
        //When
        let numberOfSections = dataProvider.numberOfSections()
        
        //Then
        XCTAssertEqual(numberOfSections, 2)
    }
    
    func testNumberOfItemsInSection() {
        //Given
        dataProvider = AnyDataProvider(ArrayDataProvider(sections: [[1, 2], [3, 4]]))
        
        //When
        let numberOfItems = dataProvider.numberOfItems(inSection: 0)
        
        //Then
        XCTAssertEqual(numberOfItems, 2)
    }
    
    func testObjectAtIndexPath() {
        //Given
        dataProvider = AnyDataProvider(ArrayDataProvider(sections: [[1, 2], [3, 4]]))
        
        //When
        let indexPath = IndexPath(item: 0, section: 0)
        let object = dataProvider.object(at: indexPath)
        
        //Then
        XCTAssertEqual(object, 1)
    }
    
    func testIndexPathForContainingObject() {
        //Given
        dataProvider = AnyDataProvider(ArrayDataProvider(sections: [[1, 2], [3, 4]]))
        
        //When
        let indexPath = dataProvider.indexPath(for: 1)
        
        //Then
        XCTAssertEqual(indexPath, IndexPath(item: 0, section: 0))
    }
    
    func testIndexPathForNotContainingObject() {
        //Given
        dataProvider = AnyDataProvider(ArrayDataProvider(sections: [[1, 2], [3, 4]]))
        
        //When
        let indexPath = dataProvider.indexPath(for: 5)
        
        //Then
        XCTAssertNil(indexPath)
    }
    
    func testCallUpdate() {
        var didUpdateDataSource = false
        //Given
        let underlyingDataProvider = ArrayDataProvider(sections: [[1, 2], [3, 4]])
        dataProvider = AnyDataProvider(underlyingDataProvider)
        dataProvider.whenDataProviderChanged = { _ in
            didUpdateDataSource = true
        }
        //When
        underlyingDataProvider.reconfigure(with: [8, 9, 10])
        
        //Then
        XCTAssertTrue(didUpdateDataSource)
    }

}
