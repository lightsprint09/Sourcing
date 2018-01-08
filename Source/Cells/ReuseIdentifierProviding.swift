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
//
//  CellIdentifierProviding.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 24.01.17.
//

/// By implementing this the cell provides its reuse identifiere.
public protocol ReuseIdentifierProviding {
    /// Reuse Indentifier of the cell
    static var reuseIdentifier: String { get }
}

public extension ReuseIdentifierProviding {
    
    /// Reuse Indentifier of the cell which defaults to the classname.
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
#if os(iOS) || os(tvOS)
    extension BasicSupplementaryViewConfiguration where View: ReuseIdentifierProviding {
        
        public init(elementKind: String, nib: UINib? = nil, configuration: ((View, IndexPath, Object) -> Void)? = nil) {
            self.init(elementKind: elementKind, reuseIdentifier: View.reuseIdentifier, nib: nib, configuration: configuration)
        }
    }
    
    extension BasicCellConfiguration where CellToConfigure: ReuseIdentifierProviding {
        public init(configuration: @escaping (Object, Cell) -> Void, nib: UINib? = nil) {
            self.init(reuseIdentifier: CellToConfigure.reuseIdentifier, nib: nib, configuration: configuration)
        }
    }
#else
    extension BasicCellConfiguration where CellToConfigure: ReuseIdentifierProviding {
        public init(configuration: @escaping (Object, Cell) -> Void) {
            self.init(reuseIdentifier: CellToConfigure.reuseIdentifier, configuration: configuration)
        }
    }
#endif
