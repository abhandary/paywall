//
//  PaywallView.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//  Copyright © 2022 Disney Streaming. All rights reserved.
//

import Foundation
import UIKit

private let TAG = "PaywallView"

class PaywallView : UIView {
  
  lazy var splashImage = UIImageView()
  lazy var vStack = UIStackView()
  var stackedViews: [UIView?] = []
  
  func setup(usingPaywall paywall: Paywall) {
    
    setupMeta(withPaywall: paywall)
    setupPaywallVStack(withPaywall: paywall)
    
    NSLayoutConstraint.activate(staticConstraints(withPaywall: paywall))
  }
  
  private func setupMeta(withPaywall paywall: Paywall) {
    self.backgroundColor = UIColor(hexaString: paywall.meta.backgroundColor)
    setupSplashImage(paywall: paywall)
  }
  
  private func setupSplashImage(paywall: Paywall) {
    self.addSubview(splashImage)
    splashImage.translatesAutoresizingMaskIntoConstraints = false
    guard let url = URL(string: paywall.meta.backgroundImage) else {
      Log.error(TAG, "paywall splash image URL is invalid")
      return
    }
    AssetStore.shared.fetchAsset(url: url) { [weak self]  result in
      guard let self = self else {
        Log.error(TAG, "self is nil")
        return
      }
      switch(result) {
      case .success(let asset):
        DispatchQueue.main.async {
          self.splashImage.image = UIImage(data: asset.data)
        }
      case .failure(let error):
        Log.error(TAG, error)
      }
    }
  }
  
  private func setupPaywallVStack(withPaywall paywall: Paywall) {
    
    vStack = UIStackView()
    vStack.axis = .vertical
    vStack.distribution = .fill
    vStack.alignment = .fill
    vStack.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(vStack)
    
    for component in paywall.components {
      switch (component.type) {
      case "label":
        stackedViews.append(addLabel(component: component))
      case "image":
        stackedViews.append(addImage(component: component))
      case "button":
        stackedViews.append(addButton(component: component))
      case "separator":
        stackedViews.append(addSeparator(component: component))
      default:
        Log.error(TAG, "unknown type - \(component.type)")
      }
    }
  }
  
  private func addButton(component: PaywallComponent) -> UIView? {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = PaywallView.bgColor(forComponent: component)
    button.clipsToBounds = true
    button.setTitle(component.title, for: .normal)
    button.titleLabel?.font = PaywallView.font(forComponent: component)
    return button
  }
  
  
  private func addLabel(component: PaywallComponent) -> UIView? {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = PaywallView.font(forComponent: component)
    label.backgroundColor = PaywallView.bgColor(forComponent: component)
    label.textColor = PaywallView.color(forComponent: component)
    label.numberOfLines = 0
    label.textAlignment = PaywallView.alignment(forComponent: component)
    label.text = component.title
    return label
  }
  
  private func addImage(component: PaywallComponent) -> UIView? {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    
    image.translatesAutoresizingMaskIntoConstraints = false
    guard let urlString = component.url,
          let url = URL(string: urlString) else {
      Log.error(TAG, "paywall splash image URL is invalid")
      return nil
    }
    AssetStore.shared.fetchAsset(url: url) { result in
      switch(result) {
      case .success(let asset):
        DispatchQueue.main.async {
          image.image = UIImage(data: asset.data)
        }
      case .failure(let error):
        Log.error(TAG, error)
      }
    }
    return image
  }
  
  private func addSeparator(component: PaywallComponent) -> UIView? {
    let view = UIView()
    view.backgroundColor = PaywallView.bgColor(forComponent: component)
    return view
  }
  
  
  //MARK: - constraints
  
  private func staticConstraints(withPaywall paywall: Paywall) -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    
    // profile image constraints
    constraints.append(contentsOf: [
      splashImage.topAnchor.constraint(equalTo: self.topAnchor),
      splashImage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      splashImage.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      splashImage.widthAnchor.constraint(equalTo: splashImage.heightAnchor, multiplier: 0.7)
    ])
    
    // vstack constraints to make it grow from the bottom
    constraints.append(contentsOf:[
      vStack.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
      vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      vStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      vStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
    ])
    
    for (ix, component) in paywall.components.enumerated() {
      
      var view = stackedViews[ix]
      if let padding = component.padding, let unwrappedView = view {
        let wrappedView = wrapInPaddedSpacers(view:unwrappedView, padding: padding)
        view = wrappedView
      }
      
      if let view = view {
        
        if let aspectRatio = component.aspectRatio {
          constraints.append(contentsOf:[
            view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: CGFloat(aspectRatio))
          ])
        }
        
        if let heightProportion = component.heightProportion {
          constraints.append(contentsOf:[
            view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: CGFloat(heightProportion))
          ])
        }
        if let widthProportion = component.widthProportion {
          constraints.append(contentsOf:[
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: CGFloat(widthProportion))
          ])
        }
        vStack.addArrangedSubview(view)
      }
    }
    
    return constraints
  }
  

  
  //MARK: - helpers
  
  private func wrapInPaddedSpacers(view: UIView, padding: Float) -> UIView {
    let hstack = UIStackView()
  //  hstack.backgroundColor = UIColor.random()
    hstack.alignment = .fill
    hstack.distribution = .fill
    hstack.axis = .horizontal
    view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    hstack.layoutMargins
      = UIEdgeInsets(top: 0, left: CGFloat(padding), bottom: 0, right: CGFloat(padding))
    hstack.isLayoutMarginsRelativeArrangement = true
    hstack.addArrangedSubview(view)
    return hstack
  }
  
  private static func color(forComponent component: PaywallComponent) -> UIColor? {
    if let color = component.color {
      return UIColor(hexaString: color)
    }
    return nil
  }
  
  private static func bgColor(forComponent component: PaywallComponent) -> UIColor? {
    if let bgColor = component.bgColor {
      return UIColor(hexaString: bgColor)
    }
    return UIColor(white: 1.0, alpha: 0.0)
  }
  
  private static func alignment(forComponent component: PaywallComponent) -> NSTextAlignment {
    if let alignment = component.alignment {
      switch (alignment) {
      case "center":
        return .center
      case "left":
        return .left
      case "right":
        return .right
      case "justified":
        return .justified
      default:
        return .center
      }
    }
    return .center
  }
  
  private static func font(forComponent component: PaywallComponent) -> UIFont? {
    guard let size = component.size else {
      return nil
    }
    switch (component.weight) {
    case "bold":
      return UIFont.boldSystemFont(ofSize: CGFloat(size))
    default:
      return UIFont.systemFont(ofSize: CGFloat(size))
    }
  }
  
}

extension UIColor {
    convenience init(hexaString: String, alpha: CGFloat = 1) {
        let chars = Array(hexaString.dropFirst())
        self.init(red:   .init(strtoul(String(chars[0...1]),nil,16))/255,
                  green: .init(strtoul(String(chars[2...3]),nil,16))/255,
                  blue:  .init(strtoul(String(chars[4...5]),nil,16))/255,
                  alpha: alpha)}
}
