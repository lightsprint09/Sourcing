# Sourcing
Typesafe and flexible abstraction for TableView &amp; CollectionView DataSoruces written in Swift.

## Usage

```swift
import Sourcing

//Your cell needs to confirm to `ConfigurableCell`
class IntegerCell: ConfigurableCell {
   func configureForObject(integer: Int) {
    //Configure your fancy cell.
   }
}

let cellConfiguration = CellConfiguration<IntegerCell<Int>>(cellIdentifier: "YourReuseID")

let dataProvider: ArrayDataProvider<Int> = ArrayDataProvider(sections: [[2], [1, 3]])

let tableView: UITableView = //...
let dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cellDequable: cellConfig)
```

