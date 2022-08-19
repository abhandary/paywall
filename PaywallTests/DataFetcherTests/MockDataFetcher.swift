//
//  MockDataFetcher.swift
//  PaywallTests
//
//  Created by Akshay Bhandary on 8/18/22.
//

import Foundation

@testable import Paywall

struct MockDataFetcher : PaywallDataFetcherProtocol {
  
  var paywall: Paywall?
  var errorToReturn: PaywallDataFetcherError?
  
  func fetchPaywall(completion: @escaping PaywallResultCompletion) {
    if let errorToReturn = errorToReturn {
      completion(.failure(errorToReturn))
      return
    }
    
    if let paywall = paywall {
      completion(.success(paywall))
      return
    }
  }
}
