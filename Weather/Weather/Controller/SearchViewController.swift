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
    
    private let compositionalLayout: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let listLayout = UICollectionLayoutListConfiguration(appearance: .grouped)
            let section = NSCollectionLayoutSection.list(using: listLayout, layoutEnvironment: layoutEnvironment)
            
            section.interGroupSpacing = 10
            return section
        }
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "날씨"
    }
    
    private func setUpSearchController() {
        let searchViewController = UISearchController(searchResultsController: nil)
        
        searchViewController.searchBar.placeholder = "Search Location"
        navigationItem.searchController = searchViewController
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
