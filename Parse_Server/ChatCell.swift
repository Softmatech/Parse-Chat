//
//  ChatCell.swift
//  Parse_Server
//
//  Created by Joseph Andy Feidje on 10/4/18.
//  Copyright © 2018 Softmatech. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet var TextLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var bubbleView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bubbleView.layer.cornerRadius = 16
        bubbleView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
