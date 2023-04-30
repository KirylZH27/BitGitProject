//
//  RepositoriesListTableViewCell.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 30.04.23.
//

import UIKit

class RepositoriesListTableViewCell: UITableViewCell {

    static let id = String(describing: RepositoriesListTableViewCell.self)
    
    @IBOutlet var hederLabel: UILabel!
    @IBOutlet var imagePerson: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var typeRepositoriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        imagePerson.image = UIImage(systemName: "person")
    }
    
    func setupCell(with model: RepositoriesModel) {
        self.hederLabel.text = model.name
        self.descriptionLabel.text = model.description
        self.typeRepositoriesLabel.text = model.repositoriesName
        setImagePerson(imageUrlString: model.imageURLString)
    }
                       
    private func setImagePerson(imageUrlString: String?) {
        guard let imageUrlString else { return }
        guard let imageUrl = URL(string: imageUrlString) else { return }
        imagePerson.load(url: imageUrl)
    }
}
