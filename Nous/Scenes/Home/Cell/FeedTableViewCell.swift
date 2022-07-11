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
    @IBOutlet var feedImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    private var cache = NSCache<NSNumber, UIImage>()

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 10
    }

    func configure(_ model: FeedDisplayModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description

        if let uiImage = cache.object(forKey: tag as NSNumber) {
            feedImageView.image = uiImage
            print("Image: successfully retrieved from cache")

        } else {
            // If a url is present, image will be loaded, if not image is hidded, a placeholder image is also could be used based on UX
            if let url = model.image {
                feedImageView.load(url: url) {
                    if let image = self.feedImageView.image {
                        self.cache.setObject(image, forKey: self.tag as NSNumber)
                        print("Image: successfully loaded")

                    } else {
                        self.feedImageView.isHidden = true
                    }
                }

            } else {
                feedImageView.isHidden = true
            }
        }
    }
}

class FeedTableViewDiffableDataSource: UITableViewDiffableDataSource<FeedSection, FeedDisplayModel> {}

enum FeedSection {
    case feed
}

// Thanks to https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
extension UIImageView {
    func load(url: URL, _ completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completion()
                    }
                }
            }
        }
    }
}
