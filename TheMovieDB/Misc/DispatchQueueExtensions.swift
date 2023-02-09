//
//  DispatchQueueExtensions.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift

enum RxSchedulerLayerType {
    case useCase
    case viewModel
    case viewController
    case remoteDataSource
    case localDataSource

    var label: String {
        get {
            return "\(Bundle.main.bundleIdentifier ?? "")_\(self.labelSuffix)"
        }
    }

    var labelSuffix: String {
        switch self {
        case .useCase: return "_rx_use-case"
        case .viewModel: return "_rx_view-model"
        case .viewController: return "_rx_view-controller"
        case .remoteDataSource: return "_rx_datasource-remote"
        case .localDataSource: return "_rx_datasource-local"
        }
    }
}

extension DispatchQueue {
    // @formatter:off
    static var io: DispatchQueue                        = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_io", qos: .userInitiated, attributes: .concurrent)
    static var apiSerialization: DispatchQueue          = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_api_serialization", qos: .utility, attributes: .concurrent)
    static var apiRequest: DispatchQueue                = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_api_request", qos: .utility, attributes: .concurrent)
    static var apiDispatch : DispatchQueue              = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_api_request_semaphore", qos: .userInitiated, attributes: .concurrent)
    static var backgroundDownload: DispatchQueue        = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_background_download", qos: .background, attributes: .concurrent)
    static var realm: DispatchQueue                     = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_realm", qos: .userInitiated)
    static var realmBackground: DispatchQueue           = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_realm_background", qos: .background)
    static var computation: DispatchQueue               = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_computation", qos: .utility, attributes: .concurrent)
    static var backgroundQuestionCreator: DispatchQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_background_question_creator", qos: .background, attributes: .concurrent)
    // @formatter:on

    static func rxSchedulerComputation(for type: RxSchedulerLayerType) -> SerialDispatchQueueScheduler {
        rxScheduler(for: type, queue: DispatchQueue.computation)
    }

    static func rxSchedulerIo(for type: RxSchedulerLayerType) -> SerialDispatchQueueScheduler {
        rxScheduler(for: type, queue: DispatchQueue.io)
    }

    @available(*, deprecated, message: "Use rxScheduler:forLabelSuffix instead")
    static func rxScheduler(for type: RxSchedulerLayerType, queue: DispatchQueue) -> SerialDispatchQueueScheduler {
        SerialDispatchQueueScheduler(
                queue: queue,
                internalSerialQueueName: type.label
        )
    }

    static func rxScheduler(forLabelSuffix type: RxSchedulerLayerType, queue: DispatchQueue) -> SerialDispatchQueueScheduler {
        SerialDispatchQueueScheduler(
                queue: queue,
                internalSerialQueueName: "\(queue.label)\(type.labelSuffix)"
        )
    }

    enum toMain {
        static func async(_ action: @escaping () -> Void) {
            if Thread.isMainThread {
                action()
            } else {
                DispatchQueue.main.async {
                    action()
                }
            }
        }

        static func asyncAfter(deadline: DispatchTime, _ action: @escaping () -> Void) {
            if Thread.isMainThread {
                action()
            } else {
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    action()
                }
            }
        }
    }
}
