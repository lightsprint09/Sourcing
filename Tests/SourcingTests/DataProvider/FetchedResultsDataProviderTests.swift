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

// swiftlint:disable force_try force_unwrapping
@MainActor
class FetchedResultsDataProviderTests: XCTestCase {
    func managedObjectContextForTesting() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        let model = NSManagedObjectModel.mergedModel(from: Bundle.allBundles + [.module])
        context.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        try! context.persistentStoreCoordinator?.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        return context
    }
    
    private func train(id: String, name: String, sortIndex: Int, inContext context: NSManagedObjectContext) -> CDTrain {
        let train = CDTrain.newObject(in: context)
        train.id = id
        train.name = name
        train.sortIndex = NSNumber(value: sortIndex)
        return train
    }
    
    func testNumberOfSections() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Then
        XCTAssertEqual(dataProvider.numberOfSections(), 1)
    }

    func testNumberOfItems() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Then
        XCTAssertEqual(dataProvider.numberOfItems(inSection: 0), 2)
    }

    func testObjectAtIndexPath() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Then
        var indexPath = IndexPath(item: 0, section: 0)
        XCTAssertEqual(dataProvider.object(at: indexPath), train1)
        
        indexPath = IndexPath(item: 1, section: 0)
        XCTAssertEqual(dataProvider.object(at: indexPath), train2)
    }

    func testIndexPathForObject() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Then
        var indexPath = IndexPath(item: 0, section: 0)
        XCTAssertEqual(dataProvider.indexPath(for: train1), indexPath)
        
        indexPath = IndexPath(item: 1, section: 0)
        XCTAssertEqual(dataProvider.indexPath(for: train2), indexPath)
    }
    
    func testReconfigureFetchRequest() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
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
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Given
        let indexPath = IndexPath(row: 0, section: 0)
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, didChange: 1, at: nil, for: .insert, newIndexPath: indexPath)
        dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)

        //Then
        XCTAssertEqual(catpturedChange, .changes([.insert(indexPath)]))
    }
    
    func testHandleUpdate() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Given
        let indexPath = IndexPath(row: 0, section: 0)
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, didChange: 1, at: indexPath, for: .update, newIndexPath: nil)
        dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)

        //Then
        XCTAssertEqual(catpturedChange, .changes([.update(indexPath)]))
    }
    
    func testHandleInsertSection() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Given
        let section = 0
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, didChange: NSFetchedResultsSectionInfoMock(), atSectionIndex: section, for: .insert)
        dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)

        //Then
        XCTAssertEqual(catpturedChange, .changes([.insertSection(section)]))
    }
    
    func testHandleDeleteSection() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Given
        let section = 0
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, didChange: NSFetchedResultsSectionInfoMock(), atSectionIndex: section, for: .delete)
        dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)

        //Then
        XCTAssertEqual(catpturedChange, .changes([.deleteSection(section)]))
    }
    
    func testHandleMoveByUser() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Given
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 1, section: 0)
        var capturedChanges = [DataProviderChange]()
        _ = dataProvider.observable.addObserver { capturedChanges.append($0) }
        
        //When
        dataProvider.performNonUIRelevantChanges {
            dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, didChange: 1, at: oldIndexPath, for: .move, newIndexPath: newIndexPath)
            dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        }
        
        //Then
        XCTAssertEqual(capturedChanges, [.viewUnrelatedChanges([.move(oldIndexPath, newIndexPath)]), .viewUnrelatedChanges([.update(newIndexPath)])])
    }
    
    func testProcessUpdatesForMoveChange() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Given
        var changes = [DataProviderChange]()
        
        _ = dataProvider.observable.addObserver { changes.append($0) }
        
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 1, section: 0)
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, didChange: 1, at: oldIndexPath, for: .move, newIndexPath: newIndexPath)

        //When
        dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)

        //Then
        XCTAssertEqual(changes, [.changes([.move(oldIndexPath, newIndexPath)]), .changes([.update(newIndexPath)])])
    }
    
    func testProcessUpdatesForUpdateChange() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Given
        var catpturedChange: DataProviderChange?
        
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        let indexPath = IndexPath(row: 1, section: 0)
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, didChange: 1, at: indexPath, for: .update, newIndexPath: indexPath)

        //When
        dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)

        //Then
        XCTAssertEqual(catpturedChange, .changes([.update(indexPath)]))
    }
    
    func testMultipleUpdates() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Given
        let firstUpdate = IndexPath(row: 0, section: 0)
        let secondDelete = IndexPath(row: 1, section: 0)
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, didChange: 1, at: firstUpdate, for: .update, newIndexPath: nil)
        dataProvider.controllerWillChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)

        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, didChange: 1, at: secondDelete, for: .delete, newIndexPath: nil)
        dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)

        //Then
        XCTAssertEqual(catpturedChange, .changes([.delete(secondDelete)]))
    }

    func testHandleDelete() {
        let managedObjectContext = managedObjectContextForTesting()

        let train1 = self.train(id: "1", name: "TVG", sortIndex: 0, inContext: managedObjectContext)
        managedObjectContext.insert(train1)

        let train2 = self.train(id: "2", name: "ICE", sortIndex: 1, inContext: managedObjectContext)
        managedObjectContext.insert(train2)

        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        //Given
        let deletedIndexPath = IndexPath(row: 0, section: 0)
        var catpturedChange: DataProviderChange?
        _ = dataProvider.observable.addObserver { catpturedChange = $0 }
        
        //When
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, didChange: 1, at: deletedIndexPath, for: .delete, newIndexPath: nil)
        dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)

        //Then
        XCTAssertEqual(catpturedChange, .changes([.delete(deletedIndexPath)]))
    }
}
