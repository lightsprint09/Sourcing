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

public final class AnyArrayDataProvider<Element>: ArrayDataProviding {
    private let capturedContents: () -> [[Element]]
    private let setWhenDataProviderChanged: (ProcessUpdatesCallback<Element>?) -> Void
    private let getSectionIndexTitles: () -> [String]?
    private let getHeaderTitles: () -> [String]?
    
    public var contents: [[Element]] {
        return capturedContents()
    }
    
    /**
     Closure which gets called, when data inside the provider changes and those changes should be propagated to the datasource.
     
     - warning: Only set this when you are updating the datasource by your own.
     */
    public var whenDataProviderChanged: ProcessUpdatesCallback<Element>? {
        didSet {
            setWhenDataProviderChanged(whenDataProviderChanged)
        }
    }
    
    public var sectionIndexTitles: [String]? {
        return getSectionIndexTitles()
    }
    
    public var headerTitles: [String]? {
        return getHeaderTitles()
    }
    
    public init<DataProvider: ArrayDataProviding>(_ dataProvider: DataProvider) where DataProvider.Element == Element {
        capturedContents = {
            return dataProvider.contents
        }
        whenDataProviderChanged = dataProvider.whenDataProviderChanged
        setWhenDataProviderChanged = { callback in
            dataProvider.whenDataProviderChanged = callback
        }
        getSectionIndexTitles = {
            return dataProvider.sectionIndexTitles
        }
        getHeaderTitles = {
            return dataProvider.headerTitles
        }
    }
}
