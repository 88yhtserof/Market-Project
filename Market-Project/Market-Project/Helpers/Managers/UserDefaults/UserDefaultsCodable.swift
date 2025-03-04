//
//  UserDefaultsCodable.swift
//  Market-Project
//
//  Created by 임윤휘 on 3/1/25.
//

import Foundation

final class UserDefaultsCodable {
    
    static let shared = UserDefaultsCodable()
    
    private init() {}
    
    func object<T: Codable>(_ type: T.Type, forKey key: String) -> Result<T, UserDefaultsError> {
        do {
            let data = try fetchData(forKey: key)
            let value = try decodeToData(T.self, from: data)
            return .success(value)
            
        } catch let error as UserDefaultsError {
            print("Error: \(error.errorDebugDescription)")
            return .failure(error)
            
        } catch {
            print("Error: \(error.localizedDescription)")
            return .failure(.unknown(error))
        }
    }
    
    @discardableResult
    func set<T: Codable>(_ value: T, forKey key: String)  -> Result<Void, UserDefaultsError> {
        do {
            let encoded = try encodeToData(value)
            UserDefaults.standard.set(encoded, forKey: key)
            return .success(())
        } catch let error as UserDefaultsError {
            print("Error: \(error.errorDebugDescription)")
            return .failure(error)
        } catch {
            print("Error: \(error.localizedDescription)")
            return .failure(.unknown(error))
        }
    }
    
    func clear(forKey key: String...) {
        key.forEach{ UserDefaults.standard.removeObject(forKey: $0) }
    }
    
    //MARK: - Throws Method
    private func fetchData(forKey key: String) throws -> Data {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            throw UserDefaultsError.notFound
        }
        return data
    }
    
    private func decodeToData<T: Codable>(_ type: T.Type, from data: Data) throws -> T {
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            throw UserDefaultsError.decodingFailed
        }
        return decoded
    }
    
    private func encodeToData<T: Codable>(_ value: T) throws -> Data {
        guard let encoded = try? JSONEncoder().encode(value) else {
            throw UserDefaultsError.encodingFailed
        }
        return encoded
    }
}

enum UserDefaultsError: LocalizedError {
    case notFound
    case encodingFailed
    case decodingFailed
    case unknown(Error)
    
    var errorDebugDescription: String {
        switch self {
        case .notFound:
            "Could not find"
        case .encodingFailed:
            "Failed to encode"
        case .decodingFailed:
            "Failed to decode"
        case .unknown(let error):
            "Unknown Error: \(error.localizedDescription)"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            "로컬 저장소에서 해당 정보를 찾을 수 없습니다."
        case .encodingFailed:
            "로컬 저장소에 데이터를 저장하는데 실패했습니다."
        case .decodingFailed:
            "로컬 저장소에서 데이터를 불러오는데 실패했습니다."
        case .unknown:
            "알 수 없는 오류가 발생했습니다."
        }
    }
}
