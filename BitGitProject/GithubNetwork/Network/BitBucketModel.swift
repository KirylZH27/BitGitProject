//
//  BitBucketModel.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 30.04.23.
//

import Foundation
import ObjectMapper

final class BitBucketModel: Mappable {

    var values: [BitBucketValues] = []
    
    required init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        values <- map["values"]
    }
}

final class BitBucketValues: Mappable {
    var name = ""
    var description = ""
    var owner: BitBucketOwner?
    
    required init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        name <- map["name"]
        description <- map["description"]
        owner <- map["owner"]
    }
}

final class BitBucketOwner: Mappable {
    var links: BitBucketOwnerLinks?
    var displayName: String = ""
    
    required init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        links <- map["links"]
        displayName <- map["display_name"]
    }
}

final class BitBucketOwnerLinks: Mappable {
    var avatar: BitBucketAvatar?
    
    required init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        avatar <- map["avatar"]
    }
}

final class BitBucketAvatar: Mappable {
    var href: String = ""
    
    required init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        href <- map["href"]
    }
}

extension BitBucketModel {
    func convertToRepositoriesModels() -> [RepositoriesModel] {
        var repositoriesModels: [RepositoriesModel] = []
        for bitBucketValue in values {
            let name = bitBucketValue.name
            let description = bitBucketValue.description
            let imageURLString = bitBucketValue.owner?.links?.avatar?.href
            let userName = bitBucketValue.owner?.displayName
            let repositoriesModel = RepositoriesModel(name: name, description: description, imageURLString: imageURLString ?? "", repositoriesName: "BitBucket", userName: userName ?? "NoName")
            repositoriesModels.append(repositoriesModel)
        }
        return repositoriesModels
    }
}
