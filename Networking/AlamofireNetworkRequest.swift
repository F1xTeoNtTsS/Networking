//
//  AlamofireNetworkRequest.swift
//  Networking
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url).responseJSON { (response) in
            print(response)
        }
    }
}
