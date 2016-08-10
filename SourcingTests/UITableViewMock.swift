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
import XCTest
import Sourcing

class MockCell: UITableViewCell, ConfigurableCell {
    var configurationCount = 0
    
    var configuredObject: Int?
    
    func configureForObject(object: Int) {
        configurationCount += 1
        configuredObject = object
    }
}

func testTableViewDataSource<T>(tabeleView: UITableView, dataSource: UITableViewDataSource, dataConfiguration: DataProviderExpection<T>, expectedCell: UITableViewCell) {}

class UITableViewMock: TableViewRepresenting {
    var dataSource: UITableViewDataSource?
    var indexPathForSelectedRow: NSIndexPath?
    
    var reloadedCount = 0
    
    func reloadData() {
        self.reloadedCount += 1
    }
    
    var registerdNibs = Dictionary<String, UINib?>()
    func registerNib(nib: UINib?, forCellReuseIdentifier identifier: String) {
        registerdNibs[identifier] = nib
    }
    
    var mockCell = MockCell()
    var lastUedReuseIdetifier: String?
    func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        lastUedReuseIdetifier = identifier
        return mockCell
    }
    
    func beginUpdates() {
        
    }
    
    func endUpdates() {
    
    }
    
    func insertRowsAtIndexPaths(indexPaths: Array<NSIndexPath>, withRowAnimation: UITableViewRowAnimation) {
        
    }
    
    func deleteRowsAtIndexPaths(indexPaths: Array<NSIndexPath>, withRowAnimation: UITableViewRowAnimation) {
        
    }
    
    func insertSections(sections: NSIndexSet, withRowAnimation: UITableViewRowAnimation) {
        
    }
    
    func deleteSections(sections: NSIndexSet, withRowAnimation: UITableViewRowAnimation) {
    
    }
    
    func cellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell? {
        return mockCell
    }
}