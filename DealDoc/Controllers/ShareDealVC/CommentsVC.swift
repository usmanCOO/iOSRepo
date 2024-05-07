//
//  CommentsVC.swift
//  DealDoc
//
//  Created by Asad Khan on 10/14/22.
//

import UIKit
import Alamofire
import MessageUI
class CommentsVC: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var unReadCommentsLabel: UILabel!
    @IBOutlet weak var readCommentsView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
   
    
    var dealID : Int?
    var replied_to: Int?
    var dealDescription: String?
    var initCommentBy_Name: String?
    var dealCommentsList =  [GetCommentData]()
    var unReadComments : UnReadCommentsResponse?
    var readComments : ReadCommentResponse?
    var addComment : AddCommentResponse?
    var repliesList =  [Replies]()
    var isReplyTapped: Bool? = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextField.delegate = self
        hideKeyboardWhenTappedAround()
        getUserData()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.getUnReadComments()
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if Connectivity.isConnectedToInternet() {
                self.getSharedDealComments()
            }else{
                PopupHelper.showToast(message: "No internet Connection")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ReadComments()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == commentTextField {
            commentButton.isEnabled = true
        }else {
            commentButton.isEnabled = false
        }
    }
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
        }
    }
    
    func getUserData() {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
      
        Alamofire.request(URLPath.getUser, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
           
            switch response.result {
                
            case .success:
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(LoginResponse.self, from: json!)
                    if userData.success == false {
                            PopupHelper.showToast(message:  "Something wrong")
                    }
                    else {
                        DispatchQueue.main.async {
                            
        
                            self.descriptionLabel.text = self.dealDescription ?? ""
                            self.userNameLabel.text    = self.initCommentBy_Name ?? ""
                            self.userEmailLabel.text   = "\(userData.data?.email ?? "")"
                            self.userPhoneLabel.text   = "\(userData.data?.phone_no ?? "NA")"
                            print("\(BASEURL.profileImageUrl)\(userData.data?.profilePhoto ?? "")")
                            let url = "\(BASEURL.profileImageUrl)\(userData.data?.profilePhoto ?? "")"
                            self.userImageView.sd_setImage(with: URL(string: "\(url.replacingOccurrences(of: " ", with: "%20"))"), placeholderImage: #imageLiteral(resourceName: "userPlaceholder-1"))
                        }
                    }
                    print(json ?? "Error")
                }
                catch(let error){
                    print("JSON Error \(error.localizedDescription)")
                }
            case .failure:
                print("Data is not saved")
                
            }
        }
    }
    
    
    
    func getSharedDealComments() {
        
        //let token  = DealDocSessionManager.shared.getUser()?.token ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let bodyParameter:[String:Any] = ["dealId": String(dealID ?? 0)]
        print(header , bodyParameter , URLPath.getComments)
        let urlString = "\(URLPath.getComments)/\(dealID ?? 0)"
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: header).responseJSON { [self]
            response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealCommentsResp = try decoder.decode(GetCommentResponse.self, from: json!)
                    self.dealCommentsList = dealCommentsResp.data ?? []
                    DispatchQueue.main.async {
                        self.commentTextField.text?.removeAll()
                        self.commentsTableView.reloadData()
                    }
                }
                catch(let error){
                    print(error.localizedDescription)
                    
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
                
                
                
            }
        }
    }
    
    
