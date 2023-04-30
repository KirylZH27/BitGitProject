//
//  RepositoriesModel.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 30.04.23.
//

import UIKit
final class RepositoriesModel: Hashable {
    
    static func == (lhs: RepositoriesModel, rhs: RepositoriesModel) -> Bool {
        let isEquatable = lhs.name == rhs.name && lhs.description == rhs.description && lhs.imageURLString == rhs.imageURLString && lhs.repositoriesName == rhs.repositoriesName && lhs.userName == rhs.userName
        return isEquatable
        
    }
    
    var name: String
    var description: String
    var imageURLString: String
    var repositoriesName: String
    var userName: String
    
    init(name: String, description: String, imageURLString: String, repositoriesName: String, userName: String) {
        self.name = name
        self.description = description
        self.imageURLString = imageURLString
        self.repositoriesName = repositoriesName
        self.userName = userName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(imageURLString)
        hasher.combine(repositoriesName)
        hasher.combine(userName)
    }
}
