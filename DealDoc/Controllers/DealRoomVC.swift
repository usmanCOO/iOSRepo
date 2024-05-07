//
//  DealRoomVC.swift
//  DealDoc
//
//  Created by Asad Khan on 10/4/22.
//

import UIKit
import Alamofire
import DropDown
class DealRoomVC: UIViewController {
    
    @IBOutlet weak var sharedWithMeBarView: UIView!
    @IBOutlet weak var sharedByMeBarView: UIView!
    @IBOutlet weak var dealTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var dropDownTextField: UITextField!
    
    var dealSharedWithMeList = [DealSharedData]()
    var dealSharedByMeList = [DealSharedData]()
    var dealSharedObj : DealSharedData?
    var dealData = [Deal_data]()
    var isSharedDeal : Bool?
    var isShowDescription : Bool = true
    var isSharedDealWithMeTapped : Bool = false
    var isSharedDealByMeTapped : Bool = false
    var dropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if Connectivity.isConnectedToInternet(){
            getSharedDealCategories(sortedBy: "all")
        }else{
            PopupHelper.showToast(message: "No internet Connection")
        }
        
        dealTableView.refreshControl = UIRefreshControl()
        dealTableView.refreshControl?.tintColor = UIColor.white
        dealTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        
//        if isDealRoomTapped ?? false {
//            //backButton.isHidden = false
//
//        }else{
//            //backButton.isHidden = true
//
//            
//        }
    }
    
    
    func setupDropDown(button:UIButton) {
        
        dropDown.anchorView = button
        dropDown.width =  150
        dropDown.textColor = .white
        dropDown.backgroundColor = UIColor(hex: "#181818")
        dropDown.direction = .bottom
        dropDown.setupCornerRadius(8)
        
        dropDown.bottomOffset = CGPoint(x: 30, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: -120, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = ["Size","Color","Deal Name","Close Date","Updated Date","Person Name"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dropDownTextField.text = item
            if item == "Size"{
                getSharedDealCategories(sortedBy: "size")
            }else if item == "Deal Name"{
                getSharedDealCategories(sortedBy: "deal_name")
            }else if item == "Person Name"{
                getSharedDealCategories(sortedBy: "person_name")
            }else if item == "Close Date"{
                getSharedDealCategories(sortedBy: "closed_date")
            }else if item == "Updated Date"{
                getSharedDealCategories(sortedBy: "updated_date")
            }else if item == "Color"{
                getSharedDealCategories(sortedBy: "color")
            }
           // getSharedDealCategories(sortedBy: item)
        }
//        if isActiveTapped {
//            dropDown.dataSource = ["Won","Lost"]
//            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//                print("Selected item: \(item) at index: \(index)")
//                updateDealStatus(deal_ID: self.dealID ?? 0, deal_status: item)
//
//            }
//        }else if isWonTapped {
//            dropDown.dataSource = ["Lost","Active"]
//            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//                print("Selected item: \(item) at index: \(index)")
//                updateDealStatus(deal_ID: self.dealID ?? 0, deal_status: item)
//
//            }
//        }else {
//            dropDown.dataSource = ["Won","Active"]
//            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//                print("Selected item: \(item) at index: \(index)")
//                updateDealStatus(deal_ID: self.dealID ?? 0, deal_status: item)
//
//            }
//        }
      }
    @objc func refreshData(_ sender: Any) {
        DispatchQueue.main.async {
            self.getSharedDealCategories1(sortedBy: "all")
            self.dealTableView.refreshControl?.endRefreshing()
        }
    }
    @IBAction func sharedWithMeButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        sharedWithMeBarView.backgroundColor = .red
        sharedByMeBarView.backgroundColor = .clear
        isSharedDealWithMeTapped = true
        isSharedDealByMeTapped = false
        getSharedDealCategories(sortedBy: "all")
    }
    
    
    @IBAction func sharedByMeButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        sharedWithMeBarView.backgroundColor = .clear
        sharedByMeBarView.backgroundColor = .red
        isSharedDealWithMeTapped = false
        isSharedDealByMeTapped = true
        getSharedDealCategories(sortedBy: "all")
    }
    
    @IBAction func dropDownButtonTapped (_ sender: UIButton) {
        setupDropDown(button: sender)
        self.dropDown.objc_show()
        
    }
    func getSharedDealCategories(sortedBy: String?) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
       
        var urlString : String?
        if isSharedDealWithMeTapped {
            urlString = "\(URLPath.deals_shared_with_me)/\(sortedBy ?? "")"
        }else {
            urlString = "\(URLPath.deals_shared_by_me)/\(sortedBy ?? "")"
        }
        DispatchQueue.main.async {
            PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        }
        Alamofire.request(urlString!, method: .get, parameters: nil, encoding:  URLEncoding.queryString, headers: header).responseJSON {
            response in
            DispatchQueue.main.async {
                PopupHelper.ActivityIndicator.shared.removeSpinner()
            }
            
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealQuestionResp = try decoder.decode(DealSharedResponse.self, from: json!)
                    if self.isSharedDealWithMeTapped {
                        self.dealSharedWithMeList = dealQuestionResp.data ?? []
                        print( self.dealSharedWithMeList)
                    }else {
                        self.dealSharedByMeList = dealQuestionResp.data ?? []
                        print(self.dealSharedByMeList)
                    }
                    DispatchQueue.main.async {
                        self.dealTableView.reloadData()
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
                print(error.localizedDescription)
                
                
                
            }
        }
        
    }
    
    
    
    func getSharedDealCategories1(sortedBy: String?) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        var urlString : String?
        if isSharedDealWithMeTapped {
            urlString = "\(URLPath.deals_shared_with_me)/\(sortedBy ?? "")"
        }else {
            urlString = "\(URLPath.deals_shared_by_me)/\(sortedBy ?? "")"
        }
       
        Alamofire.request(urlString!, method: .get, parameters: nil, encoding:  URLEncoding.queryString, headers: header).responseJSON {
            response in
           
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealQuestionResp = try decoder.decode(DealSharedResponse.self, from: json!)
                    if self.isSharedDealWithMeTapped {
                        self.dealSharedWithMeList = dealQuestionResp.data ?? []
                        print( self.dealSharedWithMeList)
                    }else {
                        self.dealSharedByMeList = dealQuestionResp.data ?? []
                        print(self.dealSharedByMeList)
                    }
                    DispatchQueue.main.async {
                        self.dealTableView.reloadData()
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
                print(error.localizedDescription)
                
                
                
            }
        }
        
    }
    
    func deleteSharedDeal(deal_ID: Int,userID : Int?) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        
        var urlString : String?
        if isSharedDealWithMeTapped {
            urlString = "\(URLPath.delete_deals_shared_with_me)/\(deal_ID)" // sirf deal id
        }else {
            urlString = "\(URLPath.delete_deals_shared_by_me)/\(deal_ID)/\(userID ?? 0)" //  deal id or jis k sath share ki ha uski userid
        }
        Alamofire.request(urlString!, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
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
    
    
    
    @IBAction func backButtonTapped (_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func addCommentButtonTapped (_ sender: UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
//        vc.dealID = dealSharedObj?.deal?.id
//         self.present(vc, animated: true, completion: nil)
//    }

}
extension DealRoomVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSharedDealWithMeTapped{
            return dealSharedWithMeList.count
        }else{
            return dealSharedByMeList.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareDealTableViewCell", for: indexPath) as! ShareDealTableViewCell
        if isSharedDealWithMeTapped{
            cell.dealNameLabel.text = dealSharedWithMeList[indexPath.row].deal?.deal_name
            
            let dealValue = (dealSharedWithMeList[indexPath.row].deal?.investment_size?.delimiter ?? "")
            cell.invesmentSizeLabel.text = "$\(dealValue )"
            cell.sharedUserLabel.text = "Shared By: \(dealSharedWithMeList[indexPath.row].user?.fullName ?? "NA")"
            
            if  let updatedAt =  dealSharedWithMeList[indexPath.row].deal?.updatedAt?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"), let  closed_date = dealSharedWithMeList[indexPath.row].deal?.closed_date?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"){
                let formattedUpdatedAt  = updatedAt.getFormattedDate(format: "MM/dd/yyyy")
                let formattedclosed_date  = closed_date.getFormattedDate(format: "MM/dd/yyyy")
                print(formattedUpdatedAt,formattedclosed_date)
                cell.closeDateLabel.text = "Close Date : \(formattedclosed_date)"
                cell.updateDateLabel.text = "Last Updated : \(formattedUpdatedAt)"
            }
            cell.addCommentButton.tag = indexPath.row
            if dealSharedWithMeList[indexPath.row].unread ?? 0 > 0 {
                cell.unreadCommentView.isHidden = false
                cell.unreadCountLabel.text = "\(dealSharedWithMeList[indexPath.row].unread ?? 0)"
            }else{
                cell.unreadCommentView.isHidden = true
            }
           
            cell.addCommentButton.addTarget(self, action: #selector(didTapAddCommentButton), for: .touchUpInside)
            if let hexaColor = dealSharedWithMeList[indexPath.row].deal?.color {
                cell.mainView.backgroundColor = UIColor(hex: hexaColor).withAlphaComponent(0.3)
            }else {
                cell.mainView.backgroundColor = UIColor(hex: "#181818")
            }
            
//            cell.descriptionLabel.text = dealSharedWithMeList[indexPath.row].description
//            if dealSharedWithMeList[indexPath.row].isExpanded {
//                cell.buttonLabel.text = "Hide Description"
//                cell.descriptionLabel.isHidden = false
//
//            }else {
//                cell.buttonLabel.text = "Show Description"
//                cell.descriptionLabel.isHidden = true
//
//            }
//
//            cell.showDescriptionButton.tag = indexPath.row
//            cell.showDescriptionButton.addTarget(self, action: #selector(didShowDescriptionButtonTapped), for: .touchUpInside)
        }else {
            cell.dealNameLabel.text = dealSharedByMeList[indexPath.row].deal?.deal_name
            let dealValue = (dealSharedByMeList[indexPath.row].deal?.investment_size?.delimiter ?? "")
            cell.invesmentSizeLabel.text = "$\(dealValue )"
            cell.sharedUserLabel.text = "Shared with: \(dealSharedByMeList[indexPath.row].shared_user?.fullName ?? "NA")"
            if  let updatedAt =  dealSharedByMeList[indexPath.row].deal?.updatedAt?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"), let  closed_date = dealSharedByMeList[indexPath.row].deal?.closed_date?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"){
                let formattedUpdatedAt  = updatedAt.getFormattedDate(format: "MM/dd/yyyy")
                let formattedclosed_date  = closed_date.getFormattedDate(format: "MM/dd/yyyy")
                print(formattedUpdatedAt,formattedclosed_date)
                cell.closeDateLabel.text = "Close Date : \(formattedclosed_date)"
                cell.updateDateLabel.text = "Last Updated : \(formattedUpdatedAt)"
            }
            cell.addCommentButton.tag = indexPath.row
            if dealSharedByMeList[indexPath.row].unread ?? 0 > 0 {
                cell.unreadCommentView.isHidden = false
                cell.unreadCountLabel.text = "\(dealSharedByMeList[indexPath.row].unread ?? 0)"
            }else{
                cell.unreadCommentView.isHidden = true
            }
            cell.addCommentButton.addTarget(self, action: #selector(didTapAddCommentButton), for: .touchUpInside)
           
        
            if let hexaColor = dealSharedByMeList[indexPath.row].deal?.color {
                cell.mainView.backgroundColor = UIColor(hex: hexaColor).withAlphaComponent(0.3)
            }else {
                cell.mainView.backgroundColor = UIColor(hex: "#181818")
            }
            
            
//            cell.descriptionLabel.text = dealSharedByMeList[indexPath.row].description
//            if dealSharedByMeList[indexPath.row].isExpanded {
//                cell.buttonLabel.text = "Hide Description"
//                cell.descriptionLabel.isHidden = false
//
//            }else {
//                cell.buttonLabel.text = "Show Description"
//                cell.descriptionLabel.isHidden = true
//
//            }
//
//            cell.showDescriptionButton.tag = indexPath.row
//            cell.showDescriptionButton.addTarget(self, action: #selector(didShowDescriptionButtonTapped), for: .touchUpInside)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnFinishedDealVC") as! UnFinishedDealVC
        if isSharedDealWithMeTapped {
            print(dealSharedWithMeList[indexPath.row])
            vc.dealID = dealSharedWithMeList[indexPath.row].dealId
            vc.dealColor = dealSharedWithMeList[indexPath.row].deal?.color
            vc.sharedDealName =  dealSharedWithMeList[indexPath.row].deal?.deal_name
            vc.sharedBYMe = dealSharedWithMeList[indexPath.row].user?.fullName
            vc.sharedWithMe = dealSharedWithMeList[indexPath.row].shared_user?.fullName
            vc.sharedDealID = dealSharedWithMeList[indexPath.row].deal?.id
            vc.dealDescription = dealSharedWithMeList[indexPath.row].description
            vc.sharedDealInvesmentSize = dealSharedWithMeList[indexPath.row].deal?.investment_size
            vc.sharedDealCloseDate = dealSharedWithMeList[indexPath.row].deal?.closed_date
            vc.sharedDealUpdatedDate = dealSharedWithMeList[indexPath.row].deal?.updatedAt
            vc.isSharedDealWithMeTapped = isSharedDealWithMeTapped
            vc.isSharedDeal = true
            vc.isSavedDeal = false
            
        }else {
            print(dealSharedByMeList[indexPath.row])
            vc.dealID = dealSharedByMeList[indexPath.row].dealId
            vc.dealColor = dealSharedByMeList[indexPath.row].deal?.color
            vc.sharedDealName =  dealSharedByMeList[indexPath.row].deal?.deal_name
            vc.sharedBYMe = dealSharedByMeList[indexPath.row].user?.fullName
            vc.sharedWithMe = dealSharedByMeList[indexPath.row].shared_user?.fullName
            vc.sharedDealID = dealSharedByMeList[indexPath.row].deal?.id
            vc.dealDescription = dealSharedByMeList[indexPath.row].description
            vc.sharedDealInvesmentSize = dealSharedByMeList[indexPath.row].deal?.investment_size
            vc.sharedDealCloseDate = dealSharedByMeList[indexPath.row].deal?.closed_date
            vc.sharedDealUpdatedDate = dealSharedByMeList[indexPath.row].deal?.updatedAt
            vc.isSharedDealWithMeTapped = isSharedDealWithMeTapped
            vc.isSharedDeal = true
            vc.isSavedDeal = false
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        return 140
    }
    
       func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
           if isSharedDealWithMeTapped {
                   let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
                       let sourceItem = self.dealSharedWithMeList[indexPath.row]
                       self.deleteSharedDeal(deal_ID : sourceItem.deal?.id ?? 0, userID: nil)
                       self.dealSharedWithMeList.remove(at: indexPath.row)
                       self.dealTableView.deleteRows(at: [indexPath], with: .fade)
                   }
                   delete.backgroundColor = UIColor.red
                   return [delete]
               
           }else {
               let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
                   let sourceItem = self.dealSharedByMeList[indexPath.row]
                   self.deleteSharedDeal(deal_ID : sourceItem.deal?.id ?? 0, userID: sourceItem.user?.id)
                   self.dealSharedByMeList.remove(at: indexPath.row)
                   self.dealTableView.deleteRows(at: [indexPath], with: .fade)
               }
               delete.backgroundColor = UIColor.red
               return [delete]
           }
       }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    
    @objc
    func didTapAddCommentButton(_ sender: UIButton) {
        let index = sender.tag
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        if isSharedDealWithMeTapped {
            vc.dealID = dealSharedWithMeList[index].deal?.id
            vc.dealDescription = dealSharedWithMeList[index].description
            vc.initCommentBy_Name = dealSharedWithMeList[index].user?.fullName
        }
        
        else{
            if isSharedDealWithMeTapped {
                vc.dealID = dealSharedWithMeList[index].deal?.id
                vc.dealDescription = dealSharedWithMeList[index].description
                vc.initCommentBy_Name = dealSharedWithMeList[index].user?.fullName
            }
            else {
                vc.dealID = dealSharedByMeList[index].deal?.id
                vc.dealDescription = dealSharedByMeList[index].description
                vc.initCommentBy_Name = dealSharedByMeList[index].user?.fullName
            }
        }
//        else {
//            vc.dealID = dealSharedByMeList[index].deal?.id
//            vc.dealDescription = dealSharedByMeList[index].description
//            vc.initCommentBy_Name = dealSharedByMeList[index].shared_user?.fullName
//        vc.dealID = dealSharedByMeList[index].deal?.id
//        vc.dealDescription = dealSharedByMeList[index].description
//        vc.initCommentBy_Name = dealSharedByMeList[index].user?.fullName
//        }
        self.present(vc, animated: true, completion: nil)
    }
    
}
    
