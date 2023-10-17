//
//  WeatherViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/09.
//

import UIKit
import RxSwift
import RxCocoa

final class WeatherViewController: UIViewController, AlertControllerShowable {
    let location: Location
    
    private let weatherView = WeatherView()
    
    private let viewModel: WeatherViewModel
    
    private var disposeBag = DisposeBag()
    
    private var weatherTrigger = PublishSubject<Coordinate>()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
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
        
        configureUI()
        setUpConstraints()
        setUpController()
        bind()
        
        weatherTrigger.onNext(location.coordiante)
    }

    private func configureUI() {
        view.addSubview(activityIndicatorView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
        
//        bindForeCastResult(forecastResult: output.forecastResult)
        bindTodayWeather(todayWeather: output.todayWeather)
        bindDayOfWeek(dayOfWeek: output.dayOfWeek)
        bindHourlyWeather(hourlyWeather: output.hourlyWeather)
        bindWeeklyWeather(weeklyWeather: output.weeklyWeatehr)
        bindForecastFetchFailure(forecastFetchFailure: output.forecastFetchFailure)
    }
    
//    private func bindForeCastResult(forecastResult: Observable<ForecastResult>) {
//        forecastResult.bind { [unowned self] _ in
//            DispatchQueue.main.async {
//                self.activityIndicatorView.stopAnimating()
//            }
//        }.disposed(by: disposeBag)
//    }
    
    private func bindTodayWeather(todayWeather: Driver<TodayWeatherDTO?>) {
        todayWeather
            .compactMap { $0 }
            .drive { [unowned self] todayWeatherDTO in
                self.weatherView.setUpTodayWeatherViewContents(locationName: self.location.name,
                                                               todayWeatherDTO: todayWeatherDTO)
            }.disposed(by: disposeBag)
    }
    
    private func bindDayOfWeek(dayOfWeek: Driver<String?>) {
        dayOfWeek
            .compactMap { $0 }
            .drive { [unowned self] dayOfWeek in
                self.weatherView.setUpDayOfWeekView(day: dayOfWeek)
            }.disposed(by: disposeBag)
    }
    
    private func bindHourlyWeather(hourlyWeather: Driver<[HourlyWeatherDTO]?>) {
        hourlyWeather
            .compactMap { $0 }
            .drive { [unowned self] hourlyWeatherDTOList in
                self.weatherView.setUpHourlyWeatherViewContents(hourlyWeatherDTOList: hourlyWeatherDTOList)
            }.disposed(by: disposeBag)
    }
    
    private func bindWeeklyWeather(weeklyWeather: Driver<([WeeklyWeatherDTO], [DetailWeatherDTO])?>) {
        weeklyWeather
            .compactMap { $0 }
            .drive { [unowned self] (weeklyWeatherDTOList, detailWeatherDTOList) in
                self.weatherView.setUpDetailWeatherViewContents(weeklyWeatherDTOList: weeklyWeatherDTOList,
                                                                detailWeatherDTOList: detailWeatherDTOList)
            }.disposed(by: disposeBag)
    }
    
    private func bindForecastFetchFailure(forecastFetchFailure: Driver<String?>) {
        forecastFetchFailure
            .compactMap { $0 }
            .drive { [unowned self] errorMessage in
                self.showForecastFetchFailureAlert(errorMessage: errorMessage)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Alert
extension WeatherViewController {
    private func showForecastFetchFailureAlert(errorMessage: String) {
        let checkAlertAction: UIAlertAction = .init(title: "확인", style: .default)
        
        self.showAlert(title: "네트워크 에러", message: errorMessage, style: .alert, actionList: [checkAlertAction])
    }
}
