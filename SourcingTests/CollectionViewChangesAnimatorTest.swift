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

final class CollectionViewChangesAnimatorTest: XCTestCase {
    
    var collectionViewMock: UICollectionViewMock!
    var collectionViewChangesAnimator: CollectionViewChangesAnimator!
    var observable = DataProviderObservableMock()
    
    override func setUp() {
        super.setUp()
        collectionViewMock = UICollectionViewMock()
        collectionViewChangesAnimator = CollectionViewChangesAnimator(collectionView: collectionViewMock, dataProvider: observable)
    }
    
    func testProcessUpdatesInsert() {
        //Given
        let insertionIndexPath = IndexPath(row: 0, section: 0)
        let insertion = DataProviderChange.Change.insert(insertionIndexPath)

        //When
        observable.observer?(.changes([insertion]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedIndexPaths.inserted?.count, 1)
        XCTAssertEqual(collectionViewMock.modifiedIndexPaths.inserted?.first, insertionIndexPath)
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
    }
    
    func testProcessUpdatesDelete() {
        //Given
        let deletetionIndexPath = IndexPath(row: 0, section: 0)
        let deletion = DataProviderChange.Change.delete(deletetionIndexPath)
        
        //When
        observable.observer?(.changes([deletion]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedIndexPaths.deleted?.count, 1)
        XCTAssertEqual(collectionViewMock.modifiedIndexPaths.deleted?.first, deletetionIndexPath)
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
    }
    
    func testProcessUpdatesMove() {
        //Given
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 0, section: 0)
        let move = DataProviderChange.Change.move(oldIndexPath, newIndexPath)
        
        //When
        observable.observer?(.changes([move]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedIndexPaths.moved?.from, oldIndexPath)
        XCTAssertEqual(collectionViewMock.modifiedIndexPaths.moved?.to, newIndexPath)
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
    }
    
    func testProcessUpdatesUpdate() {
        //Given
        let indexPath = IndexPath(row: 0, section: 0)
        let update = DataProviderChange.Change.update(indexPath)
        
        //When
        observable.observer?(.changes([update]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedIndexPaths.reloaded?.first, indexPath)
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
    }
    
    func testProcessUpdatesInsertSection() {
        //Given
        let insertion = DataProviderChange.Change.insertSection(0)
        
        //When
        observable.observer?(.changes([insertion]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedSections.inserted?.count, 1)
        XCTAssertEqual(collectionViewMock.modifiedSections.inserted?.first, 0)
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
    }
    
    func testProcessUpdatesDeleteSection() {
        //Given
        let deleteSection = DataProviderChange.Change.deleteSection(0)
        
        //When
        observable.observer?(.changes([deleteSection]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedSections.deleted?.count, 1)
        XCTAssertEqual(collectionViewMock.modifiedSections.deleted?.first, 0)
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
    }
    
    func testProcessUpdatesMoveSection() {
        //Given
        let moveSection = DataProviderChange.Change.moveSection(0, 1)
        
        //When
        observable.observer?(.changes([moveSection]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedSections.moved?.from, 0)
        XCTAssertEqual(collectionViewMock.modifiedSections.moved?.to, 1)
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
    }
    
    func testProcessUpdatesFromDataSource() {
        //Given
        let insertSection = DataProviderChange.Change.insertSection(0)
        
        //When
        observable.observer?(.changes([insertSection]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedSections.inserted?.count, 1)
        XCTAssertEqual(collectionViewMock.modifiedSections.inserted?.first, 0)
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
    }
}
