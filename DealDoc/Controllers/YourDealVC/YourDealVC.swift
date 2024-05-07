//
//  YourDealVC.swift
//  Meddpicc App
//
//  Created by Asad Khan on 8/30/22.
//

import UIKit
import Alamofire
import DropDown

class YourDealVC: UIViewController, updateDealData {
   
    @IBOutlet weak var activeDealBarView: UIView!
    @IBOutlet weak var wonDealBarView: UIView!
    @IBOutlet weak var lostDealBarView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dealTableView: UITableView!
    @IBOutlet weak var dropDownTextField: UITextField!

    var wonDeal = [Deal_data]()
    var lostDeal = [Deal_data]()
    var completeDeal = [Deal_data]()
    var unFinishedDeal = [Deal_data]()
    var dealData = [Deal_data]()
    var getDealResponse : GetDealQuestionResponse?
    var dealSharedList = [DealSharedData]()
    var subscriptionData = GetSubscriptionResponse()
    var isActiveTapped : Bool = false
    var isWonTapped : Bool = false
    var isDealRoomTapped : Bool = false
    var isYourDeal: Bool = false
    var dealID : Int?
    var dropDown = DropDown()
    var dealColor: String?
    var editAbleText: String?
    var isCompleteCount: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        activeDealBarView.backgroundColor = .red
        wonDealBarView.backgroundColor = .clear
        lostDealBarView.backgroundColor = .clear
        
