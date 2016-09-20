//
//  Alamofire+Cancellation.swift
//  CancellationTokenExtensions
//
//  Created by Tom Lokhorst on 2014-11-08.
//  Copyright (c) 2014 Tom Lokhorst. All rights reserved.
//

import Alamofire

extension SessionManager {

  @discardableResult
  open func request(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil,
    cancellationToken: CancellationToken = NotCancellableToken)
    -> DataRequest
  {
    let req = self.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)

    cancellationToken.register { [weak req] in
      req?.cancel()
      return
    }

    return req
  }

  open func request(
    _ urlRequest: URLRequestConvertible,
    cancellationToken: CancellationToken = NotCancellableToken)
    -> DataRequest
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
  _ url: URLConvertible,
  method: HTTPMethod = .get,
  parameters: Parameters? = nil,
  encoding: ParameterEncoding = URLEncoding.default,
  headers: HTTPHeaders? = nil,
  cancellationToken: CancellationToken = NotCancellableToken)
  -> DataRequest
{
  return SessionManager.default.request(
    url,
    method: method,
    parameters: parameters,
    encoding: encoding,
    headers: headers,
    cancellationToken: cancellationToken
  )
}

@discardableResult
public func request(
  _ urlRequest: URLRequestConvertible,
  cancellationToken: CancellationToken = NotCancellableToken)
  -> DataRequest
{
  return SessionManager.default.request(urlRequest, cancellationToken: cancellationToken)
}
