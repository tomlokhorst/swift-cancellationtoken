//
//  Alamofire+Cancellation.swift
//  CancellationTokenExtensions
//
//  Created by Tom Lokhorst on 2014-11-08.
//  Copyright (c) 2014 Tom Lokhorst. All rights reserved.
//

import CancellationToken
import Alamofire

extension Manager {
  public func request(method: Alamofire.Method, URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, cancellationToken: CancellationToken = NotCancellableToken) -> Request {
    let req = self.request(method, URLString, parameters: parameters, encoding: encoding)

    cancellationToken.register { [weak req] in
      req?.cancel()
      return
    }

    return req
  }

  public func request(URLRequest: URLRequestConvertible, cancellationToken: CancellationToken = NotCancellableToken) -> Request {
    let req = self.request(URLRequest)

    cancellationToken.register { [weak req] in
      req?.cancel()
      return
    }

    return req
  }
}

public func request(method: Alamofire.Method, URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, cancellationToken: CancellationToken = NotCancellableToken) -> Request {
  return Manager.sharedInstance.request(method, URLString: URLString, parameters: parameters, encoding: encoding, cancellationToken: cancellationToken)
}

public func request(URLRequest: URLRequestConvertible, cancellationToken: CancellationToken = NotCancellableToken) -> Request {
  return Manager.sharedInstance.request(URLRequest.URLRequest, cancellationToken: cancellationToken)
}
