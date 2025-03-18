//
//  Array+SectionTexts.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 06.08.18.
//  Copyright © 2018 Lukas Schmidt. All rights reserved.
//

import XCTest
import Foundation
import Sourcing


class ArraySectionTexts: XCTestCase {

    @MainActor
    func testStaticTitleForHeader() {
        //Given
        let sectionTexts = ["sectionText"] as [String?]

        //When
        let sectionText = sectionTexts.text(inSection: 0)

        //Then
        XCTAssertEqual(sectionText, "sectionText")
    }

}
