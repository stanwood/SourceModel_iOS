//
//  AbstractCollectionDataSource.swift
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

protocol CollectionDataSourcing: class {
    
    var modelCollection: ModelCollection? { get set }
    var model: Model? { get set }
    
    func update(modelCollection: ModelCollection?)
    func update(model: Model?)
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

/**
 The `CollectionDataSource` conforms to the `CollectionDataSourcing` protocol and implements `CollectionDataSource.numberOfSections(in:)` and `CollectionDataSource.collectionView(_:numberOfItemsInSection:)`. It midiates the application data model `DataModel` and `Model` for the [`UICollectionView`](https://developer.apple.com/documentation/uikit/uicollectionview).
 
 >It is requried to subclass `CollectionDataSource` and override `CollectionDataSource.collectionView(_:cellForItemAt:)`
 
 #####Example: DataSource and Delegate design#####
 ````swift
 let items = [Model(id: "1"), Model(id: "2")]
 let modelCollection = Stanwood.Elements<Model>(items: items)
 
 let dataSource = ModelDataSource(dataObject: modelCollection)
 let delegate = ModelDelegate(dataObject: modelCollection)
 
 self.collectionView.dataSource = dataSource
 self.collectionView.delegate = delegate
 ````
 
 - SeeAlso:
 
 `CollectionDelegate`
 
 `Elements`
 
 `ModelCollection`
 
 `Model`
 */
open class CollectionDataSource: NSObject, UICollectionViewDataSource, CollectionDataSourcing, DataSourceType {
    
    // MARK: Properties
    
    /// modelCollection, a collection of models
    public internal(set) var modelCollection: ModelCollection?
    
    /// Unavalible
    @available(*, unavailable, renamed: "modelCollection")
    public internal(set) var dataType: ModelCollection?
    
    /// A single model to present
    public internal(set) var model: Model?
    
    /// Unavalible
    @available(*, unavailable, renamed: "model")
    public internal(set) var type: Model?
    
    /// :nodoc:
    private weak var delegate: AnyObject?
    
    // MARK: Initializers
    
    /**
     Initialise with a collection of types
     
     - Parameters:
         - modelCollection: `ModelCollection`
         - delegate: optional AnyObject delegate
     
     - SeeAlso: `Model`
     */
    public init(modelCollection: ModelCollection?, delegate: AnyObject? = nil) {
        self.delegate = delegate
        self.modelCollection = modelCollection
    }
    
    /**
     Initialise with a a single type object.
     
     - Parameters:
     - model: `Model`
     
     - SeeAlso: `ModelCollection`
     */
    public init(model: Model, delegate: AnyObject? = nil) {
        self.model = model
    }
    
    // MARK: Public functions
    
    /**
     Update current dataSource with dataObject.
     
     >Note: If modelCollection is a `class`, it is not required to update the modelCollection.
     
     >Hi:
     - Parameters:
        - modelCollection: `ModelCollection`
     
     - SeeAlso: `Model`
     */
    open func update(modelCollection: ModelCollection?) {
        self.modelCollection = modelCollection
    }
    
    /// Unavalible
    @available(*, unavailable, renamed: "update(modelCollection:)")
    open func update(with dataType: ModelCollection?) {}
    
    /**
     update current dataSource with type.
     >Note: If model is a `class`, it is not required to update the model.
     
     - Parameters:
        - model: `Model`
     
     - SeeAlso: `ModelCollection`
     */
    open func update(model: Model?) {
        self.model = model
    }
    
    /// Unavalible
    @available(*, unavailable, renamed: "update(model:)")
    open func update(with type: Type?) {}
    
    // MARK: UICollectionViewDataSource functions
    
    /// :nodoc:
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch (modelCollection, model) {
        case (.some, .none):
            return modelCollection?.numberOfSections ?? 0
        case (.none, .some):
            return 1
        case (.some, .some):
            fatalError("\(String(describing: Swift.type(of: self))) should not have model and modelCollection at the same time.")
        default:
            return 0
        }
    }
    
    /// :nodoc:
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelCollection?[section].numberOfItems ?? (model == nil ? 0 : 1)
    }
    
    /// :nodoc:
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellType = modelCollection?.cellType(forItemAt: indexPath) as? UICollectionViewCell.Type else { fatalError("You need to subclass Stanwood.Elements and override cellType(forItemAt:)") }
        guard let cell = collectionView.dequeue(cellType: cellType, for: indexPath) as? (UICollectionViewCell & Fillable) else { fatalError("UICollectionViewCell must conform to Fillable protocol") }
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
    
    /// :nodoc:
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let headerable = modelCollection?[indexPath.section] as? Headerable,
            let view = headerable.reusableView {
            return view
        }
        return UICollectionReusableView(frame: CGRect.zero)
    }
}

