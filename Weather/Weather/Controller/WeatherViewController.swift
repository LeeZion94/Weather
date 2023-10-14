//
//  WeatherViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/09.
//

import UIKit
import RxSwift

final class WeatherViewController: UIViewController {
    private let weatherView = WeatherView()
    private let viewModel: WeatherViewModel
    private let cityName: String
    
    private var disposeBag = DisposeBag()
    private var weatherTrigger = PublishSubject<String>()
    
    init(viewModel: WeatherViewModel, cityName: String) {
        self.viewModel = viewModel
        self.cityName = cityName
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpConstratins()
        setUpController()
        bind()
        
        weatherTrigger.onNext(cityName)
    }
    
    private func configureUI() {
        
    }
    
    private func setUpConstratins() {
        
    }
    
    private func setUpController() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Bind
extension WeatherViewController {
    private func bind() {
        let input = WeatherViewModel.Input(weatherTrigger: weatherTrigger.asObservable())
        let output = viewModel.transform(input: input)
        
        output.forecastResult.bind { forecastResult in
            print(forecastResult)
            DispatchQueue.main.async {
                let weeklyWeatherDTOList: [WeeklyWeatherDTO] = [.init(day: "수요일", imageName: "testImage", maxTemperature: "27C", minTemperature: "15C"),
                                                                .init(day: "수요일", imageName: "testImage", maxTemperature: "27C", minTemperature: "15C"),
                                                                .init(day: "수요일", imageName: "testImage", maxTemperature: "27C", minTemperature: "15C"),
                                                                .init(day: "수요일", imageName: "testImage", maxTemperature: "27C", minTemperature: "15C"),
                                                                .init(day: "수요일", imageName: "testImage", maxTemperature: "27C", minTemperature: "15C"),
                                                                .init(day: "수요일", imageName: "testImage", maxTemperature: "27C", minTemperature: "15C"),]
                let detailWeatherDTOList: [DetailWeatherDTO] = [.init(leftTitle: "humidity", leftValue: "84%", rightTitle: "pressure", rightValue: "1010 hPa"),
                                                                .init(leftTitle: "sea level pressure", leftValue: "1010 hPa", rightTitle: "ground level pressure", rightValue: "1009 hPa"),
                                                                .init(leftTitle: "wind", leftValue: "ESE 299 m/s", rightTitle: "clouds", rightValue: "1 %"),]
                self.weatherView.setUpDetailWeatherViewContents(weeklyWeatherDTOList: weeklyWeatherDTOList, detailWeatherDTOList: detailWeatherDTOList)
            }
        }.disposed(by: disposeBag)
        
        output.todayWeather.bind { todayWeatherDTO in
            self.weatherView.setUpTodayWeatherViewContents(todayWeatherDTO: todayWeatherDTO)
        }.disposed(by: disposeBag)
        
        output.dayOfWeek.bind { dayOfWeek in
            self.weatherView.setUpDayOfWeekView(day: dayOfWeek)
        }.disposed(by: disposeBag)
        
        output.hourlyWeather.bind { hourlyWeatherDTOList in
            self.weatherView.setUpHourlyWeatherViewContents(hourlyWeatherDTOList: hourlyWeatherDTOList)
        }.disposed(by: disposeBag)
    }
}

