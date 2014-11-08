//
//  CancellationTokenExamplesTests.swift
//  CancellationTokenExamplesTests
//
//  Created by Tom Lokhorst on 08/11/14.
//  Copyright (c) 2014 Tom Lokhorst. All rights reserved.
//

import UIKit
import XCTest
import Alamofire
import CancellationToken
import CancellationTokenExamples

class CancellationTokenExamplesTests: XCTestCase {

  func testAlamofire() {
    let expectation = expectationWithDescription("Request not cancelled")

    let largeFileUrl = "https://upload.wikimedia.org/wikipedia/commons/5/5f/HubbleDeepField.800px.jpg"
    let source = CancellationTokenSource()
    let token = source.token


    // Start the asynchroneous downloading of a large file, passing in the cancellation token
    alamofireRequest(.GET, largeFileUrl, cancellationToken: token)
      .response { (request, response, data, error) in
        if let error = error {
          if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
            expectation.fulfill()
          }
        }
    }

    // Request cancellation of the token after 0.1 second
    source.cancel(0.1)

    // Wait for 1 second for the download to be cancelled
    waitForExpectationsWithTimeout(1.0, handler: nil)
  }

  func testTinyNetworking() {
    let expectation = expectationWithDescription("Request not cancelled")

    let source = CancellationTokenSource()
    let token = source.token


    let baseURL = NSURL(string: "https://upload.wikimedia.org")!
    let largeFileResource = Resource(
      path: "/wikipedia/commons/5/5f/HubbleDeepField.800px.jpg",
      method: .GET,
      requestBody: nil,
      headers: [:],
      parse: { data in data })


    // Start the asynchroneous downloading of a large file, passing in the cancellation token
    tinyApiRequest({ _ in }, baseURL, largeFileResource, token, { reason, _ in
      switch reason {
      case let .Other(error):
        if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
          expectation.fulfill()
        }
      default:
        break
      }
    }, { result in
      println("result!")
    })

    // Request cancellation of the token after 0.1 second
    source.cancel(0.1)

    // Wait for 1 second for the download to be cancelled
    waitForExpectationsWithTimeout(1.0, handler: nil)
  }

}

func delay(seconds: NSTimeInterval, block: dispatch_block_t!) {
  let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
  let queue = dispatch_get_main_queue()

  dispatch_after(when, queue, block)
}
