//
//  DataSourceDelegate.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 25.05.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

public protocol DataSourceDelegate: class {
    associatedtype Object
    func cellIdentifierForObject(object: Object) -> String
}