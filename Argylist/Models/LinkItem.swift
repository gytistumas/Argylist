//
//  LinkItem.swift
//  Argylist
//
//  Created by Gytis Tumas on 2021-01-16.
//

import Foundation
import SwiftyJSON

class LinkItem {
    let id: String
    let name: String
    let loginURL: String?

    init(id: String, name: String, loginURL: String?) {
        self.id = id
        self.name = name
        self.loginURL = loginURL
    }

    convenience init?(json: JSON) {
        guard let id = json["id"].string, let name = json["name"].string else {
            return nil
        }
        let loginURL = json["login_url"].string
        self.init(id: id, name: name, loginURL: loginURL)
    }
}
