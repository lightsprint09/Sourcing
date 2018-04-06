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

import UIKit

#if os(iOS) || os(tvOS)
    /// `CollectionViewDataSource` uses data provider and provides the data as a `UICollectionViewDataSource`.
    ///
    /// - SeeAlso: `UICollectionViewDataSource`
    public final class CollectionViewDataSource<Object>: NSObject, UICollectionViewDataSource {
        /// The data provider which provides the data to the data source.
        public let dataProvider: AnyDataProvider<Object>
        
        /// Data modificator can be used to modify the data providers content.
        public let dataModificator: DataModifying?
        
        /// Provides section index tiltes.
        public let sectionIndexTitles: SectionIndexTitles?
       
        private let cellConfiguration: AnyReusableViewConfiguring<UICollectionViewCell, Object>
        
        private let supplementaryViewConfiguration: AnyReusableViewConfiguring<UICollectionReusableView, Object>?
        
        /// Creates an instance with a data provider and a cell configuration
        /// which will be displayed in the collection view.
        ///
        /// - SeeAlso: `DataProvider`
        /// - SeeAlso: `ReusableViewConfiguring`
        ///
        /// - Parameters:
        ///   - dataProvider: the data provider which provides data to the data source
        ///   - cellConfiguration: the cell configuration for the collection view cell for displaying the contents of the data provider.
        ///   - supplementaryViewConfigurations: the reusable view configurations for the collection view supplementary views.
        ///   - dataModificator: data modifier to modify the data. Defaults to `nil`.
        ///   - sectionIndexTitles: provides section index titles. Defaults to `nil`.
        public init<Cell: ReusableViewConfiguring, D: DataProvider, SupplementaryConfig: ReusableViewConfiguring>
            (dataProvider: D, cellConfiguration: Cell,
             supplementaryViewConfiguration: SupplementaryConfig,
             dataModificator: DataModifying? = nil, sectionIndexTitles: SectionIndexTitles? = nil)
            where D.Element == Object, Cell.Object == Object, SupplementaryConfig.Object == Object, Cell.View: UICollectionViewCell {
                self.dataProvider = AnyDataProvider(dataProvider)
                self.cellConfiguration = AnyReusableViewConfiguring(cellConfiguration)
                self.dataModificator = dataModificator
                self.supplementaryViewConfiguration = AnyReusableViewConfiguring(supplementaryViewConfiguration)
                self.sectionIndexTitles = sectionIndexTitles
                super.init()
        }
        
        /// Creates an instance with a data provider and a cell configuration
        /// which will be displayed in the collection view.
        ///
        /// - SeeAlso: `DataProvider`
        /// - SeeAlso: `ReusableViewConfiguring`
        ///
        /// - Parameters:
        ///   - dataProvider: the data provider which provides data to the data source
        ///   - cellConfiguration: the cell configuration for the collection view cell for displaying the contents of the data provider.
        ///   - supplementaryViewConfigurations: the reusable view configurations for the collection view supplementary views.
        ///   - dataModificator: data modifier to modify the data. Defaults to `nil`.
        ///   - sectionIndexTitles: provides section index titles. Defaults to `nil`.
        public init<Cell: ReusableViewConfiguring, D: DataProvider>(dataProvider: D, cellConfiguration: Cell,
                                                                    dataModificator: DataModifying? = nil,
                                                                    sectionIndexTitles: SectionIndexTitles? = nil)
            where D.Element == Object, Cell.Object == Object, Cell.View: UICollectionViewCell {
                self.dataProvider = AnyDataProvider(dataProvider)
                self.cellConfiguration = AnyReusableViewConfiguring(cellConfiguration)
                self.dataModificator = dataModificator
                self.supplementaryViewConfiguration = nil
                self.sectionIndexTitles = sectionIndexTitles
                super.init()
        }
        
        // MARK: UICollectionViewDataSource
        /// :nodoc:
        public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return dataProvider.numberOfSections()
        }
        
        /// :nodoc:
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return dataProvider.numberOfItems(inSection: section)
        }
        
        /// :nodoc:
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let object = dataProvider.object(at: indexPath)
            
            let reuseIdentifier = cellConfiguration.reuseIdentifier(for: object, ofType: .cell)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            cellConfiguration.configure(cell, at: indexPath, with: object)
            
            return cell
        }
        
        /// :nodoc:
        public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
            return dataModificator?.canMoveItem(at: indexPath) ?? false
        }
        
        /// :nodoc:
        public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            dataModificator?.moveItemAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath, updateView: false)
        }
        
        /// :nodoc:
        public func collectionView(_ collectionView: UICollectionView,
                                   viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard let supplementaryViewConfiguration = supplementaryViewConfiguration else {
                fatalError("Must provide supplemetary view configuration")
            }
            let object = dataProvider.object(at: indexPath)
            let reuseIdentifier = supplementaryViewConfiguration.reuseIdentifier(for: object, ofType: .supplementaryView(kind: kind))
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                withReuseIdentifier: reuseIdentifier,
                                                                                for: indexPath)
            
            supplementaryViewConfiguration.configure(supplementaryView, at: indexPath, with: object)
            return supplementaryView
        }
        
        /// :nodoc:
        public func indexTitles(for collectionView: UICollectionView) -> [String]? {
            return sectionIndexTitles?.sectionIndexTitles
        }
        
        /// :nodoc:
        public func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
            precondition(self.sectionIndexTitles != nil, "Must not called when sectionIndexTitles is nil")
            let sectionIndexTitles: SectionIndexTitles! = self.sectionIndexTitles
            return sectionIndexTitles.indexPath(forSectionIndexTitle: title, at: index)
        }
    }
#endif
