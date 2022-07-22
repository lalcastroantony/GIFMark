//
//  DataBasehandler.swift
//  GIFMark
//
//  Created by lal.castro@icloud.com on 20/07/22.
//

import Foundation
import CoreData
import UIKit
class GIFDataBaseHandler {
    private init(){}
    static let shared = GIFDataBaseHandler()
    lazy var coreDataStack = CoreDataStack(modelName: "GIFMark")
        
    func addToFavourites(viewModel: GIFViewModel) {
        self.vibrate()
        if self.isFavouriteGIF(id: viewModel.id) == false {
            let gif = GIFEntity.init(context: coreDataStack.managedContext)
            gif.gifId = viewModel.id
            gif.previewData = viewModel.imageData
            gif.imageUrl = viewModel.imageUrl
            gif.originalUrl = viewModel.originalUrl
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
        self.vibrate()
        let predicate = NSPredicate.init(format: "%K = %@", #keyPath(GIFEntity.gifId), id)
        let fetch = GIFEntity.fetchRequest()
        fetch.predicate = predicate
        if let gif = getSingleObjet(for: id) {
            coreDataStack.managedContext.delete(gif)
            coreDataStack.saveContext()
        }
    }
    
    func isFavouriteGIF(id: String?) -> Bool {
        guard let id = id else {
            return false
        }
        let predicate = NSPredicate.init(format: "%K = %@", #keyPath(GIFEntity.gifId), id)
        let fetch = GIFEntity.fetchRequest()
        fetch.predicate = predicate
        if let count = try? coreDataStack.managedContext.count(for: fetch) {
            return count > 0
        }
        return false
    }
    
    private func vibrate() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
}
