//
//  SearchResultViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/16.
//

import UIKit
import MapKit

final class SearchResultViewController: UIViewController {
    enum Section {
        case main
    }
    
    private let emptyView: SearchResultEmptyView = {
        let emptyView = SearchResultEmptyView()
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .init(width: UIScreen.main.bounds.width - 20, height: 70)
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, SearchResultDTO>?
    
    private let searchCompleter: MKLocalSearchCompleter = {
        let searchCompleter = MKLocalSearchCompleter()
        
        searchCompleter.resultTypes = .address
        return searchCompleter
    }()
    
    private var searchResults: [MKLocalSearchCompletion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setUpConstraints()
        setUpViewController()
        setUpDiffableDataSource()
        setUpDiffableDataSourceSanpShot()
    }
    
    private func configureUI() {
        [collectionView, emptyView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .black
        searchCompleter.delegate = self
    }
}

// MARK: - MKLocalSearchCompleter Delegate
extension SearchResultViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let cityNameList = completer.results.map { SearchResultDTO(cityName: $0.title) }
        
        setUpDiffableDataSourceSanpShot(cityNameList: cityNameList)
        emptyView.isHidden = cityNameList.count == 0 ? false : true
    }
}

// MARK: - SearchBar Delegate
extension SearchResultViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            return
        }
        
        searchCompleter.queryFragment = searchText
    }
}

// MARK: - CollectionView Delegate
extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - Diffable DataSource
extension SearchResultViewController {
    private func setUpDiffableDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, SearchResultDTO> { cell, indexPath, searchResultDTO in
            cell.setUpContents(title: searchResultDTO.cityName, isSearchResult: true)
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, searchResultDTO in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: searchResultDTO)
        })
    }
    
    private func setUpDiffableDataSourceSanpShot(cityNameList: [SearchResultDTO] = []) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, SearchResultDTO>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(cityNameList)
        diffableDataSource?.apply(snapShot)
    }
}
