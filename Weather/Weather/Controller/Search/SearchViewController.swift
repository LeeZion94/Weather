//
//  SearchViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/15.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func didTappedSearchLocation(index: Int)
    func didTappedSearchResultLocation(location: Location)
}

final class SearchViewController: UIViewController, ToastShowable {
    enum Section {
        case main
    }
    
    weak var delegate: SearchViewControllerDelegate?
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .init(width: UIScreen.main.bounds.width - 20, height: 50)
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Location>?
    
    private var locationList: [Location]
    
    init(locationList: [Location]) {
        self.locationList = locationList
        
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
        
        searchResultViewController.delegate = self
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search Location"
        searchController.searchBar.searchTextField.leftView?.tintColor = .white
        searchController.searchBar.delegate = searchResultViewController
        searchController.searchBar.searchTextField.textColor = .white
        UISearchBar.appearance().tintColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - SearchResultViewController Delegate
extension SearchViewController: SearchResultViewControllerDelegate {
    func didTappedSearchResultLocation(location: Location) {
        locationList.append(location)
        setUpDiffableDataSourceSnapShot()
        showToast(message: "리스트 추가 완료")
        navigationItem.searchController?.searchBar.searchTextField.text = ""
        delegate?.didTappedSearchResultLocation(location: location)
    }
}

// MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTappedSearchLocation(index: indexPath.row)
        dismiss(animated: true)
    }
}

// MARK: - Diffable DataSource
extension SearchViewController {
    private func setUpDiffableDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, Location> { cell, indexPath, location in
            cell.setUpContents(title: location.name)
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, location in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: location)
        })
    }
    
    private func setUpDiffableDataSourceSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Location>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(locationList)
        diffableDataSource?.apply(snapShot)
    }
}
