//
//  ApiHandleRepository.swift
//  MusicApp
//
//  Created by Quoc Huy on 7/26/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import Foundation

class ApiHandleRepository: ApiHandleRepositoryProtocol {
    
    let urlString = "https://run.mocky.io/v3/e7d7c811-97b1-4a8e-a555-654ad6cb6280"
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, reponse, error) in
        guard let data = data else { return }
                    
        do {
            guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else { return }
            
            jsonArray.forEach { (jsonData) in
                let music = MusicModel ()
                music.initFromJson(jsonData: jsonData)

                let result = MusicRepository.instance.add(musicmodel: music)
                print("Music Repository Add: ID = " + String(music.id) + " " + String(result))
            }
        } catch let error {
            print("Parsing Json Error: ", error)
        }
    }.resume()
    
    // MARK: Function
    func doApiURL(urlString: String) -> URL? {
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
    func doDataReponse(url: URL) -> [[String : Any]]? {
        guard let data = URLSession.shared.dataTask(with: url) { (data, reponse, error) in
            guard let data = data else { return }
            return data
        }.resume()
        
        //return dataResult
    }
    
    func doSaveDatabase(data: [[String : Any]]) {
        <#code#>
    }
    
    
}
