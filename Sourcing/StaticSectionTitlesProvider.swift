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

import Foundation

public struct StaticSectionTitlesProvider: SectionTitleProviding {
    /// All sectionIndexTitles
    public let sectionIndexTitles: [String]?
    private let sectionHeaderTitles: [String?]?
    
    public init(sectionHeaderTitles: [String?]? = nil, sectionIndexTitles: [String]? = nil) {
        self.sectionHeaderTitles = sectionHeaderTitles
        self.sectionIndexTitles = sectionIndexTitles
    }
    
    /// Generates a optional section title for a given section
    ///
    /// - Parameter section: the section to generate the title for
    /// - Returns: a section header title
    public func titleForHeader(inSection section: Int) -> String? {
        return sectionHeaderTitles?[section]
    }
}
