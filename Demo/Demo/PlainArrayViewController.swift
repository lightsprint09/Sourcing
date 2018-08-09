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
    func configure(with train: Train) {
        textLabel?.text = train.name
    }
}

class StationCell: UITableViewCell, ConfigurableCell, ReuseIdentifierProviding {
    func configure(with station: Station) {
        textLabel?.text = station.name
        detailTextLabel?.text = "\(station.distance)"
        contentView.backgroundColor = .red
    }
}

struct Station {
    let name: String
    let distance: Int
}

struct Train {
    let name: String
}

enum JourneyItem {
    case train(Train)
    case station(Station)
}

struct JourneyCellConfiguration: ReusableViewConfiguring {
    let type: ReusableViewType = .cell
    
    let nib: UINib?
    
    func configure(_ cell: UITableViewCell, at indexPath: IndexPath, with item: JourneyItem) {
        switch (item, cell) {
        case (.station(let station), let cell as StationCell):
            cell.configure(with: station)
            
        case (.train(let train), let cell as TrainCell):
            cell.configure(with: train)
        case (_, _):
            fatalError("Missing cell Type")
        }
    }
    
    func reuseIdentifier(for item: JourneyItem) -> String {
        switch item {
        case .station:
            return "StationCell"
        case .train:
            return "TrainCell"
        }
    }
}

class PlainArrayViewController: UITableViewController {

    var dataProvider = ArrayDataProvider<JourneyItem>(rows: [.station(Station(name: "Frankfurt", distance: 200)),
                                                        .train(Train(name: "ICE 4")), .station(Station(name: "Frankfurt", distance: 200))])
    var dataModificator: ArrayDataProviderModifier<JourneyItem>!
    var dataSource: TableViewDataSource<JourneyItem>!
    var dataSourceChangeAnimator: TableViewChangesAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StationCell.self, forCellReuseIdentifier: "StationCell")
        
        let cellConfig = JourneyCellConfiguration(nib: nil)
        dataModificator = ArrayDataProviderModifier(dataProvider: dataProvider, canMoveItems: true, canEditItems: true)
        dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: cellConfig)
        tableView.dataSource = dataSource
        
        dataSourceChangeAnimator = TableViewChangesAnimator(tableView: tableView, observable: dataProvider.observable)
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Hallo", handler: { [unowned self] _, indexPath in
            self.dataModificator.deleteItem(at: indexPath)
        })
        return [action]
    }

}
