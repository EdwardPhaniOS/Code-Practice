//
//  FeedImageCellController.swift
//  Case_Study
//
//  Created by Vinh Phan on 23/12/24.
//

import UIKit

final class FeedImageCellController {
    private let viewModel: FeedImageViewModel<UIImage>
    
    init(viewModel: FeedImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    static func registerCell(for tableView: UITableView) {
        tableView.registerNib(cellType: FeedImageCell.self)
    }
    
    func cell(for tableView: UITableView) -> UITableViewCell {
        let cell: FeedImageCell = tableView.dequeueReusableCell()
        viewModel.loadImageData()
        return binded(cell)
    }
    
    func preload() {
        viewModel.loadImageData()
    }
    
    func cancelLoad() {
        viewModel.cancelImageDataLoad()
    }
    
    func selectCell() {
        viewModel.selectCell()
    }
    
    private func binded(_ cell: FeedImageCell) -> FeedImageCell {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.onRetry = viewModel.loadImageData
        cell.feedImageRetryButton.isHidden = true
        
        viewModel.onImageLoad = { [weak cell]  image in
            DispatchQueue.main.async {
                cell?.feedImageView.image = image
            }
        }
        
        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            DispatchQueue.main.async {
                cell?.feedImageContainer.isShimmering = isLoading
            }
        }
        
        viewModel.onShouldRetryImageLoadStateChange = { [weak cell] shouldRetry in
            DispatchQueue.main.async {
                cell?.feedImageRetryButton.isHidden = !shouldRetry
            }
        }
        
        return cell
    }
    
}

