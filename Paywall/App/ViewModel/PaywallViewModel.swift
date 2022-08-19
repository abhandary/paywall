//
//  PaywallViewModel.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//

import Foundation
import Combine

private let TAG = "PaywallViewModel"

final class PaywallViewModel {
  
  let queue = DispatchQueue(label: TAG)
  
  let repo: PaywallRepositoryProtocol
  
  @MainActor @Published var paywall : Paywall? 
  
  init(repo: PaywallRepositoryProtocol) {
    self.repo = repo
  }
  
  @MainActor func fetchPaywall() {
    // free up the main thread
    queue.async {[weak self] in
      self?.fetchPaywallAsync()
    }
  }
  
  func fetchPaywallAsync() {
    self.repo.fetchPaywall { [weak self] result in
      guard let self = self else {
        Log.error(TAG, "self is nil")
        return
      }
      switch(result) {
      case .success(let paywall):
        DispatchQueue.main.async {
          self.paywall = paywall
        }
      case .failure(let error):
        Log.error(TAG, error)
      }
    }
  }
}
