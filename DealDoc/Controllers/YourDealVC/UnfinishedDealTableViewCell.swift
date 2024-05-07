//
//  YourDealTableViewCell.swift
//  DealDoc
//
//  Created by Asad Khan on 9/22/22.
//

import UIKit

class UnfinishedDealTableViewCell: UITableViewCell {

    
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var closedDateLabel: UILabel!
    @IBOutlet weak var dealNameLabel: UILabel!
    @IBOutlet weak var dealValueLabel: UILabel!
   // @IBOutlet weak var dealStatusLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: EdgeInsetLabel!
    @IBOutlet weak var dealColorView: UIView!
    @IBOutlet weak var dealColorImage: UIImageView!
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuButtonView: UIView!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lastUpdatedLabel.textInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
