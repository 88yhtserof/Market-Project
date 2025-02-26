//
//  SearchResultMainView.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/16/25.
//

import UIKit

class SearchResultMainView: BaseView {
    
    weak var delegate: SearchResultViewController?
    
    let totalLabel = FormatStringLabel(format: "%@ 개의 검색 결과")
    let simButton = SelectButton(title: "정확도", isSelected: true)
    let dateButton = SelectButton(title: "날짜순", isSelected: false)
    let highPriceButton = SelectButton(title: "가격 높은 순", isSelected: false)
    let lowPriceButton = SelectButton(title: "가격 낮은 순", isSelected: false)
    lazy var sortStackView = UIStackView(arrangedSubviews: [simButton, dateButton, highPriceButton, lowPriceButton])
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    init(_ delegate: SearchResultViewController) {
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
        
        totalLabel.font = .systemFont(ofSize: 13, weight: .bold)
        totalLabel.textAlignment = .left
        totalLabel.textColor = .green
        
        simButton.addTarget(delegate, action: #selector(delegate?.sortButtonDidTapped), for: .touchUpInside)
        dateButton.addTarget(delegate, action: #selector(delegate?.sortButtonDidTapped), for: .touchUpInside)
        highPriceButton.addTarget(delegate, action: #selector(delegate?.sortButtonDidTapped), for: .touchUpInside)
        lowPriceButton.addTarget(delegate, action: #selector(delegate?.sortButtonDidTapped), for: .touchUpInside)
        
        sortStackView.axis = .horizontal
        sortStackView.distribution = .fillProportionally
        sortStackView.spacing = 3
        sortStackView
            .arrangedSubviews
            .enumerated()
            .forEach{ $0.element.tag = $0.offset }
        
//        collectionView.delegate = delegate
//        collectionView.dataSource = delegate
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        collectionView.backgroundColor = .black
    }
    
    override func configureHierarchy() {
        addSubviews([totalLabel, sortStackView, collectionView])
    }
    
    override func configureConstraints() {
        totalLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        sortStackView.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortStackView.snp.bottom).offset(10)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
