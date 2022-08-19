//
//  PaywallTestUtils.swift
//  PaywallTestUtils
//
//

@testable import Paywall

struct PaywallDecoderUtils {
  
  static let json = #"""
    {
        "meta": {
            "backgroundImage": "http://localhost:8000/images/splash.png",
            "backgroundColor": "#1A1D28FF"
          },
          "components": [
            {
              "type": "image",
              "url": "http://localhost:8000/images/logo.png",
              "aspect_ratio": 2.3,
              "alignment": "center",
              "padding": 50.0
            },
            {
              "type": "separator",
              "height_proportion": 0.02
            },
          ]
    }
    """#

  static func getHardcodedPaywall() -> Paywall {
    return PaywallDecoder().decode(type: Paywall.self, from: json.data(using: .utf8))!
  }
}
