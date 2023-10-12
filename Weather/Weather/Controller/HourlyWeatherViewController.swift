//
//  HourlyWeatherViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import UIKit

final class HourlyWeatherViewController: UIViewController {
    enum Section {
        case main
    }
    
    private let compositionalLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return .init(section: section)
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, HourlyWeatherDTO>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpConstraints()
        setUpDiffableDataSource()
        setUPDiffableDataSourceSnapShot()
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: - Diffable DataSource
extension HourlyWeatherViewController {
    func setUpContents(hourlyWeatherDTOList: [HourlyWeatherDTO]) {
        setUPDiffableDataSourceSnapShot(hourlyWeatherDTOList: hourlyWeatherDTOList)
    }
    
    private func setUpDiffableDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<HourlyWeatherCollectionViewCell,
                                                                    HourlyWeatherDTO> { cell, indexPath, hourlyWeatherDTO in
            cell.setUpContents(hourlyweatherDTO: hourlyWeatherDTO)
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, hourlyWeatherDTO in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: hourlyWeatherDTO)
        })
    }
    
    private func setUPDiffableDataSourceSnapShot(hourlyWeatherDTOList: [HourlyWeatherDTO] = []) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, HourlyWeatherDTO>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(hourlyWeatherDTOList)
        diffableDataSource?.apply(snapShot)
    }
}
