//
//  DetailWeatherViewController.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import UIKit

final class DetailWeatherViewController: UIViewController {
    enum Section {
        case weekly
        case detail
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(WeeklyWeatherTableViewCell.self, forCellReuseIdentifier: WeeklyWeatherTableViewCell.id)
        tableView.register(DetailWeatherTableViewCell.self, forCellReuseIdentifier: DetailWeatherTableViewCell.id)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var diffableDataSource: UITableViewDiffableDataSource<Section, AnyHashable>?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: - Diffable DataSource
extension DetailWeatherViewController {
    func setUpContents(weeklyWeatherDTOList: [WeeklyWeatherDTO], detailWeatherDTOList: [DetailWeatherDTO]) {
        setUpDiffabelDataSourceSnapShot(weeklyWeatherDTOList: weeklyWeatherDTOList,
                                        detailWeatherDTOList: detailWeatherDTOList)
    }
    
    private func setUpDiffableDataSource() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            if let weeklyWeatherDTO = item as? WeeklyWeatherDTO {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WeeklyWeatherTableViewCell.id, for: indexPath) as? WeeklyWeatherTableViewCell else { return UITableViewCell() }
                
                cell.setUpContents(weeklyWeatherDTO: weeklyWeatherDTO)
            } else if let detailWeatherDTO = item as? DetailWeatherDTO {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailWeatherTableViewCell.id, for: indexPath) as? DetailWeatherTableViewCell else { return UITableViewCell() }
                
                cell.setUpContents(detailWeatherDTO: detailWeatherDTO)
            }
            
            return UITableViewCell()
        })
    }
    
    private func setUpDiffabelDataSourceSnapShot(weeklyWeatherDTOList: [WeeklyWeatherDTO] = [],
                                                 detailWeatherDTOList: [DetailWeatherDTO] = []) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapShot.appendSections([.weekly, .detail])
        snapShot.appendItems([], toSection: .weekly) // TODO: Required Data
        snapShot.appendItems([], toSection: .detail)
        diffableDataSource?.apply(snapShot)
    }
}
