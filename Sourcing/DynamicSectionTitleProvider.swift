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
 //A DataProvider with multiple sections. Each section contains trains from a single type
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
        let allSections = (0..<dataProvider.numberOfSections())
        
        return allSections.map { indexTitle(inSection: $0) }.flatMap { $0 }
    }
    
    private let dataProvider: AnyDataProvider<Element>
    private let generateSectionHeaderTitle: (Element, IndexPath) -> String?
    private let generateSectionIndexTitle: (Element, IndexPath) -> String?
    
    /// Creates a `DynamicHeaderTitlesProvider`.
    ///
    /// - Parameters:
    ///   - dataProvider: the DataProvider used as source for header titles.
    ///   - generateSectionHeaderTitles: a closure to transform a Element which is part of
    ///     the DataProvider into a single String, which is used as a section header titles.
    ///   - generateSectionIndexTitle: a closure to transform a Element which is part of the
    ///     DataProvider into a single String, which is used as a section index titles.
    public init<DataProvider: DataProviding>(dataProvider: DataProvider, generateSectionHeaderTitle: @escaping (Element, IndexPath) -> String?,
                generateSectionIndexTitle: @escaping (Element, IndexPath) -> String?) where DataProvider.Element == Element {
        self.dataProvider = AnyDataProvider(dataProvider)
        self.generateSectionHeaderTitle = generateSectionHeaderTitle
        self.generateSectionIndexTitle = generateSectionIndexTitle
    }
    
    /// Creates a `DynamicHeaderTitlesProvider`.
    ///
    /// - Parameters:
    ///   - dataProvider: the DataProvider used as source for header titles.
    ///   - generateSectionHeaderTitles: a closure to transform a Element which is part of the DataProvider into
    ///     a single String, which is used as a section header titles.
    ///   - sectionIndexTitles: all section index titles.
    public convenience init<DataProvider: DataProviding>(dataProvider: DataProvider, generateSectionHeaderTitle: @escaping (Element, IndexPath) -> String?,
                            sectionIndexTitles: [String]? = nil) where DataProvider.Element == Element {
        self.init(dataProvider: dataProvider, generateSectionHeaderTitle: generateSectionHeaderTitle,
                  generateSectionIndexTitle: { sectionIndexTitles?[$1.section] })
    }
    
    /// Creates a `DynamicHeaderTitlesProvider`.
    ///
    /// - Parameters:
    ///   - dataProvider: the DataProvider used as source for header titles.
    ///   - sectionHeaderTitles: all titles used in section headers.
    ///   - generateSectionIndexTitle: a closure to transform a Element which is part of the DataProvider
    ///     into a single String, which is used as a section index titles.
    public convenience init<DataProvider: DataProviding>(dataProvider: DataProvider, sectionHeaderTitles: [String]? = nil,
                            generateSectionIndexTitle: @escaping (Element, IndexPath) -> String?) where DataProvider.Element == Element {
        self.init(dataProvider: dataProvider, generateSectionHeaderTitle: { sectionHeaderTitles?[$1.section] },
                  generateSectionIndexTitle: generateSectionIndexTitle)
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
    
    private func indexTitle(inSection section: Int) -> String? {
        let indexPath = IndexPath(item: 0, section: section)
        let firstObjectInSection = dataProvider.object(at: indexPath)
        
        return generateSectionIndexTitle(firstObjectInSection, indexPath)
    }
}
