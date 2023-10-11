//
//  WeatherViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/09.
//

import UIKit

final class WeatherViewController: UIViewController {
    private let viewModel: WeatherViewModelType
    
    init(viewModel: WeatherViewModelType) {
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
    }
    
    private func configureUI() {
        
    }
    
    private func setUpConstratins() {
        
    }
    
    private func setUpController() {
        view.backgroundColor = .systemBackground
    }
}

