//
//  DetailWeatherTableViewCell.swift
//  DetailWeatherTableViewCell
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import UIKit

final class DetailWeatherTableViewCell: UITableViewCell, ReuseIdentifiable {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let leftTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 10)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    private let leftValueLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let rightTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 10)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    private let rightValueLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setUpConstraints()
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpContents(detailWeatherDTO: DetailWeatherDTO) {
        leftTitleLabel.text = detailWeatherDTO.leftTitle
        leftValueLabel.text = detailWeatherDTO.leftValue
        rightTitleLabel.text = detailWeatherDTO.rightTitle
        rightValueLabel.text = detailWeatherDTO.rightValue
    }
    
    private func configureUI() {
        [leftTitleLabel, leftValueLabel].forEach {
            leftStackView.addArrangedSubview($0)
        }
        
        [rightTitleLabel, rightValueLabel].forEach {
            rightStackView.addArrangedSubview($0)
        }
        
        [leftStackView, rightStackView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(mainStackView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        leftValueLabel.setContentHuggingPriority(.init(1), for: .vertical)
        rightValueLabel.setContentHuggingPriority(.init(1), for: .vertical)
    }
    
    private func setUpCell() {
        backgroundColor = .clear
    }
}
