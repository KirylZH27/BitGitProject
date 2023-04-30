//
//  GithubViewController.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 26.04.23.
//

import UIKit

enum RepositoriesSortedType {
    case GitHub
    case BitBucket
}
enum AlphabetSortedType {
    case alphabet
    case invertAlphabet
    case initial
}

class RepositoriesListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var repositories = [RepositoriesModel]()
    private var defaultRepositories = [RepositoriesModel]()
    private var currentRepositoriesSortedType: RepositoriesSortedType = .GitHub
    private var currentAlphabetSortedType: AlphabetSortedType = .initial
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getData()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        
        let nib = UINib(nibName: RepositoriesListTableViewCell.id, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: RepositoriesListTableViewCell.id)
    }
    
    private func getData(){
        Provider().getRepositories { [weak self] result in
            switch result {
                case .success(let repositories):
                    self?.repositories = repositories
                    self?.defaultRepositories = repositories
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                case .failure(let error):
                    self?.showErrorAlert(with: error.localizedDescription)
            }
        }
    }
    private func showErrorAlert(with error: String){
        let title = "Error"
        let message = error
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alertController, animated: false)
    }
    
    
    @IBAction func sortedTypesRepositoriesButtonWasPressed(_ sender: Any) {
        switch currentRepositoriesSortedType {
            case .GitHub:
                repositories.sort { $0.repositoriesName < $1.repositoriesName }
                currentRepositoriesSortedType = .BitBucket
            case .BitBucket:
                repositories.sort { $0.repositoriesName > $1.repositoriesName }
                currentRepositoriesSortedType = .GitHub
        }
        tableView.reloadData()
    }
    
    
    @IBAction func alphabetSortedButtonWasPressed(_ sender: Any) {
        switch currentAlphabetSortedType {
            case .alphabet:
                repositories.sort{ $0.name > $1.name}
                currentAlphabetSortedType = .invertAlphabet
            case .invertAlphabet:
                repositories = defaultRepositories
                currentAlphabetSortedType = .initial
            case .initial:
                repositories.sort{ $0.name < $1.name}
                currentAlphabetSortedType = .alphabet
        }
        tableView.reloadData()
    }
}

extension RepositoriesListViewController {
    @objc private func refreshData() {
        getData()
    }
}

extension RepositoriesListViewController: UITableViewDelegate {
    
}

extension RepositoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoriesListTableViewCell.id, for: indexPath)
        
        guard let repositoriesCell = cell as? RepositoriesListTableViewCell else { return cell }
        repositoriesCell.setupCell(with: repositories[indexPath.row])
        
        return repositoriesCell
    }
}
