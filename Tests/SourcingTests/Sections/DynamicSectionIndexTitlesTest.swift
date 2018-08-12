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

class DynamicSectionIndexTitlesTest: XCTestCase {
    
    func testGenerateSectionIndexTitles() {
        //Given
        let dataProvider = ArrayDataProvider(rows: ["SectionIndexTitle"])
        let sectionTitleProvider = DynamicSectionIndexTitles(dataProvider: dataProvider,
                                                             generateSectionIndexTitle: { element, _ in element },
                                                             using: .firstElementInSection)
        
        //When
        let sectionIndexTitles = sectionTitleProvider.sectionIndexTitles
    
        //Then
        XCTAssertEqual(sectionIndexTitles?.first, "SectionIndexTitle")
    }
    
    func testIndexPathForSectionIndexTitle() {
        //Given
        let indexTitel = "SectionIndexTitle"
        let dataProvider = ArrayDataProvider(rows: [indexTitel])
        let sectionTitleProvider = DynamicSectionIndexTitles(dataProvider: dataProvider,
                                                             generateSectionIndexTitle: { element, _ in element },
                                                             using: .firstElementInSection)
        
        //When
        let indexPath = sectionTitleProvider.indexPath(forSectionIndexTitle: indexTitel, at: 0)
        
        //Then
        XCTAssertEqual(indexPath, IndexPath(row: 0, section: 0))
    }
    
    func testIndexPathForSectionIndexTitleUsingLastElementInSection() {
        //Given
        let dataProvider = ArrayDataProvider(rows: ["A", "B", "C"])
        let sectionTitleProvider = DynamicSectionIndexTitles(dataProvider: dataProvider,
                                                             generateSectionIndexTitle: { element, _ in element },
                                                             using: .lastElementInSection)
        
        //When
        let indexPath = sectionTitleProvider.indexPath(forSectionIndexTitle: "C", at: 0)
        
        //Then
        XCTAssertEqual(indexPath, IndexPath(row: 2, section: 0))
    }
}
