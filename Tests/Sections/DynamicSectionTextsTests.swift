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

class DynamicSectionTextsTests: XCTestCase {
    
    func testGenerateHeaderTitleIfNoContent() {
        //Given
        let dataProvider = ArrayDataProvider<String>(rows: [])
        
        let sectionTitelProvider = DynamicSectionTexts(dataProvider: dataProvider,
                                                       sectionTextWithElement: { string, _ in return  string },
                                                       using: .firstElementInSection)
        
        //When
        let title = sectionTitelProvider.text(inSection: 0)
        
        //Then
        XCTAssertNil(title)
    }
    
    func testGenerateHeaderTitleWithFirstElement() {
        //Given
        let dataProvider = ArrayDataProvider(rows: ["SectionTitle"])
        let sectionTitelProvider = DynamicSectionTexts(dataProvider: dataProvider,
                                                       sectionTextWithElement: { string, _ in return  string },
                                                       using: .firstElementInSection)
        
        //When
        let title = sectionTitelProvider.text(inSection: 0)
        
        //Then
        XCTAssertEqual(title, "SectionTitle")
    }
    
    func testGenerateTextWithLastElement() {
        //Given
        let dataProvider = ArrayDataProvider(rows: ["SectionTitle", "LastSectionTitle"])
        let sectionTitelProvider = DynamicSectionTexts(dataProvider: dataProvider,
                                                       sectionTextWithElement: { string, _ in return  string },
                                                       using: .lastElementInSection)
        
        //When
        let title = sectionTitelProvider.text(inSection: 0)
        
        //Then
        XCTAssertEqual(title, "LastSectionTitle")
    }
    
    func testGenerateHeaderTitleNthLastElement() {
        //Given
        let dataProvider = ArrayDataProvider(rows: ["SectionTitle", "nthSectionTitle", "Last"])
        let sectionTitelProvider = DynamicSectionTexts(dataProvider: dataProvider,
                                                       sectionTextWithElement: { string, _ in return  string },
                                                       using: .nthElementInSection(elementIndex: 1))
        
        //When
        let title = sectionTitelProvider.text(inSection: 0)
        
        //Then
        XCTAssertEqual(title, "nthSectionTitle")
    }
    
    func testGenerateHeaderTitleWithDataProvider() {
        //Given
        let dataProvider = ArrayDataProvider(rows: ["SectionTitle"])
        let sectionTitelProvider = DynamicSectionTexts(dataProvider: dataProvider,
                                                         sectionTextWithDataProvider: { (provider, _) in provider.content.first?.first })
        
        //When
        let title = sectionTitelProvider.text(inSection: 0)
        
        //Then
        XCTAssertEqual(title, "SectionTitle")
    }
}
