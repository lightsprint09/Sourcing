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
//  Sourcing
//
//  Created by Lukas Schmidt on 10.08.16.
//

import XCTest
import CoreData
@testable import Sourcing

// swiftlint:disable force_cast force_try force_unwrapping xctfail_message
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
    var fetchedResultsController: NSFetchedResultsController<CDTrain>!
    var dataProvider: FetchedResultsDataProvider<CDTrain>!
    
    override func setUp() {
        managedObjectContext = managedObjectContextForTesting()
        
        train1 = self.train(id: "1", name: "ICE")
        managedObjectContext.insert(train1)
        
        train2 = self.train(id: "2", name: "ICE")
        managedObjectContext.insert(train2)
        
        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.id), ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: #keyPath(CDTrain.name), cacheName: nil)
        dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController, dataProviderDidUpdate: { _ in })
    }
    
    private func train(id: String, name: String) -> CDTrain {
        let train = CDTrain.newObject(in: managedObjectContext)
        train.id = id
        train.name = name
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
        var didUpdate = false
        dataProvider.whenDataProviderChanged = { updates in
            didUpdate = updates == nil
        }
        try? dataProvider.reconfigure(with: { _ in
            
        })
        
        XCTAssert(didUpdate)
    }
    
    func testHandleInsert() {
        //Given
        let indexPath = IndexPath(row: 0, section: 0)
        
        //When
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>,
                                didChange: 1, at: nil, for: .insert, newIndexPath: indexPath)
        
        //Then
        XCTAssertEqual(dataProvider.updates.count, 1)
        if case .insert(let updatedIndexPath) = dataProvider.updates.first! {
            XCTAssertEqual(indexPath, updatedIndexPath)
        } else {
            XCTFail()
        }
    }
    
    func testHandleUpdate() {
        //Given
        let indexPath = IndexPath(row: 0, section: 0)
        
        //When
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>,
                                didChange: 1, at: indexPath, for: .update, newIndexPath: nil)
        
        //Then
        XCTAssertEqual(dataProvider.updates.count, 1)
        if case .update(let updatedIndexPath, _) = dataProvider.updates.first! {
            XCTAssertEqual(indexPath, updatedIndexPath)
        } else {
            XCTFail()
        }
    }
    
    func testHandleInsertSection() {
        //Given
        let section = 0
        
        //When
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>,
                                didChange: NSFetchedResultsSectionInfoMock(), atSectionIndex: section, for: .insert)
        
        //Then
        XCTAssertEqual(dataProvider.updates.count, 1)
        if case .insertSection(let updatedSection) = dataProvider.updates.first! {
            XCTAssertEqual(section, updatedSection)
        } else {
            XCTFail()
        }
    }
    
    func testHandleDeleteSection() {
        //Given
        let section = 0
        
        //When
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>,
                                didChange: NSFetchedResultsSectionInfoMock(), atSectionIndex: section, for: .delete)
        
        //Then
        XCTAssertEqual(dataProvider.updates.count, 1)
        if case .deleteSection(let updatedSection) = dataProvider.updates.first! {
            XCTAssertEqual(section, updatedSection)
        } else {
            XCTFail()
        }
    }
    
    func testHandleMove() {
        //Given
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 1, section: 0)
        
        //When
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>,
                                didChange: 1, at: oldIndexPath, for: .move, newIndexPath: newIndexPath)
        
        //Then
        XCTAssertEqual(dataProvider.updates.count, 1)
        if case .move(let updatedIndexPath, let newMovedIndexPath) = dataProvider.updates.first! {
            XCTAssertEqual(oldIndexPath, updatedIndexPath)
            XCTAssertEqual(newIndexPath, newMovedIndexPath)
        } else {
            XCTFail()
        }
    }
    
    func testProcessUpdates() {
        //Given
        var didUpdateNotification = false
        var didUpdateDataSource = false
        dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController,
                                                       dataProviderDidUpdate: { _ in
                                                        didUpdateNotification = true
        })
        dataProvider.whenDataProviderChanged = { _ in didUpdateDataSource = true }
        
        //When
        dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        
        //Then
        XCTAssert(didUpdateNotification)
        XCTAssert(didUpdateDataSource)
    }
    
    func testProcessUpdatesForMoveChange() {
        //Given
        var updateIndexPath = IndexPath()
        var moveIndexPaths = [IndexPath]()
        
        dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController, dataProviderDidUpdate: { _ in })
        dataProvider.whenDataProviderChanged = { updates in
            guard let updates = updates, !updates.isEmpty else {
                return
            }
            
            for update in updates {
                switch update {
                case .update(let indexPath, _):
                    updateIndexPath = indexPath
                case .move(let indexPath, let newIndexPath):
                    moveIndexPaths = [indexPath, newIndexPath]
                default: break
                }
            }
        }
        
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 1, section: 0)
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>,
                                didChange: 1, at: oldIndexPath, for: .move, newIndexPath: newIndexPath)
        
        //When
        dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        
        //Then
        XCTAssertEqual(updateIndexPath, newIndexPath)
        XCTAssertEqual(moveIndexPaths, [oldIndexPath, newIndexPath])
    }
    
    func testProcessUpdatesOrderForMoveChange() {
        var updatesNumber = 0
        var isFirstMoveCall = false
        var isSecondUpdateCall = false
        
        dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController, dataProviderDidUpdate: { _ in })
        dataProvider.whenDataProviderChanged = { updates in
            guard let updates = updates, !updates.isEmpty else {
                return
            }
            
            updatesNumber += 1
            
            if case .move(_, _) = updates.first! {
                isFirstMoveCall = true
            }
            
            if case .update(_, _) = updates.first! {
                if isFirstMoveCall {
                    isSecondUpdateCall = true
                }
            }
            
        }
        
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 1, section: 0)
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>,
                                didChange: 1, at: oldIndexPath, for: .move, newIndexPath: newIndexPath)
        
        //When
        dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        
        //Then
        XCTAssertEqual(updatesNumber, 2)
        XCTAssert(isFirstMoveCall)
        XCTAssert(isSecondUpdateCall)
    }
    
    func testProcessUpdatesForUpdateChange() {
        //Given
        var updateIndexPath = IndexPath()
        
        dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController, dataProviderDidUpdate: { _ in })
        dataProvider.whenDataProviderChanged = { updates in
            guard let updates = updates, !updates.isEmpty else {
                return
            }
            
            if case .update(let indexPath, _) = updates.first! {
                updateIndexPath = indexPath
            }
        }
        
        let indexPath = IndexPath(row: 1, section: 0)
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>,
                                didChange: 1, at: indexPath, for: .update, newIndexPath: indexPath)
        
        //When
        dataProvider.controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        
        //Then
        XCTAssertEqual(updateIndexPath, indexPath)
    }
    
    func testWillChangeContent() {
        //Given
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 1, section: 0)
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>,
                                didChange: 1, at: oldIndexPath, for: .move, newIndexPath: newIndexPath)
        XCTAssert(!dataProvider.updates.isEmpty)
        
        //When
        dataProvider.controllerWillChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        
        //Then
         XCTAssert(dataProvider.updates.isEmpty)
       
    }

    func testHandleDelete() {
        //Given
        let deletedIndexPath = IndexPath(row: 0, section: 0)
        
        //When
        dataProvider.controller(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>,
                                didChange: 1, at: deletedIndexPath, for: .delete, newIndexPath: nil)
        
        //Then
        XCTAssertEqual(dataProvider.updates.count, 1)
        if case .delete(let updatedIndexPath) = dataProvider.updates.first! {
            XCTAssertEqual(deletedIndexPath, updatedIndexPath)
        } else {
            XCTFail()
        }
    }
    
    func testSectionIndexTitles() {
        
        //When
        let sectionIndex = dataProvider.sectionIndexTitles
        
        //Then
        XCTAssertEqual(sectionIndex!, ["I"])
    }
}
