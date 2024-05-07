//
//  CoachingMaterialVC.swift
//  Meddpicc App
//
//  Created by Asad Khan on 8/31/22.
//



import UIKit
import Stripe
import Alamofire
import AVKit
import SDWebImage
class CoachingMaterialVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var sessionUrlLabel: UITextView!
    @IBOutlet weak var sessionUrlStackView: UIStackView!
    @IBOutlet weak var sessionDoneLabel: UILabel!
    @IBOutlet weak var sessionStatusLabel: UILabel!
    @IBOutlet weak var sessionDateTimeLabel: UILabel!
    @IBOutlet weak var coachingTableView: UITableView!
    @IBOutlet weak var coachingBarView: UIView!
    @IBOutlet weak var myStuffBarView: UIView!
    @IBOutlet weak var myStuffStackView: UIStackView!
    @IBOutlet weak var coachingView: UIView!
    @IBOutlet weak var myStuffView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var paymentSheet: PaymentSheet?
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    var dealID : Int?
    var dealName: String?
    var isSession_purchase: Bool = false
    var dealData = [Deal_data]()
    var sessionUrl : String?
    var isUnFinishedTapped: Bool?
    var unFinishedDealObj : Deal_data?
    var coachingVideoResp : CoachingVideoResponse?
    var isCoachingTapped : Bool = false
    
    let videos = [
        "https://vimeo.com/767094031",
        "https://vimeo.com/767094061",
        "https://vimeo.com/767094085",
        "https://vimeo.com/767094098",
        "https://vimeo.com/767094120",
        "https://vimeo.com/767094135",
        "https://vimeo.com/765838732",
        "https://vimeo.com/767094153"
    ]
    private var CoachingVC: CoachingVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CoachingVC") as! CoachingVC
        return viewController
    }()
    private var SessionVC: SessionVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "SessionVC") as! SessionVC
        return viewController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        //        buyButton.addTarget(self, action: #selector(didTapCheckoutButton), for: .touchUpInside)
        //        buyButton.isEnabled = true
        if isUnFinishedTapped ?? false {
            self.backButton.isHidden = false
        }else {
            self.backButton.isHidden = true
        }
       // PaymentData()
//        self.getVideos()
////        DispatchQueue.main.asyncAfter(deadline: .now()  + 2.0) {
////            self.getVideos()
////        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.getAllDeals()
//        }
        
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // userNameLabel.text = "Hey \(DealDocSessionManager.shared.getUser()?.fullName ?? "")"
    }
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func updateView() {
            
            add(asChildViewController: CoachingVC)
            
        }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    @IBAction func coachingButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        coachingBarView.backgroundColor = .red
        myStuffBarView.backgroundColor = .clear
        remove(asChildViewController: SessionVC)
        add(asChildViewController: CoachingVC)
//        isCoachingTapped = true
//        coachingView.isHidden = false
//        myStuffView.isHidden = true
    }
    
    
    @IBAction func myStuffButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        coachingBarView.backgroundColor = .clear
        myStuffBarView.backgroundColor = .red
        remove(asChildViewController: CoachingVC)
        add(asChildViewController: SessionVC)
