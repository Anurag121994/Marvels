//
//  CharactersViewController.swift
//  Marvels
//
//  Created by Anurag Mehta on 31/01/22.
//

import UIKit

class CharactersViewController: UIViewController {
    
    @IBOutlet private weak var charactersTableView: UITableView!
    private let charactersVM = CharactersViewModel()
    private let characterDetailViewControllerIdentifier = "CharacterDetailViewController"
    private let characterTableViewCellIdentifier = "CharacterTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViewModel()
    }
    
    func initViewModel() {
        startActivityIndicator()
        charactersVM.fetchCharactersData {[weak self] result  in
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
                switch result {
                case .success(let successBool):
                    if successBool == true {
                        self?.charactersTableView.reloadData()
                    }else{
                        self?.presentAlert(withTitle: Constants.alertTitle, message: Constants.parsingDataErrorMessage)
                    }
                case .failure( _):
                    self?.presentAlert(withTitle: Constants.alertTitle, message: Constants.internetConnectionErrorMessage)
                }
            }
        }
    }
}

extension CharactersViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactersVM.charactersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: characterTableViewCellIdentifier) as! CharacterTableViewCell
        guard let character = charactersVM.character(at: indexPath.row) else{return cell}
        cell.refreshWithCharacter(character)
        return cell
    }
}

extension CharactersViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: characterDetailViewControllerIdentifier) as! CharacterDetailViewController
        characterDetailViewController.characterID = charactersVM.selectedCharacterID(at: indexPath.row)
        navigationController?.pushViewController(characterDetailViewController, animated: true)
    }
}

