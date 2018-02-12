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

import XCTest
import Sourcing

class DynamicSectionTitlesTests: XCTestCase {
    
    func testGenerateHeaderTitle() {
        //Given
        let dataProvider = ArrayDataProvider(rows: ["SectionTitle"])
        let sectionTitelProvider = DynamicSectionTitles(dataProvider: dataProvider,
                                                               generateSectionHeaderTitle: { (element, _) in element })
        
        //When
        let title = sectionTitelProvider.titleForHeader(inSection: 0)
        let footer = sectionTitelProvider.titleForFooter(inSection: 0)
        let sectionIndexTitles = sectionTitelProvider.sectionIndexTitles
        
        //Then
        XCTAssertEqual(title, "SectionTitle")
        XCTAssertNil(footer)
        XCTAssertNil(sectionIndexTitles)
    }
    
    func testGenerateSectionIndexTitles() {
        //Given
        let dataProvider = ArrayDataProvider(rows: ["SectionIndexTitle"])
        let sectionTitelProvider = DynamicSectionTitles(dataProvider: dataProvider,
                                                               generateSectionIndexTitle: { (element, _) in element })
        
        //When
        let sectionIndexTitles = sectionTitelProvider.sectionIndexTitles
        let title = sectionTitelProvider.titleForHeader(inSection: 0)
        let footer = sectionTitelProvider.titleForFooter(inSection: 0)
        
        //Then
        XCTAssertEqual(sectionIndexTitles?.first, "SectionIndexTitle")
        XCTAssertNil(title)
        XCTAssertNil(footer)

    }
    
    func testGenerateFooterTitle() {
        //Given
        let dataProvider = ArrayDataProvider(rows: ["SectionFooter"])
        let sectionTitelProvider = DynamicSectionTitles(dataProvider: dataProvider,
                                                               generateSectionFooterTitle: { (element, _) in element })
        
        //When
        let footer = sectionTitelProvider.titleForFooter(inSection: 0)
        let title = sectionTitelProvider.titleForHeader(inSection: 0)
        let sectionIndexTitles = sectionTitelProvider.sectionIndexTitles
        
        //Then
        XCTAssertEqual(footer, "SectionFooter")
        XCTAssertNil(title)
        XCTAssertNil(sectionIndexTitles)
    }
}
