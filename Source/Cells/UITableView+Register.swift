//
//  File.swift
//  
//
//  Created by Lukas Schmidt on 26.03.20.
//

import UIKit

public extension UITableView {

    /// Registers a class for use in creating new table cells.
    ///
    /// Prior to dequeueing any cells, call this method or the register(_:forCellReuseIdentifier:) method to tell the table view how to create new cells. If a cell of the specified type is not currently in a reuse queue, the table view uses the provided information to create a new cell object automatically.
    /// - Parameter type: The class of a cell that you want to use in the table.
    func register<T: ReuseIdentifierProviding>(class type: T.Type) where T: UITableViewCell {
        register(type, forCellReuseIdentifier: T.reuseIdentifier)
    }

    /// Registers a nib object containing a cell with the table view under a ReuseIdentifierProviding reuse identifier.
    ///
    /// Discussion

    /// Prior to dequeueing any cells, call this method or the register(_:forCellReuseIdentifier:) method to tell the table view how to create new cells. If a cell of the specified type is not currently in a reuse queue, the table view uses the provided information to create a new cell object automatically.
    /// - Parameter nibFor: Uses ReuseIdentifierProvidings reuse identifer to create a nib.
    func register<T: ReuseIdentifierProviding>(nibFor type: T.Type) where T: UITableViewCell {
        let reuseIdentifier = T.reuseIdentifier
        let uiNib = UINib(nibName: reuseIdentifier, bundle: Bundle(for: type))
        register(uiNib, forCellReuseIdentifier: reuseIdentifier)
    }

    /// Registers a nib object containing a header or footer with the table view under a specified identifier.
    ///
    ///Before dequeueing any header or footer views, call this method or the register(_:forHeaderFooterViewReuseIdentifier:) method to tell the table view how to create new instances of your views. If a view of the specified type is not currently in a reuse queue, the table view uses the provided information to create a new one automatically.
    /// - Parameter nibFor: Uses ReuseIdentifierProvidings reuse identifer to create a nib.
    func registerHeaderFooter<T: ReuseIdentifierProviding>(nibFor type: T.Type) where T: UITableViewHeaderFooterView {
        let reuseIdentifier = T.reuseIdentifier
        let uiNib = UINib(nibName: reuseIdentifier, bundle: Bundle(for: type))
        register(uiNib, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

    /// Registers a class for use in creating new table header or footer views.
    ///
    ///Before dequeueing any header or footer views, call this method or the register(_:forHeaderFooterViewReuseIdentifier:) method to tell the table view how to create new instances of your views. If a view of the specified type is not currently in a reuse queue, the table view uses the provided information to create a new one automatically.
    /// - Parameter class:  The class of a header / footer that you want to use in the table.
    func registerHeaderFooter<T: ReuseIdentifierProviding>(class type: T.Type) where T: UITableViewHeaderFooterView {
        register(type, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

}
