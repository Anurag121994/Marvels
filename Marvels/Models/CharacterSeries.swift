//
//  CharacterSeries.swift
//  Marvels
//
//  Created by Anurag Mehta on 01/02/22.
//

import Foundation

struct CharacterSeries: Codable, Equatable {
    let available : Int?
    let items : [CharacterSeriesItem]?
}

struct CharacterSeriesItem: Codable, Equatable{
    let resourceURI : String?
    let name : String?
}
