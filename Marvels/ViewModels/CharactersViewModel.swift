//
//  CharactersViewModel.swift
//  Marvels
//
//  Created by Anurag Mehta on 01/02/22.
//

import Foundation

class CharactersViewModel {
    
    private var httpManager = HTTPManager.shared
    private var jsonParser = JSONParser.shared
    private var characters: [CharacterDataModel]?

    var apiAuthenticator: MD5Authenticator {
        MD5Authenticator(keyData: EnvironmentVariableKeyRetriever())
    }
    
    func fetchCharactersData(completionBlock: @escaping (Result<Bool,Error>) -> Void) {
        guard let params = apiAuthenticator.authenticate(with: Date().timeIntervalSince1970) else {return}
        httpManager.get(urlString: Constants.charactersURLString(), parameters: params, completionBlock: {[weak self] result in
            switch result {
            case .success(let data):
                if let parseData = self?.jsonParser.parse(json: data) {
                    self?.characters = parseData
                    completionBlock(.success(true))
                }else {
                    completionBlock(.success(false))
                }
            case .failure(let error):
                completionBlock(.failure(error))
            }
        })
    }
    
    var charactersCount: Int {
        guard let charactersData = characters else{return 0}
        return charactersData.count
    }
    
    func character(at index: Int) -> CharacterDataModel? {
        guard let charactersData = characters else{return nil}
        return charactersData[index]
    }
    
    func selectedCharacterID(at index: Int) -> Int? {
        guard let charactersData = characters else{return 0}
        return charactersData[index].id
    }
}
