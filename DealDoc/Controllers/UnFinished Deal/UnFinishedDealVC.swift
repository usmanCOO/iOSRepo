//
//  UnFinishedDealVC.swift
//  DealDoc
//
//  Created by Asad Khan on 9/28/22.
//

import UIKit
import Alamofire
//import iOSDropDown

struct AnswerModel {
    var yes : Int?
    var no : Int?
    var none : Int?
}

class UnFinishedDealVC: UIViewController, UITextViewDelegate, updateDealData {
    
    var Checkflag: Bool = false
    var isComplete : Int = 0
    var dealData = [Deal_data]()
    var dealName: String?
    var selected_deal: Deal_data?
    var dealCategoryList = [DealQuestionResponseData]()
    var getDealResponse : GetDealQuestionResponse?
    var emptyFilteredQuestions = [DealQuestionResponseData]()
    var emptyQuestion = [Questions]()
    var subscriptionData = GetSubscriptionResponse()
    var dealID : Int?
    var isLastUnfilledCategory: Bool = false
    var isSavedDeal: Bool = false
    var isNotSavedDeal: Bool = false
    var isNextButtonSelected: Bool = false
    var isAllCategoryFinished: Bool = false
    var isUnFinishedTapped: Bool?
    var redCount: Int  = 0
    var orangeCount: Int  = 0
    var yellowCount: Int = 0
    var lightGreenCount: Int = 0
    var greenCount: Int = 0
    var hexaColor: String?
    var unFinishedDealObj : Deal_data?
    var isYourScreen: Bool?
    var isUpdatedDealScreen: Bool?
    var dealColor: String?
    var isSharedButtonTapped: Bool?
    var isSubmitDealForReviewApi: Bool?
    var editAbleText: String?
    var isSharedDealWithMeTapped : Bool?
    var isSharedDeal : Bool?
    var sharedBYMe: String?
    var sharedWithMe: String?
    var sharedDealID : Int?
    var sharedDealInvesmentSize : Int?
    var sharedDealCloseDate : String?
    var sharedDealUpdatedDate : String?
    var sharedDealName : String?
    var dealDescription: String?
    var isbackButtonTapped: Bool?
    var isFromQuestionScreenTapped: Bool?
    @IBOutlet weak var dealNameLabel: UILabel!
    @IBOutlet weak var dealTitleLabel: UILabel!
    @IBOutlet weak var dealTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var saveDealButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var goToCoachingScreenButton: UIButton!
    @IBOutlet weak var submitDealForReviewButton: UIButton!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet var dealCompletedLabel: UILabel!
    @IBOutlet var dealCompletedView: UIView!
    @IBOutlet var dealEditButton: UIButton!
    @IBOutlet var dealCommentButton: UIButton!
    
