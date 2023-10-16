//
//  SearchViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/15.
//

import UIKit

final class SearchViewController: UIViewController {
    enum Section {
        case main
    }
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .init(width: UIScreen.main.bounds.width - 20, height: 50)
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, String>?
    
    private let cityNameList: [String]
    
    init(cityNameList: [String]) {
        self.cityNameList = cityNameList
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setUpViewController()
        setUpSearchController()
        setUpNavigationBarAppearance()
        setUpConstraints()
        setUpDiffableDataSource()
        setUpDiffableDataSourceSnapShot()
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "날씨"
    }
    
    private func setUpNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        navigationBarAppearance.backgroundColor = .black
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func setUpSearchController() {
        let searchResultViewController = SearchResultViewController()
        let searchController = UISearchController(searchResultsController: searchResultViewController)
        
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search Location"
        searchController.searchBar.searchTextField.leftView?.tintColor = .white
        searchController.searchBar.delegate = searchResultViewController
        searchController.searchBar.searchTextField.textColor = .white
        UISearchBar.appearance().tintColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - Diffable DataSource
extension SearchViewController {
    private func setUpDiffableDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, String> { cell, indexPath, cityName in
            cell.setUpContents(title: cityName)
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, cityName in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: cityName)
        })
    }
    
    private func setUpDiffableDataSourceSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(cityNameList)
        diffableDataSource?.apply(snapShot)
    }
}
