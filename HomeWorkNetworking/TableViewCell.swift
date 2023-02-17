//
//  TableViewCell.swift
//  HomeWorkNetworking
//
//  Created by Алина Андрушок on 02.02.2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    
}

class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
