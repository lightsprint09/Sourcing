//
//  ViewController.swift
//  Demo
//
//  Created by Lukas Schmidt on 05.01.18.
//  Copyright © 2018 DBSystel. All rights reserved.
//

import UIKit
import Sourcing

class TrainCell: UITableViewCell, ConfigurableCell, ReuseIdentifierProviding {
    func configure(with trainName: String) {
        textLabel?.text = trainName
    }
}

class PlainArrayViewController: UITableViewController {

    var dataProvider = ArrayDataProvider(sections: [["IC", "ICE"], ["TGV"], ["Eurostar"]])
    var dataModificator: ArrayDataProviderModifier<String>!
    var dataSource: TableViewDataSource<String>!
    var dataSourceChangeAnimator: TableViewChangesAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellConfig = BasicReuseableViewConfiguration<TrainCell, String>()
        dataModificator = ArrayDataProviderModifier(dataProvider: dataProvider, canMoveItems: true, canDeleteItems: true)
        dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: cellConfig, dataModificator: dataModificator)
        tableView.dataSource = dataSource
        tableView.setEditing(true, animated: true)
        
        dataSourceChangeAnimator = TableViewChangesAnimator(tableView: tableView, dataProviderObservable: dataProvider.observable)
        
    }

}
