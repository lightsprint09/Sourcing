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
    var train: CDTrain!
    var fetchedResultsController: NSFetchedResultsController<CDTrain>!
    var dataProvider: FetchedResultsDataProvider<CDTrain>!
    
    override func setUp() {
        managedObjectContext = managedObjectContextForTesting()
        
        train = NSEntityDescription.insertNewObject(forEntityName: "CDTrain", into: managedObjectContext) as! CDTrain
        train.id = "1"
        train.name = "ICE"
        managedObjectContext.insert(train)
        
        let fetchReuqest = NSFetchRequest<CDTrain>(entityName: "CDTrain")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController, dataProviderDidUpdate: { _ in })
    }
    
    func testNumberOfSections() {
        //Then
        XCTAssertEqual(dataProvider.numberOfSections(), 1)
    }

    func testNumberOfItems() {
        //Then
        XCTAssertEqual(dataProvider.numberOfItems(inSection: 0), 1)
    }

    func testObjectAtIndexPath() {
        //Then
        let indexPath = IndexPath(item: 0, section: 0)
        XCTAssertEqual(dataProvider.object(at: indexPath), train)
    }

    func testIndexPathForObject() {
        //Then
        let indexPath = IndexPath(item: 0, section: 0)
        XCTAssertEqual(dataProvider.indexPath(for: train), indexPath)
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
}
