//
//  HourlyWeatherCollectionViewCell.swift
//  HourlyWeatherCollectionViewCell
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import UIKit

final class HourlyWeatherCollectionViewCell: UICollectionViewCell, ReuseIdentifiable {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        
        label.font  = .systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.font  = .systemFont(ofSize: 10)
        label.textColor = .white
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
    
    func setUpContents(hour: String, imageName: String, temperature: String) {
        hourLabel.text = hour
        weatherImageView.image = UIImage(named: imageName)
        temperatureLabel.text = temperature
    }
    
    private func configureUI() {
        [hourLabel, weatherImageView, temperatureLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        
        temperatureLabel.setContentHuggingPriority(.init(1), for: .vertical)
    }
}
