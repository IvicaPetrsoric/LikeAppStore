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
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed to fetch apps ", err.localizedDescription)
                completion([], err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results, nil)
            } catch let jsonError {
                print("Failed to decode json ", jsonError.localizedDescription)
                completion([], jsonError)
            }
        }.resume()
    }
    
    func fetchTopGrossing(completion: @escaping(AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchGames(completion: @escaping(AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }

    
    func fetchAppGroup(urlString: String, completion: @escaping(AppGroup?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed to fetch app groups: ", err.localizedDescription)
                completion(nil, err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data)
                completion(appGroup, nil)
            } catch let jsonError {
                print("Failed to decode: ", jsonError.localizedDescription)
                completion(nil, jsonError)
            }
        }.resume()
    }
    
    func fetchSocialApps(completion: @escaping([SocialApp]?, Error?) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed to fetch social app: ", err.localizedDescription)
                completion(nil, err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let objects = try JSONDecoder().decode([SocialApp].self, from: data)
                completion(objects, nil)
            } catch let jsonError {
                print("Failed to decode: ", jsonError.localizedDescription)
                completion(nil, jsonError)
            }
        }.resume()
    }
    
}
