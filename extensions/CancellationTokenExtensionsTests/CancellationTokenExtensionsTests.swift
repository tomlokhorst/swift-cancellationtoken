//
//  CancellationTokenExtensionsTests.swift
//  CancellationTokenExtensionsTests
//
//  Created by Tom Lokhorst on 2014-11-08.
//  Copyright (c) 2014 Tom Lokhorst. All rights reserved.
//

import XCTest
import Alamofire
import CancellationTokenExtensions

class CancellationTokenExamplesTests: XCTestCase {

  func testAlamofire() {
    let expectation = expectationWithDescription("Request not cancelled")

    let largeFileUrl = "https://upload.wikimedia.org/wikipedia/commons/5/5f/HubbleDeepField.800px.jpg"
    let source = CancellationTokenSource()
    let token = source.token


    // Start the asynchroneous downloading of a large file, passing in the cancellation token
    request(.GET, URLString: largeFileUrl, cancellationToken: token)
      .response { (request, response, data, error) in
        if let error = error as? NSError {
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
    tinyApiRequest({ _ in }, baseURL: baseURL, resource: largeFileResource, cancellationToken: token, failure: { reason, _ in
      switch reason {
      case let .Other(error):
        if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
          expectation.fulfill()
        }
      default:
        break
      }
    }, completion: { result in
      print("result!")
    })

    // Request cancellation of the token after 0.1 second
    source.cancel(0.1)

    // Wait for 1 second for the download to be cancelled
    waitForExpectationsWithTimeout(1.0, handler: nil)
  }

  func testFibonacci() {
    let source = CancellationTokenSource()
    let token = source.token

    // Request cancellation of the token after 0.5 second
    source.cancel(0.5)

    // Start calculation of the 36th fibonacci number on main queue
    let result = fib(36, token)

    XCTAssertNotEqual(result, 14930352, "Fibonacci calculation was not cancelled")
  }
}

func delay(seconds: NSTimeInterval, block: dispatch_block_t!) {
  let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
  let queue = dispatch_get_main_queue()

  dispatch_after(when, queue, block)
}
