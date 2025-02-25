//
//  ListCellConfigurable.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/16/25.
//

import Foundation

protocol ListCellConfigurable: AnyObject {
    associatedtype CellModel
    
    func configure(with model: CellModel)
}
