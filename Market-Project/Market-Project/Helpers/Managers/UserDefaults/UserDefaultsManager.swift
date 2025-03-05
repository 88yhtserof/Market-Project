//
//  UserDefaultsManager.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/27/25.
//

import Foundation

import RxSwift
import RxCocoa

@propertyWrapper
struct UserDefaultsWrapper<T: Codable> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            let value = UserDefaultsCodable.shared.object(T.self, forKey: key)
            switch value {
            case .success(let success):
                return success
            case .failure(let failure):
                print(failure) // TODO: - 오류 발생 시 alert로 표시
                return defaultValue
            }
        }
        set {
            UserDefaultsCodable.shared.set(newValue, forKey: key)
            setNewValue.onNext(newValue)
        }
    }
    
    private let setNewValue: BehaviorSubject<T?> = BehaviorSubject(value: nil)
    
    var projectedValue: Observable<T> {
        return setNewValue
            .compactMap{ $0 }
            .share()
    }
}


enum UserDefaultsManager {
    
    enum Key: String {
        case wishList
    }
    
    @UserDefaultsWrapper<[String: MarketItem]>(key: Key.wishList.rawValue, defaultValue: [:])
    static var wishList
}
