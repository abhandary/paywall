//
//  SceneDelegate.swift
//  Paywall
//
//  Copyright © 2020 Disney Streaming. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  /// `true` to use UIKit, `false` to use SwiftUI.
  let useUIKit = true

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }

    let window = UIWindow(windowScene: windowScene)
    if useUIKit {
      let dataFetcher = PaywallDataFetcher()
      let repo = PaywallRepository(dataFetcher: dataFetcher)
      let viewModel = PaywallViewModel(repo: repo)
      let rootViewController = PaywallViewController(viewModel: viewModel)
      rootViewController.view.backgroundColor = .white
      window.rootViewController = rootViewController
    }
    else {
      let rootView = PaywallViewOld()
      window.rootViewController = UIHostingController(rootView: rootView)
    }
    self.window = window
    window.makeKeyAndVisible()
  }

}

