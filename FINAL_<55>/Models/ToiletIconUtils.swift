//
//  ToiletIconUtils.swift
//  FINAL_<55>
//
//  Created by haoning yin on 11/29/24.
//

import Foundation

enum ToiletIconUtils {
    static func iconName(for type: String) -> String {
        switch type {
        case "Public":
            return "public"
        case "Tampon":
            return "Tampon"
        case "Password":
            return "Password"
        case "Accessible":
            return "Accessible"
        default:
            return "questionmark"
        }
    }
}
