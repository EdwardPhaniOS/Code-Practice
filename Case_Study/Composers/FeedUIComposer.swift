//
//  FeedUIComposer.swift
//  Case_Study
//
//  Created by Vinh Phan on 23/12/24.
//

import UIKit

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader, selectFeedCallback: @escaping (FeedImage) -> Void) -> FeedViewController {
        
        let feedViewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(viewModel: feedViewModel)
        let feedController = FeedViewController(refreshController: refreshController)
        feedViewModel.onFeedLoad = { [weak feedController] feed in
            feedController?.tableModel = adaptFeedToCellControllers(feed: feed, imageLoader: imageLoader, selectFeedCallback: selectFeedCallback)
        }
        return feedController
    }
    
    private static func adaptFeedToCellControllers(feed: [FeedImage], imageLoader: FeedImageDataLoader, selectFeedCallback: @escaping (FeedImage) -> Void) -> [FeedImageCellController] {
        return feed.map({ model in
            let viewModel = FeedImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init, selectCallback: { selectFeedCallback(model) })
            return FeedImageCellController(viewModel: viewModel)
        })
    }
    
}
