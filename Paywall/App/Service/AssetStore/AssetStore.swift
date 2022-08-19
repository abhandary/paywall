//
//  AssetStore.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/13/22.
//

import Foundation
import CryptoKit

private let TAG = "AssetStore"

enum AssetStoreError : Error {
  case networkError
}

typealias AssetStoreResultCompletion = (Result<Asset, AssetStoreError>) -> Void

class AssetStore {
  
  private let session: NetworkSessionProtocol
  
  static let shared = AssetStore()
  
//MARK: public methods
  
  init(session: NetworkSessionProtocol = URLSession.paywall) {
    self.session = session
  }
  
  func fetchAsset(url: URL, completion: @escaping AssetStoreResultCompletion) {
    let urlRequest = URLRequest(url: url)
    self.session.loadData(from: urlRequest) { result in
      switch(result) {
      case .success(let data):
        completion(.success(Asset(url: url, state: .downloaded, data: data)))
      case .failure(let error):
        Log.error(TAG, error)
        completion(.failure(.networkError))
      }
    }
  }
}

