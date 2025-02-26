//
//  BaseViewModel.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/25/25.
//

import Foundation

import RxSwift

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input) -> Output
}
