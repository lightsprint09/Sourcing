[![Build Status](https://travis-ci.org/lightsprint09/Sourcing.svg?branch=master)](https://travis-ci.org/lightsprint09/Sourcing)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Sourcing

|           | Main Features                  |
| --------- | ------------------------------ |
| 🛡        | Typesave when using a homogeneous data type       |
| 🐍 | Less typesafe, but flexible when displaying heterogeneous data types |
| 🚄        | Extendable API                 |
| &#9989;   | Fully unit tested              |

Typesafe and flexible abstraction for TableView &amp; CollectionView DataSources written in Swift.

## Usage
### Homogeneous data types
Setting up your TableViewCell by implementing `ConfigurableCell`. This works for CollectionViewCells as well. Creating a typed configuartion `CellConfiguration` object for your cell with a given resue identifier or with a nib.
```swift
import Sourcing

class TrainCell: UITableViewCell, ConfigurableCell {
   @IBOutlet var nameLabel: UILabel!
   
   func configure(with train: Train) {
      nameLabel.text = train.name
   }
}

let trainCellConfiguration = CellConfiguration<TrainCell>(cellIdentifier: "YourReuseID")

```

Create an data provider. Use the default `ArrayDataProvider`or implement you own custom dataprovider, eg with network capabilities.
```swift
var dataSource: TableViewDataSource<ArrayDataProvider<Train>, CellConfiguration<TrainCell>>?
let trains: Array<Train> = //
let dataProvider: ArrayDataProvider<Train> = ArrayDataProvider(rows: trains, { [ weak self] updates in
                dataSource?.processUpdates(updates)
          })
```
Bring your data and your cell configuration together by creating a `TableViewDataSource` object.
```swift
let tableView: UITableView = //...
dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cellDequable: trainCellConfiguration)
```

### Heterogeneous data types
Create multiple `CellConfiguration`s with diffrent types
```swift
let trainCellConfiguration = CellConfiguration<TrainCell>(cellIdentifier: "YourReuseID")
let stationCellConfiguration = CellConfiguration<StationCell>(cellIdentifier: "YourReuseSecondID")
```
Create an loosly typed data provider. Keep in mind that you loos all your compiler support. 
```swift
let data: Array<Any> = //
let dataProvider: ArrayDataProvider<Any> = ArrayDataProvider(rows: data)
```
Again bring your data and your cell configurations together by creating a `MultiCellTableViewDataSource` object.
```swift
let tableView: UITableView = //...
let dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cellDequeables: [trainCellConfiguration, stationCellConfiguration])
```

### Extending Sourcing by creating your own DataProvider.
TBD

## Requirements

- iOS 9.3+
- Xcode 8.0+
- Swift 3.0

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

Specify the following in your `Cartfile`:

```ogdl
github "lightsprint09/sourcing" ~> 1.1
```
## Contributing
Feel free to submit a pull request with new features, improvements on tests or documentation and bug fixes. Keep in mind that we welcome code that is well tested and documented.

## Contact
Lukas Schmidt ([Mail](mailto:lukas.la.schmidt@deutschebahn.com), [@lightsprint09](https://twitter.com/lightsprint09))

## License
Sourcing is released under the MIT license. See LICENSE for details.

