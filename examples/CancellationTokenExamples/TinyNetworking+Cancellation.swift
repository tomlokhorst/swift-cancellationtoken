//
//  TinyNetworking+Cancellation.swift
//  CancellationTokenExamples
//
//  Created by Tom Lokhorst on 08/11/14.
//  Copyright (c) 2014 Tom Lokhorst. All rights reserved.
//

import Foundation
import CancellationToken

public func tinyApiRequest<A>(modifyRequest: NSMutableURLRequest -> (), baseURL: NSURL, resource: Resource<A>, cancellationToken: CancellationToken, failure: (Reason, NSData?) -> (), completion: A -> ()) -> NSURLSessionTask {
  let task = apiRequest(modifyRequest, baseURL, resource, failure, completion)

  cancellationToken.register {
    task.cancel()
  }

  return task
}