//
//  GIFListCellViewModel.swift
//  GIFMark
//
//  Created by lal.castro@icloud.com on 20/07/22.
//

import Foundation
class GIFViewModel {
    var imageUrl: String?
    var id: String?
    var imageData: Data?
    var originalUrl: String?
    
    init(gifData: [String: Any]) {
        self.id = gifData["id"] as? String
        if let images = gifData["images"] as? [String: Any] {
            if let preview = images["preview_gif"] as? [String: Any], let url = preview["url"] as? String {
                self.imageUrl = url
            }
            if let original = images["original"] as? [String: Any], let url = original["url"] as? String {
                self.originalUrl = url
            }
        }
    }
    
    init(gifEntity: GIFEntity) {
        self.imageUrl = gifEntity.imageUrl
        self.id = gifEntity.gifId
        self.imageData = gifEntity.previewData
        self.originalUrl = gifEntity.originalUrl
    }
    
    func addToFavourite() {
        if id != nil {
            GIFDataBaseHandler.shared.addToFavourites(viewModel: self)
        }
    }
    
    func removeFromFavourite() {
        if let id = id {
            GIFDataBaseHandler.shared.removeFromFavourites(id: id)
        }
    }
}
