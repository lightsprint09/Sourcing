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

/** 
 Generates section header titles and section index titles by fetching the first
 element of a section and transforms it with a given closure into  header titles & section index titles.
 
 **Example**
 ```swift
 //A data provider with multiple sections. Each section contains trains from a single type
 let dataProvider: ArrayDataPrvoider<Train> = //
 
 //Use type name as a section header and shortname as a section index title.
 let sectionTitleProvider = DynamicSectionTitleProvider<Train>(dataProvider: dataProvider,
                                generateSectionHeaderTitle: { train, _ in return train.type.name }, 
                                generateSectionIndexTitle: { train, _ in return train.type.shortName })
 ```
 
 */
public final class DynamicSectionTitleProvider<Element>: SectionTitleProviding {
    /**
     Section Index Titles for `UITableView`. Related to `UITableViewDataSource` method `sectionIndexTitlesForTableView`
     */
    public var sectionIndexTitles: [String]? {
        return indexSectionTitles()
    }
    
    private let dataProvider: AnyDataProvider<Element>
    private let generateSectionHeaderTitle: (Element, IndexPath) -> String?
    private let generateSectionFooterTitle: (Element, IndexPath) -> String?
    private let generateSectionIndexTitle: ((Element, IndexPath) -> String)?
    
    /// Creates a `DynamicHeaderTitlesProvider`.
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider used as source for header titles.
    ///   - generateSectionHeaderTitles: a closure to transform a Element which is part of
    ///     the data provider into a single String, which is used as a section header titles.
    ///   - generateSectionFooterTitle: a closure to transform a Element which is part of
    ///     the data provider into a single String, which is used as a section footer titles.
    ///   - generateSectionIndexTitle: a closure to transform a Element which is part of the
    ///     data provider into a single String, which is used as a section index titles.
    public init<DataProvider: DataProviding>(dataProvider: DataProvider, generateSectionHeaderTitle: @escaping (Element, IndexPath) -> String? = { _, _ in return nil },
                                             generateSectionFooterTitle: @escaping (Element, IndexPath) -> String? = { _, _ in return nil },
                generateSectionIndexTitle: ((Element, IndexPath) -> String)? = nil) where DataProvider.Element == Element {
        self.dataProvider = AnyDataProvider(dataProvider)
        self.generateSectionHeaderTitle = generateSectionHeaderTitle
        self.generateSectionFooterTitle = generateSectionFooterTitle
        self.generateSectionIndexTitle = generateSectionIndexTitle
    }
    
    /// Generates a optional section title for a given section.
    ///
    /// - Parameter section: the section to generate the title for.
    /// - Returns: a section header title.
    public func titleForHeader(inSection section: Int) -> String? {
        let indexPath = IndexPath(item: 0, section: section)
        let firstObjectInSection = dataProvider.object(at: indexPath)
        
        return generateSectionHeaderTitle(firstObjectInSection, indexPath)
    }
    
    /// Generates a optional section footer for a given section
    ///
    /// - Parameter section: the section to generate the title for
    /// - Returns: a section footer title
    public func titleForFooter(inSection section: Int) -> String? {
        let indexPath = IndexPath(item: 0, section: section)
        let firstObjectInSection = dataProvider.object(at: indexPath)
        
        return generateSectionFooterTitle(firstObjectInSection, indexPath)
    }
    
    private func indexSectionTitles() -> [String]? {
        guard let generateSectionIndexTitle = generateSectionIndexTitle else {
            return nil
        }
        let allSections = 0..<dataProvider.numberOfSections()
        
        return allSections.map {
            let indexPath = IndexPath(item: 0, section: $0)
            let firstObjectInSection = dataProvider.object(at: indexPath)
            
            return generateSectionIndexTitle(firstObjectInSection, indexPath)
        }
    }
}