    let isSubscribed = UserDefaults.standard.bool(forKey: "isSubscribed")
    let checkID = UserDefaults.standard.integer(forKey: "id")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        if dealID == checkID {
        //
        //        }
        
        print(checkID)
        
        //        if isComplete >= 1 && isSubscribed == false {
        //            getSubscriptionData()
        //        }
        //        else {
        //            // DO CREATE FREE DEAL
        //        }
        
        //        if  isSharedDeal ?? false {
        //            buttonStack.isHidden = true
        //        }else  {
        //            buttonStack.isHidden = false
        //        }
        
        
        if isSavedDeal {
            if self.dealColor == nil {
                DispatchQueue.main.async {
                    self.dealCompletedView.backgroundColor = UIColor(hex: "#181818")
                }
            }else {
                DispatchQueue.main.async {
                    self.dealCompletedView.backgroundColor = UIColor(hex: "\(self.dealColor ?? "")").withAlphaComponent(0.3)
                }
            }
            self.buttonStack.isHidden = false
        }else {
            
            if  isSharedDeal ?? false {
                buttonStack.isHidden = true
                dealCommentButton.isHidden = false
            }else  {
                buttonStack.isHidden = false
                dealCommentButton.isHidden = true
            }
            if self.dealColor == nil {
                DispatchQueue.main.async {
                    self.dealCompletedView.backgroundColor = UIColor(hex: "#181818")
                }
            }else {
                DispatchQueue.main.async {
                    self.dealCompletedView.backgroundColor = UIColor(hex: "\(self.dealColor ?? "")").withAlphaComponent(0.3)
                }
            }
            self.buttonStack.isHidden = true
            
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        userNameLabel.text = "Hey \(DealDocSessionManager.shared.getUser()?.fullName ?? "")"
        setUpView()
        
        
        
        
        if isFromQuestionScreenTapped ?? false{
            self.dealNameLabel.text = self.dealName
        }else if isYourScreen ?? false {
            DispatchQueue.main.async {
                self.dealNameLabel.text = self.selected_deal?.deal_name ?? ""
            }
        } else if isSharedDealWithMeTapped ?? false || !(isSharedDealWithMeTapped ?? false) {
            DispatchQueue.main.async {
                self.dealNameLabel.text = self.sharedDealName
            }
        }else {
            self.updateDealNameData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.countQuestionPercentage()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.checkDealStatus()
        }
        
    }
    
    func setUpView() {
        if editAbleText == "Active" || editAbleText == nil {
            dealEditButton.isEnabled = true
        }else {
            dealEditButton.isEnabled = false
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CoachingMaterialVC") as! CoachingMaterialVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.isUnFinishedTapped = true
        vc.dealID = self.dealID
        vc.dealName = self.dealName
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
    
    func countQuestionPercentage() {
        DispatchQueue.main.async {
            PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        }
        getDealQuestionResponseV2(dealID: dealID ?? 0) { [weak self] error,data  in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                PopupHelper.ActivityIndicator.shared.removeSpinner()
            }
            guard  error == nil else {
                PopupHelper.showAlertControllerWithError(forErrorMessage: error?.localizedDescription ?? "unknown Error" , forViewController: self)
                return
            }
            self.dealCategoryList = data?.data ?? []
            self.dealCategoryList = self.dealCategoryList.filter({$0.is_delete == false})
            self.updateDealCategoryList()
            DispatchQueue.main.async {
                self.dealTableView.reloadData()
            }
        }
    }
    
    @IBAction func commentButtonTapped (_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        vc.dealID = self.sharedDealID
        vc.dealDescription = dealDescription
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func updateDealButtonTapped (_ sender: UIButton) {
        if isSharedDeal ?? false {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SharedDealAnalysisVC") as! SharedDealAnalysisVC
            vc.deal_Name = sharedDealName ?? ""
            vc.deal_Value = sharedDealInvesmentSize
            vc.closeDate = sharedDealCloseDate
            vc.updatedDate = sharedDealUpdatedDate
            vc.sharedBYMe = self.sharedBYMe
            vc.sharedWithMe = self.sharedWithMe
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateDealVC") as! UpdateDealVC
            vc.delegate = self
            vc.deal_Name = selected_deal?.deal_name ?? ""
            vc.deal_ID = selected_deal?.id ?? 0
            vc.deal_Value = selected_deal?.investment_size
            vc.closeDate = selected_deal?.closed_date
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func updateDealNameData() {
        getDealByID()
    }
    
    @IBAction func backButtonTapped (_ sender: UIButton) {
        
        isbackButtonTapped = true
        //        isSharedButtonTapped == true
        setfinalcolor()
        
        submitDealForReview()
        //        if i {
        //
        //        }
        //        else
        //        {
        //            let vc = UnFinishedDealVC()
        //            navigationController?.popToViewController(vc, animated: true)
        //            //navigationController?.popViewController(animated: true)
        //        }
        
    }
    @IBAction func shareButtonTapped (_ sender: UIButton) {
        isSharedButtonTapped = true
        submitDealForReview()
    }
    
    @IBAction func goToCoachingButtonTapped (_ sender: UIButton) {
        isSharedButtonTapped = false
        submitDealForReview()
    }
    
    @IBAction func submitDealForReviewButton(_ sender: UIButton) {
        sender.zoomInWithEasing()
        submitDealForReview()
    }
    
    
    
    func getDealByID() {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let url = "\(URLPath.getAllDeals)/\(dealID ?? 0)"
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealResp = try decoder.decode(DealResponse.self, from: json!)
                    self.selected_deal = dealResp.deal_data?.first
                    DispatchQueue.main.async {
                        self.dealNameLabel.text =  self.selected_deal?.deal_name ?? ""
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
    
    
    func checkDealStatus() {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let url = "\(URLPath.getAllDeals)/\(dealID ?? 0)"
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealResp = try decoder.decode(DealResponse.self, from: json!)
                    self.selected_deal = dealResp.deal_data?.first
                    if self.selected_deal?.is_draft == true {
                        self.isSubmitDealForReviewApi = true
                    }else {
                        self.isSubmitDealForReviewApi = false
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
    
    func submitDealForReview() {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        var bodyParameter:[String:Any] = [:]
        if hexaColor == "" || hexaColor == nil  {
            bodyParameter = ["dealId": dealID ?? 0 ,"color": dealColor ?? ""]
        }else {
            bodyParameter = ["dealId": dealID ?? 0 ,"color": hexaColor ?? ""]
        }
        print(bodyParameter)
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request(URLPath.submitDealForReview, method: .post, parameters: bodyParameter , encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
                
            case .success:
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealResponse = try decoder.decode(SaveDealResponse.self, from: json!)
                    
                    if dealResponse.status == false {
                        PopupHelper.showToast(message:  "Something wrong")
                    }
                    else {
                        if self.isbackButtonTapped ?? false{
                            self.navigationController?.popViewController(animated: true)
                        }
                        else if self.isSharedButtonTapped ?? false {
                            self.goToCoachingScreenButton.isHidden = false
                            //self.buttonStack.isHidden = false
                            PopupHelper.showToast(message:  "Submitted Deal For Review Successfully")
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShareDealVC") as! ShareDealVC
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.modalTransitionStyle = .crossDissolve
                            vc.dealID = self.dealID
                            self.present(vc, animated: true, completion: nil)
                        }
                        else if self.isSharedButtonTapped ?? false == false {
                            // self.buttonStack.isHidden = true
                            // self.buttonStack.isHidden = false
                            PopupHelper.showToast(message:  "Submitted Deal For Review Successfully")
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CoachingMaterialVC") as! CoachingMaterialVC
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.modalTransitionStyle = .crossDissolve
                            vc.unFinishedDealObj = self.unFinishedDealObj
                            vc.isUnFinishedTapped = true
                            vc.dealID = self.dealID
                            vc.dealName = self.dealName
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    print(json ?? "Error")
                }
                catch(let error){
                    print("JSON Error \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
    }
    
    
    
    func getDealQuestionResponseV2(dealID: Int,completion:@escaping (_ error: Error?, _ getDeal: GetDealQuestionResponseV2?) -> ()) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let url = "\(URLPath.getAllDeals)/\(dealID)/responsev2"
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            switch response.result {
                
            case .success:
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealQuestionResp = try decoder.decode(GetDealQuestionResponseV2.self, from: json!)
                    self.emptyFilteredQuestions = dealQuestionResp.data?.filter({$0.questions?.contains(where: {$0.questionResponses?.isEmpty ?? false}) ?? false }) ?? []
                    //                    for (index,_) in dealQuestionResp.data?.enumerated(){
                    //                        emptyQuestion = dealQuestionResp.data[index].questions
                    //                    }
                    //                    print(emptyQuestion)
                    print(self.emptyFilteredQuestions)
                    print(self.emptyFilteredQuestions.count)
                    //                    emptyFilteredQuestions = dealQuestionResp.data?.filter({$0.questions?.contains(where: {$0.questionResponses?.first(where: {$0.response != "0" && $0.response != "1"})})}) ?? []
                    completion(nil, dealQuestionResp)
                    
                }
                catch(let error){
                    print(error.localizedDescription)
                    completion(error, nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(error, nil)
                
            }
        }
    }
    
}
extension UnFinishedDealVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealMenuTableViewCell", for: indexPath) as! DealMenuTableViewCell
        cell.dealNameLabel.text = dealCategoryList[indexPath.row].name
        if let hexaColor = dealCategoryList[indexPath.row].dealHexColor {
            cell.mainView.backgroundColor = UIColor(hex: hexaColor).withAlphaComponent(0.3)
            print(hexaColor)
            cell.dealColorImage.image =  #imageLiteral(resourceName: "Group 34222")
            let color = UIColor(hexString: hexaColor)
            cell.tickImage.image =  #imageLiteral(resourceName: "tick")
            cell.dealColorImage.setImageColor(color: color)
        }else {
            cell.mainView.backgroundColor = UIColor(hex: "#181818")
            cell.dealColorImage.image =  UIImage()
            cell.tickImage.image = UIImage()
            cell.dealColorImage.setImageColor(color: .clear)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        greenCount = 0; yellowCount = 0; redCount = 0; lightGreenCount = 0; orangeCount = 0
        self.goToNextScreen(selectedCategory: self.dealCategoryList[indexPath.row])
    }
    
    func goToNextScreen(selectedCategory: DealQuestionResponseData)  {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DealQuestionaireVC") as! DealQuestionaireVC
        let categoryQuestions = selectedCategory.questions ?? []
        vc.selectedDealCategory = selectedCategory
        vc.editAbleText = self.editAbleText
        vc.dealID = dealID
        vc.isLastUnfilledCategory = self.isLastUnfilledCategory
        vc.isSharedDeal = self.isSharedDeal ?? false
        vc.isSavedDeal = self.isSavedDeal
        vc.isNotSavedDeal = self.isNotSavedDeal
        vc.selected_deal = self.selected_deal
        vc.isAllCategoryFinished = self.isAllCategoryFinished
        vc.dealName = self.dealName
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension UnFinishedDealVC {
    
    public func calculatePercentage(value:Double,totalVal:Double)->Double {
        let percent =  value / totalVal * 100
        return percent
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
    
    func showSubscriptionScreen(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func updateDealCategoryList() {
        
        var filledColorCount: Int = 0
        for index in 0..<dealCategoryList.count {
            
            let totalQuestionsCount = dealCategoryList[index].questions?.count ?? 0
            let yesCount = dealCategoryList[index].questions?.filter({$0.questionResponses?.first?.response == "1"}).count ?? 0
            let noCount = dealCategoryList[index].questions?.filter({$0.questionResponses?.first?.response == "0"}).count ?? 0
            var isCategoryAllQuestionFilled: Bool = false
            if totalQuestionsCount == yesCount + noCount {
                isCategoryAllQuestionFilled = true
            }else {
                isCategoryAllQuestionFilled = false
            }
            var yesPercent = self.calculatePercentage(value: Double(yesCount ), totalVal: Double(totalQuestionsCount))
            var noPercent = self.calculatePercentage(value: Double(noCount ), totalVal: Double(totalQuestionsCount))
            print("Yes Percent \(yesPercent.roundToPlaces(places: 2)) No Percent \(noPercent.roundToPlaces(places: 2))")
            //            <40% Red
            //            40 - 60% Orange
            //            60 - 85% Yellow
            //            85% - 95% Light Green
            //            95 - 100% Green
            if totalQuestionsCount > 0 && isCategoryAllQuestionFilled  {
                if yesPercent < 40.0 {
                    let hexaColor = "#FF0000"
                    self.dealCategoryList[index].dealHexColor = hexaColor
                    self.dealCategoryList[index].isFinished = true
                    redCount += 1
                }else if yesPercent >= 40.0 && yesPercent <= 60.0 {
                    let hexaColor = "#FFA500"
                    self.dealCategoryList[index].dealHexColor = hexaColor
                    self.dealCategoryList[index].isFinished = true
                    orangeCount += 1
                }else if yesPercent >= 60.0 && yesPercent <= 85.0 {
                    let hexaColor = "#FFFF00"
                    self.dealCategoryList[index].dealHexColor = hexaColor
                    self.dealCategoryList[index].isFinished = true
                    yellowCount += 1
                }else if yesPercent >= 85.0 && yesPercent <= 95.0 {
                    let hexaColor = "#91EE92"
                    self.dealCategoryList[index].dealHexColor = hexaColor
                    self.dealCategoryList[index].isFinished = true
                    lightGreenCount += 1
                }else if yesPercent >= 95.0 && yesPercent <= 100.0 {
                    let hexaColor = "#00FF00"
                    self.dealCategoryList[index].dealHexColor = hexaColor
                    self.dealCategoryList[index].isFinished = true
                    greenCount += 1
                }
            }else {
                self.dealCategoryList[index].dealHexColor = nil
                self.dealCategoryList[index].isFinished = false
            }
        }
        
        
        let questionFilledCount = self.dealCategoryList.filter({$0.questions?.contains(where: {$0.isAnsweredType != .none}) ?? false}).count
        
        let isCompleteCount = self.dealData.filter({$0.is_draft == true}).count
        
        //        if questionFilledCount == 6 && isSubscribed == false {
        //            print("call subscription")
        //            self.getSubscriptionData()
        //        }else {
        //            print("Already Subscribe")
        //        }
        
        
        
        //        if isComplete == 0 {
        //            // DO CREATE FREE DEAL
        //        }
        //        else if isComplete >= 1 {
        //
        //
        //        }
        //        else {
        //            print("***8888****")
        //        }
        
        
        
        let catCount = self.dealCategoryList.filter({$0.isFinished == true}).count
        
        //        if catCount == 6 && isSubscribed == false{
        //            self.getSubscriptionData()
        //        } else{
        if catCount == self.dealCategoryList.count {
            if isSavedDeal {
                self.buttonStack.isHidden = false
                //setColorForDeal()
                ////setDealColor()
                
                setfinalcolor()
                
            }else {
                isAllCategoryFinished = true
                if  isSharedDeal ?? false {
                    buttonStack.isHidden = true
                    dealCommentButton.isHidden = false
                }else  {
                    buttonStack.isHidden = false
                    dealCommentButton.isHidden = true
                }
                // self.buttonStack.isHidden = false
                //setColorForDeal()
                ////setDealColor()
                ///
                setfinalcolor()
            }
        }
        else {
            // self.buttonStack.isHidden = true
        }
    }
   
    func setfinalcolor()
    {
        //MARK: If Red is Greater
        if redCount > greenCount && redCount > lightGreenCount && redCount > yellowCount && redCount > orangeCount
        {
            print("red is dominant")
            hexaColor = "#FF0000"
        }
        //MARK: If Green is Greater
        else if greenCount > redCount && greenCount > yellowCount && greenCount > lightGreenCount && greenCount > orangeCount
        {
            
            if greenCount == 5 && redCount == 2 || greenCount == 5 && redCount == 3 || greenCount == 6 && redCount == 2 || greenCount == 7 && redCount == 1 || greenCount == 6 && redCount == 1 || greenCount == 4 && redCount == 2 || greenCount == 3 && redCount == 2 || greenCount == 5 && redCount == 1 || greenCount == 4 && redCount == 3 || greenCount == 3 && redCount == 1 {
                print("yellow is dominant")
                hexaColor = "#FFFF00"
            }
            else if greenCount == 6 && yellowCount == 2 || greenCount == 7 && yellowCount == 1 || greenCount == 5 && yellowCount == 3 || greenCount == 5 && yellowCount == 1 || greenCount == 5 && yellowCount == 2
            {
                print("Light is dominant")
                hexaColor = "#91EE92"
            }
            else {
                print("Green is dominant")
                hexaColor = "#00FF00"
            }
        }
        //MARK: If Yellow is Greater
        else if yellowCount > redCount && yellowCount > greenCount && yellowCount > lightGreenCount && yellowCount > orangeCount
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        //MARK: If lightGreen is Greater
        else if lightGreenCount > redCount && lightGreenCount > greenCount && lightGreenCount > yellowCount && lightGreenCount > orangeCount
        {
            print("Light is dominant")
            hexaColor = "#91EE92"
        }
        //MARK: If Orange is Greater
        else if orangeCount > redCount && orangeCount > greenCount && orangeCount > yellowCount && orangeCount > lightGreenCount
        {
            print("orange is dominant")
            hexaColor = "#FFA500"
            
        }
        //MARK: Equality Comparison
        //MARK: if Red and Green are equal
        else if redCount > lightGreenCount && redCount > yellowCount && redCount > orangeCount && greenCount > yellowCount && greenCount > lightGreenCount && greenCount > orangeCount && redCount == greenCount
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        
        
        //MARK: if Red and yellow are equal
        else if redCount > lightGreenCount && redCount > orangeCount && redCount > greenCount && yellowCount > greenCount && yellowCount > lightGreenCount && yellowCount > orangeCount && redCount == yellowCount
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        
        
        //MARK: if Green and yellow are equal
        else if greenCount > redCount && greenCount > lightGreenCount && greenCount > orangeCount && yellowCount > redCount && yellowCount > lightGreenCount && yellowCount > orangeCount && yellowCount == greenCount
        {
            print("orange is dominant")
            hexaColor = "#FFA500"
        }
        
        //MARK: if green and lightgreen are equal
        else if greenCount > redCount && greenCount > yellowCount && greenCount > orangeCount && lightGreenCount > redCount && lightGreenCount > yellowCount && lightGreenCount > orangeCount && greenCount == lightGreenCount
        {
            print("Light is dominant")
            hexaColor = "#91EE92"
        }
        else if greenCount == 2 && redCount == 2 && yellowCount == 2 && lightGreenCount == 2 && orangeCount == 2
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        else if greenCount == 2 && redCount == 2 && lightGreenCount == 2 && orangeCount == 2
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        else if greenCount == 2 && redCount == 2 && yellowCount == 2 && lightGreenCount == 2
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        else if redCount == 2 && yellowCount == 2 && lightGreenCount == 2 && orangeCount == 2
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        else if greenCount == 2 && redCount == 2 && yellowCount == 2 && orangeCount == 2
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        else if greenCount == 2 && yellowCount == 2 && lightGreenCount == 2 && orangeCount == 2
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        //&&&&&
        else if greenCount == 2 && yellowCount == 2 && lightGreenCount == 1 && orangeCount == 1 && redCount == 1
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        else if greenCount == 2 && yellowCount == 1 && lightGreenCount == 1 && orangeCount == 2 && redCount == 2
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        else if greenCount == 1 && yellowCount == 2 && lightGreenCount == 2 && orangeCount == 1 && redCount == 1
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        else if greenCount == 1 && yellowCount == 1 && lightGreenCount == 2 && orangeCount == 1 && redCount == 2
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        else if greenCount == 1 && yellowCount == 2 && lightGreenCount == 2 && orangeCount == 1 && redCount == 2
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        
        else if lightGreenCount == 3 && greenCount == 3 && yellowCount == 2 || lightGreenCount == 3 && greenCount == 3 && redCount == 2 || lightGreenCount == 3 && greenCount == 3 && yellowCount == 1 && redCount == 1
        {
            print("Light is dominant")
            hexaColor = "#91EE92"
        }
        else if greenCount == 0 && redCount == 0 && lightGreenCount == 0 && yellowCount == 0 && orangeCount == 0
        {
            print("yellow is dominant")
            hexaColor = "#000000"
        }
        else
        {
            print("yellow is dominant")
            hexaColor = "#FFFF00"
        }
        
    }
    
    //    func setDealColor(){
    //
    //            if redCount == greenCount && redCount >= lightGreenCount && greenCount >= lightGreenCount && redCount >= orangeCount && greenCount >= orangeCount && redCount >= yellowCount && greenCount >= yellowCount  {
    //                print("yellow is dominant")
    //                hexaColor = "#FFFF00"
    //            }
    //        else if greenCount == yellowCount && yellowCount > redCount && yellowCount > lightGreenCount && yellowCount > orangeCount{
    //            print("yellow is dominant")
    //            hexaColor = "#FFFF00"
    //        }
    //
    //        else if greenCount >= orangeCount && greenCount >= redCount  && lightGreenCount >= greenCount && lightGreenCount >= orangeCount && lightGreenCount >= redCount && greenCount > yellowCount {
    //            print("Light is dominant")
    //            hexaColor = "#91EE92"
    //            }
    ////
    ////        else if greenCount > yellowCount {
    ////            print("Light is dominant")
    ////            hexaColor = "#90EE90"
    ////        }
    //        //MARK: check for individual Colors
    //        else if greenCount > redCount && greenCount > lightGreenCount && greenCount > orangeCount && greenCount > yellowCount {
    //                print("Green is dominant")
    //                hexaColor = "#00FF00"
    //        }
    //         if redCount > orangeCount && redCount > yellowCount && redCount > lightGreenCount && redCount > greenCount {
    //                print("red is dominant")
    //                hexaColor = "#FF0000"
    //            }
    //        else if orangeCount > redCount && orangeCount > yellowCount && orangeCount > lightGreenCount && orangeCount > greenCount {
    //                print("orange is dominant")
    //                hexaColor = "#FFA500"
    //            }
    //        else if yellowCount > redCount && yellowCount > orangeCount && yellowCount > lightGreenCount && yellowCount > greenCount  {
    //                print("yellow is dominant")
    //                hexaColor = "#FFFF00"
    //            }
    //        else if lightGreenCount > redCount && lightGreenCount > yellowCount && lightGreenCount > orangeCount && lightGreenCount > greenCount  {
    //                print("Light is dominant")
    //                hexaColor = "#91EE92"
    //            }
    //
    //
    //
    //        else if greenCount >= yellowCount && greenCount >= orangeCount && greenCount >= redCount  && lightGreenCount == greenCount {
    //                print("yellow is dominant")
    //                hexaColor = "#FFFF00"
    //            }
    //        else if greenCount >= lightGreenCount && greenCount >= orangeCount && greenCount >= redCount  && yellowCount == greenCount {
    //                print("Green is dominant")
    //                hexaColor = "#00FF00"
    //            }
    //        else if lightGreenCount >= greenCount && lightGreenCount >= orangeCount && lightGreenCount >= redCount  &&  yellowCount == lightGreenCount {
    //                print("Light is dominant")
    //                hexaColor = "#91EE92"
    //            }
    //        else if yellowCount >= greenCount && yellowCount >= lightGreenCount && yellowCount >= redCount  && yellowCount == orangeCount {
    //                print("yellow is dominant")
    //                hexaColor = "#FFFF00"
    //            }
    //        else if greenCount >= lightGreenCount && greenCount >= yellowCount && greenCount >= redCount  && orangeCount == greenCount {
    //                print("Green is dominant")
    //                hexaColor = "#00FF00"
    //            }
    //        else if lightGreenCount >= greenCount && lightGreenCount >= yellowCount && lightGreenCount >= redCount && orangeCount == lightGreenCount {
    //                print("Light is dominant")
    //                hexaColor = "#91EE92"
    //            }
    //        else if greenCount >= lightGreenCount && greenCount >= yellowCount && greenCount >= orangeCount  && greenCount  >= redCount {
    //            print("Light is dominant")
    //            hexaColor = "#91EE92" //90EE90
    //            }
    //
    //        else if lightGreenCount >= greenCount && lightGreenCount >= yellowCount && lightGreenCount >= orangeCount && redCount == lightGreenCount {
    //                print("Light is dominant")
    //                hexaColor = "#91EE92"
    //            }
    //        else if  yellowCount >= greenCount && yellowCount >= lightGreenCount && yellowCount >= orangeCount  && redCount == yellowCount{
    //                print("yellow is dominant")
    //                hexaColor = "#FFFF00"
    //            }
    //        else if orangeCount >= greenCount && orangeCount >= yellowCount && orangeCount >= lightGreenCount  && redCount == orangeCount {
    //                print("orange is dominant")
    //                hexaColor = "#FFA500"
    //            }
    //        else {
    //                print("red is dominant")
    //                hexaColor = "#FF0000"
    //            }
    //            print("Red color = \(redCount) Orange color = \(orangeCount) Yellow color  = \(yellowCount) Light Green color = \(lightGreenCount) Green color = \(greenCount)")
    //        }
    
    
    
    
    
    func setColorForDeal() {
        //        //            <40% Red
        //        //            40 - 60% Orange
        //        //            60 - 85% Yellow
        //        //            85% - 95% Light Green
        //        //            95 - 100% Green
        //
        ////        if redCount > orangeCount && redCount > yellowCount && redCount > lightGreenCount && redCount == greenCount{
        ////            print("yellow is dominant")
        ////            hexaColor = "#FFFF00"
        ////        }
        ////
        ////        else if greenCount > orangeCount && greenCount > yellowCount && greenCount > lightGreenCount && greenCount == redCount {
        ////            print("yellow is dominant")
        ////            hexaColor = "#FFFF00"
        ////        }
        //
        //         if redCount > orangeCount && redCount > yellowCount && redCount > lightGreenCount && redCount > greenCount {
        //            print("red is dominant")
        //            hexaColor = "#FF0000"
        //        }else if orangeCount > redCount && orangeCount > yellowCount && orangeCount > lightGreenCount && orangeCount > greenCount {
        //            print("orange is dominant")
        //            hexaColor = "#FFA500"
        //        }else if yellowCount > redCount && yellowCount > orangeCount && yellowCount > lightGreenCount && yellowCount > greenCount  {
        //            print("yellow is dominant")
        //            hexaColor = "#FFFF00"
        //        }else if lightGreenCount > redCount && lightGreenCount > yellowCount && lightGreenCount > orangeCount && lightGreenCount > greenCount  {
        //            print("Light is dominant")
        //            hexaColor = "#90EE90"
        //        }else if greenCount > redCount && greenCount > yellowCount && greenCount > orangeCount && greenCount > lightGreenCount  {
        //            print("Green is dominant")
        //            hexaColor = "#00FF00"
        //        }else if greenCount >= yellowCount && greenCount >= orangeCount && greenCount >= redCount  && lightGreenCount == greenCount {
        //            print("Green is dominant")
        //            hexaColor = "#00FF00"
        //        }else if greenCount >= lightGreenCount && greenCount >= orangeCount && greenCount >= redCount  && yellowCount == greenCount {
        //            print("Green is dominant")
        //            hexaColor = "#00FF00"
        //        }
        //        else if lightGreenCount >= greenCount && lightGreenCount >= orangeCount && lightGreenCount >= redCount  &&  yellowCount == lightGreenCount {
        //            print("Light is dominant")
        //            hexaColor = "#90EE90"
        //        }else if yellowCount >= greenCount && yellowCount >= lightGreenCount && yellowCount >= redCount  && yellowCount == orangeCount {
        //            print("yellow is dominant")
        //            hexaColor = "#FFFF00"
        //        }else if greenCount >= lightGreenCount && greenCount >= yellowCount && greenCount >= redCount  && orangeCount == greenCount {
        //            print("Green is dominant")
        //            hexaColor = "#00FF00"
        //        }else if lightGreenCount >= greenCount && lightGreenCount >= yellowCount && lightGreenCount >= redCount && orangeCount == lightGreenCount {
        //            print("Light is dominant")
        //            hexaColor = "#90EE90"
        //        }else if greenCount >= lightGreenCount && greenCount >= yellowCount && greenCount >= orangeCount  && redCount  == greenCount {
        //            print("yellow is dominant")
        //            hexaColor = "#FFFF00"
        //        }else if lightGreenCount >= greenCount && lightGreenCount >= yellowCount && lightGreenCount >= orangeCount && redCount == lightGreenCount {
        //            print("Light is dominant")
        //            hexaColor = "#90EE90"
        //        }else if  yellowCount >= greenCount && yellowCount >= lightGreenCount && yellowCount >= orangeCount  && redCount == yellowCount{
        //            print("yellow is dominant")
        //            hexaColor = "#FFFF00"
        //        }else if orangeCount >= greenCount && orangeCount >= yellowCount && orangeCount >= lightGreenCount  && redCount == orangeCount {
        //            print("orange is dominant")
        //            hexaColor = "#FFA500"
        //        }else {
        //            print("red is dominant")
        //            hexaColor = "#FF0000"
        //        }
        //        print("Red color = \(redCount) Orange color = \(orangeCount) Yellow color  = \(yellowCount) Light Green color = \(lightGreenCount) Green color = \(greenCount)")
    }
    
}


























































// Color Through BackEnd Code



//
//            if totalQuestionsCount > 0 && isCategoryAllQuestionFilled {
//
//                if let categoryLabel = dealCategoryList[index].categoryLabels?.first(where: {$0.condition == .isEqualTo && Int($0.value ?? "0") == yesCount}) , let hexaColor = categoryLabel.color {
//                    print("condition is ==","color is \(hexaColor)")
//                    self.dealCategoryList[index].isFinished = true
//                    self.dealCategoryList[index].dealHexColor = hexaColor
//
//                    if hexaColor == "#FF0000" {
//                        redCount += 1
//                    }else if hexaColor == "#FFA500" {
//                        orangeCount += 1
//                    }else if hexaColor == "#FFFF00" {
//                        yellowCount += 1
//                    }else if hexaColor == "#90EE90" {
//                        lightGreenCount += 1
//                    }else {
//                        greenCount += 1
//                    }
//
//
//                }else  if let categoryLabel = dealCategoryList[index].categoryLabels?.first(where: {$0.condition == .isGreaterThan  && Int($0.value ?? "0") ?? 0 > yesCount}) , let hexaColor = categoryLabel.color {
//                    print("condition is >","color is \(hexaColor)")
//                    self.dealCategoryList[index].isFinished = true
//                    self.dealCategoryList[index].dealHexColor = hexaColor
//
//                    if hexaColor == "#FF0000" {
//                        redCount += 1
//                    }else if hexaColor == "#FFA500" {
//                        orangeCount += 1
//                    }else if hexaColor == "#FFFF00" {
//                        yellowCount += 1
//                    }else if hexaColor == "#90EE90" {
//                        lightGreenCount += 1
//                    }else {
//                        greenCount += 1
//                    }
//
//                } else  if let categoryLabel = dealCategoryList[index].categoryLabels?.first(where: {$0.condition == .isLessThan  && Int($0.value ?? "0") ?? 0 < yesCount}) , let hexaColor = categoryLabel.color {
//                    print("condition is <","color is \(hexaColor)")
//                    self.dealCategoryList[index].isFinished = true
//                    self.dealCategoryList[index].dealHexColor = hexaColor
//
//                    if hexaColor == "#FF0000" {
//                        redCount += 1
//                    }else if hexaColor == "#FFA500" {
//                        orangeCount += 1
//                    }else if hexaColor == "#FFFF00" {
//                        yellowCount += 1
//                    }else if hexaColor == "#90EE90" {
//                        lightGreenCount += 1
//                    }else {
//                        greenCount += 1
//                    }
//                } else if let categoryLabel = dealCategoryList[index].categoryLabels?.first(where: {$0.condition == .isLessThanEqualTo && yesCount <= Int($0.value ?? "0") ?? 0 }) ,  let hexaColor = categoryLabel.color {
//                    //                    if yesCount >= 0 {
//                    print("condition is <=","color is \(hexaColor)")
//                    self.dealCategoryList[index].isFinished = true
//                    self.dealCategoryList[index].dealHexColor = hexaColor
//
//                    if hexaColor == "#FF0000" {
//                        redCount += 1
//                    }else if hexaColor == "#FFA500" {
//                        orangeCount += 1
//                    }else if hexaColor == "#FFFF00" {
//                        yellowCount += 1
//                    }else if hexaColor == "#90EE90" {
//                        lightGreenCount += 1
//                    }else {
//                        greenCount += 1
//                    }
//                    //                    }
//                    //                    else {
//                    //                        print("no condition","no color")
//                    //                        self.dealCategoryList[index].isFinished = false
//                    //                        self.dealCategoryList[index].dealHexColor = nil
//                    //
//                    //                    }
//                }
//                else  if let categoryLabel = dealCategoryList[index].categoryLabels?.first(where: {$0.condition == .isGreaterThanEqualTo  && Int($0.value ?? "0") ?? 0 >= yesCount}) , let hexaColor = categoryLabel.color {
//                    print("condition is >=","color is \(hexaColor)")
//                    self.dealCategoryList[index].isFinished = true
//                    self.dealCategoryList[index].dealHexColor = hexaColor
//
//                    if hexaColor == "#FF0000" {
//                        redCount += 1
//                    }else if hexaColor == "#FFA500" {
//                        orangeCount += 1
//                    }else if hexaColor == "#FFFF00" {
//                        yellowCount += 1
//                    }else if hexaColor == "#90EE90" {
//                        lightGreenCount += 1
//                    }else {
//                        greenCount += 1
//                    }
//                }
//                else {
//                    print("no condition","no color")
//                    self.dealCategoryList[index].isFinished = false
//                    self.dealCategoryList[index].dealHexColor = nil
//                }
//
//            }
