//
//  CoinManager.swift
//  littleBitCoin
//
//  Created by Kubra Bozdogan on 12/11/24.
//
import Foundation
import CryptoKit
import CommonCrypto

protocol CoinManagerDelegate {
    func didUpdatePrice(price:String, currency: String)
    func didFailWithError (error: Error)
}
struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
//    let apiKey = "3D7865FC-C6CC-45B0-9D82-03416D7EE9F9"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        if let apiKey = getSecretKeys() {
            let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    //print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
        } else {
            print("API key not found 🥲")
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            
            return lastPrice
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    func getSecretKeys()  -> String? {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey") as? String
        return apiKey
    }
}
