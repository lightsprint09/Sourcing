//
//  Copyright (C) 2016 Lukas Schmidt.
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
//  AssertionsDeclaration.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 25.08.16.
//

import Foundation

/// Stores custom assertions closures, by default it points to Swift functions. But test target can override them.
class Assertions {
    
    static var assertClosure = swiftAssertClosure
    static var assertionFailureClosure = swiftAssertionFailureClosure
    static var preconditionClosure = swiftPreconditionClosure
    static var preconditionFailureClosure = swiftPreconditionFailureClosure
    static var fatalErrorClosure = swiftFatalErrorClosure
    
    static let swiftAssertClosure              = { Swift.assert($0, $1, file: $2, line: $3) }
    static let swiftAssertionFailureClosure    = { Swift.assertionFailure($0, file: $1, line: $2) }
    static let swiftPreconditionClosure        = { Swift.precondition($0, $1, file: $2, line: $3) }
    static let swiftPreconditionFailureClosure = { Swift.preconditionFailure($0, file: $1, line: $2) }
    static let swiftFatalErrorClosure          = { Swift.fatalError($0, file: $1, line: $2) }
}