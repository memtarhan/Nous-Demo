//
//  FeedTableViewCell.swift
//  Nous
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    static let nibIdentifier = "FeedTableViewCell"
    static let reuseIdentifier = "Feed"

    // MARK: IBOutlets

    @IBOutlet var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = containerView.frame.height / 10
    }

    func configure(_ model: FeedDisplayModel) {
        // TODO: Configure cell with model
    }
}

class FeedTableViewDiffableDataSource: UITableViewDiffableDataSource<FeedSection, FeedDisplayModel> {}

enum FeedSection {
    case feed
}
