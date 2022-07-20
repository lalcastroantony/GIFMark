//
//  GIFEntity+CoreDataProperties.swift
//  GIFMark
//
//  Created by lal.castro@icloud.com on 20/07/22.
//
//

import Foundation
import CoreData


extension GIFEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GIFEntity> {
        return NSFetchRequest<GIFEntity>(entityName: "GIFEntity")
    }

    @NSManaged public var gifId: String?
    @NSManaged public var previewData: Data?
    @NSManaged public var imageUrl: String?
    @NSManaged public var originalUrl: String?

}

extension GIFEntity : Identifiable {

}
