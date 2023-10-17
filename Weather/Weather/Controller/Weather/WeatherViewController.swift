//
//  WeatherViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/09.
//

import UIKit
import RxSwift

final class WeatherViewController: UIViewController, AlertControllerShowable {
    private let weatherView = WeatherView()
    private let viewModel: WeatherViewModel
    let location: Location
    
    private var disposeBag = DisposeBag()
    private var weatherTrigger = PublishSubject<Coordinate>()
    
    init(viewModel: WeatherViewModel, location: Location) {
        self.viewModel = viewModel
        self.location = location
        
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
        
        weatherTrigger.onNext(location.coordiante)
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
        bindForecastFetchFailure(forecastFetchFailure: output.forecastFetchFailure)
    }
    
    private func bindTodayWeather(todayWeather: Observable<TodayWeatherDTO>) {
        todayWeather.bind { [unowned self] todayWeatherDTO in
            self.weatherView.setUpTodayWeatherViewContents(locationName: self.location.name,
                                                           todayWeatherDTO: todayWeatherDTO)
        }.disposed(by: disposeBag)
    }
    
    private func bindDayOfWeek(dayOfWeek: Observable<String>) {
        dayOfWeek.bind { [unowned self] dayOfWeek in
            self.weatherView.setUpDayOfWeekView(day: dayOfWeek)
        }.disposed(by: disposeBag)
    }
    
    private func bindHourlyWeather(hourlyWeather: Observable<[HourlyWeatherDTO]>) {
        hourlyWeather.bind { [unowned self] hourlyWeatherDTOList in
            self.weatherView.setUpHourlyWeatherViewContents(hourlyWeatherDTOList: hourlyWeatherDTOList)
        }.disposed(by: disposeBag)
    }
    
    private func bindWeeklyWeather(weeklyWeather: Observable<([WeeklyWeatherDTO], [DetailWeatherDTO])>) {
        weeklyWeather.bind { [unowned self] (weeklyWeatherDTOList, detailWeatherDTOList) in
            self.weatherView.setUpDetailWeatherViewContents(weeklyWeatherDTOList: weeklyWeatherDTOList,
                                                            detailWeatherDTOList: detailWeatherDTOList)
        }.disposed(by: disposeBag)
    }
    
    private func bindForecastFetchFailure(forecastFetchFailure: Observable<String>) {
        forecastFetchFailure.bind { [unowned self] errorMessage in
            self.showForecastFetchFailureAlert(errorMessage: errorMessage)
        }.disposed(by: disposeBag)
    }
}

// MARK: - Alert
extension WeatherViewController {
    private func showForecastFetchFailureAlert(errorMessage: String) {
        let checkAlertAction: UIAlertAction = .init(title: "확인", style: .default)
        
        DispatchQueue.main.async {
            self.showAlert(title: "네트워크 에러", message: errorMessage, style: .alert, actionList: [checkAlertAction])
        }
    }
}