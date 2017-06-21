[![Build Status](https://travis-ci.org/lightsprint09/Sourcing.svg?branch=master)](https://travis-ci.org/lightsprint09/Sourcing)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov](https://codecov.io/gh/lightsprint09/Sourcing/branch/master/graph/badge.svg)](https://codecov.io/gh/lightsprint09/Sourcing)

# Sourcing

* [Quick Demo](#quick-demo)
* [DataProvider](#dataprovider)
   * [ArrayDataProvider](#arraydataprovider)
   * [FetchedResultsDataProvider](#fetchedresultsdataprovider)
   * [DataProviderSwitcher](#dataproviderswitcher)
   * [AnyDataProvider](#anydataprovider)
   * [AnyArrayDataProvider](#anyarraydataprovider)
   * [Custom DataProvider](#custom-dataprovider)
* [DataModificator](#datamodificator)
  * [ArrayDataModificator](#arraydatamodificator)
* [DataSource](#datasource)
   * [TableViewDataSource](#tableviewdatasource)
   * [CollectionViewDataSource](#collectionviewdatasource)
   * [Multi Cell DataSources](#multicelldatasource)
* [Cells](#cells)
   * [BasicCellConfiguration](#basiccellconfiguration)
   * [ConfigurableCell & CellConfiguration](#configurablecell--cellconfiguration)
   * [CellIdentifierProviding](#cellidentifierproviding)
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
extension TrainCell: CellIdentifierProviding {}

let trainCell = CellConfiguration<TrainCell>()
let trains: [Train] = //
let dataProvider = ArrayDataProvider(rows: trains)
let dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cell: trainCell)
```
## DataProvider
A DataProvider encaupsulates you data. Use one of the given DataProviders or implement `DataProviding` to create your own DataProvider.

### ArrayDataProvider
`ArrayDataProvider<Element>` wraps `Array<Element>` to a DataProvider.

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

### DataProviderSwitcher
`DataProviderSwitcher` allows switching between different DataProviders dynamically by changing to a given state. It can help to compose DataPrvoiders.

```swift
enum State {
  case initial
  case loaded
}
let dataProviderSwitcher = DataProviderSwitcher<Train, State>(initialState: .initial, resolve: { state in 
   switch state {
      case .initial:
        return AnyDataProvider(cachedDataProvider)
      case .loaded:
        return AnyDataProvider(networkResultDataProvider)
   }
} 

//When state changes.
dataProviderSwitcher.state = .loaded
```

### AnyDataProvider
`AnyDataProvider<Element>` is a Type Eraser (http://chris.eidhof.nl/post/type-erasers-in-swift/) for DataProviding. This can be useful if you want to put diffrent DataProviders in a Container.

```swift
let fetchedResultsDataProvider = FetchedResultsDataProvider<CDTrain>(fetchedResultsController: fetchedResultsController)
let arrayDataProvider = ArrayDataProvider<CDTrain>(sections: trains)
let dataProviders: [AnyDataProvider<CDTrain>] = [AnyDataProvider(fetchedResultsDataProvider), AnyDataProvider(arrayDataProvider)]
```

### AnyArrayDataProvider
`AnyArrayDataProvider<Element>` is a Type Eraser (http://chris.eidhof.nl/post/type-erasers-in-swift/) for ArrayDataProviding. This can be useful if you want to put diffrent ArrayDataProviders in a Container or composing features to ArrayDataProvider like filtering, sorting, etc.

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
If you need full controll of your DataProvider, implement `DataProviding`.

Thirdparty DataProviders:
* [DBNetworkStack+Sourcing - NetworkDataProvider](https://github.com/dbsystel/DBNetworkStack-Sourcing)

## DataModificator
DataModificator can handle modifications by the user. If a user deletes a cell in a TableView, DataModificator needs to handle the changes on the model side. If you do not provide a DataModificator to DataSource, the views won't be editable. You  can create a custom DataModificator by implementing `DataModifying`

### ArrayDataModificator
An ArrayDataProvider supports modifications out of the box.
```swift
let trains: [Train] = //
let dataProvider = ArrayDataProvider(rows: trains)
let dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cell: trainCell, dataModificator: dataProvider)
```
## DataSource
DataSources connect to either UITablevView (TableViewDataSource) or UICollectionView(CollectionViewDataSource) with any given DataProvider.

### TableViewDataSource
```swift
let dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cell: trainCell, dataModificator: dataProvider, displaySectionIndexTitles: true)
```

### CollectionViewDataSource
```swift
let dataSource = CollectionViewDataSource(tableView: tableView, dataProvider: dataProvider, cell: trainCell, dataModificator: dataProvider, displaySectionIndexTitles: true)
```

### Multi Cell DataSources
If you need to display different kind of objects with different cells, you can do that too. DataSource looks up a matching cell for an object.

## Cells
For each cell you want to display you'll need a CellConfiguration. A configuration is a type object which sets up all elements on your custom cell or delegates the setup to the cell itself. Use `BasicCellConfiguration`, `CellConfiguration` or implement your own configuration by using `StaticCellConfiguring`.

### BasicCellConfiguration
`BasicCellConfiguration` gives you a lot of freedom on how to configure your cell. You can provide custom cellIdentifier, nib and a block to configure your cell. If you do not provide a nib, it will use an already registered cell from the storyboard. 
```swift
let cellConfiguration: BasicCellConfiguration<TrainCell, Train> = BasicCellConfiguration(cellIdentifier: "TrainCell", configuration: { cell, train in 
   cell.trainNameLabel.text = train.name
   //...
})
```

### ConfigurableCell & CellConfiguration
A common pattern is to delegate configuration of a cell to the cell itself. If you are using this pattern, then your cell can implement `ConfigurableCell`. You can then use the configuration provided by the cell as configuration block.
```swift
extension TrainCell: ConfigurableCell {
    func configure(with train: Train) {
       trainNameLabel.text = train.name
    }
}
let cellConfiguration: CellConfiguration<TrainCell> = CellConfiguration(cellIdentifier: "TrainCell")
// CellConfiguration is just a generic typealias around BasicCellConfiguration
```

If you need to pass additional setup to your cell, which is not contained in your model object, you can use the following:
```swift
let cellConfiguration: CellConfiguration<TrainCell> = CellConfiguration(cellIdentifier: "TrainCell", additionalConfigurtion: { cell, train in 
    // cell.setYourAdditionalState
})
```

```swift
let trainCell = //
let statationCell = //
let dataProvider: ArrayDataProvider<Any> = ArrayDataProvider(rows: [train, station])
let dataSource = CollectionViewDataSource(tableView: tableView, dataProvider: dataProvider, anyCells: [trainCell, stationCell], dataModificator: dataProvider, displaySectionIndexTitles: true)
```
This works for CollectionViewDataSource as well.

### CellidentifierProviding

When your cell class name is the same as you cell identifier you could implement `CellidentifierProviding` for this class.

```swift
extension TrainCell: CellidentifierProviding {}

let cellConfiguration = CellConfiguration<TrainCell>() //No need to provide a cell identifier.
```
## Requirements

- iOS 9.3+
- Xcode 8.0+
- Swift 3.0

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

Specify the following in your `Cartfile`:

```ogdl
github "lightsprint09/sourcing" ~> 2.1
```
## Contributing
See CONTRIBUTING for details.

## Contact
Lukas Schmidt ([Mail](mailto:lukas.la.schmidt@deutschebahn.com), [@lightsprint09](https://twitter.com/lightsprint09))

## License
Sourcing is released under the MIT license. See LICENSE for details.

