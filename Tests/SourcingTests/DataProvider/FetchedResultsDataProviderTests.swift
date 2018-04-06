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

import XCTest
import CoreData
@testable import Sourcing

// swiftlint:disable force_cast force_try force_unwrapping
class FetchedResultsDataProviderTests: XCTestCase {
    func managedObjectContextForTesting() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        let model = NSManagedObjectModel.mergedModel(from: Bundle.allBundles)
        context.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        try! context.persistentStoreCoordinator?.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        return context
    }
    
    var managedObjectContext: NSManagedObjectContext!
    var train1: CDTrain!
    var train2: CDTrain!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var typedFetchedResultsController: NSFetchedResultsController<CDTrain>!
    var dataProvider: FetchedResultsDataProvider<CDTrain>!
    
    override func setUp() {
        super.setUp()
        managedObjectContext = managedObjectContextForTesting()
        
        train1 = self.train(id: "1", name: "TVG", sortIndex: 0)
        managedObjectContext.insert(train1)
        
        train2 = self.train(id: "2", name: "ICE", sortIndex: 1)
        managedObjectContext.insert(train2)
        
        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        typedFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: typedFetchedResultsController)
        
        self.fetchedResultsController = typedFetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>
    }
    
    private func train(id: String, name: String, sortIndex: Int) -> CDTrain {
        let train = CDTrain.newObject(in: managedObjectContext)
        train.id = id
        train.name = name
        train.sortIndex = NSNumber(value: sortIndex)
        return train
    }
    
    func testNumberOfSections() {
        //Then
        XCTAssertEqual(dataProvider.numberOfSections(), 1)
    }

    func testNumberOfItems() {
        //Then
        XCTAssertEqual(dataProvider.numberOfItems(inSection: 0), 2)
    }

    func testObjectAtIndexPath() {
        //Then
        var indexPath = IndexPath(item: 0, section: 0)
        XCTAssertEqual(dataProvider.object(at: indexPath), train1)
        
        indexPath = IndexPath(item: 1, section: 0)
        XCTAssertEqual(dataProvider.object(at: indexPath), train2)
    }

    func testIndexPathForObject() {
        //Then
        var indexPath = IndexPath(item: 0, section: 0)
        XCTAssertEqual(dataProvider.indexPath(for: train1), indexPath)
        
        indexPath = IndexPath(item: 1, section: 0)
        XCTAssertEqual(dataProvider.indexPath(for: train2), indexPath)
    }
    
    func testReconfigureFetchRequest() {
        //Given
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        try? dataProvider.reconfigure(with: { _ in
            
        })
        
        //Then
        XCTAssertEqual(catpturedChange, .unknown)
    }
    
    func testHandleInsert() {
        //Given
        let indexPath = IndexPath(row: 0, section: 0)
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        dataProvider.controller(fetchedResultsController, didChange: 1, at: nil, for: .insert, newIndexPath: indexPath)
        dataProvider.controllerDidChangeContent(fetchedResultsController)
        
        //Then
        XCTAssertEqual(catpturedChange, .changes([.insert(indexPath)]))
    }
    
    func testHandleUpdate() {
        //Given
        let indexPath = IndexPath(row: 0, section: 0)
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        dataProvider.controller(fetchedResultsController, didChange: 1, at: indexPath, for: .update, newIndexPath: nil)
        dataProvider.controllerDidChangeContent(fetchedResultsController)
        
        //Then
        XCTAssertEqual(catpturedChange, .changes([.update(indexPath)]))
    }
    
    func testHandleInsertSection() {
        //Given
        let section = 0
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        dataProvider.controller(fetchedResultsController, didChange: NSFetchedResultsSectionInfoMock(), atSectionIndex: section, for: .insert)
        dataProvider.controllerDidChangeContent(fetchedResultsController)
        
        //Then
        XCTAssertEqual(catpturedChange, .changes([.insertSection(section)]))
    }
    
    func testHandleDeleteSection() {
        //Given
        let section = 0
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        dataProvider.controller(fetchedResultsController, didChange: NSFetchedResultsSectionInfoMock(), atSectionIndex: section, for: .delete)
        dataProvider.controllerDidChangeContent(fetchedResultsController)
        
        //Then
        XCTAssertEqual(catpturedChange, .changes([.deleteSection(section)]))
    }
    
    func testHandleMoveByUser() {
        //Given
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 1, section: 0)
        var capturedChanges = [DataProviderChange]()
        _ = dataProvider.observable.addObserver { capturedChanges.append($0) }
        
        //When
        dataProvider.performNonUIRelevantChanges {
            dataProvider.controller(fetchedResultsController, didChange: 1, at: oldIndexPath, for: .move, newIndexPath: newIndexPath)
            dataProvider.controllerDidChangeContent(fetchedResultsController)
        }
        
        //Then
        XCTAssertEqual(capturedChanges, [.viewUnrelatedChanges([.move(oldIndexPath, newIndexPath)]), .viewUnrelatedChanges([.update(newIndexPath)])])
    }
    
    func testProcessUpdatesForMoveChange() {
        //Given
        var changes = [DataProviderChange]()
        
        dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: typedFetchedResultsController)
        _ = dataProvider.observable.addObserver { changes.append($0) }
        
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 1, section: 0)
        dataProvider.controller(fetchedResultsController, didChange: 1, at: oldIndexPath, for: .move, newIndexPath: newIndexPath)
        
        //When
        dataProvider.controllerDidChangeContent(fetchedResultsController)
        
        //Then
        XCTAssertEqual(changes, [.changes([.move(oldIndexPath, newIndexPath)]), .changes([.update(newIndexPath)])])
    }
    
    func testProcessUpdatesForUpdateChange() {
        //Given
        var catpturedChange: DataProviderChange?
        
        dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: typedFetchedResultsController)
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        let indexPath = IndexPath(row: 1, section: 0)
        dataProvider.controller(fetchedResultsController, didChange: 1, at: indexPath, for: .update, newIndexPath: indexPath)
        
        //When
        dataProvider.controllerDidChangeContent(fetchedResultsController)
        
        //Then
        XCTAssertEqual(catpturedChange, .changes([.update(indexPath)]))
    }
    
    func testMultipleUpdates() {
        //Given
        let firstUpdate = IndexPath(row: 0, section: 0)
        let secondDelete = IndexPath(row: 1, section: 0)
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        dataProvider.controller(fetchedResultsController, didChange: 1, at: firstUpdate, for: .update, newIndexPath: nil)
        dataProvider.controllerWillChangeContent(fetchedResultsController)

        dataProvider.controller(fetchedResultsController, didChange: 1, at: secondDelete, for: .delete, newIndexPath: nil)
        dataProvider.controllerDidChangeContent(fetchedResultsController)

        //Then
        XCTAssertEqual(catpturedChange, .changes([.delete(secondDelete)]))
    }

    func testHandleDelete() {
        //Given
        let deletedIndexPath = IndexPath(row: 0, section: 0)
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        dataProvider.controller(fetchedResultsController, didChange: 1, at: deletedIndexPath, for: .delete, newIndexPath: nil)
        dataProvider.controllerDidChangeContent(fetchedResultsController)
        
        //Then
        XCTAssertEqual(catpturedChange, .changes([.delete(deletedIndexPath)]))
    }
}
