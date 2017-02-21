[![Build Status](https://travis-ci.org/lightsprint09/Sourcing.svg?branch=master)](https://travis-ci.org/lightsprint09/Sourcing)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Sourcing

* [Quick Demo](#quick-demo)
* [DataProvider](#dataprovider)
   * [ArrayDataProvider](#arraydataprovider)
   * [FetchedResultsDataProvider](#fetchedresultsdataprovider)
   * [AnyDataProvider](#anydataprovider)
   * [Custom DataProvider](#custom-dataprovider)
* [DataModificator](#datamodificator)
  * [ArrayDataModificator](#arraydatamodificator)
* [DataSource](#datasource)
   * [TableViewDataSource](#tableviewdatasource)
   * [CollectionViewDataSource](#collectionviewdatasource)
   * [Multi Cell DataSources](#multicelldatasource)
* [Cells]
   * [ConfigurableCell]
   * [BasicCellConfiguration]
   * [CellConfiguration]
   * [CellIdentifierProviding]
* [Installation](#installation)

Typesafe and flexible abstraction for TableView &amp; CollectionView DataSources written in Swift.

## Quick Demo
Setting up your Cell by implementing `ConfigurableCell` & `CellIdentifierProviding`.
```swift
import Sourcing

class TrainCell: UITableViewCell, ConfigurableCell {
   @IBOutlet var nameLabel: UILabel!
   
   func configure(with train: Train) {
      nameLabel.text = train.name
   }
}

//If your reuse identifier is the same a the class name
extenion TrainCell: CellIdentifierProviding {}

let trainCell = CellConfiguration<TrainCell>()
let trains: [Train] = //
let dataProvider = ArrayDataProvider(rows: trains)
let dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cell: trainCell)
```
## DataProvider
A DataProvider encaupsulates you data. Use one of the given DataProviders or implement `DataProviding` to create your own DataProvider.

### ArrayDataProvider
`ArrayDataProvider<Element>` wraps  `Array<Element>` to an DataProvider.

```swift
let trains: [[Train]] = //
let dataProvider = ArrayDataProvider(sections: trains, sectionIndexTitles: ["German", "French"])
```

### FetchedResultsDataProvider
`FetchedResultsDataProvider<Element>` takes a FetchedResultsController and provides a DataProvider for it.

```swift
let trains: NSFetchrequest<CDTrain> = //
let fetchedResultsController: NSFetchedResultsController<CDTrain> = //
let dataProvider = FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController)
```

### AnyDataProvider
`AnyDataProvider<Element>` is a Type Eraser (http://chris.eidhof.nl/post/type-erasers-in-swift/) for DataProvider. This can be usefull if you want to put diffrent DataProviders in a Container.

```swift
let fetchedResultsDataProvider = FetchedResultsDataProvider<CDTrain>(fetchedResultsController: fetchedResultsController)
let arrayDataProvider = ArrayDataProvider<CDTrain>(sections: trains)
let dataProviders: [AnyDataProvider<CDTrain>] = [AnyDataProvider(fetchedResultsDataProvider), AnyDataProvider(arrayDataProvider)]
```

### Custom DataProvider
If you want to create a simple DataProvider, implement the `ArrayDataProviding` like the following example
```swift
final public class DictionaryDataProvider<Object>: ArrayDataProviding {
    public var whenDataProviderChanged: ProcessUpdatesCallback<Object>?

    public var data: [[Object]]
    public let sectionIndexTitles: Array<String>?
    
    public init(dictionary: [String: [Object]]) {
        self.sectionIndexTitles = Array(dictionary.keys)
        self.data = dictionary.reduce([[]], { result, element in
            return result.append(contentsOf: result)
        })
    }
}
```
If you need full controll of your DataProvider implement `DataProviding`.

Thirdparty Dataproviders:
* [DBNetworkStack+Sourcing - NetworkDataProvider](https://github.com/dbsystel/DBNetworkStack-Sourcing)

## DataModificator
DataModificator can handle modification caused by the user. If a user deletes a cell in the a TableView, DataModificator needs to handle the changes on the model side. If you do not provider a DataModificator to the DataSource, the views wont be editable. You create a custom DataModificator by implementing `DataModifying`

### ArrayDataModificator
An ArrayDataProvider supports modifications out of the box.
```swift
let trains: [Train] = //
let dataProvider = ArrayDataProvider(rows: trains)
let dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cell: trainCell, dataModificator: dataProvider)
```
## DataSource
DataSources connect either UITablevView (TableViewDataSource) or UICollectionView(CollectionViewDataSource) with any given DataProvider.

### TableViewDataSource
```swift
let dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cell: trainCell, dataModificator: dataProvider, displaySectionIndexTitles: true)
```

### CollectionViewDataSource
```swift
let dataSource = CollectionViewDataSource(tableView: tableView, dataProvider: dataProvider, cell: trainCell, dataModificator: dataProvider, displaySectionIndexTitles: true)
```

### Multi Cell DataSources
If you need to display diffrent kind of objects with different kind of cells, you cann do that too. DataSource looks up a matching cell for an object

```swift
let trainCell = //
let statationCell = //
let dataProvider: ArrayDataProvider<Any> = ArrayDataProvider(rows: [train, station])
let dataSource = CollectionViewDataSource(tableView: tableView, dataProvider: dataProvider, anyCells: [trainCell, stationCell], dataModificator: dataProvider, displaySectionIndexTitles: true)
```
This works for CollectionViewDataSource as well.

## Requirements

- iOS 9.3+
- Xcode 8.0+
- Swift 3.0

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

Specify the following in your `Cartfile`:

```ogdl
github "lightsprint09/sourcing" ~> 2.0
```
## Contributing
Feel free to submit a pull request with new features, improvements on tests or documentation and bug fixes. Keep in mind that we welcome code that is well tested and documented.

## Contact
Lukas Schmidt ([Mail](mailto:lukas.la.schmidt@deutschebahn.com), [@lightsprint09](https://twitter.com/lightsprint09))

## License
Sourcing is released under the MIT license. See LICENSE for details.

