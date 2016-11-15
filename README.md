[![Build Status](https://travis-ci.org/lightsprint09/Sourcing.svg?branch=master)](https://travis-ci.org/lightsprint09/Sourcing)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Sourcing

|           | Main Features                  |
| --------- | ------------------------------ |
| 🛡        | Typesave when using a single data type       |
| 🐍 | Less typesafe, but flexible when displaying different data types |
| 🚄        | Extendable API                 |
| &#9989;   | Fully unit tested              |

Typesafe and flexible abstraction for TableView &amp; CollectionView DataSources written in Swift.

## Usage

Setting up your TableViewCell by implementing `ConfigurableCell`. This works for CollectionViewCells as well. Creating a typed configuartion `CellConfiguration` object for your cell with a given resue identifier or with a nib. You can do additional configuration by providing a configuration closure to to some setup.
```swift
import Sourcing

class TrainCell: UITableViewCell, ConfigurableCell {
   @IBOutlet var nameLabel: UILabel!
   
   func configure(with train: Train) {
      nameLabel.text = train.name
   }
}

let cellConfiguration = CellConfiguration<TrainCell>(cellIdentifier: "YourReuseID")

```

Create an data provider. Use the default `ArrayDataProvider`or implement you own custom dataprovider, eg with network capabilities.
```swift
let trains: Array<Train> = //
let dataProvider: ArrayDataProvider<Train> = ArrayDataProvider(rows: trains)
```
Bring your data and your cell configuration together by creating a `TableViewDataSource` object.
```swift
let tableView: UITableView = //...
let dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cellDequable: cellConfiguration)
```