        print(DealDocSessionManager.shared.getUser()?.appleID ?? "")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameLabel.text = "Hey \(DealDocSessionManager.shared.getUser()?.fullName ?? "")"
        isActiveTapped = true
        activeDealBarView.backgroundColor = .red
        wonDealBarView.backgroundColor = .clear
        lostDealBarView.backgroundColor = .clear
        if Connectivity.isConnectedToInternet(){
            getAllDeals(sortedBy: "all")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                self.showSubscriptionScreen()
              //  self.getSubscriptionData()
            }
        }else{
            PopupHelper.showToast(message: "No internet Connection")
        }
        
    }
    
    
    
    func setupMenuDropDown(button:UIButton) {
        
        dropDown.anchorView = button
        dropDown.width =  150
        dropDown.textColor = .white
        dropDown.backgroundColor = UIColor(hex: "#181818")
        dropDown.direction = .bottom
        dropDown.setupCornerRadius(8)
        
        dropDown.bottomOffset = CGPoint(x: 30, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: -120, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = ["Size","Deal Name","Color","Close Date","Updated Date"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dropDownTextField.text = item
            if item == "Size"{
                getAllDeals(sortedBy: "investment_size")
            }else if item == "Deal Name"{
                getAllDeals(sortedBy: "deal_name")
            }else if item == "Color"{
                getAllDeals(sortedBy: "color")
            }else if item == "Close Date"{
                getAllDeals(sortedBy: "closed_date")
            }else if item == "Updated Date"{
                getAllDeals(sortedBy: "updated_date")
            }
           
        }
      }
    
    @IBAction func dropDownButtonTapped (_ sender: UIButton) {
        setupMenuDropDown(button: sender)
        self.dropDown.objc_show()
        
    }
    func showSubscriptionScreen(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        self.present(vc, animated: true)
    }
    func updateDealNameData() {
        getAllDeals(sortedBy: "all")
    }
    
    func setupDropDown(button:UIButton,index: Int) {
        
        dropDown.anchorView = button
        dropDown.width =  100
        dropDown.textColor = .white
        dropDown.backgroundColor = UIColor(hex: "#181818")
        dropDown.direction = .bottom
        dropDown.setupCornerRadius(8)
        
        dropDown.bottomOffset = CGPoint(x: -20, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: -120, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        if isActiveTapped {
            dropDown.dataSource = ["Won","Lost"]
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                updateDealStatus(deal_ID: self.dealID ?? 0, deal_status: item)
             
            }
        }else if isWonTapped {
            dropDown.dataSource = ["Lost","Active"]
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                updateDealStatus(deal_ID: self.dealID ?? 0, deal_status: item)
             
            }
        }else {
            dropDown.dataSource = ["Won","Active"]
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                updateDealStatus(deal_ID: self.dealID ?? 0, deal_status: item)
             
            }
        }
      }
    @IBAction func activeDealButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        activeDealBarView.backgroundColor = .red
        wonDealBarView.backgroundColor = .clear
        lostDealBarView.backgroundColor = .clear
        isActiveTapped = true
        isWonTapped = false
        getAllDeals(sortedBy: "all")
        
    }
    

    
    @IBAction func wonDealButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        activeDealBarView.backgroundColor = .clear
        wonDealBarView.backgroundColor = .red
        lostDealBarView.backgroundColor = .clear
        isWonTapped = true
        isActiveTapped = false
        getAllDeals(sortedBy: "all")
        

    }
    
    
    @IBAction func lostDealButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        activeDealBarView.backgroundColor = .clear
        wonDealBarView.backgroundColor = .clear
        lostDealBarView.backgroundColor = .red
        // isDealRoomTapped = false
        isWonTapped = false
        isActiveTapped = false
        getAllDeals(sortedBy: "all")
        
       
    }
    
    
    func updateDealStatus(deal_ID: Int,deal_status: String) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        // Create Date
        let date = Date()
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        // Convert Date to String
       let todayDateString =  dateFormatter.string(from: date)
        print(todayDateString)
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        let bodyParameter:[String:Any] = ["dealId": dealID ?? 0,"status": deal_status, "closed_date": todayDateString]
        Alamofire.request(URLPath.updateDealStatus, method: .patch, parameters: bodyParameter, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealResp = try decoder.decode(UpdateDealStatusResponse.self, from: json!)
                    if dealResp.status ?? false {
                        PopupHelper.showToast(message: "Deal Status Updated Successfully")
                        self.getAllDeals(sortedBy: "all")
                    }else  {
                        PopupHelper.showToast(message: "Data is not updated")
                    }
                }
                catch {
                    print("JSON Error")
                }
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
        
    }

    
    func getAllDeals(sortedBy: String?) {
        

        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        DispatchQueue.main.async {
            PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
            self.createLogs(log_type: "Your DealVC Line no 195 Loader start ",metadata: [:])
        }
       let urlString =  "\(URLPath.getUserDeals)/\(sortedBy ?? "")"
       
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            DispatchQueue.main.async {
                PopupHelper.ActivityIndicator.shared.removeSpinner()
                self.createLogs(log_type: "Your DealVC Line no 202  Loader hide",metadata: [:])
            }
            switch response.result {
                
            case .success:
                let json = response.data
                self.createLogs(log_type: "Deal Logs",metadata: response.result.value as! [String : Any])
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealResp = try decoder.decode(UserDealResponse.self, from: json!)
                    self.dealData = dealResp.deal_data ?? []
                    self.unFinishedDeal  = self.dealData.filter({$0.status == "Active"})
                    self.wonDeal = self.dealData.filter({$0.status == "Won"})
                    self.lostDeal = self.dealData.filter({$0.status == "Lost"})
                    self.isCompleteCount =  self.dealData.filter({$0.is_draft == false}).count
                    let firstCompleteDeal = self.dealData.first(where: {$0.is_draft == false})?.id
                    UserDefaults.standard.set(firstCompleteDeal, forKey: "id")
                    print(self.unFinishedDeal.count , self.wonDeal.count , self.lostDeal.count)
                    print(self.isCompleteCount)
                    DispatchQueue.main.async {
                        self.dealTableView.reloadData()
                    }
                }
                catch (let error){
                    print("JSON Error \(error.localizedDescription)")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.createLogs(log_type: "Your DealVC Line no 231 Error ",metadata: [:])
                }
               
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
        
    }
    
    
    
    func getSubscriptionData() {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        print(header)
        
        let url = URLPath.getSubscription
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            switch response.result {

            case .success:
                let json = response.data
                print(response.result.value!)

                do{
                    let decoder = JSONDecoder()
                    let subsResp = try decoder.decode(GetSubscriptionResponse.self, from: json!)
                    self.subscriptionData = subsResp
                    print(self.subscriptionData.subscriptionended ?? false)
                    if self.subscriptionData.message == "Subscription record not found" {
                        self.showSubscriptionScreen()
                    }else {
                        print(self.subscriptionData.message ?? "")
                    }
                }
                catch (let error){
                    print("JSON Error \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")

            }
        }
        
    }
    
    
    
    func createLogs(log_type: String,metadata: [String:Any]) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
       
        let bodyParam : [String:Any] = ["log_type":log_type,"metadata":metadata]
        Alamofire.request(URLPath.createLogs, method: .post, parameters: bodyParam, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            
            switch response.result {
                
            case .success:
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealLogResp = try decoder.decode(CreateLogsResponse.self, from: json!)
                    print(dealLogResp)
                  
                }
                catch (let error){
                    print("JSON Error \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
        
    }
    
    
    func deleteDeal(deal_ID: Int) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request("\(URLPath.getAllDeals)/\(deal_ID)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealResp = try decoder.decode(DealResponse.self, from: json!)
                    print(dealResp)
                }
                catch {
                    print("JSON Error")
                }
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
        
    }
    
    
//    func createLogFile() {
//       guard let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
//                return
//       }
//       let fileName = "\(Date()).log"
//       let logFilePath = (documentsDirectory as NSString).appendingPathComponent(fileName)
//       freopen(logFilePath.cString(using: String.Encoding.ascii), "a+", stderr)
//    }

}




