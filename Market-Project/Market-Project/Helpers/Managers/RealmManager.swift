//
//  RealmManager.swift
//  Market-Project
//
//  Created by 임윤휘 on 3/4/25.
//

import Foundation

import RealmSwift
import RxSwift
import RxCocoa

@propertyWrapper
struct RealmWrapper<T: Object, ID> {
    
    private let realm = try! Realm()
    
    var wrappedValue: Update<T, ID> {
        get {
            return .fetchAll(fetchAll()) // id를 인수로 받아 해당하는 데이터만을 조회해 반환할 수는 없을까
        }
        set {
            switch newValue {
            case .add(let item):
                add(item)
            case .delete(let id):
                delete(for: id)
            default:
                break
            }
        }
    }
    
    private let result = PublishRelay<Result<Update<T,ID>, Error>>()
    
    var projectedValue: Observable<Result<Update<T,ID>, Error>> {
        return result
            .share()
    }
    
    func fetchAll() -> Results<T> {
        realm.objects(T.self)
    }
    
    func add(_ item: T) {
        do {
            try realm.write {
                realm.add(item, update: .modified)
                result.accept(.success(.add(item)))
            }
        } catch {
            print("Failed to save data: \(error)")
            result.accept(.failure(error))
        }
    }
    
    func delete(for id: ID) {
        guard let item = realm.object(ofType: T.self, forPrimaryKey: id) else {
            print("Could not find item to delete")
            return
        }
        
        do {
            try realm.write {
                realm.delete(item)
                result.accept(.success(.delete(id)))
            }
        } catch {
            print("Failed to save data: \(error)")
            result.accept(.failure(error))
        }
    }
}

enum RealmProvider {
    
    @RealmWrapper<MarketTable, String>
    static var wishTable
}

enum Update<Element: Object, ID> {
    case add(Element)
    case delete(ID)
    case fetchAll(Results<Element>)
}
