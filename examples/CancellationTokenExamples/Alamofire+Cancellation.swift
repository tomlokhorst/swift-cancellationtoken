//
//  Alamofire+Cancellation.swift
//  CancellationTokenExamples
//
//  Created by Tom Lokhorst on 08/11/14.
//  Copyright (c) 2014 Tom Lokhorst. All rights reserved.
//

import CancellationToken
import Alamofire

public func alamofireRequest(method: Alamofire.Method, URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, cancellationToken: CancellationToken = NotCancellableToken) -> Request {
  let req = Alamofire.request(method, URLString, parameters: parameters, encoding: encoding)

  cancellationToken.register { [weak req] in
    req?.cancel()
    return
  }

  return req
}