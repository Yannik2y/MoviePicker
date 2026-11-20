//
//  PosterImageCache.swift
//  MoviePicker
//
//  In-memory + URLSession image cache so scroll remounts do not flash empty AsyncImage.
//

import Foundation
import UIKit

@MainActor
final class PosterImageCache {
    static let shared = PosterImageCache()
    
    private let memory = NSCache<NSURL, UIImage>()
    private var inflight: [URL: Task<UIImage?, Never>] = [:]
    
    private init() {
        memory.countLimit = 80
    }
    
    func image(for url: URL) -> UIImage? {
        memory.object(forKey: url as NSURL)
    }
    
    @discardableResult
    func load(_ url: URL) async -> UIImage? {
        if let cached = image(for: url) {
            return cached
        }
        if let existing = inflight[url] {
            return await existing.value
        }
        
        let task = Task.detached(priority: .userInitiated) { () -> UIImage? in
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                    return nil
                }
                return UIImage(data: data)
            } catch {
                return nil
            }
        }
        
        inflight[url] = task
        let result = await task.value
        inflight[url] = nil
        
        if let result {
            memory.setObject(result, forKey: url as NSURL)
        } else {
            AppLogger.warning("Poster download failed for \(url.host ?? "unknown")", category: .network)
        }
        return result
    }
    
    func prefetch(_ urls: [URL]) {
        for url in urls {
            guard image(for: url) == nil else { continue }
            Task { _ = await load(url) }
        }
    }
}
