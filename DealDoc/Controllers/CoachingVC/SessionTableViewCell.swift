//
//  SessionTableViewCell.swift
//  DealDoc
//
//  Created by Asad Khan on 12/2/22.
//

import UIKit

class SessionTableViewCell: UITableViewCell {

    @IBOutlet weak var dealNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sessionLinkLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
