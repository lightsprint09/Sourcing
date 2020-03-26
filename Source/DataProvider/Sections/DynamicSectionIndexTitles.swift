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

/** 
 Generates section index titles by fetching the first
 element of a section and transforms it with a given closure into a section index titles.
 
 **Example**
 ```swift
 //A data provider with multiple sections. Each section contains trains from a single type
 let dataProvider: ArrayDataProvider<Train> = //
 
 //Use type name as a section header and shortname as a section index title.
 let sectionTitleProvider = DynamicSectionIndexTitles(dataProvider: dataProvider,
                                generateSectionIndexTitle: { train, _ in return train.type.shortName })
 ```
 
 */
public final class DynamicSectionIndexTitles: SectionIndexTitles {
    /**
     Section Index Titles for `UITableView`. Related to `UITableViewDataSource` method `sectionIndexTitlesForTableView`
     */
    public var sectionIndexTitles: [String]? {
        return indexSectionTitles()
    }
    
    private let generateSectionIndexTitle: (Int) -> String
    private let getNumberOfSections: () -> Int
    private let indexPathForSectionTitel: (_ section: Int) -> IndexPath
    
    /// Creates a `DynamicHeaderTitlesProvider`.
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider used as source for header titles.
    ///   - generateSectionIndexTitle: a closure to transform a Element which is part of the
    ///     data provider into a single String, which is used as a section index titles.
    public init<D: DataProvider>(dataProvider: D,
                                 generateSectionIndexTitle: @escaping (D.Element, IndexPath) -> String,
                                 using element: SectionMetaData.SectionMetaDataElement) {
            self.generateSectionIndexTitle = { section -> String in
                let item = element.elementIndex(with: dataProvider, inSection: section)
                let indexPath = IndexPath(item: item, section: section)
                
                return generateSectionIndexTitle(dataProvider.object(at: indexPath), indexPath)
            }
            self.getNumberOfSections = { dataProvider.numberOfSections() }
            self.indexPathForSectionTitel = { IndexPath(item: element.elementIndex(with: dataProvider, inSection: $0), section: $0) }
    }
    
    /// Asks the data provider to return the index of the section having the given title and section title index.
    ///
    /// - Parameters:
    ///   - sectionIndexTitle: The title as displayed in the section index
    ///   - index: An index number identifying a section title in the array returned by `sectionIndexTitles`
    /// - Returns: An index number identifying a section.
    public func indexPath(forSectionIndexTitle sectionIndexTitle: String,
                   at index: Int) -> IndexPath {
        return indexPathForSectionTitel(index)
    }
    
    private func indexSectionTitles() -> [String]? {
        let allSections = 0..<getNumberOfSections()
        
        return allSections.map(generateSectionIndexTitle)
    }
}
