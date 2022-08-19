//
//  PaywallViewController.swift
//  Paywall
//
//  Copyright © 2020 Disney Streaming. All rights reserved.
//

import UIKit
import Combine
import SwiftUI

private let TAG = "PaywallViewController"

@MainActor class PaywallViewController: UIViewController {

  var cancellables: Set<AnyCancellable> = []
  let viewModel: PaywallViewModel
  lazy var paywallView = PaywallView()
  lazy var loadingViewController = UIHostingController(rootView: LoadingView())
  
  init(viewModel: PaywallViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  // This is also necessary when extending the superclass.
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    showLoadingView()
    setupViewModel()
  }
  
  func didShake() {
    self.viewModel.fetchPaywall()
  }
}

//MARK: - View Model work extension
extension PaywallViewController {
  func setupViewModel() {
    viewModel.$paywall
      .receive(on: RunLoop.main)
      .sink { paywall in self.paywallUpdated(paywall: paywall)
      }.store(in: &cancellables)
    self.viewModel.fetchPaywall()
  }
  
  func paywallUpdated(paywall: Paywall?) {
    Log.verbose(TAG, "paywall updated")
    guard let paywall = paywall else {
      Log.error(TAG, "got a nil paywall")
      return
    }
    showPaywallView(withPaywall: paywall)
  }
}

//MARK: - View management extension
extension PaywallViewController {
  func showPaywallView(withPaywall paywall: Paywall) {
    self.loadingViewController.removeFromParent()
    self.loadingViewController.view.removeFromSuperview()
    paywallView.removeFromSuperview()
    paywallView = PaywallView()
    paywallView.setup(usingPaywall: paywall)
    self.view.addSubview(paywallView)
    paywallView.frame = self.view.frame
  }
  
  func showLoadingView() {
    paywallView.removeFromSuperview()
    self.addChild(loadingViewController)
    self.view.addSubview(loadingViewController.view)
    loadingViewController.view.frame = self.view.frame
  }
}

extension PaywallViewController {
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
    if motion == .motionShake {
      didShake()
    }
  }
}
