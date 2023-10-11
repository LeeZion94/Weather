//
//  WeatherViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/09.
//

import UIKit
import RxSwift

final class WeatherViewController: UIViewController {
    private let viewModel: WeatherViewModel
    
    private var disposeBag = DisposeBag()
    private var weatherTrigger = PublishSubject<Void>()
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpConstratins()
        setUpController()
        bind()
        
        weatherTrigger.onNext(Void())
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
        }.disposed(by: disposeBag)
    }
}

