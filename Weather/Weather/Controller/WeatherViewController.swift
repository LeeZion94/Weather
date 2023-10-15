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
        
        setUpController()
        bind()
        
        weatherTrigger.onNext(cityName)
    }

    private func setUpController() {
        view.backgroundColor = .clear
    }
}

// MARK: - Bind
extension WeatherViewController {
    private func bind() {
        let input = WeatherViewModel.Input(weatherTrigger: weatherTrigger.asObservable())
        let output = viewModel.transform(input: input)
        
        bindTodayWeather(todayWeather: output.todayWeather)
        bindDayOfWeek(dayOfWeek: output.dayOfWeek)
        bindHourlyWeather(hourlyWeather: output.hourlyWeather)
        bindWeeklyWeather(weeklyWeather: output.weeklyWeatehr)
    }
    
    private func bindTodayWeather(todayWeather: Observable<TodayWeatherDTO>) {
        todayWeather.bind { todayWeatherDTO in
            self.weatherView.setUpTodayWeatherViewContents(todayWeatherDTO: todayWeatherDTO)
        }.disposed(by: disposeBag)
    }
    
    private func bindDayOfWeek(dayOfWeek: Observable<String>) {
        dayOfWeek.bind { dayOfWeek in
            self.weatherView.setUpDayOfWeekView(day: dayOfWeek)
        }.disposed(by: disposeBag)
    }
    
    private func bindHourlyWeather(hourlyWeather: Observable<[HourlyWeatherDTO]>) {
        hourlyWeather.bind { hourlyWeatherDTOList in
            self.weatherView.setUpHourlyWeatherViewContents(hourlyWeatherDTOList: hourlyWeatherDTOList)
        }.disposed(by: disposeBag)
    }
    
    private func bindWeeklyWeather(weeklyWeather: Observable<([WeeklyWeatherDTO], [DetailWeatherDTO])>) {
        weeklyWeather.bind { (weeklyWeatherDTOList, detailWeatherDTOList) in
            self.weatherView.setUpDetailWeatherViewContents(weeklyWeatherDTOList: weeklyWeatherDTOList,
                                                            detailWeatherDTOList: detailWeatherDTOList)
        }.disposed(by: disposeBag)
    }
}

