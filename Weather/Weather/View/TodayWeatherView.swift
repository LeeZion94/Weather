//
//  TodayWeatherView.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import UIKit

final class TodayWeatherView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 25)
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
    
    func setUpContents(cityName: String, weatherDescription: String, temperature: String) {
        cityNameLabel.text = cityName
        weatherDescriptionLabel.text = weatherDescription
        temperatureLabel.text = temperature
    }
    
    private func configureUI() {
        [cityNameLabel, weatherDescriptionLabel, temperatureLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        addSubview(stackView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
        
        temperatureLabel.setContentHuggingPriority(.init(1), for: .vertical)
    }
}
