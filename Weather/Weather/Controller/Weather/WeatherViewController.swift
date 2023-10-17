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
    
    /// 얘 반드시 사용될거같은데 lazy네영?
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
    
    /// 사실 여기서 뷰를 갈아끼워주는것도 포멀한 방법은 아니라
    /// 질문 잘 대답해야할듯여 저라면 과제에서는 굳이 안할듯
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
        
        bindTodayWeather(todayWeather: output.todayWeather)
        bindDayOfWeek(dayOfWeek: output.dayOfWeek)
        bindHourlyWeather(hourlyWeather: output.hourlyWeather)
        bindWeeklyWeather(weeklyWeather: output.weeklyWeatehr)
        bindForecastFetchFailure(forecastFetchFailure: output.forecastFetchFailure)
    }
    
    private func bindTodayWeather(todayWeather: Driver<TodayWeatherDTO?>) {
        todayWeather
            .compactMap { $0 }
            /// 갠췬데 확실한 상황이어도 저는 unowned는 잘 안쓰는거 같아여 위험해서
            .drive { [unowned self] todayWeatherDTO in
                self.activityIndicatorView.stopAnimating()
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
    
    private func bindForecastFetchFailure(forecastFetchFailure: Driver<String>) {
        forecastFetchFailure
            .filter { $0.count != 0 }
            .drive { [unowned self] errorMessage in
                self.showForecastFetchFailureAlert(errorMessage: errorMessage)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Alert
extension WeatherViewController {
    private func showForecastFetchFailureAlert(errorMessage: String) {
        let checkAlertAction: UIAlertAction = .init(title: "확인", style: .default)
        
        showAlert(title: "네트워크 에러", message: errorMessage, style: .alert, actionList: [checkAlertAction])
    }
}