//        isCoachingTapped = false
//        coachingView.isHidden = true
//        myStuffView.isHidden = false
        //myStuffStackView.isHidden = true
    }
    func getAllDeals() {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let urlString : String?
        if isUnFinishedTapped ?? false{
            urlString = "\(URLPath.getAllDeals)/\(unFinishedDealObj?.id ?? 0)"
        }else {
            urlString = URLPath.getAllDeals
        }
        
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request(urlString!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealResp = try decoder.decode(DealResponse.self, from: json!)
                    self.dealData = dealResp.deal_data ?? []
//                    let sessionUrl = self.dealData.first(where: {$0.session_url != nil})
//                    let isSessionPurchased = self.dealData.first(where: {$0.is_session_purchased == true})
//                    self.sessionUrl = sessionUrl?.session_url
//                    print(self.sessionUrl ?? "")
//                //    if isSessionPurchased?.is_session_purchased ?? false {
//                        if self.sessionUrl != nil{
//                            DispatchQueue.main.async {
//                                self.sessionUrlStackView.isHidden = false
//                                self.sessionDoneLabel.isHidden = true
//                                self.sessionStatusLabel.isHidden = false
//                                self.sessionDateTimeLabel.isHidden = false
//                                self.sessionStatusLabel.text = "Status: Scheduled"
//                                let attributedString = NSMutableAttributedString(string: self.sessionUrl ?? "")
//    //                            attributedString = NSAttributedString(string: self.sessionUrl ?? "", attributes: [.font : UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.red]) as! NSMutableAttributedString
//
//    //                            let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular),
//    //                                             NSAttributedString.Key.foregroundColor: UIColor.red]
//    //
//    //                            let attributedText = NSAttributedString(string: self.sessionUrl ?? "", attributes: attribute)
//
//                                attributedString.addAttribute(.link, value: self.sessionUrl ?? "", range: NSRange(location: 0, length: self.sessionUrl?.count ?? 0))
//                                self.sessionUrlLabel.attributedText = attributedString
//                                self.sessionDateTimeLabel.text = "Date:\(Date.getTodayDateString()) \t \t Time:\(Date.getTodayTimeString())"
//                            }
//
//                        }else {
//                            self.sessionDateTimeLabel.isHidden = true
//                            self.sessionStatusLabel.isHidden = false
//                            self.sessionDoneLabel.isHidden = false
//                            self.sessionStatusLabel.text = "Status: Pending"
//                            self.sessionUrlStackView.isHidden = true
//                            print("no found")
//                        }
////                    }else {
////                        print("Session is not Purchased")
////                    }
                   
                    
                }
                catch (let error){
                    print("JSON Error \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
        
    }
    
    
    func PaymentData() {
        let token  = UserDefaults.standard.string(forKey: "token") ?? ""
        let backendCheckoutUrl = URL(string: URLPath.createPaymentIntent)!
        let parameters = ["amount": 25]
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        var request = URLRequest(url: backendCheckoutUrl)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let task = URLSession.shared.dataTask(
            with: request,
            completionHandler: { [weak self] (data, response, error) in
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        as? [String: Any],
                      let result = json["paymentIntent"] as? NSDictionary,
                      let paymentIntentClientSecret = result["client_secret"] as? String,
                      let self = self
                else {
                    // Handle error
                    return
                }
                
                // MARK: Set your Stripe publishable key - this allows the SDK to make requests to Stripe for your account
                STPAPIClient.shared.publishableKey = "pk_test_51L0djBBWYwCyp5v0kEATd8XrmyvGKmoj2g9a4odUiEstm6SkW7nZleoF1IetMIkI9Ebl0g7uP1NLogvIGP7lBzCo00XTQcZSkw"
                
                // MARK: Create a PaymentSheet instance
                var configuration = PaymentSheet.Configuration()
                configuration.merchantDisplayName = "Example, Inc."
                configuration.applePay = .init(
                    merchantId: "com.foo.example", merchantCountryCode: "US")
                configuration.returnURL = "payments-example://stripe-redirect"
                self.paymentSheet = PaymentSheet(
                    paymentIntentClientSecret: paymentIntentClientSecret,
                    configuration: configuration)
            })
        task.resume()
    }
    
    
    @IBAction func backButtonTapped (_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func coachingSessionButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"

        ]
        print(header)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.dealID = dealID
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
//        let url = URL(string: "https://admin.davidweisssales.com/calendly?deal_id=\(dealID ?? 0)")!
//        print(url)
//        UIApplication.shared.open(url)
//        isSession_purchase = true
//        // MARK: Start the checkout process
//        paymentSheet?.present(from: self) { paymentResult in
//            // MARK: Handle the payment result
//            switch paymentResult {
//            case .completed:
//                self.createPaymentHistory(payment_purchased_type: "Session", deal_name: self.dealName ?? "", payment_status: true, payment_amount: 25, payment_response: "Completed")
//                self.updateDeal(is_Session_Purchase: true, is_Video_Purchase: false,deal_ID: self.dealID ?? 0)
//                print("Your order is confirmed!")
//                // self.displayAlert("Your order is confirmed!")
//            case .canceled:
//                print("Canceled!")
//            case .failed(let error):
//                print(error)
//                self.displayAlert("Payment failed: \n\(error.localizedDescription)")
//            }
//       }
    }
    
        
    @objc func didTapCheckoutButton(_ sender: UIButton) {
        sender.zoomInWithEasing()
        let cell = coachingTableView.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? CoachingMaterialTableViewCell
        // MARK: Start the checkout process
        paymentSheet?.present(from: self) { paymentResult in
            // MARK: Handle the payment result
            switch paymentResult {
            case .completed:
                self.createPaymentHistory(payment_purchased_type: "Videos", deal_name: self.dealName ?? "", payment_status: true, payment_amount: 25, payment_response: "Completed")
                self.updateDeal(is_Session_Purchase: false, is_Video_Purchase: true,deal_ID: self.dealID ?? 0)
                print("Your order is confirmed!")
                // self.displayAlert("Your order is confirmed!")
            case .canceled:
                print("Canceled!")
            case .failed(let error):
                print(error)
                self.displayAlert("Payment failed: \n\(error.localizedDescription)")
            }
        }
    }
    
    func getVideos() {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request(URLPath.getVideos, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    self.coachingVideoResp = try decoder.decode(CoachingVideoResponse.self, from: json!)
                    self.coachingTableView.reloadData()
                }
                catch {
                    print("JSON Error")
                }
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
        
    }
    
    func updateDeal(is_Session_Purchase: Bool?,is_Video_Purchase: Bool?,deal_ID:Int) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let bodyParameters:[String:Any] = ["is_session_purchased" :is_Session_Purchase ?? false,"is_video_purchased":is_Video_Purchase ?? false]
        Alamofire.request("\(URLPath.updateDeal)/\(deal_ID)", method: .patch, parameters: bodyParameters, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            self.stopAnimating()
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealResp = try decoder.decode(CreateDealResponse.self, from: json!)
                    if dealResp.success ?? false {
                        PopupHelper.showToast(message: dealResp.message ?? "")
                        self.dismiss(animated: true)
                    }else  {
                        PopupHelper.showToast(message: dealResp.message ?? "")
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
    
    func displayAlert(_ message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func createPaymentHistory(payment_purchased_type: String,deal_name: String,payment_status:Bool,payment_amount:Int,payment_response:String) {
        let token  = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let bodyParameters:[String:Any] = ["payment_purchased_type":payment_purchased_type,"deal_name": deal_name,"payment_status": payment_status,"payment_amount":payment_amount,"payment_response":payment_response]
        
        Alamofire.request(URLPath.createpaymentlog, method: .post, parameters: bodyParameters, encoding: JSONEncoding.default, headers: header).responseData(completionHandler: { response in
            switch response.result {
            case .success:
                let json = response.data
                print(response.result.value!)
                do{
                    let decoder = JSONDecoder()
                    let createPaymentResponse = try decoder.decode(CreatePaymentLogResponse.self, from: json!)
                    if createPaymentResponse.success == false {
                        PopupHelper.showToast(message: createPaymentResponse.message ?? "")
                    }
                    else {
                        // DealDocSessionManager.shared.saveUser(value: self.createDealResponse)
                        PopupHelper.showToast(message: createPaymentResponse.message ?? "")
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
        })
    }
}

//extension CoachingMaterialVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return coachingVideoResp?.video_data?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachingMaterialTableViewCell") as! CoachingMaterialTableViewCell
//       // cell.comminInit(title: "We are Recomending You to Watch this ", videoUrl: videos[indexPath.row])
//
//        let url = "\(BASEURL.ImageUrl)\(coachingVideoResp?.video_data?[indexPath.row].thumbnail ?? "")"
//        cell.videoImage.loadImage(url,.scaleAspectFit) {  (_, _, _) in
//        }
//        //cell.buyButton.isHidden = true
////        cell.buyButton.tag = indexPath.row
////        cell.buyButton.addTarget(self, action: #selector(didTapCheckoutButton), for: .touchUpInside)
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        playVideo(videoUrl: coachingVideoResp?.video_data?[indexPath.row].url ?? "")
//    }
//    func playVideo(videoUrl: String){
//        let url: URL = URL(string: videoUrl)!
//        UIApplication.shared.open(url)
////        playerView = AVPlayer(url: url)
////        playerViewController.player = playerView
////        self.present(playerViewController, animated: true)
////        self.playerViewController.player?.play()
//
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
//    }
//}
