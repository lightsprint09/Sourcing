//
//  DataSourcing.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 27.05.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import UIKit


protocol DataSourcing {
    associatedtype Data: DataProvider
    var dataProvider: Data { get }
    var cellDequeables: Array<CellDequeable> { get }
}