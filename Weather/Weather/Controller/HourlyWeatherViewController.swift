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
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
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
