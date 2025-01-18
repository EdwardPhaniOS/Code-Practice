//
//  FeedRefreshViewController.swift
//  Case_Study
//
//  Created by Vinh Phan on 23/12/24.
//

import UIKit

final class FeedRefreshViewController: NSObject {
    private(set) lazy var view = binded(UIRefreshControl())
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
        
    func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    view?.beginRefreshing()
                } else {
                    view?.endRefreshing()
                }
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
}
