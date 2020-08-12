//
//  ApiHandleRepositoryProtocol.swift
//  MusicApp
//
//  Created by Quoc Huy on 7/26/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import Foundation

protocol ApiHandleRepositoryProtocol {
    func doApiURL(urlString: String) -> URL
    func doDataReponse(url: URL) -> [[String: Any]]
    func doSaveDatabase(data: [[String: Any]])
}
