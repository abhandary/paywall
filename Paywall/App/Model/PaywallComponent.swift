//
//  PaywallComponent.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//  Copyright © 2022 Disney Streaming. All rights reserved.
//

import Foundation

struct PaywallComponent : Codable, Equatable {
  let type: String
  let title: String?
  let color: String?
  let bgColor: String?
  let weight: String?
  let alignment: String?
  let aspectRatio: Float?
  let size: Float?
  let url: String?
  let widthMultipler: Float?
  let heightProportion: Float?
  let widthProportion: Float?
  let padding: Float?
  let alert: String?
}
