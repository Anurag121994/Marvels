//
//  Constants.swift
//  Marvels
//
//  Created by Anurag Mehta on 03/02/22.
//

import Foundation

class Constants: NSObject {
    
    static let alertTitle = "Alert"
    static let parsingDataErrorMessage = "Error occured while parsing the data"
    static let internetConnectionErrorMessage = "No Internet connection. Please check your network settings."
    static let characterSeriesHeaderTitle = "Series :"
}

extension Constants {
    
    static let apiBaseURLString = "https://gateway.marvel.com/v1/public/"
    
    class func charactersURLString() -> String {
        return (apiBaseURLString + "characters")
    }
    
    class func characterDetailURLString(with id: String) -> String {
        return (apiBaseURLString + "characters/\(id)")
    }
}
