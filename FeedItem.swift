//
//  FeedItem.swift
//  ExchangeAGram
//
//  Created by Thomas Grant on 07/07/2015.
//  Copyright (c) 2015 Thomas Grant. All rights reserved.
//

import Foundation
import CoreData

@objc (FeedItem)

class FeedItem: NSManagedObject {

    @NSManaged var caption: String
    @NSManaged var image: NSData
    @NSManaged var thumbnail: NSData

}
