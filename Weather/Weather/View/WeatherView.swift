//
//  WeatherView.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/12.
//

import UIKit

final class WeatherView: UIView {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "background"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let todayWeatherView: TodayWeatherView = {
        let todayWeatherView = TodayWeatherView()
        
        todayWeatherView.translatesAutoresizingMaskIntoConstraints = false
        return todayWeatherView
    }()
    
    private let dayOfWeekView: DayOfWeekView = {
        let dayOfWeekView = DayOfWeekView()
        
        dayOfWeekView.translatesAutoresizingMaskIntoConstraints = false
        return dayOfWeekView
    }()
    
    private let hourlyWeatherViewController: HourlyWeatherViewController = {
        let hourlyWeatherViewController = HourlyWeatherViewController()
        
        hourlyWeatherViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return hourlyWeatherViewController
    }()
    
    private let detailWeatherViewController: DetailWeatherViewController = {
        let detailWeatherViewController = DetailWeatherViewController()
        
        detailWeatherViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return detailWeatherViewController
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
        [backgroundImageView, todayWeatherView,
         dayOfWeekView, hourlyWeatherViewController.view, detailWeatherViewController.view].forEach {
            addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        setUpBackgroundImageViewConstraint()
        setUpTodayWeatherViewConstraint()
        setUpHourlyWeatherViewConstraint()
        setUpWeeklyWeatherViewConstraint()
    }
}

// MARK: - Constraints
extension WeatherView {
    private func setUpBackgroundImageViewConstraint() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpTodayWeatherViewConstraint() {
        NSLayoutConstraint.activate([
            todayWeatherView.leadingAnchor.constraint(equalTo: leadingAnchor),
            todayWeatherView.trailingAnchor.constraint(equalTo: trailingAnchor),
            todayWeatherView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    private func setUpDayOfWeekViewConstraint() {
        NSLayoutConstraint.activate([
            dayOfWeekView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayOfWeekView.topAnchor.constraint(equalTo: todayWeatherView.bottomAnchor, constant: 20)
        ])
    }
    
    private func setUpHourlyWeatherViewConstraint() {
        guard let hourlyWeatherView = hourlyWeatherViewController.view else { return }
        
        NSLayoutConstraint.activate([
            hourlyWeatherView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hourlyWeatherView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hourlyWeatherView.topAnchor.constraint(equalTo: dayOfWeekView.bottomAnchor),
        ])
    }
    
    private func setUpWeeklyWeatherViewConstraint() {
        guard let detailWeatherView = detailWeatherViewController.view,
                let hourlyWeatherView = hourlyWeatherViewController.view else { return }
        
        NSLayoutConstraint.activate([
            detailWeatherView.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailWeatherView.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailWeatherView.topAnchor.constraint(equalTo: hourlyWeatherView.bottomAnchor),
            detailWeatherView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
