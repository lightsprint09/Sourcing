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

class StaticSectionTitleProviderTest: XCTestCase {
    
    func testStaticIndexTitles() {
        //Given
        let sectionIndexTitles = ["SectionIndexTitle"]
        let sectionTitelProvider = StaticSectionTitlesProvider(sectionIndexTitles: sectionIndexTitles)
        
        //When
        let resultingSectionIndexTitles = sectionTitelProvider.sectionIndexTitles
        
        //Then
        XCTAssertEqual(resultingSectionIndexTitles ?? [], sectionIndexTitles)
    }
    
    func testStaticTitleForHeader() {
        //Given
        let headerTiltes = ["SectionIndexTitle"]
        let sectionTitelProvider = StaticSectionTitlesProvider(sectionHeaderTitles: headerTiltes)
        
        //When
        let headerTitle = sectionTitelProvider.titleForHeader(inSection: 0)
        
        //Then
        XCTAssertEqual(headerTitle, "SectionIndexTitle")
    }
    
    func testStaticFooterForHeader() {
        //Given
        let headerTiltes = ["SectionFooterTitle"]
        let sectionTitelProvider = StaticSectionTitlesProvider(sectionFooterTitles: headerTiltes)
        
        //When
        let footerTitle = sectionTitelProvider.titleForFooter(inSection: 0)
        
        //Then
        XCTAssertEqual(footerTitle, "SectionFooterTitle")
    }
    
    func testSectionForSectionIndexTitle() {
        //Given
        let headerTiltes = ["SectionFooterTitle"]
        let sectionTitelProvider = StaticSectionTitlesProvider(sectionFooterTitles: headerTiltes)
        
        //When
        let indexPath = sectionTitelProvider.indexPath(forSectionIndexTitle: "SectionFooterTitle", at: 0)
        
        //Then
        XCTAssertEqual(indexPath.section, 0)
    }
}
