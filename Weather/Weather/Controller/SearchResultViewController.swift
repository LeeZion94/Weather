//
//  SearchResultViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/16.
//

import UIKit

final class SearchResultViewController: UIViewController {
    enum Section {
        case main
    }
    
    private let compositionalLayout: UICollectionViewCompositionalLayout = {
        let listLayout = UICollectionLayoutListConfiguration(appearance: .plain)
        
        return UICollectionViewCompositionalLayout.list(using: listLayout)
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setUpConstraints()
        setUpViewController()
        setUpDiffableDataSource()
        setUpDiffableDataSourceSanpShot()
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .black
    }
}

// MARK: - Diffable DataSource
extension SearchResultViewController {
    private func setUpDiffableDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, String> { cell, indexPath, cityName in
            cell.setUpContents(title: cityName, isSearchResult: true)
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, cityName in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: cityName)
        })
    }
    
    private func setUpDiffableDataSourceSanpShot(cityNameList: [String] = []) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(cityNameList)
        diffableDataSource?.apply(snapShot)
    }
}
