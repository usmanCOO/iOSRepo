//
//  DealMenuVC.swift
//  Meddpicc App
//
//  Created by Asad Khan on 9/1/22.
//

import UIKit
import Alamofire
class DealMenuVC: UIViewController {

    @IBOutlet weak var dealTableView: UITableView!
    @IBOutlet weak var dealNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var dealName: String?
    var dealID: Int?
    var dealList = [DealCategoryModel]()
    var dealData = [Deal_data]()
    var newdealData = [Deal_data]()
    var dealCategoryList = [DealQuestionResponseData]()
    var isNewCreatedDeal: Bool? = false
    override func viewDidLoad() {
        super.viewDidLoad()
        dealNameLabel.text = dealName
        getDealQuestionResponseV2(dealID: dealID ?? 0)
        getAllDeals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameLabel.text = "Hey \(DealDocSessionManager.shared.getUser()?.fullName ?? "")"
    }
    
    @IBAction func dealButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DealQuestionaireVC") as! DealQuestionaireVC
        vc.dealName = dealName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backButtonTapped (_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getDealQuestionResponseV2(dealID: Int) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let url = "\(URLPath.getAllDeals)/\(dealID)/responsev2"
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
                
            case .success:
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealQuestionResp = try decoder.decode(GetDealQuestionResponseV2.self, from: json!)
                    self.dealCategoryList = dealQuestionResp.data?.filter({$0.is_delete == false}) ?? []
                    DispatchQueue.main.async {
                        self.dealTableView.reloadData()
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
    
    
    
    func getAllDeals() {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        Alamofire.request(URLPath.getAllDeals, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            self.stopAnimating()
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealResp = try decoder.decode(DealResponse.self, from: json!)
                    self.dealData = dealResp.deal_data ?? []
                    self.newdealData = self.dealData.filter({$0.id == self.dealID })
                    print(self.newdealData)
                    
                    
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
extension DealMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealCategoryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealMenuTableViewCell", for: indexPath) as! DealMenuTableViewCell
        cell.dealNameLabel.text = dealCategoryList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DealQuestionaireVC") as! DealQuestionaireVC
        vc.selectedDealCategory  = dealCategoryList[indexPath.row]
        vc.selected_deal = newdealData.first
        vc.dealID = dealID ?? 0
        vc.isNewCreatedDeal = true
        vc.dealName = self.dealName
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
