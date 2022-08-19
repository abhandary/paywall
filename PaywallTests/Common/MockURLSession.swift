//
//  MockURLSession.swift
//  PaywallTests
//
//  Created by Akshay Bhandary on 8/18/22.
//

import Foundation

@testable import Paywall

struct MockURLSession: NetworkSessionProtocol {
  
  var dataToReturn: Data? = nil
  var errorToReturn: NetworkError? = nil
  
  public func loadData(from endPoint: EndPoint, completion: NetworkCompletion?) {
    loadDataInternal(completion: completion)
  }
  
  public func loadData(from urlRequest: URLRequest, completion: NetworkCompletion?) {
    loadDataInternal(completion: completion)
  }
  
  private func loadDataInternal(completion: NetworkCompletion?) {
    if let errorToReturn = errorToReturn {
      completion?(.failure(errorToReturn))
      return
    }
    if let dataToReturn = self.dataToReturn {
      completion?(.success(dataToReturn))
      return
    }
  }
}

