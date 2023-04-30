//
//  RepositoriesModel.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 30.04.23.
//

import UIKit
final class RepositoriesModel {
    var name: String
    var description: String
    var imageURLString: String
    var repositoriesName: String
    
    init(name: String, description: String, imageURLString: String, repositoriesName: String) {
        self.name = name
        self.description = description
        self.imageURLString = imageURLString
        self.repositoriesName = repositoriesName
    }
}
