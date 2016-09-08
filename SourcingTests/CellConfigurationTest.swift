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
    func testCellConfigurationInit() {
        //Given
        let identifier = "cellIdentifier"
        let nib = UINib(data: Data(), bundle: nil)
        let additionalConfiguartion = { (obj: Int, cell: MockCell<Int>) in }
        
        //When
        let configuration = CellConfiguration<MockCell<Int>>(cellIdentifier: identifier, nib: nib, additionalConfiguartion: additionalConfiguartion)
        
        //Then
        XCTAssertNotNil(configuration.additionalConfiguartion)
        XCTAssertNotNil(configuration.nib)
    }
    
    func testConfigureCell() {
        //Given
        let identifier = "cellIdentifier"
        let nib = UINib(data: Data(), bundle: nil)
        var didCallAdditionalConfiguartion = false
        let additionalConfiguartion = { (obj: Int, cell: MockCell<Int>) in
            didCallAdditionalConfiguartion = true
        }
        let configuration = CellConfiguration<MockCell<Int>>(cellIdentifier: identifier, nib: nib, additionalConfiguartion: additionalConfiguartion)
        let cell = MockCell<Int>()
        
        //When
        configuration.configureCell(cell, object: 100)
        
        //Then
        XCTAssertTrue(didCallAdditionalConfiguartion)
        XCTAssertEqual(cell.configurationCount, 1)
        XCTAssertEqual(cell.configuredObject, 100)
    }
    
    func testCanConfigureCell() {
        //Given
        let identifier = "cellIdentifier"
        
        //When
        let configuration = CellConfiguration<MockCell<Int>>(cellIdentifier: identifier)
        
        //Then
        XCTAssertNotNil(configuration.canConfigurecellForItem(MockCell<Int>()))
    }


}
