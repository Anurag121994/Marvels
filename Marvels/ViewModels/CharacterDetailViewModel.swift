//
//  CharacterDetailViewModel.swift
//  Marvels
//
//  Created by Anurag Mehta on 01/02/22.
//

import Foundation

class CharacterDetailViewModel {
    
    private var httpManager = HTTPManager.shared
    private var jsonParser = JSONParser.shared
    private var characterDetail: CharacterDataModel?
    
    var apiAuthenticator: MD5Authenticator {
        MD5Authenticator(keyData: EnvironmentVariableKeyRetriever())
    }
    
    func fetchCharacterDetailData(id: String, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        guard let params = apiAuthenticator.authenticate(with: Date().timeIntervalSince1970) else { return}
        httpManager.get(urlString: Constants.characterDetailURLString(with: id), parameters: params, completionBlock: {[weak self] result in
            switch result {
            case .success(let data):
                if let parseData = self?.jsonParser.parse(json: data){
                    self?.characterDetail = parseData.first
                    completionBlock(.success(true))
                }else{
                    completionBlock(.success(false))
                }
            case .failure(let error):
                completionBlock(.failure(error))
            }
        })
    }
}

extension CharacterDetailViewModel {
    
    var characterSeriesCount: Int {
        guard let charactersData = characterDetail, let series = charactersData.series,let items = series.items else{return 0}
        return items.count
    }
    
    var characterName: String {
        guard let charactersData = characterDetail, let name = charactersData.name else {return ""}
        return name
    }
    
    var characterDescription: String {
        guard let charactersData = characterDetail, let description = charactersData.description else {return ""}
        return description
    }
    
    var characterImageURLString: String {
        guard let charDetail = characterDetail, let charThumbnail = charDetail.thumbnail, let path = charThumbnail.path, let imageExtension = charThumbnail.imageExtension else {return ""}
        let imageURLString = path + ".\(imageExtension)"
        return imageURLString
    }
    
    func characterSeriesName(at index: Int) -> String? {
        guard let charactersData = characterDetail, let series = charactersData.series,let items = series.items else{return ""}
        return items[index].name
    }
}
