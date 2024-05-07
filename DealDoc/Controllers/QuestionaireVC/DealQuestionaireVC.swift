//
//  DealQuestionaireVC.swift
//  Meddpicc App
//
//  Created by Asad Khan on 9/1/22.
//

import UIKit
import Alamofire


enum QuestionSelectionType {
    case none
    case yes
    case no
    
    func getStatus() -> Bool? {
        
        switch self {
        case .none:
            return nil
        case .yes:
            return true
        case .no:
            return false
        }
    }
}


class DealQuestionaireVC: UIViewController {
    
    
    @IBOutlet weak var dealNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextViewButton: UIButton!
    @IBOutlet weak var saveDealButton: UIButton!
    @IBOutlet weak var submitDealForReviewButton: UIButton!
    @IBOutlet weak var questionaireCollectionView: UICollectionView!
    @IBOutlet var emptyQuestionSwitch:UISwitch!
    
    
    var selected_deal: Deal_data?
    var selectedDealCategory: DealQuestionResponseData?
    var saveDealResponse :SaveDealResponse?
    var draftDealResponse :DraftDealResponse?
    var getDealResponse : GetDealQuestionResponse?
    var emptyQuestions = [Questions]()
    
    var dealName: String?
    var dealID: Int?
    var currentIndex: Int = 0
    var isSelectedCategoryQuestionFinished: Bool = false
    var isLastUnfilledCategory: Bool = false
    var isSavedDeal: Bool = false
    var isNotSavedDeal: Bool = false
    var isNextButtonSelected: Bool = false
    var isAllCategoryFinished: Bool = false
    var isNewCreatedDeal: Bool = false
    var isNextButtonTapped: Bool = false
    var isSharedDeal: Bool?
    var editAbleText: String?
    var isFromQuestionScreenTapped: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        dealNameLabel.text = dealName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameLabel.text = "Hey \(DealDocSessionManager.shared.getUser()?.fullName ?? "")"
    }
        
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if let secondViewController = segue.destination as! YourDealVC {
//                delegate = YourDealVC
//            }
//        }
    
    func setUpData() {
        self.emptyQuestions = selectedDealCategory?.questions ?? []
        if self.emptyQuestions.contains(where: {$0.isAnsweredType == .no || $0.isAnsweredType == .yes}) {
            self.nextButton.isHidden = false
        }else{
            self.nextButton.isHidden = true
        }
        emptyQuestionSwitch.addTarget(self, action:#selector(questionsSwitchValueChanged(_:)), for: .valueChanged)
        dealNameLabel.text = dealName
        categoryNameLabel.text = selectedDealCategory?.name
        
        if (editAbleText ==  "Active" || editAbleText ==  nil){
            if  isSharedDeal ?? false {
                saveDealButton.isHidden = true
            }else {
                saveDealButton.isHidden = false
            }
           
        }else {
            if  isSavedDeal {
                saveDealButton.isHidden = true
                //saveDealButton.isEnabled = false
                // submitDealForReviewButton.isEnabled = false
            }else {
                saveDealButton.isHidden = false
                //saveDealButton.isEnabled = true
                // submitDealForReviewButton.isEnabled = false
            }
        }
//        if isSavedDeal{
//            saveDealButton.isHidden = true
//            //saveDealButton.isEnabled = false
//            // submitDealForReviewButton.isEnabled = false
//        }else {
//            saveDealButton.isHidden = false
//            //saveDealButton.isEnabled = true
//            // submitDealForReviewButton.isEnabled = false
//        }
        //        if isAllCategoryFinished {
        //            nextViewButton.isHidden = false
        //        }else {
        //            nextViewButton.isHidden = true
        //        }
        countLabel.text = "\(currentIndex + 1)/\(emptyQuestions.count)"
        
    }
    
    @objc  func questionsSwitchValueChanged(_ sender : UISwitch!){
        filterYesNoQuestionList()
    }
    
    @IBAction func backButtonTapped (_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        let questions = emptyQuestions
        guard questions.count > 0 else {
            return
        }
        let indexPath = IndexPath(row: currentIndex, section: 0)
        showNextCollectionViewCell(indexPath : indexPath)
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        
        currentIndex -= 1
        let indexPath = IndexPath(row: currentIndex, section: 0)
        showPreviousCollectionViewCell(indexPath: indexPath)
    }
    
    
    @IBAction func nextViewButtonTapped(_ sender: UIButton) {
        sender.zoomInWithEasing()
        isNextButtonTapped = true
        saveDealInDraft()
    }
    
    
    func saveDealInDraft() {
    
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let questions = emptyQuestions
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        var questionData: [[String:Any]] = []
        
        questions.forEach { item in
            if let respStatus = item.isAnsweredType.getStatus() {
                let quesDic:[String:Any] = ["questionId": item.id ?? 0 ,"response": respStatus ]
                questionData.append(quesDic)
            }
        }
        
        guard !questionData.isEmpty  else { return }
        
        let bodyParameter:[String:Any] = ["dealId": dealID ?? 0,"data" : questionData]
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request(URLPath.draftDeal, method: .post, parameters: bodyParameter , encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
                
            case .success:
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    self.draftDealResponse = try decoder.decode(DraftDealResponse.self, from: json!)
                    if self.saveDealResponse?.status == false {
                        
                        PopupHelper.showToast(message:  "Something wrong")
                    }
                    else {
                        self.updateDealDate(deal_ID: self.dealID ?? 0)
                        if self.isNextButtonTapped {
                            PopupHelper.showToast(message:  "Deal Saved  in Draft Successfully")
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnFinishedDealVC") as! UnFinishedDealVC
//                            vc.editAbleText = self.editAbleText
//                            vc.dealID = self.dealID
//                            vc.selected_deal = self.selected_deal
//                            vc.isNextButtonSelected = true
//                            vc.dealName = self.dealName
//                            vc.isFromQuestionScreenTapped = true
//                            self.navigationController?.pushViewController(vc, animated: true)
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            self.updateDealDate(deal_ID: self.dealID ?? 0)
                           // self.setUpData()
                            DispatchQueue.main.async {
                                self.updateListLocally()
                            }
                            
                            PopupHelper.showToast(message:  "Deal Saved  in Draft Successfully")
                        }
                        
                    }
                    print(json ?? "Error")
                }
                catch{
                    print("JSON Error")
                }
            case .failure:
                print("Data is not saved")
                
            }
        }
    }
    
    
    func updateDealDate(deal_ID: Int) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        Alamofire.request("\(URLPath.updateDealDate)/\(deal_ID)", method: .put, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            self.stopAnimating()
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealResp = try decoder.decode(DealResponse.self, from: json!)
                    print(dealResp)
                    print("Deal Date Updated")
                }
                catch {
                    print("JSON Error")
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
        let bodyParameter:[String:Any] = ["dealId": dealID ?? 0]
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
                    self.saveDealResponse = try decoder.decode(SaveDealResponse.self, from: json!)
                    if self.saveDealResponse?.status == false {
                        PopupHelper.showToast(message:  "Something wrong")
                    }
                    else {
                        PopupHelper.showToast(message:  " Submitted Deal For Review Successfully")
                    }
                    print(json ?? "Error")
                }
                catch{
                    print("JSON Error")
                }
            case .failure:
                print("Data is not saved")
                
            }
        }
    }
    
    @IBAction func saveDealButton(_ sender: UIButton) {
        sender.zoomInWithEasing()
        saveDealInDraft()
    }
    
    @IBAction func submitDealForReviewButton(_ sender: UIButton) {
        sender.zoomInWithEasing()
        submitDealForReview()
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x) / Int(scrollView.frame.width)
        currentIndex = index
        
    }
    
    
    func updateListLocally() {
        for emptyQuestion in emptyQuestions {
            if let catagoryIndex =  selectedDealCategory?.questions?.firstIndex(where: {$0.id == emptyQuestion.id}) {
                selectedDealCategory?.questions?[catagoryIndex].isAnsweredType = emptyQuestion.isAnsweredType
            }
        }
        filterYesNoQuestionList()
    }
    
    func filterYesNoQuestionList() {
        if emptyQuestionSwitch.isOn {
            self.emptyQuestions = selectedDealCategory?.questions?.filter({$0.isAnsweredType == .no}) ?? []
        } else {
            self.emptyQuestions = selectedDealCategory?.questions ?? []
        }
        if self.emptyQuestions.contains(where: {$0.isAnsweredType == .no || $0.isAnsweredType == .yes}) {
            self.nextButton.isHidden = false
        }else{
            self.nextButton.isHidden = true
        }
        currentIndex = 0
        countLabel.text = "\(currentIndex + 1)/\(emptyQuestions.count)"
        self.questionaireCollectionView.reloadData()
    }
    
}
extension DealQuestionaireVC : UICollectionViewDelegate, UICollectionViewDataSource , DealQuestionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emptyQuestions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DealQuestionaireCollectionViewCell", for: indexPath) as! DealQuestionaireCollectionViewCell
        let questions = emptyQuestions
        cell.questionLabel.text = questions[indexPath.row].statement
        cell.delegate = self
        
        if questions[indexPath.row].isAnsweredType == .none {
            let yesImage = UIImage(named: "Unselected")
            cell.yesImageView.image = yesImage
            let noImage = UIImage(named: "Unselected")
            cell.noImageView.image = noImage
           
        } else if questions[indexPath.row].isAnsweredType == .yes {
            let yesImage = UIImage(named: "Selected")
            cell.yesImageView.image = yesImage
            let noImage = UIImage(named: "Unselected")
            cell.noImageView.image = noImage
           
        } else {
            let yesImage = UIImage(named: "Unselected")
            cell.yesImageView.image = yesImage
            let noImage = UIImage(named: "Selected")
            cell.noImageView.image = noImage
    
        }
         if (isSharedDeal ?? false) && editAbleText ==  nil {
             cell.yesRadioButton.isEnabled = false
             cell.noRadioButton.isEnabled = false
        }
        else if (editAbleText ==  "Active" || editAbleText ==  nil){
            cell.yesRadioButton.isEnabled = true
            cell.noRadioButton.isEnabled = true
        }else {
            cell.yesRadioButton.isEnabled = false
            cell.noRadioButton.isEnabled = false
        }
         
