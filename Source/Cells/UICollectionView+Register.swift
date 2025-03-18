import UIKit

public extension UICollectionView {

    /// Registers a class for use in creating new  cell items.
    ///
    /// Discussion

    /// Prior to dequeueing any cells, call this method or the register(_:forCellReuseIdentifier:) method to tell the collection view how to create new cells. If a cell of the specified type is not currently in a reuse queue, the collection view uses the provided information to create a new cell object automatically.
    /// - Parameter type: The class of a cell that you want to use in the table.
    func register<T: ReuseIdentifierProviding>(class type: T.Type) where T: UICollectionViewCell {
        register(type, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    /// Registers a nib object containing a cell with the collection view under a ReuseIdentifierProviding reuse identifier.
    ///
    /// Discussion

    /// Prior to dequeueing any cells, call this method or the register(_:forCellReuseIdentifier:) method to tell the collection view how to create new cells. If a cell of the specified type is not currently in a reuse queue, the collection view uses the provided information to create a new cell object automatically.
    /// - Parameter nibFor: Uses ReuseIdentifierProvidings reuse identifer to create a nib.
    func register<T: ReuseIdentifierProviding>(nibFor type: T.Type) where T: UICollectionViewCell {
        let reuseIdentifier = T.reuseIdentifier
        let uiNib = UINib(nibName: reuseIdentifier, bundle: Bundle(for: type))
        register(uiNib, forCellWithReuseIdentifier: reuseIdentifier)
    }

}
