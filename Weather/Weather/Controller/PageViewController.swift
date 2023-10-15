//
//  PageViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/15.
//

import UIKit

final class PageViewController: UIViewController {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "background"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal)
        
        pageViewController.dataSource = self
        pageViewController.view.backgroundColor = .clear
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return pageViewController
    }()

    private var viewControllerList: [UIViewController]
    
    init(viewControllerList: [UIViewController]) {
        self.viewControllerList = viewControllerList

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpConstraints()
        setUpController()
    }
    
    private func configureUI() {
        [backgroundImageView, pageViewController.view].forEach {
            view.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        setUpBackgroundImageViewConstraint()
        setUpPageViewControllerConstraints()
    }
    
    private func setUpController() {
        view.backgroundColor = .systemBackground
        
        guard let rootViewController = viewControllerList.first else { return }
        
        pageViewController.setViewControllers([rootViewController], direction: .forward, animated: true)
    }
}

//MARK: - PageViewController DataSource
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        
        if previousIndex < 0 {
            return nil
        }
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        
        if nextIndex == viewControllerList.count {
            return nil
        }
        
        return viewControllerList[nextIndex]
    }
}

// MARK: - Constraints
extension PageViewController {
    private func setUpBackgroundImageViewConstraint() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setUpPageViewControllerConstraints() {
        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
