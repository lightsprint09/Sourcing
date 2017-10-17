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

import UIKit

public final class CollectionViewChangesAnimator {
     public let dataProvider: DataProviderObservable
    
    private var dataPrvoiderObserver: NSObjectProtocol?
    private let collectionView: UICollectionView
    
    public init<DataProvider: DataProviderObservable>(collectionView: UICollectionView, dataProvider: DataProvider) {
        self.collectionView = collectionView
        self.dataProvider = dataProvider
        dataPrvoiderObserver = dataProvider.addObserver(observer: { [weak self] update in
            switch update {
            case .unknown:
                self?.collectionView.reloadData()
            case .changes(let updates):
                self?.process(updates: updates)
            }
        })
    }
    
    private func process(update: DataProviderChange.Change) {
        switch update {
        case .insert(let indexPath):
            collectionView.insertItems(at: [indexPath])
        case .update(let indexPath):
            collectionView.reloadItems(at: [indexPath])
        case .move(let indexPath, let newIndexPath):
            collectionView.moveItem(at: indexPath, to: newIndexPath)
        case .delete(let indexPath):
            collectionView.deleteItems(at: [indexPath])
        case .insertSection(let sectionIndex):
            collectionView.insertSections(IndexSet(integer: sectionIndex))
        case .deleteSection(let sectionIndex):
            collectionView.deleteSections(IndexSet(integer: sectionIndex))
        case .moveSection(let section, let newSection):
            collectionView.moveSection(section, toSection: newSection)
        }
    }
    
    /// Animates multiple insert, delete, reload, and move operations as a group.
    ///
    /// - Parameter updates: All updates you want to execute. Pass `nil` if you want to relaod all content.
    public func process(updates: [DataProviderChange.Change]) {
        collectionView.performBatchUpdates({
            updates.forEach(self.process)
        }, completion: nil)
    }
}
