//
//  CoachingVC.swift
//  DealDoc
//
//  Created by Asad Khan on 12/2/22.
//

import UIKit
import Alamofire
import AVKit
import SDWebImage
class CoachingVC: UIViewController {
    
    @IBOutlet weak var coachingTableView: UITableView!
    var coachingVideoResp : CoachingVideoResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        if Connectivity.isConnectedToInternet(){
            getVideos()
        }else{
            PopupHelper.showToast(message: "No internet Connection")
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

}

extension CoachingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return coachingVideoResp?.video_data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachingMaterialTableViewCell") as! CoachingMaterialTableViewCell
        cell.titleLabel.text = coachingVideoResp?.video_data?[indexPath.row].name
        let url = "\(BASEURL.ImageUrl)\(coachingVideoResp?.video_data?[indexPath.row].thumbnail ?? "")"
        cell.videoImage.loadImage(url,.scaleAspectFit) {  (_, _, _) in
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(videoUrl: coachingVideoResp?.video_data?[indexPath.row].url ?? "")
    }
    
    func playVideo(videoUrl: String){
        let url: URL = URL(string: videoUrl)!
        UIApplication.shared.open(url)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 300
    }
}
