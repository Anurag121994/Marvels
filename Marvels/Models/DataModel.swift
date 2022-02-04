//
//  DataModel.swift
//  Marvels
//
//  Created by Anurag Mehta on 01/02/22.
//

import Foundation

struct DataModel: Codable, Equatable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [CharacterDataModel]?
}
