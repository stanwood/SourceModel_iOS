//
//  TableDelegate.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 Stanwood GmbH (www.stanwood.io)
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
    
    var dataType: ModelCollection? { get set }
    var type: Model? { get set }
    
    func update(modelCollection: ModelCollection?)
    func update(model: Model?)
}


/**
 The `TableDelegate` conforms to the `TableDelegating` protocol. It allows you to manage the selection and highlighting of items in a collection view and to perform actions on those items. [`UITableView`](https://developer.apple.com/documentation/uikit/uitableview).
 
 #####Example: DataSource and Delegate design#####
 ````swift
 let items = [Element(id: "1"), Element(id: "2")]
 self.objects = Stanwood.Elements<Element>(items: items)
 
 self.dataSource = ElementDataSource(dataType: objects)
 self.delegate = ElementDelegate(dataType: objects)
 
 self.tableView.dataSource = self.dataSource
 self.tableView.delegate = self.delegate
 ````
 
 - SeeAlso:
 
 `TableDataSource`
 
 `Objects`
 
 `DataType`
 
 `Type`
 */
open class TableDelegate: NSObject, UITableViewDelegate, TableDelegating, DelegateSourceType {
    
    // MARK: Properties
    
    /// dataType, a collection of types
    public internal(set) var dataType: ModelCollection?
    
    /// A single type object to present
    public internal(set) var type: Model?

    // MARK: Initializers
    
    /**
     Initialise with a collection of types
     
     - Parameters:
     - dataType: dataType
     
     - SeeAlso: `DataType`
     */
    public init(modelCollection: ModelCollection?) {
        self.dataType = modelCollection
    }
    
    /// Unavalible
    @available(*, unavailable, renamed: "init(modelCollection:)")
    public init(dataType: DataType?) {}
    
    /**
     Initialise with a a single type object.
     
     - Parameters:
     - dataType: DataType
     
     - SeeAlso: `Type`
     */
    public init(model: Model) {
        self.type = model
    }
    
    /// Unavalible
    @available(*, unavailable, renamed: "init(model:)")
    public init(type: Type) {}
    
    // MARK: Public functions
    
    /**
     update current dataSource with dataType.
     >Note: If data type is a `class`, it is not reqruied to update the dataType.
     
     - Parameters:
     - dataType: DataType
     
     - SeeAlso: `Type`
     */
    open func update(modelCollection: ModelCollection?) {
        self.dataType = modelCollection
    }
    
    @available(*, unavailable, renamed: "update(modelCollection:)")
    open func update(with dataType: DataType?) {}
    
    /**
     update current dataSource with dataType.
     >Note: If data type is a `class`, it is not reqruied to update the dataType.
     
     - Parameters:
     - dataType: Type
     
     - SeeAlso: `DataType`
     */
    open func update(model: Model?) {
        self.type = model
    }
    
    @available(*, unavailable, renamed: "update(model:)")
    open func update(with type: Type?) {}
    
    /// :nodoc:
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let headerable = dataType?[section] as? Headerable,
            let view = headerable.headerView {
            return view.bounds.size.height
        }
        return 0.0
    }
    
    /// :nodoc:
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerable = dataType?[section] as? Headerable {
            return headerable.headerView
        }
        return nil
    }
}

