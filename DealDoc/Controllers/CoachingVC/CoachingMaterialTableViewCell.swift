//
//  CoachingMaterialTableViewCell.swift
//  DealDoc
//
//  Created by Asad Khan on 11/16/22.
//

import UIKit
import AVFoundation
class CoachingMaterialTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var buyButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func comminInit(title: String,videoUrl: String){
        self.titleLabel.text = title
        let url = URL(string: videoUrl) ?? URL(fileURLWithPath: "")
        self.getThumbnailFromVideoURL(url: url) { thumbnailImage in
            self.videoImage.image = thumbnailImage
        }
    }
    
    func getThumbnailFromVideoURL(url: URL, completion: @escaping((_ image : UIImage)-> Void)){
        DispatchQueue.main.async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumbnailTime = CMTimeMake(value: 2, timescale: 2)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumbnailTime, actualTime: nil)
                let UiImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(UiImage)
                }
            }catch(let error) {
                print(error.localizedDescription)
            }
        }
        
    }
}
