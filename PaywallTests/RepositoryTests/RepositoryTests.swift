//
//  RepositoryTests.swift
//  PaywallTests
//
//  Created by Akshay Bhandary on 8/18/22.
//

import Foundation
import XCTest

@testable import Paywall

class PaywallRepositoryTests: XCTestCase {

  // employee repo is a passthrough module for now, till data store is incorporated,
  // so doing a basic singular success and error test for now
    
  func testSuccess() async throws {
    
    // setup data fetcher for this test
    let mockPaywall = PaywallDecoderUtils.getHardcodedPaywall()
    let mockDataFetcher = MockDataFetcher(paywall: mockPaywall, errorToReturn: nil)
    let repository = PaywallRepository(dataFetcher: mockDataFetcher)
    
    // run query
    repository.fetchPaywall { result in
      // verify result
      switch (result) {
      case .success(let paywall):
        XCTAssertEqual(mockPaywall, paywall)
      case .failure(let errorResult):
        XCTFail("unexpected error \(errorResult)")
      }
    }
  }
  
  func testError() async throws {
    // setup data fetcher for this test
    let mockPaywall = PaywallDecoderUtils.getHardcodedPaywall()
    let mockDataFetcher = MockDataFetcher(paywall: mockPaywall, errorToReturn: .networkError)
    let repository = PaywallRepository(dataFetcher: mockDataFetcher)
    
    // run query
    repository.fetchPaywall { result in
      // verify result
      switch (result) {
      case .success(let paywall):
        XCTFail("unexpected success -  \(paywall)")
      case .failure(let errorResult):
        XCTAssertEqual(errorResult, .networkError)
      }
    }
  }
}
