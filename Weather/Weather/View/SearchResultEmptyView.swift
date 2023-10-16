//
//  SearchResultEmptyView.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/16.
//

import UIKit

final class SearchResultEmptyView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        
        label.text = "검색결과가 없습니다"
        label.textColor = .white
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
    
    private func configureUI() {
        addSubview(messageLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
