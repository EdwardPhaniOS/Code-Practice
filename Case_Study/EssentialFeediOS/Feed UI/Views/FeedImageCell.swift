//
//  FeedImageCell.swift
//  Case_Study
//
//  Created by Vinh Phan on 23/12/24.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    
    @IBOutlet weak var locationContainer: UIStackView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feedImageContainer: UIView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedImageRetryButton: UIButton!
    
    var onRetry: (() -> Void)?
    
    @IBAction func retryButtonTapped(_ sender: Any) {
        onRetry?()
    }
    
}

