//
//  TableDelegate.swift
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

protocol TableDelegating {
    
    var modelCollection: ModelCollection? { get set }
    var model: Model? { get set }
    
    func update(modelCollection: ModelCollection?)
    func update(model: Model?)
}


/**
 The `TableDelegate` conforms to the `TableDelegating` protocol. It allows you to manage the selection and highlighting of items in a collection view and to perform actions on those items. [`UITableView`](https://developer.apple.com/documentation/uikit/uitableview).
 
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
 
 `TableDataSource`
 
 `Elements`
 
 `ModelCollection`
 
 `Model`
 */
open class TableDelegate: NSObject, UITableViewDelegate, TableDelegating, DelegateSourceType {
    
    // MARK: Properties
    
    /// modelCollection, a collection of types
    public internal(set) var modelCollection: ModelCollection?
    
    /// A single model object to present
    public internal(set) var model: Model?

    // MARK: Initializers
    
    /**
     Initialise with a collection of types
     
     - Parameters:
        - modelCollection: ModelCollection
     
     - SeeAlso: `Model`
     */
    public init(modelCollection: ModelCollection?) {
        self.modelCollection = modelCollection
    }
    
    /**
     Initialise with a a single type object.
     
     - Parameters:
        - model: Model
     
     - SeeAlso: `ModelCollection`
     */
    public init(model: Model) {
        self.model = model
    }

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
   
    /**
     update current dataSource with dataType.
     >Note: If model is a `class`, it is not required to update the model.
     
     - Parameters:
        - model: Model
     
     - SeeAlso: `ModelCollection`
     */
    open func update(model: Model?) {
        self.model = model
    }
    
    /// :nodoc:
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let headerable = modelCollection?[section] as? Headerable,
            let view = headerable.headerView {
            return view.bounds.size.height
        }
        return 0.0
    }
    
    /// :nodoc:
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerable = modelCollection?[section] as? Headerable {
            return headerable.headerView
        }
        return nil
    }
}

