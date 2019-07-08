//
//  Object.swift
//  StanwoodCore_Tests
//
//  Created by Tal Zion on 03/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SourceModel

struct Item: Typeable, Codable {
    
    var title: String?
    var subTitle: String?
    var signature: String?
    var value: String?
}

class MainItem: Elements<Item> {

}

