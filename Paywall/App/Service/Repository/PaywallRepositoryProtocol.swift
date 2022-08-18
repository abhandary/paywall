//
//  PaywallRepositoryProtocol.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//  Copyright © 2022 Disney Streaming. All rights reserved.
//

import Foundation

enum PaywallRepositoryError: Error {
  case unexpected
  case networkError
  case decodingError
}

typealias PaywallRepoResultCompletion = (Result<Paywall, PaywallRepositoryError>) -> Void

protocol PaywallRepositoryProtocol {
  func fetchPaywall(completion: @escaping PaywallRepoResultCompletion)
}
