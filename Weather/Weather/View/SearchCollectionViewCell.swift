//
//  SearchCollectionViewCell.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/15.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewListCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 30)
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.cornerRadius = 4.0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpContents(title: String) {
        titleLabel.text = title
    }
    
    private func configureUI() {
        contentView.addSubview(titleLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
