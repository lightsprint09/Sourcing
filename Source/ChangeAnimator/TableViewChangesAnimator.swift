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

#if os(iOS) || os(tvOS) || os(visionOS)
    import UIKit

    /**
     A listener that observes changes of a data provider. It creates animations to make changes visible in the view by using
     `UITableView`s APIs to animate cells. You can configure your animations as needed for each change.
     */
    public final class TableViewChangesAnimator {
        
        private let observable: DataProviderObservable
        private let cellReconfigurationAtIndexPath: ((IndexPath) -> Void)?
        
        private var dataProviderObserver: NSObjectProtocol!
        private let tableView: UITableView
        private let configuration: Configuration
        
        public struct Configuration {
            let insert: UITableView.RowAnimation
            let update: UITableView.RowAnimation
            let move: UITableView.RowAnimation
            let delete: UITableView.RowAnimation
            let insertSection: UITableView.RowAnimation
            let updateSection: UITableView.RowAnimation
            let deleteSection: UITableView.RowAnimation
            
            public init(insert: UITableView.RowAnimation = .automatic, update: UITableView.RowAnimation = .automatic,
                        move: UITableView.RowAnimation = .automatic, delete: UITableView.RowAnimation = .automatic,
                        insertSection: UITableView.RowAnimation = .automatic, updateSection: UITableView.RowAnimation = .automatic,
                        deleteSection: UITableView.RowAnimation = .automatic) {
                self.insert = insert
                self.update = update
                self.move = move
                self.delete = delete
                self.insertSection = insertSection
                self.deleteSection = deleteSection
                self.updateSection = updateSection
            }
        }
        
        /// Creates an instance and starts listening for changes to animate them into the table view.
        ///
        /// - Parameters:
        ///   - tableView: the table view which should be animated
        ///   - observable: observable for listing to changes of a data provider
        ///   - configuration: configure animations for table view change actions.
        public convenience init(tableView: UITableView,
                                observable: DataProviderObservable,
                                configuration: Configuration = Configuration()) {
            self.init(tableView: tableView,
                      observable: observable,
                      configuration: configuration,
                      cellReconfigurationAtIndexPath: nil)
        }
        
        /// Creates an instance and starts listening for changes to animate them into the table view.
        ///
        /// - Parameters:
        ///   - tableView: the table view which should be animated
        ///   - dataProvider: data provider which should be observed for changes.
        ///   - configuration: configure animations for table view change actions.
        public convenience init<D: DataProvider>(tableView: UITableView,
                                dataProvider: D,
                                configuration: Configuration = Configuration()) {
            self.init(tableView: tableView,
                       observable: dataProvider.observable,
                       configuration: configuration)
        }
        
        /// Creates an instance and starts listening for changes to animate them into the table view.
        /// Use this initializer if you want to reconfigure cells on update instead of reload the cell.
        ///
        /// - Parameters:
        ///   - tableView: the table view which should be animated
        ///   - dataProvider: data provider for listing to changes & reconfiguring cells
        ///   - cellConfiguration: reusable view onfiguration to reconfigure views on update.
        ///   - configuration: configure animations for table view change actions.
        public convenience init<DataProvide: DataProvider, ReusableViewConfig: ReusableViewConfiguring>(tableView: UITableView,
                                                                                            dataProvider: DataProvide,
                                                                                            cellConfiguration: ReusableViewConfig,
                                                                                            configuration: Configuration = Configuration())
            where DataProvide.Element == ReusableViewConfig.Object {
                self.init(tableView: tableView,
                          observable: dataProvider.observable,
                          configuration: configuration,
                          cellReconfigurationAtIndexPath: { indexPath in
                                guard let cell = tableView.cellForRow(at: indexPath) as? ReusableViewConfig.View else {
                                    return
                                }
                                let object = dataProvider.object(at: indexPath)
                                cellConfiguration.configure(cell, at: indexPath, with: object)
                            })
        }
        
        private init(tableView: UITableView,
                     observable: DataProviderObservable,
                     configuration: Configuration,
                     cellReconfigurationAtIndexPath: ((IndexPath) -> Void)?) {
            self.tableView = tableView
            self.observable = observable
            self.configuration = configuration
            self.cellReconfigurationAtIndexPath = cellReconfigurationAtIndexPath
            dataProviderObserver = observable.addObserver(observer: { [weak self] update in
                self?.dataProviderDidChange(with: update)
            })
        }
        
        deinit {
            observable.removeObserver(observer: dataProviderObserver)
        }
        
        private func dataProviderDidChange(with change: DataProviderChange) {
            switch change {
            case .viewUnrelatedChanges:
            return // Do noting. TableView was already animated by user interaction.
            case .unknown:
                tableView.reloadData()
            case .changes(let updates):
                process(updates: updates)
            }
        }
        
        private func process(update: DataProviderChange.Change) {
            switch update {
            case .insert(let indexPath):
                tableView.insertRows(at: [indexPath], with: configuration.insert)
            case .update(let indexPath):
                if let specificCellUpdate = cellReconfigurationAtIndexPath {
                    specificCellUpdate(indexPath)
                } else {
                    tableView.reloadRows(at: [indexPath], with: configuration.update)
                }
            case .move(let indexPath, let newIndexPath):
                tableView.moveRow(at: indexPath, to: newIndexPath)
            case .delete(let indexPath):
                tableView.deleteRows(at: [indexPath], with: configuration.delete)
            case .insertSection(let sectionIndex):
                tableView.insertSections(IndexSet(integer: sectionIndex), with: configuration.insertSection)
            case .updateSection(let sectionIndex):
                tableView.reloadSections(IndexSet([sectionIndex]), with: configuration.updateSection)
            case .deleteSection(let sectionIndex):
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: configuration.deleteSection)
            case .moveSection(let indexPath, let newIndexPath):
                tableView.moveSection(indexPath, toSection: newIndexPath)
            }
        }
        
        /// Execute updates on your TableView. TableView will do a matching animation for each update
        ///
        /// - Parameter updates: list of updates to execute
        private func process(updates: [DataProviderChange.Change]) {
            tableView.performBatchUpdates({
                updates.forEach(process)
            })
        }
    }
#endif
