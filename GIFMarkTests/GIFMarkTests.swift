//
//  GIFMarkTests.swift
//  GIFMarkTests
//
//  Created by lal.castro@icloud.com on 15/07/22.
//

import XCTest
@testable import GIFMark

class GIFMarkTests: XCTestCase {
    var viewModelObject: ViewModel!

    override func setUpWithError() throws {
        viewModelObject = ViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        viewModelObject = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_get_trendingGifs() {
        viewModelObject.getTrendingGifs {
            XCTAssertGreaterThan(self.viewModelObject.GIFs.value.count, 0)
        }
    }

    func test_searchgifs() {
        viewModelObject.search(for: "cricket") {
            XCTAssertGreaterThan(self.viewModelObject.GIFs.value.count, 0)
        }
    }
    
    func test_trending() {
        viewModelObject.limit = 10
        viewModelObject.getTrendingGifs {
            XCTAssertEqual(self.viewModelObject.limit, self.viewModelObject.GIFs.value.count)
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

}
