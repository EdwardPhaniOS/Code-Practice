//
//  SceneDelegate.swift
//  Case_Study
//
//  Created by Vinh Phan on 08/08/2024.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let localStoreURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("feed-store.sqlite")

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
        window?.makeKeyAndVisible()
    }
    
    func configureWindow() {
        let remoteURL = URL(string: "https://static1.squarespace.com/static/5891c5b8d1758ec68ef5dbc2/t/5db4155a4fbade21d17ecd28/1572083034355/essential_app_feed.json")!
        let remoteClient = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(client: remoteClient, url: remoteURL)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
        
        let feedLoaderCacheDecorator = FeedLoaderCacheDecorator(decoratee: remoteFeedLoader, cache: localFeedLoader)
        let feedLoaderWithFallback = FeedLoaderWithFallbackComposite(primary: feedLoaderCacheDecorator, fallback: localFeedLoader)
        
        let imageLoaderCacheDecorator = FeedImageDataLoaderCacheDecorator(decoratee: remoteImageLoader, cache: localImageLoader)
        let imageLoaderWithFallback = FeedImageDataLoaderWithFallbackComposite(primary: localImageLoader, fallback: imageLoaderCacheDecorator)
        
        let feedVC = FeedUIComposer.feedComposedWith(feedLoader: feedLoaderWithFallback, imageLoader: imageLoaderWithFallback, selectFeedCallback: showComments(for:))
        window?.rootViewController = UINavigationController(rootViewController: feedVC)
    }
    
    func makeRemoteClient() -> HTTPClient {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
    
    private func showComments(for image: FeedImage) {
        print("Showing comments for \(image)")
        //TODO:
//        let url = ImageCommentsEndpoint.get(image.id).url(baseURL: baseURL)
//        let comments = CommentsUIComposer.commentsComposedWith(commentsLoader: makeRemoteCommentsLoader(url: url))
//        navigationController.pushViewController(comments, animated: true)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

