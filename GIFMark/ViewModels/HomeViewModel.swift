//
//  Trending+ViewModel.swift
//  GIFMark
//
//  Created by lal.castro@icloud.com on 15/07/22.
//

import Foundation

class HomeViewModel {
    var offset = 0
    var limit = 20
    var hasMoreData = true
    var isFetching = false
    var GIFs: ObservableObject<[[String: Any]]> = ObservableObject([])
    var isSearching = false
    var query: String?
    
    func paginate(onSucess: @escaping ()->()) {
        if isSearching {
            if let query = self.query, query.isValidSearch {
                search(for: query) {
                    onSucess()
                }
            }
        }
        else {
            getTrendingGifs {
                onSucess()
            }
        }
    }
    
    func getTrendingGifs(onSucess: @escaping ()->()) {
        if isFetching {
            return
        }
        fetchGIFs(endPoint: .trending) {
            onSucess()
        }
    }
    
    func fetchGIFs(endPoint: APIEndPoint, onSucess: @escaping ()->()) {
        if isFetching {
            return
        }
        isFetching = true
        var payloadObject = PayloadObject()
        payloadObject.limit = limit
        payloadObject.offset = self.offset
        payloadObject.q = self.query
        ApiHandler.getData(for: endPoint, payloadObject: payloadObject) { responseObject in
            self.isFetching = false
            if let gifs = responseObject.data as? [[String: Any]] {
                self.GIFs.value = self.GIFs.value + gifs
                if gifs.count < self.limit {
                    self.hasMoreData = false
                }
                else {
                    self.offset += self.limit
                }
                onSucess()
            }
        } onFailure: {
            self.isFetching = false
        }
    }
    
    func search(for query: String, onSucess: @escaping ()->()) {
        if query != self.query {
            self.hasMoreData = true
            self.offset = 0
            isFetching = false
            self.query = query
        }
        self.fetchGIFs(endPoint: .search) {
        }
    }
}
