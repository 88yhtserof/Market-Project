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
            print("Get", key)
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
            print("Set", newValue, key)
            UserDefaultsCodable.shared.set(newValue, forKey: key)
        }
    }
    
    var projectedValue: Observable<T> {
        return UserDefaults.standard.rx
            .observe(T.self, key) // UserDefaults와 그 프로퍼티의 value를 관찰한다 -> 변경사항 발생 시 이벤트로 받는다
            .map{
                print(key, $0)
                return defaultValue // 원래 신호만 전달되는게 맞는건가?
            }
            .share()   // 변경 사항 발생 시 모든 구독자에게 동일한 값을 전달하기 위함 + 불필요한 스트림 생성 방지
    }
}


enum UserDefaultsManager {
    
    enum Key: String {
        case wishList
    }
    
    @UserDefaultsWrapper<[String: MarketItem]>(key: Key.wishList.rawValue, defaultValue: [:])
    static var wishList
}
