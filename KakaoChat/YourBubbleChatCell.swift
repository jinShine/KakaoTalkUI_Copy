//
//  YourBubbleChatCell.swift
//  KakaoChat
//
//  Created by 김승진 on 2018. 7. 11..
//  Copyright © 2018년 김승진. All rights reserved.
//

import UIKit

class YourBubbleChatCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var bubbleText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        profileImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
