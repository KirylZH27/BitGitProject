//
//  GithubViewController.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 26.04.23.
//

import UIKit

class RepositoriesListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var info = [GitHubModel]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getData {}
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        
        let nib = UINib(nibName: RepositoriesListTableViewCell.id, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: RepositoriesListTableViewCell.id)
    }
    
    private func getData(completion: @escaping () -> Void){
        Provider().getInfo { result in
            self.info = result
            self.tableView.reloadData()
            completion()
        } failure: {
            completion()
        }
    }
}

extension RepositoriesListViewController {
    @objc private func refreshData() {
        getData { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

extension RepositoriesListViewController: UITableViewDelegate {
    
}

extension RepositoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoriesListTableViewCell.id, for: indexPath)
        
        guard let githubCell = cell as? RepositoriesListTableViewCell else { return cell }
        githubCell.set(info: info[indexPath.row])
        
        return githubCell
    }
}
