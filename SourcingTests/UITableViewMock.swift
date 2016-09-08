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
//  UITableViewMock.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 09.08.16.
//

import UIKit
import Sourcing

class MockCell<T>: UITableViewCell, ConfigurableCell {
    var configurationCount = 0
    var configuredObject: T?
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        Swift.fatalError("init(coder:) has not been implemented")
    }
    
    func configureForObject(_ object: T) {
        configurationCount += 1
        configuredObject = object
    }
}

class UITableViewMock: UITableCollectionViewBaseMock, TableViewRepresenting {
    var dataSource: UITableViewDataSource?
    var indexPathForSelectedRow: IndexPath?
    
   
    init(mockTableViewCells: Dictionary<String, UITableViewCell> = ["cellIdentifier": MockCell<Int>()]) {
        super.init(mockCells: mockTableViewCells)
    }
    
    func registerNib(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        registerdNibs[identifier] = nib
    }
    
    func dequeueReusableCellWithIdentifier(_ identifier: String, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        return dequeueWithIdentifier(identifier, forIndexPath: indexPath)
    }
    
    func beginUpdates() {
        
    }
    
    func endUpdates() {
    
    }
    
    func insertRowsAtIndexPaths(_ indexPaths: Array<IndexPath>, withRowAnimation: UITableViewRowAnimation) {
        
    }
    
    func deleteRowsAtIndexPaths(_ indexPaths: Array<IndexPath>, withRowAnimation: UITableViewRowAnimation) {
        
    }
    
    func insertSections(_ sections: IndexSet, withRowAnimation: UITableViewRowAnimation) {
        
    }
    
    func deleteSections(_ sections: IndexSet, withRowAnimation: UITableViewRowAnimation) {
    
    }
    
    func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell? {
        let cell = cellMocks.first
        return cell?.1 as? UITableViewCell
    }
}
