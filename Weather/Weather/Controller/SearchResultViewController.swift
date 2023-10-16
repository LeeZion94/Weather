//
//  SearchResultViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/16.
//

import UIKit
import MapKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func didTappedSearchResultLocation(location: Location)
}

final class SearchResultViewController: UIViewController, AlertControllerShowable {
    enum Section {
        case main
    }
    
    weak var delegate: SearchResultViewControllerDelegate?
    
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

// MARK: - CollectionView Delegate
extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedLocalCompletion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedLocalCompletion)
        let localSearch = MKLocalSearch(request: searchRequest)
        
        localSearch.start { [weak self] response, error in
            if let _ = error {
                self?.showAlert(title: "장소 찾기 에러", message: "찾을 수 없는 장소 입니다", style: .alert)
                return
            }
            
            guard let mapItem = response?.mapItems.first else { return }
            let coordinate = Coordinate(coordinate: mapItem.placemark.coordinate)
            let locationName = mapItem.name ?? ""
            let location = Location(name: locationName, coordiante: coordinate)
            
            self?.delegate?.didTappedSearchResultLocation(location: location)
            self?.dismiss(animated: true)
        }
    }
}

// MARK: - MKLocalSearchCompleter Delegate
extension SearchResultViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let cityNameList = completer.results.map { SearchResultDTO(cityName: $0.title) }
        
        searchResults = completer.results
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
