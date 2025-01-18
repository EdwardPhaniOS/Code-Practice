//
//  FeedImageViewModel.swift
//  Case_Study
//
//  Created by Vinh Phan on 23/12/24.
//

import Foundation

class FeedImageViewModel<Image> {
    typealias Observer<T> = (T) -> Void
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private let imageTransformer: (Data) -> Image?
    private let selectCallback: () -> Void
    
    init(task: FeedImageDataLoaderTask? = nil, model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?, selectCallback: @escaping () -> Void) {
        self.task = task
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
        self.selectCallback = selectCallback
    }
    
    var description: String? {
        return model.description
    }
    
    var location: String? {
        return model.location
    }
    
    var hasLocation: Bool {
        return location != nil
    }
    
    var onImageLoad: Observer<Image>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    
    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        task = imageLoader.loadImageData(from: model.url, completion: { [weak self] result in
            self?.handle(result)
        })
    }
    
    func handle(_ result: Result<Data, Error>) {
        if let image = (try? result.get()).flatMap(self.imageTransformer) {
            self.onImageLoad?(image)
        } else {
            self.onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
    
    func selectCell() {
        selectCallback()
    }
}

