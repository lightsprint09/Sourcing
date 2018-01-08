//
//  Copyright (C) DB Systel GmbH.
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
    import UIKit
    
    public extension UICollectionView {
        
        /**
         Registers a nib object containing a supplementary view with the collection view under a specified identifier.
         
         Before dequeueing any supplementary views, call this method to tell the collection
         view how to create new supplementary views. If a supplementary view of the specified type is not currently in a reuse queue,
         the collection view uses the provided information to create a new supplementary view object automatically.
         
         - parameter supplementaryViewConfiguration: the supplementary views configuration which to register.
         */
        func register<SupplementaryView: SupplementaryViewConfiguring>(supplementaryViewConfiguration: SupplementaryView) {
            register(supplementaryViewConfigurations: [supplementaryViewConfiguration])
        }
        
        /**
         Registers a nib object containing a supplementary view with the collection view under a specified identifier.
         
         Before dequeueing any supplementary views, call this method to tell the collection
         view how to create new supplementary views. If a supplementary view of the specified type is not currently in a reuse queue,
         the collection view uses the provided information to create a new supplementary view object automatically.
         
         - parameter supplementaryViewConfigurations: the list of supplementary views configurations which to register.
         */
        func register<SupplementaryView: SupplementaryViewConfiguring>(supplementaryViewConfigurations: [SupplementaryView]) {
            for supplementaryViewConfiguration in supplementaryViewConfigurations where supplementaryViewConfiguration.nib != nil {
                register(supplementaryViewConfiguration.nib, forSupplementaryViewOfKind: supplementaryViewConfiguration.supplementaryElementKind,
                         withReuseIdentifier: supplementaryViewConfiguration.reuseIdentifier)
            }
        }
        
    }
#endif
