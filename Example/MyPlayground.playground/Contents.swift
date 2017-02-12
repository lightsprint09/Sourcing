//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import Sourcing

let str = "hello"


struct Train {
    var id: String
    var title: String
}

class TrainCell: UITableViewCell, ConfigurableCell {
    typealias DataSource = Train
    var titleLabel: UILabel!
    
    func configure(with noteBook: DataSource) {
        titleLabel.text = noteBook.title
    }
    
}

class MyViewController: UIViewController, UITableViewDataSource {
    typealias DataProvider = ArrayDataProvider<Train>
    typealias CellConfig = CellConfiguration<TrainCell>
    let trainCellConfiguration = CellConfig(cellIdentifier: "TrainCell")
    var dataProvider: DataProvider!
    var dataSource: TableViewDataSource<DataProvider, CellConfig>!
    var trains: Array<Train> = []
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        for i in 0..<6 {
            trains.append(Train(id: "ID\(i)", title: "TEST \(i)"))
        }
        dataProvider = ArrayDataProvider(rows: trains, dataProviderDidUpdate: { [weak self] updates in
            self?.dataSource.processUpdates(updates)
        })
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cellDequable: trainCellConfiguration)
    }
    
    private func addTableView() {
        view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.register(TrainCell.self, forCellReuseIdentifier: "TrainCell")
        view.addSubview(tableView)
    }
    
}
var ctrl = MyViewController()
PlaygroundPage.current.liveView = ctrl.view


