//
//  DataBasehandler.swift
//  GIFMark
//
//  Created by lal.castro@icloud.com on 20/07/22.
//

import Foundation
import CoreData
class GIFDataBaseHandler {
    private init(){}
    static let shared = GIFDataBaseHandler()
    lazy var coreDataStack = CoreDataStack(modelName: "GIFMark")
        
    func addToFavourites(id: String, data: Data?) {
        if self.isFavouriteGIF(id: id) == false {
            let gif = GIFEntity.init(context: coreDataStack.managedContext)
            gif.gifId = id
            gif.previewData = data
            coreDataStack.saveContext()
        }
    }
    
    func getSingleObjet(for id: String) -> GIFEntity? {
        let predicate = NSPredicate.init(format: "%K = %@", #keyPath(GIFEntity.gifId), id)
        let fetch = GIFEntity.fetchRequest()
        fetch.predicate = predicate
        if let gifs = try? coreDataStack.managedContext.fetch(fetch), let gif = gifs.first {
            return gif
        }
        return nil
    }
    
    func removeFromFavourites(id: String) {
        let predicate = NSPredicate.init(format: "%K = %@", #keyPath(GIFEntity.gifId), id)
        let fetch = GIFEntity.fetchRequest()
        fetch.predicate = predicate
        if let gif = getSingleObjet(for: id) {
            coreDataStack.managedContext.delete(gif)
            coreDataStack.saveContext()
        }
    }
    
    func isFavouriteGIF(id: String) -> Bool {
        let predicate = NSPredicate.init(format: "%K = %@", #keyPath(GIFEntity.gifId), id)
        let fetch = GIFEntity.fetchRequest()
        fetch.predicate = predicate
        if let count = try? coreDataStack.managedContext.count(for: fetch) {
            return count > 0
        }
        return false
    }
}
