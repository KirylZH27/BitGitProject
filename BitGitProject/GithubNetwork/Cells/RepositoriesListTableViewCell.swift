//
//  GithubTableViewCell.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 26.04.23.
//

import UIKit

class RepositoriesListTableViewCell: UITableViewCell {

    static let id = String(describing: RepositoriesListTableViewCell.self)
    
    @IBOutlet var hederLabel: UILabel!
    @IBOutlet var imagePerson: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func set(info: GitHubModel) {
        self.hederLabel.text = "\(info.name)"
        self.descriptionLabel.text = "\(info.description)"
        setImagePerson(imageUrlString: info.owner?.avatarUrl)
    }
    
    private func setImagePerson(imageUrlString: String?) {
        guard let imageUrlString else { return }
        guard let imageUrl = URL(string: imageUrlString) else { return }
        imagePerson.load(url: imageUrl)
    }
}
