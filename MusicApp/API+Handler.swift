//
//  APIHandler.swift
//  MusicApp
//
//  Created by Quoc Huy on 8/18/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import Foundation
import Alamofire

class APIHandler {
    
    // MARK: Singleton
    static let shared = APIHandler()
    
    private init() {}
    
    // MARK: Function
    func parsingDataFromApi(urlString: String) {
        print("APIHandler -> parsingDataFromApi: Start parsing Data from API")
        
        AF.request(urlString).responseJSON { [weak self] (response) in
            guard let this = self else { return }
            
            switch response.result {
            case .success(let result):
                this.successBlock(json: result as? [NSDictionary])
                           
            case .failure(let error):
                this.failureBlock(error: error)
            }
        }
    }
    
    private func successBlock(json: [NSDictionary]?) {
        
        if var json = json {
            print("APIHandler -> successBlock: Start handling Json result")
            
            json.sort { ($0["name"] as? String ?? "") < ($1["name"] as? String ?? "") }

            json.forEach { [weak self] (jsonItem) in
                guard let this = self else { return }
                this.jsonItemToObject(jsonItem: jsonItem)
            }
        } else {
            print("APIHandler -> successBlock: Could not start handling Json result")
        }
    }
    
    private func failureBlock(error: Error) {
        print("APIHandler -> failureBlock: ", error)
    }
    
    private func jsonItemToObject(jsonItem: NSDictionary) {
        let music = MusicModel()
        music.initFromJson(jsonData: jsonItem)

        if (MusicRepository.shared.getById(id: music.id) == nil) {
            MusicRepository.shared.add(musicmodel: music)
            print("APIHandler -> jsonItemToObject: Add Music ID \(music.id)")
        } else {
            print("APIHandler -> jsonItemToObject: Music ID \(music.id) is existed")
        }
    }
}


