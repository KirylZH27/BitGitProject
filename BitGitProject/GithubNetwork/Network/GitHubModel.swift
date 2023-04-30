//
//  Model.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 26.04.23.
//

import Foundation
import ObjectMapper

class GitHubModel: Mappable {
    var name: String = ""
    var description: String = ""
    var owner: GitHubOwner?
    
    required init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        name        <- map["name"]
        description <- map["description"]
        owner <- map["owner"]
    }
    
    
}
class GitHubOwner: Mappable {
    var avatarUrl: String = ""
    
    required init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        avatarUrl <- map["avatar_url"]
    }
}

extension GitHubModel {
    func convertToRepositoriesModel() -> RepositoriesModel {
        let repositoresModel = RepositoriesModel(name: name, description: description, imageURLString: owner?.avatarUrl ?? "", repositoriesName: "GitHub")
        return repositoresModel
    }
}
