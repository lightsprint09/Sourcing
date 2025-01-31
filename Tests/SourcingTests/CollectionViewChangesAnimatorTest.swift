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
final class CollectionViewChangesAnimatorTest: XCTestCase {

    func testInitDeinit() {
        //Given
        let observable = DataProviderObservableMock()
        let collectionViewMock = UICollectionViewMock()
        var collectionViewChangesAnimator: CollectionViewChangesAnimator? = CollectionViewChangesAnimator(collectionView: collectionViewMock, observable: observable)

        XCTAssertNotNil(observable.observer)
        
        //When
       collectionViewChangesAnimator = nil
        
        //Then
        XCTAssertNil(observable.observer)
    }
    
    func testProcessUnknownReload() {
        //When
        let observable = DataProviderObservableMock()
        let collectionViewMock = UICollectionViewMock()
        let collectionViewChangesAnimator = CollectionViewChangesAnimator(collectionView: collectionViewMock, observable: observable)
        observable.send(updates: .unknown)

        //Then
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 0)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 0)
        XCTAssertEqual(collectionViewMock.executionCount.reloaded, 1)
    }
    
    func testProcessUpdatesInsert() {
        //Given
        let observable = DataProviderObservableMock()
        let collectionViewMock = UICollectionViewMock()
        let collectionViewChangesAnimator = CollectionViewChangesAnimator(collectionView: collectionViewMock, observable: observable)
        let insertionIndexPath = IndexPath(row: 0, section: 0)
        let insertion = DataProviderChange.Change.insert(insertionIndexPath)

        //When
         observable.send(updates: .changes([insertion]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedIndexPaths.inserted, [insertionIndexPath])
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesDelete() {
        //Given
        let observable = DataProviderObservableMock()
        let collectionViewMock = UICollectionViewMock()
        let collectionViewChangesAnimator = CollectionViewChangesAnimator(collectionView: collectionViewMock, observable: observable)
        let deletetionIndexPath = IndexPath(row: 0, section: 0)
        let deletion = DataProviderChange.Change.delete(deletetionIndexPath)
        
        //When
         observable.send(updates: .changes([deletion]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedIndexPaths.deleted, [deletetionIndexPath])
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesMove() {
        //Given
        let observable = DataProviderObservableMock()
        let collectionViewMock = UICollectionViewMock()
        let collectionViewChangesAnimator = CollectionViewChangesAnimator(collectionView: collectionViewMock, observable: observable)
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 0, section: 0)
        let move = DataProviderChange.Change.move(oldIndexPath, newIndexPath)
        
        //When
         observable.send(updates: .changes([move]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedIndexPaths.moved?.from, oldIndexPath)
        XCTAssertEqual(collectionViewMock.modifiedIndexPaths.moved?.to, newIndexPath)
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesUpdate() {
        //Given
        let observable = DataProviderObservableMock()
        let collectionViewMock = UICollectionViewMock()
        let collectionViewChangesAnimator = CollectionViewChangesAnimator(collectionView: collectionViewMock, observable: observable)
        let indexPath = IndexPath(row: 0, section: 0)
        let update = DataProviderChange.Change.update(indexPath)
        
        //When
         observable.send(updates: .changes([update]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedIndexPaths.reloaded, [indexPath])
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesInsertSection() {
        //Given
        let observable = DataProviderObservableMock()
        let collectionViewMock = UICollectionViewMock()
        let collectionViewChangesAnimator = CollectionViewChangesAnimator(collectionView: collectionViewMock, observable: observable)
        let insertion = DataProviderChange.Change.insertSection(0)
        
        //When
         observable.send(updates: .changes([insertion]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedSections.inserted, IndexSet([0]))
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesDeleteSection() {
        //Given
        let observable = DataProviderObservableMock()
        let collectionViewMock = UICollectionViewMock()
        let collectionViewChangesAnimator = CollectionViewChangesAnimator(collectionView: collectionViewMock, observable: observable)
        let deleteSection = DataProviderChange.Change.deleteSection(0)
        
        //When
         observable.send(updates: .changes([deleteSection]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedSections.deleted, IndexSet([0]))
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesUpdateSection() {
        //Given
        let observable = DataProviderObservableMock()
        let collectionViewMock = UICollectionViewMock()
        let collectionViewChangesAnimator = CollectionViewChangesAnimator(collectionView: collectionViewMock, observable: observable)
        let deleteSection = DataProviderChange.Change.updateSection(0)
        
        //When
         observable.send(updates: .changes([deleteSection]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedSections.updated, IndexSet([0]))
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesMoveSection() {
        //Given
        let observable = DataProviderObservableMock()
        let collectionViewMock = UICollectionViewMock()
        let collectionViewChangesAnimator = CollectionViewChangesAnimator(collectionView: collectionViewMock, observable: observable)
        let moveSection = DataProviderChange.Change.moveSection(0, 1)
        
        //When
         observable.send(updates: .changes([moveSection]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedSections.moved?.from, 0)
        XCTAssertEqual(collectionViewMock.modifiedSections.moved?.to, 1)
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesFromDataSource() {
        //Given
        let observable = DataProviderObservableMock()
        let collectionViewMock = UICollectionViewMock()
        let collectionViewChangesAnimator = CollectionViewChangesAnimator(collectionView: collectionViewMock, observable: observable)
        let insertSection = DataProviderChange.Change.insertSection(0)
        
        //When
         observable.send(updates: .changes([insertSection]))
        
        //Then
        XCTAssertEqual(collectionViewMock.modifiedSections.inserted?.count, 1)
        XCTAssertEqual(collectionViewMock.modifiedSections.inserted?.first, 0)
        XCTAssertEqual(collectionViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(collectionViewMock.executionCount.reloaded, 0)
    }
    
}
