//
//  SectionMetdaData.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 06.08.18.
//  Copyright © 2018 Lukas Schmidt. All rights reserved.
//

public struct SectionMetdaData {
    public let indexTitles: SectionIndexTitles?
    public let headerTexts: SectionTexts?
    public let footerTexts: SectionTexts?
    
    public init(indexTitles: SectionIndexTitles? = nil, headerTexts: SectionTexts? = nil, footerTexts: SectionTexts? = nil) {
        self.indexTitles = indexTitles
        self.headerTexts = headerTexts
        self.footerTexts = footerTexts
    }
}
