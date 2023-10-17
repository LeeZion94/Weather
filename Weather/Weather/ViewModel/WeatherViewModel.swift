//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import RxSwift
import RxCocoa

final class WeatherViewModel: ViewModelType {
    struct Input {
        let weatherTrigger: Observable<Coordinate>
    }

    struct Output {
        let todayWeather: Driver<TodayWeatherDTO?>
        let dayOfWeek: Driver<String?>
        let hourlyWeather: Driver<[HourlyWeatherDTO]?>
        let weeklyWeatehr: Driver<([WeeklyWeatherDTO], [DetailWeatherDTO])?>
        let forecastFetchFailure: Driver<String>
    }
    
    private let weatherRepository: WeatherRepositoryType
    private let weatherViewControllerUseCase: WeatherViewControllerUseCaseType
    
    private let forecastFetchFailureTrigger =  PublishRelay<String>()
    
    init(weatherRepository: WeatherRepositoryType,
         weatherViewControllerUseCase: WeatherViewControllerUseCaseType) {
        self.weatherRepository = weatherRepository
        self.weatherViewControllerUseCase = weatherViewControllerUseCase
    }
    
    func transform(input: Input) -> Output {
        let forecastResult: Observable<ForecastResult> = input.weatherTrigger.flatMap { coordinate in
            return self.weatherRepository.fetchWeatherData(coordinate: coordinate).compactMap { result in
                switch result {
                case .success(let forecastResult):
                    return forecastResult
                case .failure(let error):
                    self.forecastFetchFailureTrigger.accept(error.errorDescription)
                    return nil
                }
            }
        }.share()
        
        let todayWeather: Driver<TodayWeatherDTO?> = forecastResult.map { forecastResult in
            return self.weatherViewControllerUseCase.convertTodayWeatherDTO(forecastResult: forecastResult)
        }.asDriver(onErrorJustReturn: nil)
        
        let dayOfWeek: Driver<String?> = forecastResult.map { forecastResult in
            return self.weatherViewControllerUseCase.convertDayOfWeekString(forecastResult: forecastResult)
        }.asDriver(onErrorJustReturn: nil)
        
        let hourlyWeather: Driver<[HourlyWeatherDTO]?> = forecastResult.map { forecastResult in
            return self.weatherViewControllerUseCase.convertHourlyWeatherDTOList(forecastResult: forecastResult)
        }.asDriver(onErrorJustReturn: nil)
        
        let weeklyWeather: Driver<([WeeklyWeatherDTO], [DetailWeatherDTO])?> = forecastResult.map { forecastResult in
            guard let detailWeatherDTOList = self.weatherViewControllerUseCase.convertDetailWeatherDTOList(forecastResult: forecastResult) else { return nil }
            let weeklyWeatherDTOList = self.weatherViewControllerUseCase.convertWeeklyWeatherDTOList(forecastResult: forecastResult)
            
            return (weeklyWeatherDTOList, detailWeatherDTOList)
        }.asDriver(onErrorJustReturn: nil)
        
        return Output(todayWeather: todayWeather,
                      dayOfWeek: dayOfWeek,
                      hourlyWeather: hourlyWeather,
                      weeklyWeatehr: weeklyWeather,
                      forecastFetchFailure: forecastFetchFailureTrigger.asDriver(onErrorJustReturn: ""))
    }
}
