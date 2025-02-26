//
//  Observable.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/6/25.
//

import Foundation

//class Observable<T> {
//    
//    private var closure: ((T)-> Void)?
//    
//    var value: T {
//        didSet {
//            closure?(value)
//        }
//    }
//    
//    init(_ value: T) {
//        self.value = value
//    }
//    
//    func bind(_ closure: @escaping (T)-> Void) {
//        closure(value)
//        self.closure = closure
//    }
//    
//    func lazyBind(_ closure: @escaping (T)-> Void) {
//        self.closure = closure
//    }
//    
//    /// Set value property to the received value.
//    func send(_ value: T) {
//        self.value = value
//    }
//    
//    func send() where T == Void {
//        self.value = ()
//    }
//}
