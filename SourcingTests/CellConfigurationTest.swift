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
//  CellConfigurationTest.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 10.08.16.
//

import XCTest
import UIKit
@testable import Sourcing

class CellConfigurationTest: XCTestCase {
    
    let nib = UINib(data: Data(), bundle: nil)
    var configuration: CellConfiguration<UITableViewCellMock<Int>>!
    let identifier = "cellIdentifier"
    
    func testCellConfigurationInit() {
        //Given
        let additionalConfiguartion = { (object: Int, cell: UITableViewCellMock<Int>) in }
        
        //When
        configuration = CellConfiguration(cellIdentifier: identifier, nib: nib, additionalConfiguartion: additionalConfiguartion)
        
        //Then
        XCTAssertEqual(identifier, configuration.cellIdentifier)
        XCTAssertNotNil(configuration.nib)
    }
    
    func testCellConfigurationInitWithCellIDentifierProviding() {
        //Given
        let additionalConfiguartion = { (object: Int, cell: UITableViewCellMock<Int>) in }
        
        //When
        configuration = CellConfiguration(nib: nib, additionalConfiguartion: additionalConfiguartion)
        
        //Then
        XCTAssertEqual(UITableViewCellMock<Int>.cellIdentifier, configuration.cellIdentifier)
        XCTAssertNotNil(configuration.nib)
    }
    
    func testConfigureCell() {
        //Given
        var didCallAdditionalConfiguartion = false
        let additionalConfiguartion = { (object: Int, cell: UITableViewCellMock<Int>) in
            didCallAdditionalConfiguartion = true
        }
        configuration = CellConfiguration(cellIdentifier: identifier, nib: nib, additionalConfiguartion: additionalConfiguartion)
        let cell = UITableViewCellMock<Int>()
        
        //When
        let _ = configuration.configure(cell, with: 100)
        
        //Then
        XCTAssertTrue(didCallAdditionalConfiguartion)
        XCTAssertEqual(cell.configurationCount, 1)
        XCTAssertEqual(cell.configuredObject, 100)
    }
    
    func testCanConfigureCell() {
        //When
        configuration = CellConfiguration(cellIdentifier: identifier)
        
        //Then
        XCTAssert(configuration.canConfigureCell(with: 1))
    }

}
