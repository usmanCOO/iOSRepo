//
//  ShareDealTableViewCell.swift
//  DealDoc
//
//  Created by Asad Khan on 10/13/22.
//

import UIKit

class ShareDealTableViewCell: UITableViewCell {

    @IBOutlet weak var dealNameLabel: UILabel!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var unreadCountLabel: UILabel!
    @IBOutlet weak var unreadCommentView: UIView!
    @IBOutlet weak var invesmentSizeLabel: UILabel!
    @IBOutlet weak var closeDateLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var sharedUserLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    override var isSelected: Bool {
//        didSet {
//            self.buttonLabel.text = isSelected ? "Hide Description" : "Show Description"
//            self.descriptionLabel.isHidden = isSelected ? false : true
//        }
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

