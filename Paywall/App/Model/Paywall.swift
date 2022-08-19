//
//  Paywall.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//

import Foundation

struct Paywall : Codable, Equatable {
  let meta: PaywallMeta
  let components: [PaywallComponent]
}
