//
//  Paywall.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//  Copyright © 2022 Disney Streaming. All rights reserved.
//

import Foundation

struct Paywall : Codable, Equatable {
  let meta: PaywallMeta
  let components: [PaywallComponent]
}
