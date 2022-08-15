//
//  MoviesListTableViewCell.swift
//  GluUpMovyDB
//
//  Created by Denis on 11.08.2022.
//

import UIKit

class MoviesListTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    
    // MARK: - Properties
    
    var viewModel: MovieCellViewModel? {
        didSet {
            populateUi()
        }
    }
    
    // MARK: - Methods
    
    private func populateUi() {
        titleLabel.text = viewModel?.title
        viewModel?.getPosterImage { [weak self] image in
            self?.posterImageView.image = image
        }
    }
}
