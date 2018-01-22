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

#if os(iOS) || os(tvOS)
    /// A cell configuration can decide if it can configure a given cell with an object or not. If `true` it can configure the cell with the object.
    /// A configuration can be registered at the collection view / table view with the configurations nib and reuse identifier for later dequeuing.
    ///
    /// - Note: Dequeuing a cell is not part of a configuration.
    /// - SeeAlso: `StaticSupplementaryViewConfiguring`
    /// - SeeAlso: `CellConfiguring`
    public typealias CellConfiguration<Cell: ConfigurableCell> = ReusableViewConfiguration<Cell, Cell.ObjectToConfigure>
#endif
