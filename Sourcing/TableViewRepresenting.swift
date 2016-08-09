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
//  TableViewRepresenting.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 09.08.16.
//

import Foundation

//Protocol abstractionfor UITableView
public protocol TableViewRepresenting: class {
    var dataSource: UITableViewDataSource? { get set }
    var indexPathForSelectedRow: NSIndexPath? { get }
    
    func reloadData()
    
    func registerNib(nib: UINib?, forCellReuseIdentifier identifier: String)
    
    func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell
    
    func beginUpdates()
    func endUpdates()
    
    func insertRowsAtIndexPaths(indexPaths: Array<NSIndexPath>, withRowAnimation: UITableViewRowAnimation)
    func deleteRowsAtIndexPaths(indexPaths: Array<NSIndexPath>, withRowAnimation: UITableViewRowAnimation)
    
    func deleteSections(sections: NSIndexSet, withRowAnimation: UITableViewRowAnimation)
    func insertSections(sections: NSIndexSet, withRowAnimation: UITableViewRowAnimation)
    
    
    func cellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell?
    
}

extension UITableView: TableViewRepresenting { }