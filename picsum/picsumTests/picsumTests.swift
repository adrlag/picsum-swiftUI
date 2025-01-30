//
//  picsumTests.swift
//  picsumTests
//
//  Created by Adrian Lage Gil on 29/1/25.
//

import XCTest
@testable import picsum

final class ContentViewModelTests: XCTestCase {
    
    var viewModel: ContentViewwModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ContentViewwModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testPhotoDecoding() {
        let jsonData = """
        {
            "id": "0",
            "author": "Alejandro Escamilla",
            "width": 5000,
            "height": 3333,
            "url": "https://unsplash.com/photos/yC-Yzbqy7PY",
            "download_url": "https://picsum.photos/id/0/5000/3333"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let photo = try decoder.decode(Photo.self, from: jsonData)
            XCTAssertEqual(photo.id, "0")
            XCTAssertEqual(photo.author, "Alejandro Escamilla")
            XCTAssertEqual(photo.width, 5000)
            XCTAssertEqual(photo.height, 3333)
            XCTAssertEqual(photo.url, "https://unsplash.com/photos/yC-Yzbqy7PY")
            XCTAssertEqual(photo.download_url, "https://picsum.photos/id/0/5000/3333")
        } catch {
            XCTFail("Error decoding: \(error)")
        }
    }
    
    func testFetchPhotosSuccess() async {
        let expectation = XCTestExpectation()
        
        let jsonData = """
        [
            {"id":"8","author":"Alejandro Escamilla","width":5000,"height":3333,"url":"https://unsplash.com/photos/xII7efH1G6o","download_url":"https://picsum.photos/id/8/5000/3333"},
            {"id":"9","author":"Alejandro Escamilla","width":5000,"height":3269,"url":"https://unsplash.com/photos/ABDTiLqDhJA","download_url":"https://picsum.photos/id/9/5000/3269"},
            {"id":"10","author":"Paul Jarvis","width":2500,"height":1667,"url":"https://unsplash.com/photos/6J--NXulQCs","download_url":"https://picsum.photos/id/10/2500/1667"},
            {"id":"11","author":"Paul Jarvis","width":2500,"height":1667,"url":"https://unsplash.com/photos/Cm7oKel-X2Q","download_url":"https://picsum.photos/id/11/2500/1667"},
            {"id":"12","author":"Paul Jarvis","width":2500,"height":1667,"url":"https://unsplash.com/photos/I_9ILwtsl_k","download_url":"https://picsum.photos/id/12/2500/1667"},
            {"id":"13","author":"Paul Jarvis","width":2500,"height":1667,"url":"https://unsplash.com/photos/3MtiSMdnoCo","download_url":"https://picsum.photos/id/13/2500/1667"},
            {"id":"14","author":"Paul Jarvis","width":2500,"height":1667,"url":"https://unsplash.com/photos/IQ1kOQTJrOQ","download_url":"https://picsum.photos/id/14/2500/1667"},
        ]
        """.data(using: .utf8)!
        
        XCTAssertTrue(viewModel.photos.isEmpty)
        
        Task {
            await viewModel.fetchPhotos()
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 5)
        
        XCTAssertEqual(viewModel.photos.count, 10)
        XCTAssertEqual(viewModel.photos.first?.author, "Alejandro Escamilla")
        XCTAssertEqual(viewModel.isLoading, false)
        XCTAssertNil(viewModel.errorMessage)
        
    }
}
