//
//  AssetStoreUnitTests.swift
//  PaywallTests
//
//  Created by Akshay Bhandary on 8/18/22.
//  Copyright © 2022 Disney Streaming. All rights reserved.
//

import Foundation
import XCTest

@testable import Paywall

class AssetStoreUnitTests: XCTestCase {
  
  func testSuccesfullFetch() {
    
    // setup asset store with a mock session
    let url = URL(string: "http://disney.com")
    let mockNetworkData = Data()
    let mockURLSession = MockURLSession(dataToReturn: mockNetworkData,
                                        errorToReturn: nil)
    let assetStore = AssetStore(session: mockURLSession)
    
    // run the fetch method
    assetStore.fetchAsset(url: url!, completion: { result in
      switch (result) {
      case .success(let asset):
        XCTAssertEqual(asset.url, url)
        XCTAssertEqual(asset.state, .downloaded)
        XCTAssertEqual(asset.data, mockNetworkData)
      case .failure(let error):
        XCTFail("unexpectedly got an error - \(error)")
      }
    })
  }
  
  func testFetchFailure() {
    
    // setup asset store with a mock session
    let url = URL(string: "http://disney.com")
    let mockNetworkData = Data()
    let mockURLSession = MockURLSession(dataToReturn: mockNetworkData,
                                        errorToReturn: .genericNetworkError)
    let assetStore = AssetStore(session: mockURLSession)
    
    // run the fetch method
    assetStore.fetchAsset(url: url!, completion: { result in
      switch (result) {
      case .success(let asset):
        XCTFail("unexpectedly got an asset - \(asset)")
      case .failure(let error):
        XCTAssertEqual(error, .networkError)
      }
    })
  }
  
}
                          
