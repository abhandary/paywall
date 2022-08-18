//
//  PaywallViewModel.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//  Copyright © 2022 Disney Streaming. All rights reserved.
//

import Foundation
import Combine

private let TAG = "PaywallViewModel"

final class PaywallViewModel {
  
  let repo: PaywallRepositoryProtocol
  
  @MainActor @Published var paywall : Paywall? 
  
  init(repo: PaywallRepositoryProtocol) {
    self.repo = repo
  }
  
  func fetchPaywall() {
    self.repo.fetchPaywall { [weak self] result in
      switch(result) {
      case .success(let paywall):
        DispatchQueue.main.async {
          self?.paywall = paywall
        }
      case .failure(let error):
        Log.error(TAG, error)
      }
    }
  }
}
