//
//  PaywallRepository.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//

import Foundation

private let TAG = "PaywallRepository"

// This module is passthrough for now but meant to be the 'source of truth' and can be updated to
// have the ability to fetch from data store while data is fetched from the network
final class PaywallRepository : PaywallRepositoryProtocol {
  
  let dataFetcher: PaywallDataFetcherProtocol

  init(dataFetcher: PaywallDataFetcherProtocol) {
    self.dataFetcher = dataFetcher
  }
  
  func fetchPaywall(completion: @escaping PaywallRepoResultCompletion) {

    Log.verbose(TAG,"running query for paywall")
    
    // async fetch from network and update and notify
    dataFetcher.fetchPaywall { [weak self] result in
      guard let self = self else {
        Log.error(TAG, "self is nil")
        completion(.failure(.unexpected))
        return
      }
      switch (result) {
      case .success(let response):
        completion(.success(response))
      case .failure(let error):
        Log.error(TAG, error)
        completion(.failure(self.map(networkError: error)))
      }
    }
  }
  
  private func map(networkError: PaywallDataFetcherError) -> PaywallRepositoryError {
    switch (networkError) {
    case .networkError:
      return .networkError
    case .decodingError:
      return .decodingError
    }
  }
}

