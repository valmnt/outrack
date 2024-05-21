//
//  APICallerTests.swift
//  OutrackWatchAppTests
//
//  Created by Valentin Mont on 06/09/2023.
//

import XCTest
@testable import OutrackWatchApp
import Combine

class APICallerTests: XCTestCase {

    private var result: Any!
    private var error: APICallerErrors!
    private var apiCaller: DefaultAPICaller!
    private var request: URLRequest = URLRequest(url: URL(string: "http://google.com/")!)

    func test_succeeds_to_send_requests() {
        let successCode = Set<Int>(200...299)
        for code in successCode {
            requestSucceded(code)
        }
     }

     func test_fails_to_send_requests() {
         for code in APICallerErrors.allCases {
             requestFailed(code.rawValue)
         }
     }

    // MARK: - Given
     private func givenAPICaller(httpCode: Int) {
         let urlSession = FakeURLSession(expected: generateURLResponse(httpCode: httpCode))
         apiCaller = APICaller(urlSession: urlSession)
     }

    // MARK: - When
     private func whenMakingAPICall(request: URLRequest) {
         let expectation = expectation(description: "Must wait until it done")
         Task {
             do {
                 try await apiCaller.call(urlRequest: request)
                 expectation.fulfill()
             } catch {
                 self.error = (error as! APICallerErrors)
                 expectation.fulfill()
             }
         }

         wait(for: [expectation], timeout: 1)
     }

    // MARK: - Then
     private func thenAPICallFailed(with expected: Int) {
         XCTAssertNil(self.result)
         XCTAssertEqual(expected, self.error.rawValue)
     }

     private func thenAPICallSucceeded() {
         XCTAssertNil(self.error)
     }

    // MARK: - Others
     private func generateURLResponse(httpCode: Int) -> HTTPURLResponse {
         HTTPURLResponse(url: request.url!, statusCode: httpCode, httpVersion: nil, headerFields: nil)!
     }

     private func requestSucceded(_ statusCode: Int) {
         givenAPICaller(httpCode: statusCode)
         whenMakingAPICall(request: request)
         thenAPICallSucceeded()
     }

     private func requestFailed(_ statusCode: Int) {
         givenAPICaller(httpCode: statusCode)
         whenMakingAPICall(request: request)
         thenAPICallFailed(with: statusCode)
     }
 }
