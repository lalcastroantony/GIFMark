//
//  ApiHandler.swift
//  GIFMark
//
//  Created by lal-7695 on 15/07/22.
//

import Foundation



let API_KEY = "f3nCiLR09QYGibw3umEuKNbvawFWxzZE"
let baseUrl = "https://api.giphy.com/v1/gifs/"
let trendingEndPoint = "trending"
let searchEndPoint = "search"

struct PayloadObject: Encodable {
    var api_key: String = API_KEY
    var limit: Int?
    var offset: Int?
    var rating: String = "r"
    var random_id: String?
    var bundle: String?
    var lang: String?
    var q: String?
    var payloadDictionary: [String: Any]? {
        guard let jsonData = try? self.jsonData() else {
            return nil
        }
        guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any] else {
            return nil
        }
        return dictionary
    }
}

struct ResponseObject {
    var data: Any
    var meta: [String: Any]
    var pagination: [String: Any]?
}

enum APIEndPoint {
    case trending
    case search
    case singleGIF(id: String)
    func getUrl() -> String {
        switch self {
        case .trending:
            return trendingEndPoint
        case .search:
            return searchEndPoint
        case .singleGIF(let id):
            return "\(baseUrl)/\(id)"
        }
    }
}

class ApiHandler {

    static func getData(for endPoint: APIEndPoint,payloadObject: PayloadObject, onSuccess: @escaping (_ responseObject: ResponseObject)->(), onFailure: @escaping ()->() ) {
        URLRequest.dataTask(endPoint: endPoint.getUrl(), method: .GET, payload: payloadObject.payloadDictionary) { data, response, error in
            if response?.isSuccess() ?? false {
                if let dataObj = data, let jsonResponse = try? JSONSerialization.jsonObject(with: dataObj) as? [String: Any], let responseData = jsonResponse["data"], let meta = jsonResponse["meta"] as? [String: Any] {
                    let object = ResponseObject.init(data: responseData, meta: meta, pagination: jsonResponse["pagination"] as? [String: Any])
                    onSuccess(object)
                }
                else {
                    onFailure()
                }
            }
            else {
                onFailure()
            }
        }
    }
}



