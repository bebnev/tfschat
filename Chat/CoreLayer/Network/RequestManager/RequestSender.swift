//
//  RequestSender.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class RequestSender: IRequestSender {
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func send<Parser>(requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model, RequestSenderErrors>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(.failure(.canNotParseToUrl))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, _: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(.failure(.error(msg: error.localizedDescription)))
                return
            }
            guard let data = data,
                let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    completionHandler(.failure(.canNotParseData))
                    return
            }
            
            completionHandler(.success(parsedModel))
        }
        
        task.resume()
    }
}
