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


/// Generates section header titles by fetching the first element of a section and transforms it with a given closure into a header titles.
public final class DynamicSectionTitleProvider<Element>: SectionTitleProviding {
    /**
     Section Index Titles for `UITableView`. Related to `UITableViewDataSource` method `sectionIndexTitlesForTableView`
     */
    public let sectionIndexTitles: [String]?
    
    private let dataProvider: AnyDataProvider<Element>
    private let generateSectionHeaderTitles: (Element) -> String?
    
    
    /// Creates a `DynamicHeaderTitlesProvider`.
    ///
    /// - Parameters:
    ///   - dataProvider: the DataProvider used as source for header titles
    ///   - generateSectionHeaderTitles: a closure to transform a Element which is part of the DataProvider into a single String, which is used as a section header titles
    ///   - sectionIndexTitles: all section index titles
    public init<DataProvider: DataProviding>(dataProvider: DataProvider, generateSectionHeaderTitles: @escaping (Element) -> String?, sectionIndexTitles: [String]? = nil) where DataProvider.Element == Element {
        self.dataProvider = AnyDataProvider(dataProvider)
        self.sectionIndexTitles = sectionIndexTitles
        self.generateSectionHeaderTitles = generateSectionHeaderTitles
    }
    
    /// Generates a optional section title for a given section
    ///
    /// - Parameter section: the section to generate the title for
    /// - Returns: a section header title
    public func titleForHeader(inSection section: Int) -> String? {
        let indexPath = IndexPath(item: 0, section: section)
        let firstObjectInSection = dataProvider.object(at: indexPath)
        
        return generateSectionHeaderTitles(firstObjectInSection)
    }
}