//        if isSavedDeal{
//            cell.yesRadioButton.isEnabled = false
//            cell.noRadioButton.isEnabled = false
//        }else {
//            cell.yesRadioButton.isEnabled = true
//            cell.noRadioButton.isEnabled = true
//        }
        
        return cell
        
    }
    
    func showNextCollectionViewCell(indexPath: IndexPath) {
        let questions = emptyQuestions
        
        if (indexPath.item < (questions.count - 1)) {
            currentIndex += 1
            let nextIndexPath = IndexPath(row: currentIndex, section: 0)
            questionaireCollectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
            countLabel.text = "\(nextIndexPath.row + 1)/\(questions.count)"
            previousButton.isHidden = false
            nextViewButton.isHidden = true
            
            if nextIndexPath.item == questions.count - 1{
                if (editAbleText ==  "Active" || editAbleText ==  nil){
                    if  isSharedDeal ?? false {
                        saveDealButton.isHidden = true
                    }else {
                        saveDealButton.isHidden = false
                    }
                }else {
                    nextViewButton.isHidden = true
                }
              //  nextViewButton.isHidden = false
                nextButton.isHidden = true
            }
            else if emptyQuestions[nextIndexPath.row].isAnsweredType == .none || nextIndexPath.item == questions.count - 1 {
                nextButton.isHidden = true
            }else {
                nextButton.isHidden = false
            }
        }else {
            // click on last question button
            DispatchQueue.main.async {
                self.nextButton.isHidden = true
                self.nextViewButton.isHidden = false
            }
        }
        
        questionaireCollectionView.reloadData()
//        if (editAbleText ==  "Active" || editAbleText ==  nil){
//            nextViewButton.isHidden = false
//        }else {
//            if isSavedDeal || isNotSavedDeal {
//                nextViewButton.isHidden = true
//            }
//        }
//        else{
//            nextViewButton.isHidden = true
//        }
    }
    
    func showPreviousCollectionViewCell(indexPath: IndexPath) {
        
        questionaireCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        if indexPath.row == 0 {
            previousButton.isHidden = true
            nextButton.isHidden = false
            nextViewButton.isHidden = true
            countLabel.text = "\(currentIndex + 1)/\(emptyQuestions.count)"
        }else if indexPath.row < emptyQuestions.count{
            nextButton.isHidden = false
            previousButton.isHidden = false
            nextViewButton.isHidden = true
            countLabel.text = "\(currentIndex + 1)/\(emptyQuestions.count)"
        }
        else {
            nextButton.isHidden = false
            previousButton.isHidden = false
            countLabel.text = "\(currentIndex + 1)/\(emptyQuestions.count)"
        }
        
        if emptyQuestions.count == emptyQuestions.count - 1 {
            if isSavedDeal{
                nextViewButton.isHidden = true
            }else{
                nextViewButton.isHidden = false
            }
        }
        
        if isSavedDeal || isNotSavedDeal {
            nextViewButton.isHidden = true
        }
//        else{
//            nextViewButton.isHidden = true
//        }
    }
    
    
    func didTapYesButton(cell: DealQuestionaireCollectionViewCell) {
        
        guard let indexPath = questionaireCollectionView.indexPath(for: cell) else {
            return
        }
        emptyQuestions[indexPath.row].isAnsweredType = .yes
        showNextCollectionViewCell(indexPath : indexPath)
        
    }
    
    
    func didTapNoButton(cell: DealQuestionaireCollectionViewCell) {
        
        guard let indexPath = questionaireCollectionView.indexPath(for: cell) else {
            return
        }
        emptyQuestions[indexPath.row].isAnsweredType = .no
        showNextCollectionViewCell(indexPath : indexPath)
        
    }
}

extension DealQuestionaireVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frameSize = collectionView.frame.size
        return CGSize(width: frameSize.width, height: frameSize.height)
    }
    
}
