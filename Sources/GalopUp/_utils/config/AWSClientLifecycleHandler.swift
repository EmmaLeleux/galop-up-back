//
//  AwsClient.swift
//  GalopUp
//
//  Created by Emma on 01/10/2026.
//

import Vapor
import SotoCore

struct AWSClientLifecycleHandler: LifecycleHandler {
    let awsClient: AWSClient

    func shutdown(_ application: Application) {
        try? awsClient.syncShutdown()
    }
}
