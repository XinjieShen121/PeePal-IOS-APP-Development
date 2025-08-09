//
//  ReportedToilet.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 12/1/24.
//

import Foundation

struct ReportedToilet {
    enum Status {
        case underReview
        case deleted
        case unknown
    }

    let id: String
    let name: String
    let reportReason: String
    var status: Status
}
