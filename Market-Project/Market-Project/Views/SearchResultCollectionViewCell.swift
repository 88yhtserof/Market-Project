//
//  SearchResultCollectionViewCell.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import UIKit

import SnapKit
import Kingfisher

class SearchResultCollectionViewCell: BaseCollectionViewCell, ListCellConfigurable {
    private let imageView = UIImageView()
    private let productNameLabel = WhiteLabel()
    private let titleLabel = WhiteLabel()
    private let priceLabel = WhiteLabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, productNameLabel, titleLabel, priceLabel])
    
    static let identifier = String(describing: SearchViewController.self)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(systemName: "circle.dotted")
    }
    
    override func configureSubviews() {
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        imageView.cornerRadius(8)
        productNameLabel.font = .systemFont(ofSize: 12, weight: .light)
        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        titleLabel.numberOfLines = 2
        priceLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .fill
        stackView.distribution = .fill
    }
    
    override func configureHierarchy() {
        addSubviews([stackView])
    }
    
    override func configureConstraints() {
        let width = contentView.frame.width
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(imageView.snp.width)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    func configure(with item: MarketItem) {
        titleLabel.text = item.title.replacingHTMLTags
        priceLabel.text = (Int(item.lprice) ?? 0).decimal()
        productNameLabel.text = item.mallName
        if let image = URL(string: item.image) {
            imageView.kf.setImage(with: image)
        }
    }
}
