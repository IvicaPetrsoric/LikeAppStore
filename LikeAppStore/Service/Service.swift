//
//  Service.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 27/04/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import Foundation

class Service {
    
    static let shared = Service()
    
    private init() {}
    
    // search
    func fetchApps(searchTerm: String, completion: @escaping (SearchResult?, Error?) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchTopGrossing(completion: @escaping(AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchGames(completion: @escaping(AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchTopFree(completion: @escaping(AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/10/explicit.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchAppGroup(urlString: String, completion: @escaping(AppGroup?, Error?) -> Void) {
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchSocialApps(completion: @escaping([SocialApp]?, Error?) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    // generic json
    func fetchGenericJSONData<T: Codable>(urlString: String, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                completion(objects, nil)
            } catch let jsonError {
                print("Failed to decode: ", jsonError.localizedDescription)
                completion(nil, jsonError)
            }
        }.resume()
    }
    
}
