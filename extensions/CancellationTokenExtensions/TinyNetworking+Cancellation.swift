//
//  TinyNetworking+Cancellation.swift
//  CancellationTokenExtensions
//
//  Created by Tom Lokhorst on 2014-11-08
//  Copyright (c) 2014 Tom Lokhorst. All rights reserved.
//

import Foundation

public func tinyApiRequest<A>(modifyRequest: NSMutableURLRequest -> (), baseURL: NSURL, resource: Resource<A>, cancellationToken: CancellationToken, failure: (Reason, NSData?) -> (), completion: A -> ()) -> NSURLSessionTask {
  let task = apiRequest(modifyRequest, baseURL: baseURL, resource: resource, failure: failure, completion: completion)

  cancellationToken.register { [weak task] in
    task?.cancel()
    return
  }

  return task
}