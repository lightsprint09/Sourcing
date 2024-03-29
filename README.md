[![Build Status](https://travis-ci.org/lightsprint09/Sourcing.svg?branch=master)](https://travis-ci.org/lightsprint09/Sourcing)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov](https://codecov.io/gh/lightsprint09/Sourcing/branch/master/graph/badge.svg)](https://codecov.io/gh/lightsprint09/Sourcing)

# Sourcing

Typesafe and flexible abstraction for TableView &amp; CollectionView DataSources written in Swift. It helps you to seperate concerns and keep ViewControllers light. By operating on data providers replacing your view implementation is easy at any time.

## Documentation

Read the [docs](https://lightsprint09.github.io/Sourcing). Generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com).


## Quick Demo
Setting up your Cell by implementing `ConfigurableCell` & `ReuseIdentifierProviding`.
```swift
import Sourcing

class LabelCell: UITableViewCell, ConfigurableCell {

   func configure(with label: String) {
      textLabel?.text = label
   }
   
}

//If the reuse identifier is the same as the class name.
extension LabelCell: ReuseIdentifierProviding {}

let labelCellConfiguration = CellConfiguration<LabelCell>()
let labelsToDispay = ArrayDataProvider(sections: [["Row 1", "Row 2"], ["Row 1", "Row 2"]])
let dataSource = TableViewDataSource(dataProvider: labelsToDispay, cellConfiguration: labelCellConfiguration)

tableView.dataSource = dataSource

//Add this to sync data changes to the table view.
let changeAnimator = TableViewChangeAnimator(tableView: tableView, dataProvider: labelsToDispay)
```

## Installation

### Swift Package Manager

[SPM](https://swift.org/package-manager/) is integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Specify the following in your `Package.swift`:

```swift
.package(url: "https://github.com/lightsprint09/Sourcing", from: "4.1.0"),
```

## Contributing
See CONTRIBUTING for details.

## Contact
Lukas Schmidt ([Mail](mailto:lukas.la.schmidt@deutschebahn.com), [@lightsprint09](https://twitter.com/lightsprint09))

## License
Sourcing is released under the MIT license. See LICENSE for details.
