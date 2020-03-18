//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Mauricio Contreras on 18/03/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let rate: Double
    let currency: String
    
    var coinRate: String {
        return String(format: "%.1f", rate)
    }
  
    
}
