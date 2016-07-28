//
//  Alamofire+Cancellation.swift
//  CancellationTokenExtensions
//
//  Created by Tom Lokhorst on 2014-11-08.
//  Copyright (c) 2014 Tom Lokhorst. All rights reserved.
//

import Alamofire

extension Manager {

  @discardableResult
  public func request(
    _ method: Alamofire.Method,
    _ URLString: URLStringConvertible,
    parameters: [String: AnyObject]? = nil,
    encoding: ParameterEncoding = .url,
    headers: [String: String]? = nil,
    cancellationToken: CancellationToken = NotCancellableToken)
    -> Request
  {
    let req = self.request(method, URLString, parameters: parameters, encoding: encoding, headers: headers)

    cancellationToken.register { [weak req] in
      req?.cancel()
      return
    }

    return req
  }

  public func request(
    _ urlRequest: URLRequestConvertible,
    cancellationToken: CancellationToken = NotCancellableToken)
    -> Request
  {
    let req = self.request(urlRequest)

    cancellationToken.register { [weak req] in
      req?.cancel()
      return
    }

    return req
  }
}

@discardableResult
public func request(
  _ method: Alamofire.Method,
  _ URLString: URLStringConvertible,
  parameters: [String: AnyObject]? = nil,
  encoding: ParameterEncoding = .url,
  headers: [String: String]? = nil,
  cancellationToken: CancellationToken = NotCancellableToken)
  -> Request
{
  return Manager.sharedInstance.request(
    method,
    URLString,
    parameters: parameters,
    encoding: encoding,
    cancellationToken: cancellationToken
  )
}

@discardableResult
public func request(
  _ urlRequest: URLRequestConvertible,
  cancellationToken: CancellationToken = NotCancellableToken)
  -> Request
{
  return Manager.sharedInstance.request(urlRequest, cancellationToken: cancellationToken)
}
