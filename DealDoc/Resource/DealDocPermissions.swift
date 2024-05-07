//
//  DealDocPermissions.swift
//  DealDoc
//
//  Created by Asad Khan on 12/21/22.
//


import Foundation
import Photos
import AVFoundation
import UIKit
final class DealDocPermissions {

    static func checkCameraPermission(message:String = "",completion:@escaping (Bool)->()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            openSettingAlert(title:"QuizMarks needs Camera permission",message:"Please go to settings and give permission to the app to use the Camera \(message)")
            completion(false)
            return
        case .authorized:
            completion(true)
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    completion(true)
                    return
                }
            }
        case .restricted:
            completion(false)
            return
        @unknown default:
           completion(false)
            return
        }
    }

    static  func checkPhotosLibraryPermission(message:String = "",completion:@escaping  (Bool)->()) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized,.limited:
            completion(true)
            return
        case .denied:
            self.openSettingAlert(title:"QuizMarks needs photos permissions",message:"Please go to settings and give permission to the app to use photos \(message)")
            completion(false)
            return
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if #available(iOS 14, *) {
                    if status == .authorized || status == .limited {
                        completion(true)
                        return
                    }
                } else {
                    if status == .authorized {
                        completion(true)
                        return
                    }
                }
            }
        case .restricted :
            completion(false)
            return
        @unknown default:
            completion(true)
            return
        }
    }

   static func openSettingAlert(title:String,message:String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { (alert) -> Void in
            if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
            }
        }))
        DispatchQueue.main.async {
            SceneDelegate.shared?.topmostViewController()?.present(alert, animated: true, completion: nil)
        }
    }
}
