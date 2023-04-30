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
    @IBOutlet var searchBar: UISearchBar!
    
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
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
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
    
    private func filteredByUserName(serchedText: String) -> [RepositoriesModel]{
        repositories.filter { $0.userName.lowercased().contains(serchedText.lowercased())}
    }
    private func filteredByRepositoriesName(serchedText: String) -> [RepositoriesModel]{
        repositories.filter { $0.name.lowercased().contains(serchedText.lowercased())}
    }
    private func filterByRepositoriesTypeName(serchedText: String) -> [RepositoriesModel]{
        repositories.filter { $0.repositoriesName.lowercased().contains(serchedText.lowercased())}
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositore = repositories[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let repositoreVC = storyboard.instantiateViewController(withIdentifier: "PersonDescriptionViewController") as! PersonDescriptionViewController
        repositoreVC.repositore = repositore
        navigationController?.pushViewController(repositoreVC, animated: true)
    }
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

extension RepositoriesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        repositories = defaultRepositories
        guard !searchText.isEmpty else {
            tableView.reloadData()
            return }
        var filtertedRepositories: Set<RepositoriesModel> = []
        
        let userNameFiltered = filteredByUserName(serchedText: searchText)
        let repositoriesNameFiltered = filteredByRepositoriesName(serchedText: searchText)
        let repositoriesTypeNameFiltered = filterByRepositoriesTypeName(serchedText: searchText)
        
        userNameFiltered.forEach{filtertedRepositories.insert($0)}
        repositoriesNameFiltered.forEach{filtertedRepositories.insert($0)}
        repositoriesTypeNameFiltered.forEach{filtertedRepositories.insert($0)}
        
        repositories = Array(filtertedRepositories)
        tableView.reloadData()
    }
}
