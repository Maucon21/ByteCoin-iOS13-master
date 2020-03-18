//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation



protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager : CoinManager, coin : CoinModel)
    func didFailWithError(error : Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "2E02A155-935B-4B8E-A869-A49493334418"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    var delegate : CoinManagerDelegate?
    
    func getCoinPrice(for currency : String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        perfomRequest(with: urlString)
        print(urlString)
    }
    
    func perfomRequest(with urlString: String) {
        //step 1 Create URL
        if  let url = URL(string: urlString) {
            // Step 2 create URL Session
            let session = URLSession(configuration: .default)
            // Step 3 : Give the session Task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    //var backToString = String(data: safeData, encoding: String.Encoding.utf8) as String?
                    //print(backToString)
                    if let coin =  self.parseJson(safeData) {
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            }
            // step 4 : Start Task
            task.resume()
        }
    }
    
    func parseJson(_ data : Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(CoinData.self, from: data)
            let rate = decodeData.rate
            let quota = decodeData.asset_id_quote
            let rateU = CoinModel(rate: rate, currency: quota)
            return rateU
            
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
