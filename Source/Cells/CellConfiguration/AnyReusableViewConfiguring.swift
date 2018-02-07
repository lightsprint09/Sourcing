//
//  Copyright (C) 2018 Lukas Schmidt.
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

struct AnyReusableViewConfiguring<View, Object>: ReusableViewConfiguring {
    let type: ReusableViewType
    
    private let configureClosure: (View, IndexPath, Object) -> Void
    
    private let reuseIdentifierClosure: (Object) -> String
    
    init<Config: ReusableViewConfiguring>(_ configuration: Config) where Config.Object == Object {
        self.type = configuration.type
        self.reuseIdentifierClosure = { configuration.reuseIdentifier(for: $0) }
        self.configureClosure = { view, indexPath, object in
            guard let view = view as? Config.View else {
                fatalError()
            }
            configuration.configure(view, at: indexPath, with: object)
        }
    }
    
    func configure(_ view: View, at indexPath: IndexPath, with object: Object) {
        configureClosure(view, indexPath, object)
    }
    
    func reuseIdentifier(for object: Object) -> String {
        return reuseIdentifierClosure(object)
    }
    
}
