//
//  Copyright (C) DB Systel GmbH.
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

import XCTest
import Sourcing

@MainActor
class JoinedDataProviderTest: XCTestCase {
    
    func testNumberOfSection() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        
        // When
        let numberOfSections = aggregator.numberOfSections()
        
        // Then
        XCTAssertEqual(numberOfSections, 4)
    }
    
    func testNumberOfElementsInSection() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        
        // When
        
        let numberOfElementInSections = (0..<aggregator.numberOfSections()).map { aggregator.numberOfItems(inSection: $0) }
        
        // Then
        XCTAssertEqual(numberOfElementInSections, [2, 3, 4, 4])
    }
    
    func testObjectAtIndexPath() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        
        // When
        let indexPath = IndexPath(row: 3, section: 2)
        let objectAtIndexPath = aggregator.object(at: indexPath)
        
        // Then
        XCTAssertEqual(objectAtIndexPath, 6)
    }
    
    func testObjectAtIndexPathAll() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        
        // When
        let indexPaths = (0..<aggregator.numberOfSections()).map { section in
            return (0..<aggregator.numberOfItems(inSection: section)).map { rowIndex in
                return IndexPath(row: rowIndex, section: section)
            }
        }
        let objects = indexPaths.map { $0.map { aggregator.object(at: $0) } }
        
        // Then
        XCTAssertEqual(objects, [[1, 2], [3, 4, 5], [1, 2, 5, 6], [3, 4, 7, 8]])
    }
    
    func testObserveChangesInsert() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        var changes: DataProviderChange?
        
        // When
        aggregator.observable.addObserver(observer: { changes = $0 })
        providerTwo.reconfigure(with: [[1, 2, 5, 6, 12], [3, 4, 7, 8]], change: .changes([.insert(IndexPath(row: 3, section: 0))]))
        
        // Then
        XCTAssertEqual(changes, .changes([.insert(IndexPath(row: 3, section: 2))]))
    }
    
    func testObserveChangesUpdate() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        var changes: DataProviderChange?
        
        // When
        aggregator.observable.addObserver(observer: { changes = $0 })
        providerTwo.reconfigure(with: [[1, 2, 5, 12], [3, 4, 7, 8]], change: .changes([.update(IndexPath(row: 3, section: 0))]))
        
        // Then
        XCTAssertEqual(changes, .changes([.update(IndexPath(row: 3, section: 2))]))
    }
    
    func testObserveChangesMove() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        var changes: DataProviderChange?
        
        // When
        aggregator.observable.addObserver(observer: { changes = $0 })
        providerTwo.reconfigure(with: [[1, 2, 5, 6], [3, 4, 7, 8]],
                                change: .changes([.move(IndexPath(row: 0, section: 0), IndexPath(row: 3, section: 0))]))
        
        // Then
        XCTAssertEqual(changes, .changes([.move(IndexPath(row: 0, section: 2), IndexPath(row: 3, section: 2))]))
    }
    
    func testObserveChangesDelete() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        var changes: DataProviderChange?
        
        // When
        aggregator.observable.addObserver(observer: { changes = $0 })
        providerTwo.reconfigure(with: [[1, 2, 5], [3, 4, 7, 8]],
                                change: .changes([.delete(IndexPath(row: 3, section: 0))]))
        
        // Then
        XCTAssertEqual(changes, .changes([.delete(IndexPath(row: 3, section: 2))]))
    }
    
    func testObserveChangesInsertSection() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        var changes: DataProviderChange?
        
        // When
        aggregator.observable.addObserver(observer: { changes = $0 })
        providerTwo.reconfigure(with: [[1, 2, 5], [3, 4, 7, 8], [0]], change: .changes([.insertSection(1)]))
        
        // Then
        XCTAssertEqual(changes, .changes([.insertSection(3)]))
    }
    
    func testObserveChangesUpdateSection() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        var changes: DataProviderChange?
        
        // When
        aggregator.observable.addObserver(observer: { changes = $0 })
        providerTwo.reconfigure(with: [[1, 2, 5], [3, 4, 7, 75]], change: .changes([.updateSection(1)]))
        
        // Then
        XCTAssertEqual(changes, .changes([.updateSection(3)]))
    }
    
    func testObserveChangesDeleteSection() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        var changes: DataProviderChange?
        
        // When
        aggregator.observable.addObserver(observer: { changes = $0 })
        providerTwo.reconfigure(with: [[1, 2, 5]], change: .changes([.deleteSection(1)]))
        
        // Then
        XCTAssertEqual(changes, .changes([.deleteSection(3)]))
    }
    
    func testObserveChangesMoveSection() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        var changes: DataProviderChange?
        
        // When
        aggregator.observable.addObserver(observer: { changes = $0 })
        providerTwo.reconfigure(with: [[1, 2, 5], [3, 4, 7, 75]], change: .changes([.moveSection(0, 1)]))
        
        // Then
        XCTAssertEqual(changes, .changes([.moveSection(2, 3)]))
    }
    
    func testObserveChangesUnknown() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        var changes: DataProviderChange?
        
        // When
        aggregator.observable.addObserver(observer: { changes = $0 })
        providerTwo.reconfigure(with: [[1, 2, 5], [3, 4, 7, 75]], change: .unknown)
        
        // Then
        XCTAssertEqual(changes, .unknown)
    }
    
    func testObserveViewUnrelatedChangesMove() {
        // Given
        let providerOne = ArrayDataProvider(sections: [[1, 2], [3, 4, 5]])
        let providerTwo = ArrayDataProvider(sections: [[1, 2, 5, 6], [3, 4, 7, 8]])
        let aggregator = JoinedDataProvider(dataProviders: [providerOne, providerTwo])
        var changes: DataProviderChange?

        // When
        aggregator.observable.addObserver(observer: { changes = $0 })
        providerTwo.reconfigure(with: [[1, 2, 5, 6], [3, 4, 7, 8]],
                                change: .viewUnrelatedChanges([.move(IndexPath(row: 0, section: 0), IndexPath(row: 3, section: 0))]))
        
        // Then
        XCTAssertEqual(changes, .viewUnrelatedChanges([.move(IndexPath(row: 0, section: 2), IndexPath(row: 3, section: 2))]))
    }
    
}
