//
//  AuthenticationInfoManager.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/16/25.
//

import Foundation

enum AuthenticationInfoManager {
    case naver
    
    
    private static let dictionary: NSDictionary? = {
        guard let url = Bundle.main.url(forResource: "authenticationInfo", withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: url) else {
            print("Failed to find resource")
            return nil
        }
        return dictionary
    }()
    
    var clientID: String? {
        guard let dictionary = AuthenticationInfoManager.dictionary,
              let clientID = dictionary["naver-client-id"] as? String else {
            print("Failed to case resource")
            return nil
        }
        return clientID
    }
    
    var clientSecret: String? {
        guard let dictionary = AuthenticationInfoManager.dictionary,
              let clientSecret = dictionary["naver-client-secret"] as? String else {
            print("Failed to case resource")
            return nil
        }
        return clientSecret
    }
}