//    @objc func didShowDescriptionButtonTapped(_ sender: UIButton) {
//        if isSharedDealWithMeTapped {
//            let index = sender.tag
//            let cell = dealTableView.cellForRow(at: IndexPath(item: index, section: 0)) as? ShareDealTableViewCell
//            if dealSharedWithMeList[index].isExpanded {
//                cell?.buttonLabel.text = "Hide Description"
//                cell?.descriptionLabel.isHidden = false
//
//            }else {
//                cell?.buttonLabel.text = "Show Description"
//                cell?.descriptionLabel.isHidden = true
//
//            }
//            dealSharedWithMeList[index].isExpanded.toggle()
//        }else {
//            let index = sender.tag
//            let cell = dealTableView.cellForRow(at: IndexPath(item: index, section: 0)) as? ShareDealTableViewCell
//            if dealSharedByMeList[index].isExpanded {
//                cell?.buttonLabel.text = "Hide Description"
//                cell?.descriptionLabel.isHidden = false
//
//            }else {
//                cell?.buttonLabel.text = "Show Description"
//                cell?.descriptionLabel.isHidden = true
//
//            }
//            dealSharedByMeList[index].isExpanded.toggle()
//        }
//        DispatchQueue.main.async {
//            self.dealTableView.reloadData()
//        }
//
//    }
  
