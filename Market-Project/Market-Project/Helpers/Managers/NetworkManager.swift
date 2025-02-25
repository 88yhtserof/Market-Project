//
//  NetworkManager.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/16/25.
//

import Foundation

import Alamofire

class NetworkManager {
    
    enum Pagenation: Int {
        case market = 30
        
        var display: Int {
            return rawValue
        }
        
        var displayString: String {
            return String(display)
        }
    }
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private let domain = "https://openapi.naver.com/v1/search/shop.json"
    private let clientId = HTTPHeader(name: "X-Naver-Client-Id", value: AuthenticationInfoManager.naver.clientID ?? "")
    private let clientSecret = HTTPHeader(name: "X-Naver-Client-Secret", value: AuthenticationInfoManager.naver.clientSecret ?? "")
    
    private func configrueURLComponents(_ text: String, sort: MarketItemSort, start: String) -> URL? {
        guard var urlComponents = URLComponents(string: domain) else {
            print("Failed to create URLComponents")
            return nil
        }
        urlComponents.queryItems = [URLQueryItem(name: "query", value: text),
                                    URLQueryItem(name: "display", value: Pagenation.market.displayString),
                                    URLQueryItem(name: "sort", value: sort.value),
                                    URLQueryItem(name: "start", value: start)]
        return urlComponents.url
    }
    
    func getShopList(searchWord word: String, sort: MarketItemSort, start: String, handler: @escaping (MarketResponse?, String?) -> Void) {
        guard let url = configrueURLComponents(word, sort: sort, start: start) else {
            print("Failed to configure URL")
            return
        }
        let httpHeaders: HTTPHeaders = [clientId, clientSecret]
        
        AF.request(url, method: .get, headers: httpHeaders)
            .responseDecodable(of: MarketResponse.self) { response in
                var networkError: NetworkError?
                guard let statusCode = response.response?.statusCode else {
                    print("No statusCode")
                    return
                }
                switch statusCode {
                case 200..<300:
                    networkError = .none
                case 401:
                    networkError = .unauthorized
                case 403:
                    networkError = .forbidden
                case 400..<500:
                    networkError = .invalidURL
                case 500:
                    networkError = .systemError
                default:
                    networkError = .none
                }
                
                switch response.result {
                case .success(let value):
                    print("Success")
                    handler(value, nil)
                case .failure(let error):
                    print("Fail: ", error)
                    print(networkError?.errorDescription ?? "")
                    handler(nil, networkError?.errorMessageForUser)
                    
                }
            }
    }
}


enum NetworkError: Error {
    case noInternet
    case unauthorized // 유효한 인증 정보가 부족
    case forbidden // 권한이 없어 요청이 거부
    case invalidURL
    case decodingFailed
    case systemError
    
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "No internet connection"
        case .unauthorized:
            return "Authentication failed"
        case .forbidden:
            return "Forbidden access"
        case .invalidURL:
            return "Invalid URL"
        case .decodingFailed:
            return "Decoding failed"
        case .systemError:
            return "System error"
        }
    }
    
    var errorMessageForUser: String {
        switch self {
        case .noInternet:
            return "네트워크 연결이 끊겼습니다"
        case .systemError:
            return "시스템 에러입니다"
        default:
            return "관리자에게 문의하십시오"
        }
    }
}
