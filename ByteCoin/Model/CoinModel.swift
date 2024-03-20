//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Farhan Fadhilah on 20/03/24.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

import Foundation
struct CoinModel: Codable {
    var currency: String
    var rate: Double
    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
