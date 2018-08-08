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
 let sectionTitleProvider = DynamicSectionTexts(dataProvider: dataProvider,
 sectionTextWithElement: { train, _ in return train.type.name },
 using: .firstElementInSection)
 ```
 
 */
public final class DynamicSectionTexts: SectionTexts {
    
    private let generateSectionText: (Int) -> String?
    
    /// Creates a `DynamicSectionTexts`.
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider used as source for header titles.
    ///   - sectionTextWithDataProvider: a closure to transform a data provider and a given section index into an optional `String`,
    ///     which is used as a section text.
    public init<D: DataProvider>(dataProvider: D,
                                 sectionTextWithDataProvider: @escaping (D, Int) -> String?) {
            self.generateSectionText = { sectionTextWithDataProvider(dataProvider, $0) }
    }
    
    /// Creates a `DynamicHeaderTitlesProvider`.
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider used as source for header titles.
    ///   - sectionTextWithElement: a closure to transform an Element which is part of
    ///     the data provider into a single `String`, which is used as a section text.
    public convenience init<D: DataProvider>(dataProvider: D,
                                             sectionTextWithElement: @escaping (D.Element, IndexPath) -> String?,
                                             using element: SectionMetdaData.SectionMetdaDataElement) {
            self.init(dataProvider: dataProvider,
                      sectionTextWithDataProvider: { (provider, section) -> String? in
                        let item = element.elementIndex(with: dataProvider, inSection: section)
                        let indexPath = IndexPath(item: item, section: section)
                        return provider.safeAccessToObject(at: indexPath)
                            .flatMap { sectionTextWithElement($0, indexPath) }
            })
    }
    
    /// Generates a optional section title for a given section
    ///
    /// - Parameter section: the section to generate the title for
    /// - Returns: a section header title
    public func text(inSection section: Int) -> String? {
        return generateSectionText(section)
    }
    
}
