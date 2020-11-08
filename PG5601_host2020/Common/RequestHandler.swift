//
//  RequestHandler.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 01/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
//

import Foundation
import Alamofire

class RequestHandler {
  
    func requestWeaterData(url: String, completed:@escaping (_ response: Welcome) -> Void) {
    AF.request(url)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(queue: DispatchQueue.init(label: "Background"))
      { response in
        guard let data = response.data else {return};
        guard let _ = response.value else {return};
        
        if let statusCode = response.error?.responseCode {
          print("Error with status code: \(statusCode)");
        }
        
        do {
            let fetchRes = try JSONDecoder().decode(Welcome.self, from: data)
          DispatchQueue.main.async {
            completed(fetchRes);
          }
        } catch let error {
          print(error)
        }
    }
  }
}
