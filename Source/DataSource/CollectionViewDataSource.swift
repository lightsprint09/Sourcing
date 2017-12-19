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
//  MultiCellCollectionViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//
import UIKit

#if os(iOS) || os(tvOS)
    /// `CollectionViewDataSource` uses data provider and provides the data as a `UICollectionViewDataSource`
    final public class CollectionViewDataSource<Object>: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
        /// The data provider which provides the data to the data source
        public let dataProvider: AnyDataProvider<Object>
        
        /// Optional data modificator can be used to modify the data providers content
        public let dataModificator: DataModifying?
       
        private let cellConfigurations: [CellConfiguring]
        
        /// Creates an instance with a data provider and cell configurations
        /// which will be displayed in the collection view.
        ///
        /// - Note: This initializer is loosly typed. If you just display one cell, use the strongly typed initializer.
        /// - Parameters:
        ///   - dataProvider: the data provider which provides data to the data source
        ///   - anyCells: the cell configuration for the collection view cells
        ///   - dataModificator: optional data modifier.
        public init<DataProvider: DataProviding>(dataProvider: DataProvider,
                        anyCellConfigurations: [CellConfiguring], dataModificator: DataModifying? = nil)
            where DataProvider.Element == Object {
                self.dataProvider = AnyDataProvider(dataProvider)
                self.cellConfigurations = anyCellConfigurations
                self.dataModificator = dataModificator
                super.init()
        }
        
        // MARK: Private
        
        private func cellDequeableForIndexPath(_ object: Object) -> CellConfiguring? {
            return cellConfigurations.first(where: { $0.canConfigureCell(with: object) })
        }
        
        // MARK: UICollectionViewDataSource
        
        public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return dataProvider.numberOfSections()
        }
        
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return dataProvider.numberOfItems(inSection: section)
        }
        
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let object = dataProvider.object(at: indexPath)
            
            guard let cellDequeable = cellDequeableForIndexPath(object) else {
                fatalError("Unexpected cell type at \(indexPath)")
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellDequeable.cellIdentifier, for: indexPath)
            cellDequeable.configure(cell, with: object)
            
            return cell
        }
        
        public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
            return dataModificator?.canMoveItem(at: indexPath) ?? false
        }
                
        public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            dataModificator?.moveItemAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath, updateView: true)
        }
        
        // MARK: UICollectionViewDataSourcePrefetching
        
        @available(iOS 10.0, *)
        public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
            dataProvider.prefetchItems(at: indexPaths)
        }
        
        @available(iOS 10.0, *)
        public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
            dataProvider.cancelPrefetchingForItems(at: indexPaths)
        }
    }

    // MARK: TypesafeInitializers

    public extension CollectionViewDataSource {
        /// Creates an instance with a data provider and a cell configuration
        /// which will be displayed in the collection view.
        ///
        /// - Parameters:
        ///   - dataProvider: the data provider which provides data to the data source
        ///   - cell: the cell configuration for the collection view cell which must support displaying the contents of the data provider.
        ///   - dataModificator: optional data modifier.
        convenience init<Cell: StaticCellConfiguring, DataProvider: DataProviding>
            (dataProvider: DataProvider, cellConfiguration: Cell, dataModificator: DataModifying? = nil)
            where DataProvider.Element == Object, Cell.Object == Object, Cell.Cell: UICollectionViewCell {
                let typeErasedDataProvider = AnyDataProvider(dataProvider)
                self.init(dataProvider: typeErasedDataProvider, anyCellConfigurations: [cellConfiguration], dataModificator: dataModificator)
        }
        
        /// Creates an instance with a data provider and a cell configuration
        /// which will be displayed in the collection view.
        ///
        /// - Parameters:
        ///   - dataProvider: the data provider which provides data to the data source
        ///   - cells: the cell configurations for the collection view cells which must support displaying the contents of the data provider.
        ///   - dataModificator: optional data modifier.
        convenience init<Cell: StaticCellConfiguring, DataProvider: DataProviding>
            (dataProvider: DataProvider, cellConfigurations: [Cell], dataModificator: DataModifying? = nil)
            where DataProvider.Element == Object, Cell.Object == Object, Cell.Cell: UICollectionViewCell {
                let typeErasedDataProvider = AnyDataProvider(dataProvider)
                self.init(dataProvider: typeErasedDataProvider, anyCellConfigurations: cellConfigurations, dataModificator: dataModificator)
        }
    }
#endif
