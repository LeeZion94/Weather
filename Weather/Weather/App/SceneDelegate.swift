//
//  SceneDelegate.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let urlSessionProvider: URLSessionProviderType = URLSessionProvider()
        let weatherRepository: WeatherRepositoryType = WeatherRepository(urlSessionProvider: urlSessionProvider)
        let dateConverter: DateConverterType = DateConverter()
        let weatherViewControllerUseCase: WeatherViewControllerUseCaseType = WeatherViewControllerUseCase(dateConverter: dateConverter)
        let viewModel: WeatherViewModel = WeatherViewModel(weatherRepository: weatherRepository,
                                                           weatherViewControllerUseCase: weatherViewControllerUseCase)
        let coordinate: Coordinate = .init(latitude: "37.5683", longitude: "126.9778")
        let location: Location = .init(name: "서울특별시", coordiante: coordinate)
        let weatherViewController = WeatherViewController(viewModel: viewModel, location: location)
        let pageController = PageViewController(weatherViewControllerList: [weatherViewController])
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = pageController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

