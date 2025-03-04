//
//  WishListGridMainView.swift
//  Market-Project
//
//  Created by 임윤휘 on 3/5/25.
//

import UIKit

class WishListGridMainView: BaseView {
    
    weak var delegate: WishListGridViewController?
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    init(_ delegate: WishListGridViewController) {
        self.delegate = delegate
        super.init(frame: .zero)
        
    }
    
    func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let spacing: CGFloat = 8
        let inset: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing + inset * 2)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: width / 2, height: 280)
        return layout
    }
    
    override func configureSubviews() {
        
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        collectionView.backgroundColor = .black
    }
    
    override func configureHierarchy() {
        addSubviews([collectionView])
    }
    
    override func configureConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
