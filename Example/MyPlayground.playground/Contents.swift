//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import Sourcing

struct Train {
    var id: String
    var title: String
}

class TrainCell: UITableViewCell, ConfigurableCell {
    typealias DataSource = Train
    
    func configure(with noteBook: DataSource) {
        self.textLabel?.text = noteBook.title
    }
}

class TableViewController: UITableViewController {
    typealias DataProvider = ArrayDataProvider<Train>
    typealias CellConfig = CellConfiguration<TrainCell>
    let trainCellConfiguration = CellConfig(cellIdentifier: "TrainCell")
    var dataProvider: DataProvider!
    var dataSource: TableViewDataSource<DataProvider, CellConfig>!
    var trains: Array<Train> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       tableView.register(TrainCell.self, forCellReuseIdentifier: "TrainCell")
        for i in 0..<6 {
            trains.append(Train(id: "ID\(i)", title: "Train \(i)"))
        }
        dataProvider = ArrayDataProvider(rows: trains, dataProviderDidUpdate: { [weak self] updates in
            self?.dataSource.processUpdates(updates)
        })
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cellDequable: trainCellConfiguration)
    }
}

var tableViewController = TableViewController()
tableViewController.title = "Trains"
let navigationController = UINavigationController(rootViewController: tableViewController)
PlaygroundPage.current.liveView = navigationController.view
