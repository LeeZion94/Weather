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
        pageViewController.delegate = self
        pageViewController.view.backgroundColor = .clear
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return pageViewController
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private lazy var listButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.init(named: "list-icon"), for: .normal)
        button.addTarget(self, action: #selector(didTappedListButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        setUpPageControl()
    }
    
    private func configureUI() {
        [backgroundImageView, pageViewController.view, pageControl, listButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        setUpBackgroundImageViewConstraint()
        setUpPageViewControllerConstraints()
        setUpPageControlConstraint()
        setUpListButtonConstraint()
    }
    
    private func setUpController() {
        view.backgroundColor = .systemBackground
        
        guard let rootViewController = viewControllerList.first else { return }
        
        pageViewController.setViewControllers([rootViewController], direction: .forward, animated: true)
    }
    
    private func setUpPageControl() {
        pageControl.numberOfPages = viewControllerList.count
        pageControl.currentPage = 0
    }
}

// MARK: - Button Action
extension PageViewController {
    @objc
    private func didTappedListButton() {
        let searchViewController = SearchViewController()
        let navigationController = UINavigationController(rootViewController: searchViewController)
        
        present(navigationController, animated: true)
    }
}

//MARK: - PageViewController DataSource, Delegate
extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let displayViewController = pageViewController.viewControllers?.first,
              let index = viewControllerList.firstIndex(of: displayViewController) else { return }
        
        pageControl.currentPage = index
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
            pageViewController.view.bottomAnchor.constraint(equalTo: pageControl.topAnchor)
        ])
    }
    
    private func setUpPageControlConstraint() {
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setUpListButtonConstraint() {
        NSLayoutConstraint.activate([
            listButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor),
            listButton.trailingAnchor.constraint(equalTo: pageControl.trailingAnchor, constant: -20),
            listButton.widthAnchor.constraint(equalToConstant: 20),
            listButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
