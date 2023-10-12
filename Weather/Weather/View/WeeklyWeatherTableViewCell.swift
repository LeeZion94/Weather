//
//  WeeklyWeatherTableViewCell.swift
//  WeeklyWeatherTableViewCell
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import UIKit

final class WeeklyWeatherTableViewCell: UITableViewCell, ReuseIdentifiable {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let temperatureStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let minTemperatureLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
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
    
    func setUpContents(weeklyWeatherDTO: WeeklyWeatherDTO) {
        dayLabel.text = weeklyWeatherDTO.day
        weatherImageView.image = UIImage(named: weeklyWeatherDTO.imageName)
        maxTemperatureLabel.text = weeklyWeatherDTO.maxTemperature
        minTemperatureLabel.text = weeklyWeatherDTO.minTemperature
    }
    
    private func configureUI() {
        [maxTemperatureLabel, minTemperatureLabel].forEach {
            temperatureStackView.addArrangedSubview($0)
        }
        
        [dayLabel, weatherImageView, temperatureStackView].forEach {
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
        
        dayLabel.setContentHuggingPriority(.init(1), for: .horizontal)
    }
    
    private func setUpCell() {
        backgroundColor = .clear
    }
}
