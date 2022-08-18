//
//  Networking.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//

import Foundation

//MARK: - Endpoint

public protocol EndPoint {
  var path: String { get }
  var request: URLRequest? { get }
}

enum API {
  case paywall
}

extension API: EndPoint {
  var path: String {
    switch self {
    case .paywall:
      return "http://localhost:8000/response.json"
    }
  }
  
  var request: URLRequest? {
    guard let url = URL(string: path) else { return nil }
    return URLRequest(url: url)
  }
}

//MARK: - NetworkError

public enum NetworkError: Error {
  case genericNetworkError
}

extension NetworkError {
  
  var localizedDescription: String {
    switch self {
    case .genericNetworkError:
      return "Generic Network Error"
    }
  }
}

//MARK: - NetworkSession

public typealias NetworkCompletion = (Result<Data, NetworkError>) -> Void

public protocol NetworkSessionProtocol {
  func loadData(from endPoint: EndPoint, completion: NetworkCompletion?)
  func loadData(from urlRequest: URLRequest, completion: NetworkCompletion?)
}

extension URLSession : NetworkSessionProtocol {
  public func loadData(from endPoint: EndPoint, completion: NetworkCompletion?) {
    
    guard let request = endPoint.request else {
      Log.error("nil request in end point")
      completion?(.failure(NetworkError.genericNetworkError))
      return
    }
    
    loadData(from: request, completion: completion)
  }
  
  public func loadData(from urlRequest: URLRequest, completion: NetworkCompletion?) {
    self.dataTask(with: urlRequest) { data, urlResponse, error in
      if let error = error {
        Log.error("got a network error - \(error)")
        completion?(.failure(NetworkError.genericNetworkError))
        return
      }
      guard let data = data else {
        Log.error("got empty data from network call")
        completion?(.failure(NetworkError.genericNetworkError))
        return
      }
      completion?(.success(data))
    }.resume()
  }
}

