//
//  CommentsTableViewCell.swift
//  DealDoc
//
//  Created by Asad Khan on 10/13/22.
//

import UIKit
import Alamofire
class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var replyTableView: UITableView!
    var repliesList =  [Replies]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.replyTableView.delegate = self
        self.replyTableView.dataSource = self
       // getReplies()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
}
extension CommentsTableViewCell : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repliesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepliesTableViewCell", for: indexPath) as! RepliesTableViewCell
        cell.commentLabel.text = repliesList[indexPath.row].statement
        cell.dateLabel.text = repliesList[indexPath.row].createdAt
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
