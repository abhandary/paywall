//
//  PaywallDataFetcherProtocol.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//  Copyright © 2022 Disney Streaming. All rights reserved.
//

import Foundation


enum PaywallDataFetcherError : Error {
  case decodingError
  case networkError
}

typealias PaywallResultCompletion = (Result<Paywall, PaywallDataFetcherError>) -> Void

protocol PaywallDataFetcherProtocol {
  func fetchPaywall(completion: @escaping PaywallResultCompletion)
}
