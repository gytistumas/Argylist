//
//  UITableView+EmptyState.swift
//  Argylist
//
//  Created by Gytis Tumas on 2021-01-16.
//

import UIKit

// UITableView extension to show and hide empty state
extension UITableView {
    func showEmptyState(with text: String) {
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.textColor = .gray
        textLabel.font = .systemFont(ofSize: 14)
        textLabel.textAlignment = .center
        backgroundView = textLabel
        separatorStyle = .none
    }

    func hideEmptyState() {
        backgroundView = nil
        separatorStyle = .singleLine
    }
}
