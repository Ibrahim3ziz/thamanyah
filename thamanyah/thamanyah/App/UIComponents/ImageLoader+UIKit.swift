//
//  ImageLoader.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import UIKit

final class ImageLoader {
    
    // MARK: - Shared Instance
    static let shared = ImageLoader()
    
    // MARK: - Properties
    private let cache = NSCache<NSString, UIImage>()
    private var runningTasks = [String: URLSessionDataTask]()
    
    // MARK: - Init
    private init() {
        cache.countLimit = 100 // Maximum 100 images
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    // MARK: - Public Methods
    
    /// Load an image from URL with caching support
    /// - Parameters:
    ///   - urlString: The URL string of the image
    ///   - placeholder: Optional placeholder image to show while loading
    ///   - completion: Completion handler with the loaded image or nil
    func loadImage(
        from urlString: String,
        placeholder: UIImage? = nil,
        completion: @escaping (UIImage?) -> Void
    ) {
        // Return placeholder immediately if URL is invalid
        guard let url = URL(string: urlString) else {
            completion(placeholder)
            return
        }
        
        let cacheKey = urlString as NSString
        
        // Check cache first
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        // Return placeholder while loading
        completion(placeholder)
        
        // Cancel existing task for this URL if any
        runningTasks[urlString]?.cancel()
        
        // Create new task
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.runningTasks.removeValue(forKey: urlString)
            }
            
            guard
                error == nil,
                let data = data,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Cache the image
            self?.cache.setObject(image, forKey: cacheKey)
            
            // Return on main thread
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        runningTasks[urlString] = task
        task.resume()
    }
    
    /// Load image and set it to UIImageView
    /// - Parameters:
    ///   - imageView: The image view to set the image on
    ///   - urlString: The URL string of the image
    ///   - placeholder: Optional placeholder image
    func loadImage(
        into imageView: UIImageView,
        from urlString: String,
        placeholder: UIImage? = nil
    ) {
        // Set placeholder immediately
        imageView.image = placeholder
        
        loadImage(from: urlString, placeholder: placeholder) { image in
            imageView.image = image
        }
    }
    
    /// Cancel loading for a specific URL
    /// - Parameter urlString: The URL string to cancel
    func cancelLoad(for urlString: String) {
        runningTasks[urlString]?.cancel()
        runningTasks.removeValue(forKey: urlString)
    }
    
    /// Clear all cached images
    func clearCache() {
        cache.removeAllObjects()
    }
    
    /// Clear cached image for specific URL
    /// - Parameter urlString: The URL string to clear from cache
    func clearCache(for urlString: String) {
        let cacheKey = urlString as NSString
        cache.removeObject(forKey: cacheKey)
    }
}

// MARK: - UIImageView Extension
extension UIImageView {
    
    /// Load image from URL using ImageLoader
    /// - Parameters:
    ///   - urlString: The URL string of the image
    ///   - placeholder: Optional placeholder image
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        ImageLoader.shared.loadImage(into: self, from: urlString, placeholder: placeholder)
    }
    
    /// Cancel any ongoing image loading
    func cancelImageLoad(for urlString: String) {
        ImageLoader.shared.cancelLoad(for: urlString)
    }
}
