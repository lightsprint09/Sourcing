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

/// `DataProviderSwitcher` allows switching between different DataProviders dynamically by changing to a given state.
public class DataProviderSwitcher<State: Equatable, Object>: DataProviding {
    public var state: State {
        didSet {
            //whenDataProviderChanged?(nil)
        }
    }
    private let dataProviderResolver: (State) -> AnyDataProvider<Object>
    
    var currentDataProvider: AnyDataProvider<Object> {
        return dataProviderResolver(state)
    }
    
    public init(initialState: State, resolve: @escaping (State) -> AnyDataProvider<Object>) {
        self.state = initialState
        self.dataProviderResolver = resolve
    }
    
    public func object(at indexPath: IndexPath) -> Object {
        return currentDataProvider.object(at: indexPath)
    }
    
    public func numberOfSections() -> Int {
        return currentDataProvider.numberOfSections()
    }
    
    public func numberOfItems(inSection section: Int) -> Int {
        return currentDataProvider.numberOfItems(inSection: section)
    }
}
