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
 Generates section texts by fetching the first element of a section and
 transforms it with a given closure into section texts.
 
 **Example**
 ```swift
 //A data provider with multiple sections. Each section contains trains from a single type
 let dataProvider: ArrayDataProvider<Train> = //
 
 //Use type name as a section header and shortname as a section index title.
 let sectionTitleProvider = DynamicSectionHeaders(dataProvider: dataProvider,
 sectionTextWithElement: { train, _ in return train.type.name },
 using: .firstElementInSection)
 ```
 
 */
public final class DynamicSectionTexts<Element>: SectionTexts {
    
    /// Determines which element of the given data provider will be used
    /// to transform into section header & footer.
    public enum SectionHeaderFooterSource {
        /// Uses the first element in the section
        case firstElementInSection
        /// Uses the last element in the section
        case lastElementInSection
        /// Uses the given nth element in the section.
        case nthElementInSection(elementIndex: Int)
        
        fileprivate func elementIndex<D: DataProvider>(with dataProvider: D, inSection section: Int) -> Int {
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
    
    private let generateSectionText: (Int) -> String?
    
    /// Creates a `DynamicSectionTexts`.
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider used as source for header titles.
    ///   - sectionTextWithDataProvider: a closure to transform a data provider and a given section index into an optional `String`,
    ///     which is used as a section text.
    public init<D: DataProvider>(dataProvider: D,
                                 sectionTextWithDataProvider: @escaping (D, Int) -> String?)
        where D.Element == Element {
            self.generateSectionText = { sectionTextWithDataProvider(dataProvider, $0) }
    }
    
    /// Creates a `DynamicHeaderTitlesProvider`.
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider used as source for header titles.
    ///   - sectionTextWithElement: a closure to transform an Element which is part of
    ///     the data provider into a single `String`, which is used as a section text.
    public convenience init<D: DataProvider>(dataProvider: D,
                                             sectionTextWithElement: @escaping (Element, IndexPath) -> String?,
                                             using element: SectionHeaderFooterSource)
                                                where D.Element == Element {
                                                    
                                                    self.init(dataProvider: dataProvider,
                                                              sectionTextWithDataProvider: { (provider, section) -> String? in
                    let indexPath = IndexPath(item: element.elementIndex(with: dataProvider, inSection: section), section: section)
                    return provider.safeAccessToObject(at: indexPath)
                        .flatMap { sectionTextWithElement($0, indexPath) }
        })
    }
    
    public func text(inSection section: Int) -> String? {
        return generateSectionText(section)
    }
    
}
