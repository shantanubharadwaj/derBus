//
//  OptionsViewTvCell.swift
//  der Bus
//
//  Created by Shantanu Dutta on 2/11/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import UIKit

class OptionsViewTvCell: UITableViewCell {
    
    var cellSelected: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
