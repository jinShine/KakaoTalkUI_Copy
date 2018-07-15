//
//  MyBubbleChatCell.swift
//  KakaoChat
//
//  Created by 김승진 on 2018. 7. 11..
//  Copyright © 2018년 김승진. All rights reserved.
//

import UIKit

class MyBubbleChatCell: UITableViewCell {

    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var bubbleText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
