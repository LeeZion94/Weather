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
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = .init(width: 50, height: 110)
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
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
        self.diffableDataSource?.apply(snapShot)
    }
}
