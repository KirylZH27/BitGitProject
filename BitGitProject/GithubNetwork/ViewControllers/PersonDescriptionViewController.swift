//
//  PersonDescriptionViewController.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 30.04.23.
//

import UIKit

class PersonDescriptionViewController: UIViewController {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var typeRepositoriesLabel: UILabel!
    @IBOutlet var imagePerson: UIImageView!
    @IBOutlet var userNameLAbel: UILabel!
    
    var repositore: RepositoriesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = repositore?.name
        descriptionLabel.text = repositore?.description
        typeRepositoriesLabel.text = repositore?.repositoriesName
        userNameLAbel.text = repositore?.userName
       
        setImagePerson(imageUrlString: repositore?.imageURLString)
    }
    
    private func setImagePerson(imageUrlString: String?) {
        guard let imageUrlString else { return }
        guard let imageUrl = URL(string: imageUrlString) else { return }
        imagePerson.load(url: imageUrl)
    }
}
