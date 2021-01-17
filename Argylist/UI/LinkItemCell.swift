//
//  LinkItemCell.swift
//  Argylist
//
//  Created by Gytis Tumas on 2021-01-16.
//

import UIKit

class LinkItemCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!

    func setup(with linkItem: LinkItem) {
        nameLabel.text = linkItem.name
        accessoryType = linkItem.loginURL == nil ? .none : .disclosureIndicator
        isUserInteractionEnabled = linkItem.loginURL != nil
    }
}
