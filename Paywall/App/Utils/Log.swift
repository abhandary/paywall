//
//  Log.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//

import Foundation

import Foundation

struct Log {
  static func error(_ tag: String, _ message: Any...) {
    print("\(tag): Error:", message)
  }
  static func verbose(_ tag: String, _ message: Any...) {
    print("\(tag): Verbose:", message)
  }
}
