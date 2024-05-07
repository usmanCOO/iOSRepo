//
//  SessionVC.swift
//  DealDoc
//
//  Created by Asad Khan on 12/2/22.
//

import UIKit
import UIKit
import Stripe
import Alamofire
import AVKit
import SDWebImage
class SessionVC: UIViewController {
    
    var sessionResp : SessionResponse?
    @IBOutlet weak var sessionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Connectivity.isConnectedToInternet(){
            getSessionData()
        }else{
            PopupHelper.showToast(message: "No internet Connection")
        }
        
    }
    
    
    func getSessionData() {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        let url = URLPath.getusersessions
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
            case .success:
                let json = response.data
                print(response.result.value!)
                do{
                    let decoder = JSONDecoder()
                    self.sessionResp = try decoder.decode(SessionResponse.self, from: json!)
                    self.sessionTableView.reloadData()
                }
                catch {
                    print("JSON Error")
                }
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
    }
}
extension SessionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionResp?.user_sessions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionTableViewCell") as! SessionTableViewCell
        if sessionResp?.user_sessions?[indexPath.row].deal?.deal_name == nil {
            cell.dealNameLabel.text = ""
        }else {
            cell.dealNameLabel.text = "Deal Name: \(sessionResp?.user_sessions?[indexPath.row].deal?.deal_name ?? "")"
        }
        
        if  let date =  sessionResp?.user_sessions?[indexPath.row].metadata?.start_time?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
            print(date)
            let formattedDate  = date.getFormattedDate(format: "MM/dd/yyyy")
            let formattedTime = date.formattedWith("hh:mm a")
            print(formattedDate,formattedTime)
            cell.dateLabel.text = "Date: \(formattedDate)"
            cell.timeLabel.text = "Time: \(formattedTime)"
        }
        let attributedString = NSMutableAttributedString(string: sessionResp?.user_sessions?[indexPath.row].session_url ?? "")
        attributedString.addAttribute(.link, value: sessionResp?.user_sessions?[indexPath.row].session_url ?? "", range: NSRange(location: 0, length: sessionResp?.user_sessions?[indexPath.row].session_url?.count ?? 0))
        cell.sessionLinkLabel.attributedText = attributedString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

