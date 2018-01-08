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

import XCTest
import UIKit
import Sourcing

class SupplementaryViewMock: UICollectionReusableView {
    
}

class CollectionViewSupplementaryViewTest: XCTestCase {
    var collectionViewMock: UICollectionViewMock!
    let reuseIdentifier = "reuseIdentifier"
    let supplementaryKind = "supplementaryKind"
    let nib = UINib(data: Data(), bundle: nil)
    var supplemenaryViewConfiguration: BasicReuseableViewConfiguration<SupplementaryViewMock, Int>!
    
    override func setUp() {
        super.setUp()
        collectionViewMock = UICollectionViewMock()
        supplemenaryViewConfiguration = BasicReuseableViewConfiguration<SupplementaryViewMock, Int>(reuseIdentifier: reuseIdentifier,
                                                                                                    type: .supplementaryView(kind: supplementaryKind), nib: nib)
    }
    
    func testRegisterMultipleNib() {
        //When
        collectionViewMock.register(reuseableViewConfigurations: [supplemenaryViewConfiguration])
        
        //Then
        XCTAssertEqual(collectionViewMock.registeredReuseableViews.supplementaryViews.count, 1)
        XCTAssertEqual(collectionViewMock.registeredReuseableViews.supplementaryViews[reuseIdentifier]?.0, supplementaryKind)
        XCTAssertNotNil(collectionViewMock.registeredReuseableViews.supplementaryViews[reuseIdentifier]?.1 as Any)
    }
    
    func testRegisterNib() {
        //When
        collectionViewMock.register(reuseableViewConfiguration: supplemenaryViewConfiguration)
        
        //Then
        XCTAssertEqual(collectionViewMock.registeredReuseableViews.supplementaryViews.count, 1)
        XCTAssertEqual(collectionViewMock.registeredReuseableViews.supplementaryViews[reuseIdentifier]?.0, supplementaryKind)
        XCTAssertNotNil(collectionViewMock.registeredReuseableViews.supplementaryViews[reuseIdentifier]?.1 as Any)
    }
}
