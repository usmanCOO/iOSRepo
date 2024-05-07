//
//  uploadFile.swift
//  DealDoc
//
//  Created by Asad Khan on 10/18/22.
//

import Foundation
import Alamofire

class File:NSObject {
    
    var data:Data?
    var fileName:String
    var contentType:String?
    
    required init(data: Data, fileName:String, contentType: String?) {
        self.data = data
        self.fileName = fileName
        self.contentType = contentType
    }
    
    required init(image: UIImage , fileName : String) {
        self.data = image.jpegData(compressionQuality: 1.0)
        self.fileName = fileName
        self.contentType = "image/jpeg"
    }
    
    required init(path: URL) {
        self.data = try? Data(contentsOf: path)
        self.fileName = "file."+path.pathExtension
        self.contentType = "application/octet-stream"
    }
    
    required init(path: URL , name : String) {
        self.data = try? Data(contentsOf: path)
        self.fileName = name+"."+path.pathExtension
        self.contentType = "application/octet-stream"
    }
    
}

public enum ConnectionResult {
    case success(Any?)
    case failure(Error?)
}

class fileUploader {
    
    static let boundaryConstant = "myRandomBoundary12345"
    
    static func uploadFiles(_ url: String,headers: HTTPHeaders, params: [String : Any]?, files: KeyValuePairs<String, File>, completionHandler: @escaping (_ response: ConnectionResult?) -> ()) {
        let completeUrl = url
        let data = filesUrlRequestWithComponents(parameters: params, files: files)
        let AlamofireManager = Alamofire.SessionManager.default
        AlamofireManager.session.configuration.timeoutIntervalForRequest = 30
        AlamofireManager.upload(data, to: completeUrl, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completionHandler(ConnectionResult.success(response.data))
                case .failure(let error):
                    completionHandler(ConnectionResult.failure(error))
                }
            }
    }
    
    
    fileprivate static func filesUrlRequestWithComponents(parameters: [String : Any]?, files: KeyValuePairs<String, File>) -> Data {
        let uploadData = NSMutableData()
        
        for (key, value) in files {
            if let data = value.data {
                uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append(String("Content-Disposition: form-data; name=\"" + key + "\"; filename=\"" + value.fileName + "\"\r\n").data(using: String.Encoding.utf8)!)
                if let contentType = value.contentType {
                    uploadData.append(("Content-Type: " + contentType + "\r\n\r\n").data(using: String.Encoding.utf8)!)
                }
                uploadData.append(data)
            }
        }
        if let params = parameters {
            for (key, value) in params {
                uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
            }
        }
        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        return uploadData as Data
    }
}


    
