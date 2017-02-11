//
//  BasicCellConfiguration.swift
//  Sourcing
//
//	Legal Notice! DB Systel GmbH proprietary License!
//
//	Copyright (C) 2015 DB Systel GmbH
//	DB Systel GmbH; Jürgen-Ponto-Platz 1; D-60329 Frankfurt am Main; Germany; http://www.dbsystel.de/

//	This code is protected by copyright law and is the exclusive property of
//	DB Systel GmbH; Jürgen-Ponto-Platz 1; D-60329 Frankfurt am Main; Germany; http://www.dbsystel.de/

//	Consent to use ("licence") shall be granted solely on the basis of a
//	written licence agreement signed by the customer and DB Systel GmbH. Any
//	other use, in particular copying, redistribution, publication or
//	modification of this code without written permission of DB Systel GmbH is
//	expressly prohibited.

//	In the event of any permitted copying, redistribution or publication of
//	this code, no changes in or deletion of author attribution, trademark
//	legend or copyright notice shall be made.
//
//  Created by Lukas Schmidt on 10.02.17.
//

import UIKit

public struct BasicCellConfiguration<CellToConfigure, ObjectOfCell>: CellDequeable, StaticCellDequeable {
    public typealias Cell = CellToConfigure
    public typealias Object = ObjectOfCell
    
    public let cellIdentifier: String
    public let nib: UINib?
    let configuration: (Object, Cell) -> Void
    let additionalConfiguartion: ((Object, Cell) -> Void)?
    
    public init(cellIdentifier: String, configuration: @escaping (Object, Cell) -> Void,
                nib: UINib? = nil, additionalConfiguartion: ((Object, Cell) -> Void)? = nil) {
        self.cellIdentifier = cellIdentifier
        self.configuration = configuration
        self.nib = nib
        self.additionalConfiguartion = additionalConfiguartion
    }
    
    public func configure(_ cell: AnyObject, with object: Any) -> AnyObject {
        if let object = object as? Object, let cell = cell as? Cell {
            configuration(object, cell)
            additionalConfiguartion?(object, cell)
        }
        return cell
    }
}
