//
//  APIQueue.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Alamofire

private let kDifference = 600
private let kSemaphoreCount = 10

class APIQueue {

    // MARK: - Properties
    let apiQueueInterceptor: RequestInterceptor?

    static let shared = APIQueue()

    private(set) var queue: DispatchSemaphore
    private var oldQueues = [Int64: DispatchSemaphore]()

    private init() {
        queue = Self.generateSemaphore()
        apiQueueInterceptor = LinearTooManyRequestRetryPolicy(retryLimit: 10)
    }

    func resetQueue() {
        storeOldQueue(queue)
        queue = Self.generateSemaphore()
    }

    private static func generateSemaphore() -> DispatchSemaphore {
        DispatchSemaphore(value: 10)
    }
}

private extension APIQueue {
    func storeOldQueue(_ queue: DispatchSemaphore) {
        oldQueues[Int64(Date().timeIntervalSince1970)] = queue
        removeOldQueue()
    }

    private func removeOldQueue() {
        DispatchQueue.computation.async { [weak self] in
            let now = Int64(Date().timeIntervalSince1970)
            let oldKeys = self?.oldQueues.keys.filter({ now - $0 > kDifference })
            oldKeys?.forEach { key in
                guard let queue = self?.oldQueues[key] else {
                    return
                }
                for _ in 0 ... kSemaphoreCount * 2 {
                    queue.signal()
                }
                self?.oldQueues.removeValue(forKey: key)
            }
        }
    }
}

// MARK: -

/// A retry policy that automatically retries idempotent requests for network connection lost errors. For more
/// information about retrying network connection lost errors, please refer to Apple's
/// [technical document](https://developer.apple.com/library/content/qa/qa1941/_index.html).
class TooManyRequestRetryPolicy: RetryPolicy {
    /// Creates a `TooManyRequestRetryPolicy` instance from the specified parameters.
    ///
    /// - Parameters:
    ///   - retryLimit:              The total number of times the request is allowed to be retried.
    ///                              `RetryPolicy.defaultRetryLimit` by default.
    ///   - exponentialBackoffBase:  The base of the exponential backoff policy.
    ///                              `RetryPolicy.defaultExponentialBackoffBase` by default.
    ///   - exponentialBackoffScale: The scale of the exponential backoff.
    ///                              `RetryPolicy.defaultExponentialBackoffScale` by default.
    ///   - retryableHTTPMethods:    The idempotent http methods to retry.
    ///                              `RetryPolicy.defaultRetryableHTTPMethods` by default.
    public init(retryLimit: UInt = RetryPolicy.defaultRetryLimit,
                exponentialBackoffBase: UInt = RetryPolicy.defaultExponentialBackoffBase,
                exponentialBackoffScale: Double = RetryPolicy.defaultExponentialBackoffScale,
                retryableHTTPMethods: Set<HTTPMethod> = RetryPolicy.defaultRetryableHTTPMethods) {
        super.init(retryLimit: retryLimit,
                exponentialBackoffBase: exponentialBackoffBase,
                exponentialBackoffScale: exponentialBackoffScale,
                retryableHTTPMethods: [HTTPMethod.post],
                retryableHTTPStatusCodes: [429],
                retryableURLErrorCodes: [])
    }
}

class LinearTooManyRequestRetryPolicy: TooManyRequestRetryPolicy {
    override func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> ()) {
        if request.retryCount < retryLimit, shouldRetry(request: request, dueTo: error) {
            completion(.retryWithDelay(TimeInterval(request.retryCount) + 1.0))
        } else {
            completion(.doNotRetry)
        }
    }
}
