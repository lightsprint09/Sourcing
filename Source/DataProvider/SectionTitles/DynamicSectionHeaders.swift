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
 Generates section header titles and section footer titles by fetching the first
 element of a section and transforms it with a given closure into header titles & footer titles.
 
 **Example**
 ```swift
 //A data provider with multiple sections. Each section contains trains from a single type
 let dataProvider: ArrayDataProvider<Train> = //
 
 //Use type name as a section header and shortname as a section index title.
 let sectionTitleProvider = DynamicSectionHeaders<Train>(dataProvider: dataProvider,
 generateSectionHeaderTitle: { train, _ in return train.type.name },
 generateSectionFooterTitle: { train, _ in return train.type.description })
 ```
 
 */
public final class DynamicSectionHeaders<Element>: SectionHeaders {
    
    public enum GernatorElement {
        case firstElementInSection
        case lastElementInSection
        case nthElementInSection(elementIndex: Int)
        
        func elementIndex<D: DataProvider>(with dataProvider: D, inSection section: Int) -> Int {
            switch self {
            case .firstElementInSection:
                return 0
            case .lastElementInSection:
                return dataProvider.numberOfItems(inSection: section)
            case .nthElementInSection(let elementIndex):
                return elementIndex
            }
        }
    }
    
    private let generateSectionHeaderTitle: (Int) -> String?
    private let generateSectionFooterTitle: (Int) -> String?
    
    /// Creates a `DynamicHeaderTitlesProvider`.
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider used as source for header titles.
    ///   - generateSectionHeaderTitles: a closure to transform a data provider and a given section index into a `String`,
    ///     which is used as a section header titles.
    ///     Defaults to a closure which generates `nil` values.
    ///   - generateSectionFooterTitle: a closure to transform a data provider and a given section index into a `String`,
    ///     which is used as a section footer titles.
    ///     Defaults to a closure which generates `nil` values.
    public init<D: DataProvider>(dataProvider: D,
                                 sectionHeaderTitleWithDataProvider: @escaping (D, Int) -> String? = { _, _ in nil },
                                 sectionFooterTitleWithDataProvider: @escaping (D, Int) -> String? = { _, _ in nil })
        where D.Element == Element {
            self.generateSectionHeaderTitle = { sectionHeaderTitleWithDataProvider(dataProvider, $0) }
            self.generateSectionFooterTitle = { sectionFooterTitleWithDataProvider(dataProvider, $0) }
    }
    
    /// Creates a `DynamicHeaderTitlesProvider`.
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider used as source for header titles.
    ///   - generateSectionHeaderTitles: a closure to transform a Element which is part of
    ///     the data provider into a single String, which is used as a section header titles.
    ///     Defaults to a closure which generates `nil` values.
    ///   - generateSectionFooterTitle: a closure to transform a Element which is part of
    ///     the data provider into a single String, which is used as a section footer titles.
    ///     Defaults to a closure which generates `nil` values.
    public convenience init<D: DataProvider>(dataProvider: D,
                                             generateSectionHeaderTitle: @escaping (Element, IndexPath) -> String? = { _, _ in nil },
                                             generateSectionFooterTitle: @escaping (Element, IndexPath) -> String? = { _, _ in nil },
                                             using element: GernatorElement)
                                                where D.Element == Element {
                                                    
                                                    self.init(dataProvider: dataProvider,
                                                              sectionHeaderTitleWithDataProvider: { (provider, section) -> String? in
                    let indexPath = IndexPath(item: element.elementIndex(with: dataProvider, inSection: section), section: section)
                    return provider.safeAccessToObject(at: indexPath)
                        .flatMap { generateSectionHeaderTitle($0, indexPath) }
        }, sectionFooterTitleWithDataProvider: { (provider, section) -> String? in
            let indexPath = IndexPath(item: element.elementIndex(with: dataProvider, inSection: section), section: section)
            return provider.safeAccessToObject(at: indexPath)
                .flatMap { generateSectionFooterTitle($0, indexPath) }
        })
    }
    
    /// Generates a optional section title for a given section.
    ///
    /// - Parameter section: the section to generate the title for.
    /// - Returns: a section header title.
    public func titleForHeader(inSection section: Int) -> String? {
        return generateSectionHeaderTitle(section)
    }
    
    /// Generates a optional section footer for a given section
    ///
    /// - Parameter section: the section to generate the title for
    /// - Returns: a section footer title
    public func titleForFooter(inSection section: Int) -> String? {
        return generateSectionFooterTitle(section)
    }
    
}

fileprivate extension DataProvider {
    func safeAccessToObject(at indexPath: IndexPath) -> Element? {
        let numberOfItemsInSection = numberOfItems(inSection: indexPath.section)
        guard numberOfSections() > indexPath.section, numberOfItemsInSection > indexPath.row else {
            return nil
        }
        
        return object(at: indexPath)
    }
}
