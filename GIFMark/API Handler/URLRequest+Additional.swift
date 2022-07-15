//
//  URLRequest+Additional.swift
//  GIFMark
//
//  Created by lal-7695 on 15/07/22.
//

import Foundation


enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
    case BATCH = "BATCH"
}

extension URLRequest {
    static func dataTask(endPoint: String, method: HTTPMethod, payload: [String: Any]?, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        var endPointString = "\(baseUrl)\(endPoint)?"
        if let payload = payload, method == .GET {
            let urlParams = payload.compactMap({ (key, value) -> String in
                return "\(key)=\(value)"
            }).joined(separator: "&")
            endPointString.append(urlParams)
        }
        guard let endPointEncoded = endPointString.urlEncode(), let url = URL.init(string: endPointEncoded) else {return}
        var request = URLRequest.init(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        if let payload = payload, method != .GET {
            request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil{
                completionHandler(nil, nil, error)
            }else{
                completionHandler(data, response, nil)
            }
        }.resume()
    }
}


extension Encodable {
    /// Encode into JSON and return `Data`
    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
}

extension String {
    func urlEncode() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}

extension URLResponse {
    func isSuccess() -> Bool {
        if let statusCode = (self as? HTTPURLResponse)?.statusCode, statusCode == 200 || statusCode == 204 {
            return true
        }
        return false
    }
}
