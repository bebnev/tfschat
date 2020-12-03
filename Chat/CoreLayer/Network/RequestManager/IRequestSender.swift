//
//  IRequestSender.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

protocol IRequestSender {
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping(Result<Parser.Model, RequestSenderErrors>) -> Void)
}
