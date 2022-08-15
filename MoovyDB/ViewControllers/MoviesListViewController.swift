//
//  MoviesListViewController.swift
//  GluUpMovyDB
//
//  Created by Denis on 09.08.2022.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    // MARK: - Enums
    
    enum Section: Int {
        case list = 0
        case loadMore
    }
    
    // MARK: - Constants
    
    let movieEntryCellReuseId = "MoviesListTableViewCell"
    let loadMoreCellReuseId = "LoadMoreTableViewCell"
    let showMovieDetailsSegueId = "ShowMovieDetailsSegue"
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    
    var viewModel: MoviesListViewModel? {
        didSet {
            NotificationCenter.default.removeObserver(self, name: nil, object: oldValue)
            NotificationCenter.default.addObserver(self, selector: #selector(viewModelDidLoadPage), name: .moviesListViewModelDidLoadPage, object: viewModel)
            tableView?.reloadData()
        }
    }
    
    // MARK: - Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
        
        let provider = MoviesListProvider.createProvider()
        let listVM = MoviesListViewModel(provider: provider)
        viewModel = listVM
        viewModel?.loadPage()
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVM = sender as? MovieDetailViewModel,
           let detailVC = segue.destination as? MovieDetailsViewController {
            detailVC.viewModel = detailVM
        }
    }
    
    // MARK: - Notifications

    @objc func viewModelDidLoadPage() {
        tableView.reloadData()
    }
}

// MARK: - Table View Data Source

extension MoviesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .list:
            return viewModel?.moviesCount ?? 0
        case .loadMore:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellId = ""
        
        switch Section(rawValue: indexPath.section) {
        case .list:
            cellId = movieEntryCellReuseId
        case .loadMore:
            cellId = loadMoreCellReuseId
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        guard let moviesListCell = cell as? MoviesListTableViewCell else {
            return cell
        }
        
        let cellVM = viewModel?.cellViewModel(at: indexPath)
        moviesListCell.viewModel = cellVM
        
        return moviesListCell
    }
}

// MARK: - Table View Delegate

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0,
              let detailVM = viewModel?.detailViewModel(at: indexPath) else {
            return
        }
        
        performSegue(withIdentifier: showMovieDetailsSegueId, sender: detailVM)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if Section(rawValue: indexPath.section) == .loadMore {
            viewModel?.loadPage()
        }
    }
}
