//
//  Login.swift
//  jlack
//
//  Created by Jack Flintermann on 11/2/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa
import ReSwift

extension AppActions {
    static func login() -> Action {
        let url = URL(string: "https://slack.com/oauth/authorize")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "scope", value: "client"),
            URLQueryItem(name: "client_id", value: "264442459474.263924856769"),
        ]
        NSWorkspace.shared.open(components.url!)
        return AppActions.loginPressed
    }
}
