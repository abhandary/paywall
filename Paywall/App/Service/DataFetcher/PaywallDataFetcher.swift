//
//  PaywallDataFetcher.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//

import Foundation

private let TAG = "PaywallDataFetcher"

final class PaywallDataFetcher : PaywallDataFetcherProtocol {
  
  private var session: NetworkSessionProtocol
  private var decoder: JSONDecodable
  
  private let api: API = .paywall
  static let shared = PaywallDataFetcher()
  
  init(session: NetworkSessionProtocol = URLSession.paywall, decoder: JSONDecodable = PaywallDecoder()) {
    self.session = session
    self.decoder = decoder
  }
}

extension PaywallDataFetcher {
  func fetchPaywall(completion: @escaping PaywallResultCompletion) {
    self.session.loadData(from: api) { [weak self] result in
      guard let self = self else {
        Log.error("self is nil")
        return
      }
      switch (result) {
      case .success(let data):
        if let paywall = self.decodePaywall(data: data) {
          completion(.success(paywall))
        } else {
          completion(.failure(.decodingError))
        }
      case .failure(let error):
        Log.error("fetchPaywall: got an error - \(error)")
        completion(.failure(.networkError))
      }
    }
  }
  
  private func decodePaywall(data: Data) -> Paywall? {
    return self.decoder.decode(type: Paywall.self, from: data)
  }
}

