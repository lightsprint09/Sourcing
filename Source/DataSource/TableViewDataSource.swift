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

#if os(iOS) || os(tvOS)
    import UIKit

    /// `TableViewDataSource` uses data provider and provides the data as a `UITableViewDataSource`.
    ///
    /// - SeeAlso: `UITableViewDataSource`
    public final class TableViewDataSource<Object>: NSObject, UITableViewDataSource {
        /// The data provider which provides the data to the data source.
        public let dataProvider: AnyDataProvider<Object>
        
        /// Provides section header titles.
        public var sectionHeaderProvider: SectionHeaderProviding?
        
        /// Provides section index titles.
        public var sectionIndexTitleProvider: SectionIndexTitleProviding?
        
        /// Data modificator can be used to modify the data providers content.
        public let dataModificator: DataModifying?
        
        private let cellConfiguration: AnyReusableViewConfiguring<UITableViewCell, Object>
        
        /// Creates an instance with a data provider and cell configuration
        /// which will be displayed in the collection view.
        ///
        /// - SeeAlso: `DataProviding`
        /// - SeeAlso: `ReusableViewConfiguring`
        ///
        /// - Parameters:
        ///   - dataProvider: the data provider which provides data to the data source.
        ///   - cellConfiguration: the cell configuration for the table view cell.
        ///   - dataModificator: data modifier to modify the data. Defaults to `nil`.
        ///   - sectionTitleProvider: provides section header titles and section index titles. Defaults to `nil`.
        public init<Cell: ReusableViewConfiguring, DataProvider: DataProviding>(dataProvider: DataProvider, cellConfiguration: Cell,
                                                                                dataModificator: DataModifying? = nil,
                                                                                sectionHeaderProvider: SectionHeaderProviding? = nil,
                                                                                sectionIndexTitleProvider: SectionIndexTitleProviding? = nil)
            where DataProvider.Element == Object, Cell.Object == Object, Cell.View: UITableViewCell {
                self.dataProvider = AnyDataProvider(dataProvider)
                self.dataModificator = dataModificator
                self.cellConfiguration = AnyReusableViewConfiguring(cellConfiguration)
                self.sectionHeaderProvider = sectionHeaderProvider
                self.sectionIndexTitleProvider = sectionIndexTitleProvider
                super.init()
        }
        
        // MARK: UITableViewDataSource
        /// :nodoc:
        public func numberOfSections(in tableView: UITableView) -> Int {
            return dataProvider.numberOfSections()
        }
        
        /// :nodoc:
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataProvider.numberOfItems(inSection: section)
        }
        
        /// :nodoc:
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let object = dataProvider.object(at: indexPath)
            
            let reuseIdentifier = cellConfiguration.reuseIdentifier(for: object)
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            cellConfiguration.configure(cell, at: indexPath, with: object)
            
            return cell
        }
        
        // MARK: Section Index Titles
        /// :nodoc:
        public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            return sectionIndexTitleProvider?.sectionIndexTitles
        }
        
        /// :nodoc:
        public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
            precondition(self.sectionIndexTitleProvider != nil, "Must not called when sectionTitleProvider is nil")
            let sectionIndexTitleProvider: SectionIndexTitleProviding! = self.sectionIndexTitleProvider
            return sectionIndexTitleProvider.indexPath(forSectionIndexTitle: title, at: index).section
        }
        
        // MARK: SectionHeader & SectionFooter
        /// :nodoc:
        public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return sectionHeaderProvider?.titleForHeader(inSection: section)
        }
        
        /// :nodoc:
        public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
            return sectionHeaderProvider?.titleForFooter(inSection: section)
        }
        
        // MARK: Editing
        /// :nodoc:
        public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return dataModificator?.canMoveItem(at: indexPath) ?? false
        }
        
        /// :nodoc:
        public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            dataModificator?.moveItemAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath, updateView: false)
        }
        
        /// :nodoc:
        public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return dataModificator?.canDeleteItem(at: indexPath) ?? false
        }
        
        /// :nodoc:
        public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if let dataModificator = dataModificator, editingStyle == .delete {
                dataModificator.deleteItem(at: indexPath)
            }
        }
    }

#endif
