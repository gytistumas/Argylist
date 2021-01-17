//
//  LinkItemPage.swift
//  Argylist
//
//  Created by Gytis Tumas on 2021-01-17.
//

import Foundation

class LinkItemPage {
    let linkItems: [LinkItem]
    let nextPageURL: String?
    let previousPageURL: String?

    init(linkItems: [LinkItem], nextPageURL: String?, previousPageURL: String?) {
        self.linkItems = linkItems
        self.nextPageURL = nextPageURL
        self.previousPageURL = previousPageURL
    }
}
