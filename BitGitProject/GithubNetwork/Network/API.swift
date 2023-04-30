//
//  API.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 26.04.23.
//

import Foundation
import Moya

enum API {
    case GitHub
    case BitBucket
}
extension API: TargetType {
    
    var baseURL: URL {
        switch self {
            case .GitHub:
                return URL (string: "https://api.github.com/repositories?")!
            case .BitBucket:
                return URL (string: "https://api.bitbucket.org/2.0/repositories?fields=values.name,values.owner,values.description")!
        }
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        switch self {
            case.GitHub:
                return .get
            case .BitBucket:
                return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        guard let parameters else {return .requestPlain}
        
        return .requestParameters(parameters: parameters, encoding: encoding)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String: Any]? {
        //MARK: - Можно прокидывать параметры
        var params = [String: Any]()
        
        switch self{
            case .GitHub:
                return nil
            case .BitBucket:
                return nil
        }
        return params
    }
    
    var encoding: ParameterEncoding {
        switch self {
            case .GitHub, .BitBucket:
                return URLEncoding.queryString
        }
    }
    
}
