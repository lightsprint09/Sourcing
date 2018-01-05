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

import Foundation
import CoreData
import UIKit
import Sourcing

class CDTrainCell: UITableViewCell, ConfigurableCell, ReuseIdentifierProviding {
    func configure(with trainName: CDTrain) {
        textLabel?.text = trainName.name
    }
}

func managedObjectContextForTesting() -> NSManagedObjectContext {
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    let model = NSManagedObjectModel.mergedModel(from: Bundle.allBundles)
    context.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
    try! context.persistentStoreCoordinator?.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    
    return context
}



class FetchedResultsTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var train1: CDTrain!
    var train2: CDTrain!
    var fetchedResultsController: NSFetchedResultsController<CDTrain>!
    var dataProvider: FetchedResultsDataProvider<CDTrain>!
    var dataModificator: CoreDataModificator<CDTrain>!
    var dataSource: TableViewDataSource<CDTrain>!
    var dataSourceChangeAnimator: TableViewChangesAnimator!
    
    private func train(id: String, name: String, sortIndex: Int) -> CDTrain {
        let train = CDTrain.newObject(in: managedObjectContext)
        train.id = id
        train.name = name
        train.sortIndex = NSNumber(value: sortIndex)
        return train
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = managedObjectContextForTesting()
        
        train1 = self.train(id: "1", name: "TVG", sortIndex: 0)
        managedObjectContext.insert(train1)
        
        train2 = self.train(id: "2", name: "ICE", sortIndex: 1)
        managedObjectContext.insert(train2)
        managedObjectContext.insert(self.train(id: "3", name: "IC", sortIndex: 2))
        
        let fetchReuqest: NSFetchRequest<CDTrain> = CDTrain.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CDTrain.sortIndex), ascending: false)
        fetchReuqest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest, managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        dataProvider = try! FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
        dataModificator = CoreDataModificator(dataProvider: dataProvider, move: { source, destination in
            source.0.sortIndex = NSNumber(value: destination.1.row)
            destination.0.sortIndex = NSNumber(value: source.1.row)
            try! self.managedObjectContext.save()
        })
        
        let cellConfig = CellConfiguration<CDTrainCell>()
        dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: cellConfig, dataModificator: dataModificator)
        tableView.dataSource = dataSource
        tableView.setEditing(true, animated: true)
        
        dataSourceChangeAnimator = TableViewChangesAnimator(tableView: tableView, dataProviderObservable: dataProvider.observable)
        
    }
    
}
