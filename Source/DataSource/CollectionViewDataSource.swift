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
    /// `CollectionViewDataSource` uses data provider and provides the data as a `UICollectionViewDataSource`.
    ///
    /// - SeeAlso: `UICollectionViewDataSource`
    final public class CollectionViewDataSource<Object>: NSObject, UICollectionViewDataSource {
        /// The data provider which provides the data to the data source.
        public let dataProvider: AnyDataProvider<Object>
        
        /// Data modificator can be used to modify the data providers content.
        public let dataModificator: DataModifying?
        
        /// Provides section index tiltes.
        public let sectionIndexTitleProvider: SectionIndexTitleProviding?
       
        private let cellConfigurations: [ReusableViewConfiguring]
        private let supplementaryViewConfigurations: [ReusableViewConfiguring]
        
        /// Creates an instance with a data provider and cell configurations
        /// which will be displayed in the collection view.
        ///
        /// - Note: This initializer is loosly typed. If you just display one cell, use the strongly typed initializer.
        ///
        /// - SeeAlso: `DataProviding`
        /// - SeeAlso: `CellConfiguring`
        ///
        ///   - dataProvider: provides data to the data source.
        ///   - anyCells: the cell configuration for the collection view cells.
        ///   - anySupplementaryViewConfigurations: the reusable view configurations for the collection view supplementary views. Defaults to `[]`.
        ///   - dataModificator: data modifier to modify the data. Defaults to `nil`.
        ///   - sectionIndexTitleProvider: provides section index titles. Defaults to `nil`.
        public init<DataProvider: DataProviding>(dataProvider: DataProvider,
                        anyCellConfigurations: [ReusableViewConfiguring],
                        anySupplementaryViewConfigurations: [ReusableViewConfiguring] = [],
                        dataModificator: DataModifying? = nil, sectionIndexTitleProvider: SectionIndexTitleProviding? = nil)
            where DataProvider.Element == Object {
                self.dataProvider = AnyDataProvider(dataProvider)
                self.cellConfigurations = anyCellConfigurations
                self.dataModificator = dataModificator
                self.supplementaryViewConfigurations = anySupplementaryViewConfigurations
                self.sectionIndexTitleProvider = sectionIndexTitleProvider
                super.init()
        }
        
        // MARK: Private
        
        private func cellDequeableForIndexPath(_ object: Object) -> ReusableViewConfiguring? {
            return cellConfigurations.first(where: { $0.canConfigureView(ofKind: nil, with: object) })
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
            
            let cellDequeable: ReusableViewConfiguring! = cellDequeableForIndexPath(object)
            precondition(cellDequeable != nil, "Unexpected cell type at \(indexPath) for object of type")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellDequeable.reuseIdentifier, for: indexPath)
            cellDequeable.configure(cell, at: indexPath, with: object)
            
            return cell
        }
        
        public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
            return dataModificator?.canMoveItem(at: indexPath) ?? false
        }
                
        public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            dataModificator?.moveItemAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath, updateView: false)
        }
        
        private func supplementaryViewConfiguring(for object: Object, ofKind kind: String ) -> ReusableViewConfiguring? {
            return supplementaryViewConfigurations.first(where: { $0.canConfigureView(ofKind: kind, with: object) })
        }
        
        public func collectionView(_ collectionView: UICollectionView,
                                   viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let object = dataProvider.object(at: indexPath)
            let dequeable: ReusableViewConfiguring! = supplementaryViewConfiguring(for: object, ofKind: kind)
            precondition(dequeable != nil, "Unexpected SupplementaryView type of \(kind) for object of type \(object.self) at indexPath \(indexPath)")
            
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                    withReuseIdentifier: dequeable.reuseIdentifier, for: indexPath)
            
            _ = dequeable.configure(supplementaryView, at: indexPath, with: object)
            return supplementaryView
        }
        
        public func indexTitles(for collectionView: UICollectionView) -> [String]? {
            return sectionIndexTitleProvider?.sectionIndexTitles
        }
        
        public func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
            precondition(self.sectionIndexTitleProvider != nil, "Must not called when sectionIndexTitleProvider is nil")
            let sectionIndexTitleProvider: SectionIndexTitleProviding! = self.sectionIndexTitleProvider
            return sectionIndexTitleProvider.indexPath(forSectionIndexTitle: title, at: index)
        }
    }

    // MARK: TypesafeInitializers

    public extension CollectionViewDataSource {
        /// Creates an instance with a data provider and a cell configuration
        /// which will be displayed in the collection view.
        ///
        /// - SeeAlso: `DataProviding`
        /// - SeeAlso: `StaticCellConfiguring`
        ///
        /// - Parameters:
        ///   - dataProvider: provides data to the data source
        ///   - cellConfiguration: the cell configuration for the collection view cell for displaying the contents of the data.
        ///   - dataModificator: data modifier to modify the data. Defaults to `nil`.
        ///   - sectionIndexTitleProvider: provides section index titles. Defaults to `nil`.
        convenience init<Cell: StaticReusableViewConfiguring, DataProvider: DataProviding>
            (dataProvider: DataProvider, cellConfiguration: Cell,
             dataModificator: DataModifying? = nil, sectionIndexTitleProvider: SectionIndexTitleProviding? = nil)
            where DataProvider.Element == Object, Cell.Object == Object, Cell.View: UICollectionViewCell {
                let typeErasedDataProvider = AnyDataProvider(dataProvider)
                self.init(dataProvider: typeErasedDataProvider, anyCellConfigurations: [cellConfiguration],
                          dataModificator: dataModificator, sectionIndexTitleProvider: sectionIndexTitleProvider)
        }
        
        /// Creates an instance with a data provider and a cell configuration
        /// which will be displayed in the collection view.
        ///
        /// - SeeAlso: `DataProviding`
        /// - SeeAlso: `StaticCellConfiguring`
        ///
        /// - Parameters:
        ///   - dataProvider: the data provider which provides data to the data source
        ///   - cellConfigurations: the cell configurations for the collection view cells which must support displaying the contents of the data provider.
        ///   - dataModificator: data modifier to modify the data. Defaults to `nil`.
        ///   - sectionIndexTitleProvider: provides section index titles. Defaults to `nil`.
        convenience init<Cell: StaticReusableViewConfiguring, DataProvider: DataProviding>
            (dataProvider: DataProvider, cellConfigurations: [Cell],
             dataModificator: DataModifying? = nil, sectionIndexTitleProvider: SectionIndexTitleProviding? = nil)
            where DataProvider.Element == Object, Cell.Object == Object, Cell.View: UICollectionViewCell {
                let typeErasedDataProvider = AnyDataProvider(dataProvider)
                self.init(dataProvider: typeErasedDataProvider, anyCellConfigurations: cellConfigurations,
                          dataModificator: dataModificator, sectionIndexTitleProvider: sectionIndexTitleProvider)
        }
        
        /// Creates an instance with a data provider and a cell configuration
        /// which will be displayed in the collection view.
        ///
        /// - SeeAlso: `DataProviding`
        /// - SeeAlso: `StaticCellConfiguring`
        /// - SeeAlso: `StaticSupplementaryViewConfiguring`
        ///
        /// - Parameters:
        ///   - dataProvider: the data provider which provides data to the data source
        ///   - cellConfiguration: the cell configuration for the collection view cell for displaying the contents of the data provider.
        ///   - supplementaryViewConfigurations: the reusable view configurations for the collection view supplementary views.
        ///   - dataModificator: data modifier to modify the data. Defaults to `nil`.
        ///   - sectionIndexTitleProvider: provides section index titles. Defaults to `nil`.
        convenience init<Cell: StaticReusableViewConfiguring, DataProvider: DataProviding, SupplementaryConfig: StaticReusableViewConfiguring>
            (dataProvider: DataProvider, cellConfiguration: Cell,
             supplementaryViewConfigurations: [SupplementaryConfig],
             dataModificator: DataModifying? = nil, sectionIndexTitleProvider: SectionIndexTitleProviding? = nil)
            where DataProvider.Element == Object, Cell.Object == Object, SupplementaryConfig.Object == Object, Cell.View: UICollectionViewCell {
                let typeErasedDataProvider = AnyDataProvider(dataProvider)
                self.init(dataProvider: typeErasedDataProvider, anyCellConfigurations: [cellConfiguration],
                          anySupplementaryViewConfigurations: supplementaryViewConfigurations,
                          dataModificator: dataModificator, sectionIndexTitleProvider: sectionIndexTitleProvider)
        }
        
        /// Creates an instance with a data provider and a cell configuration
        /// which will be displayed in the collection view.
        ///
        /// - SeeAlso: `DataProviding`
        /// - SeeAlso: `StaticCellConfiguring`
        /// - SeeAlso: `StaticSupplementaryViewConfiguring`
        ///
        /// - Parameters:
        ///   - dataProvider: the data provider which provides data to the data source
        ///   - cellConfigurations: the cell configurations for the collection view cells which must support displaying the contents of the data provider.
        ///   - supplementaryViewConfigurations: the reusable view configurations for the collection view supplementary views.
        ///   - dataModificator: data modifier to modify the data. Defaults to `nil`.
        ///   - sectionIndexTitleProvider: provides section index titles. Defaults to `nil`.
        convenience init<Cell: StaticReusableViewConfiguring, DataProvider: DataProviding, SupplementaryConfig: StaticReusableViewConfiguring>
            (dataProvider: DataProvider, cellConfigurations: [Cell],
             supplementaryViewConfigurations: [SupplementaryConfig],
             dataModificator: DataModifying? = nil, sectionIndexTitleProvider: SectionIndexTitleProviding? = nil)
            where DataProvider.Element == Object, Cell.Object == Object, SupplementaryConfig.Object == Object, Cell.View: UICollectionViewCell {
                let typeErasedDataProvider = AnyDataProvider(dataProvider)
                self.init(dataProvider: typeErasedDataProvider, anyCellConfigurations: cellConfigurations,
                          anySupplementaryViewConfigurations: supplementaryViewConfigurations,
                          dataModificator: dataModificator, sectionIndexTitleProvider: sectionIndexTitleProvider)
        }
    }
#endif
