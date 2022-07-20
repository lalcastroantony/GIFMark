//
//  GIFMarkTests.swift
//  GIFMarkTests
//
//  Created by lal.castro@icloud.com on 15/07/22.
//

import XCTest
@testable import GIFMark

class GIFMarkTests: XCTestCase {
    var homeViewModel: HomeViewModel!
    
    func test_get_trendingGifs() {
        homeViewModel.getTrendingGifs {
            XCTAssertGreaterThan(self.homeViewModel.GIFs.value.count, 0)
        }
    }

    func test_searchgifs() {
        homeViewModel.search(for: "cricket") {
            XCTAssertGreaterThan(self.homeViewModel.GIFs.value.count, 0)
        }
    }
    
    func test_trending() {
        homeViewModel.limit = 10
        homeViewModel.getTrendingGifs {
            XCTAssertEqual(self.homeViewModel.limit, self.homeViewModel.GIFs.value.count)
        }
    }
    
    func test_request_payload() {
        let payload = PayloadObject()
        XCTAssertNotNil(payload.payloadDictionary)
    }
    
    func test_response_Object() {
        ApiHandler.getData(for: .trending, payloadObject: PayloadObject()) { responseObject in
            XCTAssertNotNil(responseObject)
        } onFailure: {
            XCTFail("Could not get response object")
        }
    }
    
    func test_GifViewModel() {
        ApiHandler.getData(for: .trending, payloadObject: PayloadObject()) { responseObject in
            if let gifs = responseObject.data as? [[String: Any]], let first = gifs.first {
                XCTAssertNotNil(GIFViewModel.init(gifData: first))
            }
        } onFailure: {
            XCTFail("Could not get response object")
        }

    }

}
