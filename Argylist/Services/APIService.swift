//
//  APIService.swift
//  Argylist
//
//  Created by Gytis Tumas on 2021-01-16.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService {
    static let shared = APIService()
    let apiHost = "https://api.argyle.io/link/v1/"
    let limit = "15"

    func url(forSearchText searchText: String) -> String {
        "\(apiHost)link-items?limit=\(limit)&offset=0&search=\(searchText)"
    }

    func getLinkItems(withURL url: String, completion: @escaping (Swift.Result<LinkItemPage, AFError>) -> Void) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var linkItems = [LinkItem]()
                if let results = json["results"].array {
                    for result in results {
                        if let linkItem = LinkItem.init(json: result) {
                            linkItems.append(linkItem)
                        }
                    }
                }
                let nextPageURL = json["next"].string
                let previousPageURL = json["previous"].string
                let linkItemPage = LinkItemPage(
                    linkItems: linkItems,
                    nextPageURL: nextPageURL,
                    previousPageURL: previousPageURL
                )
                completion(.success(linkItemPage))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
