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
    func configure(with train: DataSource) {
        self.textLabel?.text = train.title
    }
}

class TableViewController: UITableViewController {
    let trainCellConfiguration = CellConfiguration<TrainCell>(cellIdentifier: "TrainCell")
    var dataProvider: ArrayDataProvider<Train>!
    var dataSource: TableViewDataSource<Train>!
    var trains: Array<Train> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TrainCell.self, forCellReuseIdentifier: "TrainCell")
        for i in 0..<20 {
            trains.append(Train(id: "ID\(i)", title: "Train \(i)"))
        }
        dataProvider = ArrayDataProvider(rows: trains)
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cell: trainCellConfiguration)
    }
}

var tableViewController = TableViewController()
tableViewController.title = "Trains"
let navigationController = UINavigationController(rootViewController: tableViewController)
PlaygroundPage.current.liveView = navigationController.view