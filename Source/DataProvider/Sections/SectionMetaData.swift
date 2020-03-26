//
//  Copyright (C) 2018 Lukas Schmidt.
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

/// Encapsulates all informaton and meta data one can provide related to sections.
public struct SectionMetaData {
    
    /// The section index titles.
    public let indexTitles: SectionIndexTitles?
    
    /// The section headers.
    public let headerTexts: SectionTexts?
    
     /// The section footers.
    public let footerTexts: SectionTexts?
    
    /// Creates an instace of `SectionMetaData`
    ///
    /// - Parameters:
    ///   - indexTitles: The section index titles. Defaults to `nil`.
    ///   - headerTexts: The section headers. Defaults to `nil`.
    ///   - footerTexts: The section footers. Defaults to `nil`.
    public init(indexTitles: SectionIndexTitles? = nil, headerTexts: SectionTexts? = nil, footerTexts: SectionTexts? = nil) {
        self.indexTitles = indexTitles
        self.headerTexts = headerTexts
        self.footerTexts = footerTexts
    }
    
    /// Determines which element of the given data provider will be used
    /// to transform into section meta data.
    public enum SectionMetaDataElement {
        /// Uses the first element in the section
        case firstElementInSection
        /// Uses the last element in the section
        case lastElementInSection
        /// Uses the given nth element in the section.
        case nthElementInSection(elementIndex: Int)
        
        func elementIndex<D: DataProvider>(with dataProvider: D, inSection section: Int) -> Int {
            switch self {
            case .firstElementInSection:
                return 0
            case .lastElementInSection:
                return dataProvider.numberOfItems(inSection: section) - 1
            case .nthElementInSection(let elementIndex):
                return elementIndex
            }
        }
    }
}
