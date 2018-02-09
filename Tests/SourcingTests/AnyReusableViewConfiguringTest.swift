//
//  Copyright (C) DB Systel GmbH.
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

import XCTest
@testable import Sourcing

final class AnyReusableViewConfiguringTest: XCTestCase {
    
    func testReusieIdentifier() {
        // Given
        let reuseIdentifier = "reuseIdentifier"
        let cellConfiguration = CellConfiguration<UITableViewCellMock<Int>>(reuseIdentifier: reuseIdentifier)
        
        // When
        let anyCellConfiguration = AnyReusableViewConfiguring<UITableViewCellMock<Int>, Int>(cellConfiguration)
        
        //Then
        XCTAssertEqual(anyCellConfiguration.reuseIdentifier(for: 0), reuseIdentifier)
        
    }
    
    func testConfiguration() {
        // Given
        var capturedCell: UITableViewCellMock<Int>?
        var captruedIndexPath: IndexPath?
        var capturedValue: Int?
        let cellConfiguration = CellConfiguration<UITableViewCellMock<Int>> { cell, indexPath, value in
            capturedCell = cell
            captruedIndexPath = indexPath
            capturedValue = value
        }
        
        // When
        let anyCellConfiguration = AnyReusableViewConfiguring<UITableViewCellMock<Int>, Int>(cellConfiguration)
        anyCellConfiguration.configure(UITableViewCellMock<Int>(), at: IndexPath(row: 0, section: 0), with: 1)
        
        //Then
        XCTAssertNotNil(capturedCell)
        XCTAssertEqual(captruedIndexPath, IndexPath(row: 0, section: 0))
        XCTAssertEqual(capturedValue, 1)
    }
    
    func testConfigurationSuperType() {
        // Given
        var capturedCell: UITableViewCellMock<Int>?
        var captruedIndexPath: IndexPath?
        var capturedValue: Int?
        let cellConfiguration = CellConfiguration<UITableViewCellMock<Int>> { cell, indexPath, value in
            capturedCell = cell
            captruedIndexPath = indexPath
            capturedValue = value
        }
        
        // When
        let anyCellConfiguration = AnyReusableViewConfiguring<UITableViewCell, Int>(cellConfiguration)
        anyCellConfiguration.configure(UITableViewCellMock<Int>(), at: IndexPath(row: 0, section: 0), with: 1)
        
        //Then
        XCTAssertNotNil(capturedCell)
        XCTAssertEqual(captruedIndexPath, IndexPath(row: 0, section: 0))
        XCTAssertEqual(capturedValue, 1)
    }
}