extension YourDealVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if isActiveTapped{
            return unFinishedDeal.count
        }else if isWonTapped{
            return wonDeal.count
        }else {
            return lostDeal.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnfinishedDealTableViewCell", for: indexPath) as! UnfinishedDealTableViewCell
       
        if isActiveTapped {
            cell.dealNameLabel.text = unFinishedDeal[indexPath.row].deal_name
//            cell.updateDateLabel.text = unFinishedDeal[indexPath.row].updatedAt
           // cell.closedDateLabel.text = unFinishedDeal[indexPath.row].closed_date
            let dealValue = unFinishedDeal[indexPath.row].investment_size?.delimiter
            cell.dealValueLabel.text = "$\(dealValue ?? "")"
            if unFinishedDeal[indexPath.row].is_draft == false || unFinishedDeal[indexPath.row].color == "" {
                cell.menuButton.isHidden = false
//                cell.dealStatusLabel.textColor = .green
//                cell.dealStatusLabel.text = "saved deals"
                cell.menuButton.tag = indexPath.row
                cell.menuButton.addTarget(self, action: #selector(buttontap), for: .touchUpInside)
                print(unFinishedDeal[indexPath.row].color ?? "")
                if let hexaColor = unFinishedDeal[indexPath.row].color {
                    cell.mainView.backgroundColor = UIColor(hex: hexaColor).withAlphaComponent(0.3)
                }else {
                    cell.mainView.backgroundColor = UIColor(hex: "#181818")
                }
                if  let date =  unFinishedDeal[indexPath.row].updatedAt?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
                    let formattedDate  = date.getFormattedDate(format: "MM/dd/yyyy")
                    let formattedTime = date.formattedWith("hh:mm a")
                    print(formattedDate,formattedTime)
                    cell.lastUpdatedLabel.text = "Last Updated:\(formattedDate)"
                }
                if  let date =  unFinishedDeal[indexPath.row].closed_date?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
                    let formattedDate  = date.getFormattedDate(format: "MM/dd/yyyy")
                    let formattedTime = date.formattedWith("hh:mm a")
                    print(formattedDate,formattedTime)
                    cell.closedDateLabel.text = "Close Date: \(formattedDate)"
                }
            }
//            else if unFinishedDeal[indexPath.row].color == "" {
////                cell.dealStatusLabel.textColor = .yellow
////                cell.dealStatusLabel.text = "draft deal"
//                cell.menuButton.isHidden = true
//                cell.mainView.backgroundColor = UIColor(hex: "#181818")
//                if  let date =  unFinishedDeal[indexPath.row].updatedAt?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
//                    let formattedDate  = date.getFormattedDate(format: "MM/dd/yyyy")
//                    let formattedTime = date.formattedWith("hh:mm a")
//                    print(formattedDate,formattedTime)
//                    cell.lastUpdatedLabel.text = "Last Updated:\(formattedDate)"
//                }
//                if  let date =  unFinishedDeal[indexPath.row].closed_date?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
//                    let formattedDate  = date.getFormattedDate(format: "MM/dd/yyyy")
//                    let formattedTime = date.formattedWith("hh:mm a")
//                    print(formattedDate,formattedTime)
//                    cell.closedDateLabel.text = "Close Date: \(formattedDate)"
//                }
//            }
            
            else {
//                cell.dealStatusLabel.textColor = .yellow
//                cell.dealStatusLabel.text = "draft deal"
                cell.menuButton.isHidden = true
                cell.mainView.backgroundColor = UIColor(hex: "#181818")
                if  let date =  unFinishedDeal[indexPath.row].updatedAt?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
                    let formattedDate  = date.getFormattedDate(format: "MM/dd/yyyy")
                    let formattedTime = date.formattedWith("hh:mm a")
                    print(formattedDate,formattedTime)
                    cell.lastUpdatedLabel.text = "Last Updated:\(formattedDate)"
                }
                if  let date =  unFinishedDeal[indexPath.row].closed_date?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
                    let formattedDate  = date.getFormattedDate(format: "MM/dd/yyyy")
                    let formattedTime = date.formattedWith("hh:mm a")
                    print(formattedDate,formattedTime)
                    cell.closedDateLabel.text = "Close Date: \(formattedDate)"
                }
            }
            return cell
        }else if isWonTapped{
            cell.dealNameLabel.text = wonDeal[indexPath.row].deal_name
            let dealValue = wonDeal[indexPath.row].investment_size?.delimiter
            cell.dealValueLabel.text = "$\(dealValue ?? "")"
            //cell.dealStatusLabel.text = ""
            cell.menuButton.isHidden = false
            if  let date =  wonDeal[indexPath.row].updatedAt?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
                let formattedDate  = date.getFormattedDate(format: "MM/dd/yyyy")
                let formattedTime = date.formattedWith("hh:mm a")
                print(formattedDate,formattedTime)
                cell.lastUpdatedLabel.text = "Last Updated:\(formattedDate)"
            }
            if  let date =  wonDeal[indexPath.row].closed_date?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
                let formattedDate  = date.getFormattedDate(format: "MM/dd/yyyy")
                let formattedTime = date.formattedWith("hh:mm a")
                print(formattedDate,formattedTime)
                cell.closedDateLabel.text = "Close Date: \(formattedDate)"
            }
            cell.menuButton.tag = indexPath.row
            cell.menuButton.addTarget(self, action: #selector(buttontap), for: .touchUpInside)
            if wonDeal[indexPath.row].color != "" {
                let hexaColor = wonDeal[indexPath.row].color ?? ""
                cell.mainView.backgroundColor = UIColor(hex: hexaColor).withAlphaComponent(0.3)

            }else {
                cell.mainView.backgroundColor = UIColor(hex: "#181818")
            }
            return cell
        }else {
            cell.dealNameLabel.text = lostDeal[indexPath.row].deal_name
            let dealValue = lostDeal[indexPath.row].investment_size?.delimiter
            cell.dealValueLabel.text = "$\(dealValue ?? "")"
            //cell.dealStatusLabel.text = ""
            cell.menuButton.isHidden = false
            if  let date =  lostDeal[indexPath.row].updatedAt?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
                let formattedDate  = date.getFormattedDate(format: "MM/dd/yyyy")
                let formattedTime = date.formattedWith("hh:mm a")
                print(formattedDate,formattedTime)
                cell.lastUpdatedLabel.text = "Last Updated:\(formattedDate)"
            }
            if  let date =  lostDeal[indexPath.row].closed_date?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
                let formattedDate  = date.getFormattedDate(format: "MM/dd/yyyy")
                let formattedTime = date.formattedWith("hh:mm a")
                print(formattedDate,formattedTime)
                cell.closedDateLabel.text = "Close Date: \(formattedDate)"
            }
            cell.menuButton.tag = indexPath.row
            cell.menuButton.addTarget(self, action: #selector(buttontap), for: .touchUpInside)
            if lostDeal[indexPath.row].color != "" {
                let hexaColor = lostDeal[indexPath.row].color ?? ""
                cell.mainView.backgroundColor = UIColor(hex: hexaColor).withAlphaComponent(0.3)

            }else {
                cell.mainView.backgroundColor = UIColor(hex: "#181818")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func buttontap(_ sender:UIButton) {
        let index = sender.tag
        if isActiveTapped {
            self.dealID = unFinishedDeal[index].id
        }else if isWonTapped {
            self.dealID = wonDeal[index].id
        }else {
            self.dealID = lostDeal[index].id
        }
        self.setupDropDown(button: sender, index : index)
        self.dropDown.objc_show()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isActiveTapped{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnFinishedDealVC") as! UnFinishedDealVC
            if unFinishedDeal[indexPath.row].is_draft == false {
                vc.isSavedDeal = true
               // vc.isYourScreen = false
                vc.Checkflag = true
            }else {
                vc.isSavedDeal = false
                vc.isNotSavedDeal = true
                vc.Checkflag = false
                //vc.isYourScreen = true
            }
            vc.isYourScreen = true
            vc.isSharedDeal = false
            vc.editAbleText = unFinishedDeal[indexPath.row].status
            vc.unFinishedDealObj = unFinishedDeal[indexPath.row]
            vc.selected_deal = unFinishedDeal[indexPath.row]
            vc.dealID = unFinishedDeal[indexPath.row].id
            vc.dealColor = unFinishedDeal[indexPath.row].color
            vc.isComplete = self.isCompleteCount ?? 0
            vc.dealName = self.unFinishedDeal[indexPath.row].deal_name
            self.navigationController?.pushViewController(vc, animated: true)
        
        }else if isWonTapped {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnFinishedDealVC") as! UnFinishedDealVC
            if unFinishedDeal[indexPath.row].is_draft == false {
                vc.isSavedDeal = true
               // vc.isYourScreen = false
                vc.Checkflag = true
            }else {
                vc.isSavedDeal = false
                vc.isNotSavedDeal = true
                vc.Checkflag = false
                //vc.isYourScreen = true
            }
            vc.isSavedDeal = true
            vc.isYourScreen = true
            vc.editAbleText = wonDeal[indexPath.row].status
            vc.selected_deal = wonDeal[indexPath.row]
            vc.dealID = wonDeal[indexPath.row].id
            vc.dealColor = wonDeal[indexPath.row].color
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnFinishedDealVC") as! UnFinishedDealVC
            if unFinishedDeal[indexPath.row].is_draft == false {
                vc.Checkflag = true
            }else {
                vc.Checkflag = false
            }
            vc.isSavedDeal = true
            vc.isYourScreen = true
            vc.editAbleText = lostDeal[indexPath.row].status
            vc.selected_deal = lostDeal[indexPath.row]
            vc.dealID = lostDeal[indexPath.row].id
            vc.dealColor = lostDeal[indexPath.row].color
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
 
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if isActiveTapped {
                let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
                    let sourceItem = self.unFinishedDeal[indexPath.row]
                    self.deleteDeal(deal_ID : sourceItem.id ?? 0)
                    self.unFinishedDeal.remove(at: indexPath.row)
                    self.dealTableView.deleteRows(at: [indexPath], with: .fade)
                }
                delete.backgroundColor = UIColor.red
                return [delete]
            
        }else if isWonTapped {
            let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
                let sourceItem = self.wonDeal[indexPath.row]
                self.deleteDeal(deal_ID : sourceItem.id ?? 0)
                self.wonDeal.remove(at: indexPath.row)
                self.dealTableView.deleteRows(at: [indexPath], with: .fade)
            }
            delete.backgroundColor = UIColor.red
            return [delete]
        }else {
            let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
                let sourceItem = self.lostDeal[indexPath.row]
                self.deleteDeal(deal_ID : sourceItem.id ?? 0)
                self.lostDeal.remove(at: indexPath.row)
                self.dealTableView.deleteRows(at: [indexPath], with: .fade)
            }
            delete.backgroundColor = UIColor.red
            return [delete]
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
}

