//
//  Copyright (C) 2017 Lukas Schmidt.
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
//  DataModificatorMock.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 31.01.17.
//

import Foundation
import Sourcing

class DataModificatorMock: DataModifying {
    var canMoveItemAt: Bool = false
    var canDeleteItemAt: Bool = false
    
    var sourceIndexPath: IndexPath?
    var destinationIndexPath: IndexPath?
    var deletedIndexPath: IndexPath?
    var triggeredByUserInteraction: Bool?
    
    func moveItemAt(sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, triggerdByTableView: Bool) {
        self.sourceIndexPath = sourceIndexPath
        self.destinationIndexPath = destinationIndexPath
        triggeredByUserInteraction = triggerdByTableView
    }
    
    func canMoveItem(at indexPath: IndexPath) -> Bool {
        return canMoveItemAt
    }
    
    func canDeleteItem(at indexPath: IndexPath) -> Bool {
        return canDeleteItemAt
    }
    
    func deleteItem(at indexPath: IndexPath, triggerdByTableView: Bool) {
        deletedIndexPath = indexPath
        triggeredByUserInteraction = triggerdByTableView
    }
}