//    func getUnReadComments() {
//
//        let token = UserDefaults.standard.string(forKey: "token") ?? ""
//        let header: HTTPHeaders = [
//            "Authorization": "Bearer \(token)",
//            "Content-Type": "application/json"
//        ]
//        let urlString = URLPath.getUnreadComments
//        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: header).responseJSON { [self]
//            response in
//
//            switch response.result {
//            case .success:
//                let json = response.data
//                print(response.result.value!)
//                do{
//                    let decoder = JSONDecoder()
//                    self.unReadComments = try decoder.decode(UnReadCommentsResponse.self, from: json!)
//                    if unReadComments?.success ?? false {
//                        DispatchQueue.main.async {
//                            self.readCommentsView.isHidden = false
//                            self.unReadCommentsLabel.text = "\(self.unReadComments?.unread ?? 0)"
//                        }
//                    }else{
//                        self.readCommentsView.isHidden = true
//                    }
//                }
//                catch(let error){
//                    print(error.localizedDescription)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func ReadComments() {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let urlString = "\(URLPath.getReadComments)/\(dealID ?? 0)"
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: header).responseJSON { [self]
            response in
            switch response.result {
            case .success:
                let json = response.data
                print(response.result.value!)
                do{
                    let decoder = JSONDecoder()
                    self.readComments = try decoder.decode(ReadCommentResponse.self, from: json!)
                    print(readComments ?? [])
                }
                catch(let error){
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func addComment(replied_to: Int?) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        var bodyParam:[String:Any] = [:]
        if replied_to == nil {
            bodyParam = ["deal_id" : String(dealID ?? 0) ,"statement" : commentTextField.text ?? ""]
        }else {
            bodyParam = ["deal_id" : String(dealID ?? 0) ,"statement" : commentTextField.text ?? "","replied_to": replied_to ?? 0]
        }
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request(URLPath.addComments, method: .post, parameters: bodyParam, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
                
                
            case .success:
                let json = response.data
                print(response.result.value!)
                
                // print(String(data: data, encoding: .utf8)!)
                do{
                    let decoder = JSONDecoder()
                    self.addComment = try decoder.decode(AddCommentResponse.self, from: json!)
                    if self.addComment?.success == false {
                        PopupHelper.showToast(message: self.addComment?.message ?? "")
                    }
                    else {
                        // DealDocSessionManager.shared.saveUser(value: self.createDealResponse)
                        PopupHelper.showToast(message: self.addComment?.message ?? "")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                            self.getSharedDealComments()
                        }
                        
                    }
                }
                catch DecodingError.keyNotFound(let key, let context) {
                    Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
                } catch DecodingError.valueNotFound(let type, let context) {
                    Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
                } catch DecodingError.typeMismatch(let type, let context) {
                    Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                } catch DecodingError.dataCorrupted(let context) {
                    Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
                } catch let error as NSError {
                    NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")
            }
        }
        
    }
    @IBAction func phoneNumberButtonTapped (_ sender: UIButton) {
        makePhoneCall(phoneNumber: userPhoneLabel.text ?? "NA")
    }
    @IBAction func emailButtonTapped (_ sender: UIButton) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    @IBAction func backButtonTapped (_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func sendButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        if commentTextField.text != "" {
            if isReplyTapped ?? false{
                addComment(replied_to: replied_to)
            }else{
                addComment(replied_to: nil)
            }
        }else {
            PopupHelper.showToast(message: "Enter Comment")
        }
    }
}
extension CommentsVC : MFMailComposeViewControllerDelegate{
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["\(userEmailLabel.text ?? "")"])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension CommentsVC : UITableViewDelegate , UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dealCommentsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealCommentsList[section].replies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
        headerCell.commentLabel.text = dealCommentsList[section].statement
        headerCell.senderNameLabel.text = dealCommentsList[section].user?.fullName ?? ""
        let url = "\(BASEURL.profileImageUrl)\(dealCommentsList[section].user?.profilePhoto ?? "")"
        headerCell.userImageView.sd_setImage(with: URL(string: "\(url.replacingOccurrences(of: " ", with: "%20"))"), placeholderImage: #imageLiteral(resourceName: "userPlaceholder-1"))
//        headerCell.userImageView.loadImage(url,.scaleAspectFit) {  (_, _, _) in
//        }
        if  let date =  dealCommentsList[section].createdAt?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
            print(date)
            let convertDate  = date.convertToLocalTime(fromTimeZone: "GMT")
            print(convertDate!)
            let formattedDate  = convertDate?.getFormattedDate(format: "MM/dd/yyyy")
            let formattedTime = convertDate?.formattedWith("hh:mm a")
            headerCell.dateLabel.text = formattedDate
            headerCell.timeLabel.text = formattedTime
        }
        headerCell.replyButton.tag = section
        headerCell.replyButton.addTarget(self, action: #selector(didTapAddReplyButton), for: .touchUpInside)
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepliesTableViewCell", for: indexPath) as! RepliesTableViewCell
        cell.commentLabel.text = dealCommentsList[indexPath.section].replies?[indexPath.row].statement
        cell.senderNameLabel.text = dealCommentsList[indexPath.section].replies?[indexPath.row].user?.fullName ?? ""
        let url = "\(BASEURL.profileImageUrl)\(dealCommentsList[indexPath.section].replies?[indexPath.row].user?.profilePhoto ?? "")"
        cell.userImageView.sd_setImage(with: URL(string: "\(url.replacingOccurrences(of: " ", with: "%20"))"), placeholderImage: #imageLiteral(resourceName: "userPlaceholder-1"))
//        cell.userImageView.loadImage(url,.scaleAspectFit) {  (_, _, _) in
//        }
    
        if  let date =  dealCommentsList[indexPath.section].replies?[indexPath.row].createdAt?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
            print(date)
            let convertDate  = date.convertToLocalTime(fromTimeZone: "GMT")
            print(convertDate!)
            let formattedDate  = convertDate?.getFormattedDate(format: "MM/dd/yyyy")
            let formattedTime = convertDate?.formattedWith("hh:mm a")
            print(formattedDate,formattedTime)
            cell.dateLabel.text = formattedDate
            cell.timeLabel.text = formattedTime
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func reloadTableView(indexpath: Int) {
        let cell = commentsTableView.cellForRow(at: IndexPath(item: indexpath, section: 0)) as? CommentsTableViewCell
        cell?.replyTableView.reloadData()
        cell?.replyView.layoutIfNeeded()
        cell?.replyViewHeight.constant = (cell?.replyTableView.contentSize.height ?? 0) + 10
    }
    
    @objc
    func didTapAddReplyButton(_ sender: UIButton) {
        isReplyTapped = true
        let index = sender.tag
        dealCommentsList[index].isReplyViewExpanded = true
        self.replied_to = Int(dealCommentsList[index].id ?? 0)
        self.commentTextField.placeholder = "Reply to \(dealCommentsList[index].user?.fullName ?? "")"
        DispatchQueue.main.async {
            self.commentsTableView.reloadData()
        }
    }
}
