//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateData(_ coinModel: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B43A3EF6-6647-43F2-B803-BE92807DEB13"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        self.performRequest(with: urlString, for: currency)
    }
    
    func performRequest(with urlString: String, for currency: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = self.parseJson(coinData: safeData, for: currency){
                        self.delegate?.didUpdateData(coin)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJson(coinData: Data, for currency: String) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(CoinData.self, from: coinData)
            let coinModel = CoinModel(currency: currency, rate: decodeData.rate)
            return coinModel
        } catch {
            return nil
        }
    }
}
