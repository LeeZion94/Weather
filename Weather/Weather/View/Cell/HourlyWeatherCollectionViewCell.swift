//
//  HourlyWeatherCollectionViewCell.swift
//  HourlyWeatherCollectionViewCell
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import UIKit

/// prepare for reuse가 없네요
/// 셀이 재사용되는 방식도 물어볼듯
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
        
        label.font  = .systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.font  = .systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
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
    
    func setUpContents(hourlyweatherDTO: HourlyWeatherDTO) {
        hourLabel.text = hourlyweatherDTO.hour
        weatherImageView.image = UIImage(named: hourlyweatherDTO.imageName)
        temperatureLabel.text = hourlyweatherDTO.temperature
    }
    
    private func configureUI() {
        [hourLabel, weatherImageView, temperatureLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            weatherImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0),
            weatherImageView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0)
        ])
        
        temperatureLabel.setContentHuggingPriority(.init(1), for: .vertical)
    }
}
