//
//  CharacterDetailViewController.swift
//  Marvels
//
//  Created by Anurag Mehta on 31/01/22.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var characterNameLabel: UILabel!
    @IBOutlet private weak var characterDescriptionLabel: UILabel!
    @IBOutlet private weak var characterSeriesTableView: UITableView!
    var characterID : Int? = nil
    private let characterDetailVM = CharacterDetailViewModel()
    private let seriesNameCellIdentifier = "SeriesNameCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViewModel()
    }
    
    func initViewModel() {
        guard let characterID = characterID else {return}
        startActivityIndicator()
        
        characterDetailVM.fetchCharacterDetailData(id: "\(characterID)") {[weak self] result in
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
                switch result {
                case .success(let statusBool):
                    if statusBool == true {
                        self?.refreshCharacterDetails()
                    }else {
                        self?.presentAlert(withTitle: Constants.alertTitle, message: Constants.parsingDataErrorMessage)
                    }
                case .failure( _):
                    DispatchQueue.main.async {
                        self?.presentAlert(withTitle: Constants.alertTitle, message: Constants.internetConnectionErrorMessage)
                    }
                }
            }
        }
    }
    
    func refreshCharacterDetails() {
        
        characterImageView.loadImageUsingCache(withUrl: characterDetailVM.characterImageURLString)
        characterNameLabel.text = characterDetailVM.characterName
        characterDescriptionLabel.text = characterDetailVM.characterDescription
        
        characterSeriesTableView.reloadData()
    }
}

extension CharacterDetailViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if characterDetailVM.characterSeriesCount > 0 {return 1}
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterDetailVM.characterSeriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.seriesNameCellIdentifier) as! CharacterSeriesNameTableViewCell
        guard let seriesName = characterDetailVM.characterSeriesName(at: indexPath.row) else { return cell}
        cell.refreshSeriesName(seriesName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.characterSeriesHeaderTitle
    }
    
    
}
