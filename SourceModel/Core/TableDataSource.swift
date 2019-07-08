//
//  TableDataSource.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Stanwood GmbH (www.stanwood.io)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import StanwoodCore

protocol TableDataSourcing {
    
    var modelCollection: ModelCollection? {get set}
    var model: Model? { get set }
    
    func update(modelCollection: ModelCollection?)
    func update(model: Model?)
    
    func numberOfSections(in tableView: UITableView) -> Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

/**
 The `TableDataSource` conforms to the `TableDataSourcing` protocol and implements `TableDataSource.numberOfSections(in:)` and `TableDataSource.tableView(_:numberOfRowsInSection:)`. It midiates the application data model `ModelCollection` and `Model` for the [`UITableView`](https://developer.apple.com/documentation/uikit/uitableview).
 
 >It is requried to subclass `TableDataSource` and override `TableDataSource.tableView(_:cellForRowAt:)`
 
 #####Example: DataSource and Delegate design#####
 ````swift
 let items = [Model(id: "1"), Model(id: "2")]
 let modelCollection = Stanwood.Elements<Model>(items: items)
 
 let dataSource = ModelDataSource(dataObject: modelCollection)
 let delegate = ModelDelegate(dataObject: modelCollection)
 
 self.tableView.dataSource = dataSource
 self.tableView.delegate = delegate
 ```
 
 - SeeAlso:
 
 `CollectionDelegate`
 
 `Elements`
 
 `ModelCollection`
 
 `Model`
 */
open class TableDataSource: NSObject, UITableViewDataSource, TableDataSourcing, DataSourceType {
    
    // MARK: Properties
    
    /// modelCollection, a collection of models
    public internal(set) var modelCollection: ModelCollection?
    
    /// A single model object to present
    public internal(set) var model: Model?
    
    /**
     DataSource Cell Delegate
     
     - SeeAlso `Delegatable`
     */
    public private(set) weak var delegate: AnyObject?
    
    // MARK: Initializers
    
    /**
     Initialise with a collection of types
     
     - Parameters:
         - modelCollection: ModelCollection
         - delegate: Optional AnyObject delegate
     
     - SeeAlso: `DataType`
     */
    public init(modelCollection: ModelCollection?, delegate: AnyObject? = nil) {
        self.modelCollection = modelCollection
        self.delegate = delegate
    }
    
    /**
     Initialise with a a single type object.
     
     - Parameters:
        - modelCollection: ModelCollection
     
     - SeeAlso: `Model`
     */
    public init(model: Model) {
        self.model = model
    }
    
    /// Unavalible
    @available(*, unavailable, renamed: "init(model:)")
    public init(type: Type) {}
    
    /// Unavalible
    @available(*, unavailable, renamed: "init(type:)")
    public init(dataType: Type) {}
    
    // MARK: Public functions
    
    /**
     Update current dataSource with modelCollection.
     >Note: If modelCollection is a `class`, it is not required to update the modelCollection.
     
     - Parameters:
        - modelCollection: ModelCollection
     
     - SeeAlso: `Model`
     */
    open func update(modelCollection: ModelCollection?) {
        self.modelCollection = modelCollection
    }
    
    /// Unavalible
    @available(*, unavailable, renamed: "update(modelCollection:)")
    open func update(with dataType: DataType?) {}
    
    /**
     update current dataSource with modelCollection.
     >Note: If model is a `class`, it is not required to update the modelCollection.
     
     - Parameters:
        - model: Model
     
     - SeeAlso: `ModelCollection`
     */
    open func update(model: Model?) {
        self.model = model
    }
    
    /// Unavalible
    @available(*, unavailable, renamed: "update(modelCollection:)")
    open func update(with type: Type?) {}
    
    // MARK: UITableViewDataSource functions
    
    /// :nodoc:
    open func numberOfSections(in tableView: UITableView) -> Int {
        switch (modelCollection, model) {
        case (.some, .none):
            return modelCollection?.numberOfSections ?? 0
        case (.none, .some):
            return 1
        case (.some, .some):
            fatalError("\(String(describing: Swift.type(of: self))) should not have modelCollection and model at the same time.")
        default:
            return 0
        }
    }
    
    /// :nodoc:
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelCollection?[section].numberOfItems ?? (model == nil ? 0 : 1)
    }
    
    /// :nodoc:
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = modelCollection?.cellType(forItemAt: indexPath) as? UITableViewCell.Type else { fatalError("You need to subclass Stanwood.Elements and override cellType(forItemAt:)") }
        guard let cell = tableView.dequeue(cellType: cellType, for: indexPath) as? (UITableViewCell & Fillable) else { fatalError("UITableViewCell must conform to Fillable protocol") }
        
        if let delegateableCell = cell as? Delegateble {
            
            if let delegate = delegate {
                delegateableCell.set(delegate: delegate)
            } else {
                assert(false, "The cell requires a delegate, you must inject a delegate to proceed. See: init(modelCollection:delegate:)")
            }
        }
        
        cell.fill(with: modelCollection?[indexPath.section][indexPath])
        return cell
    }
}

