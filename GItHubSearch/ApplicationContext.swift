//
//  ApplicationContext.swift
//  GItHubSearch
//
//  Created by l08084 on 2016/08/18.
//  Copyright © 2016年 l08084. All rights reserved.
//

import Foundation

/// States shared in whole app
class ApplicationContext {
    let github: GitHubAPI = GitHubAPI()
}

protocol ApplicationContextSettable: class {
    var appContext: ApplicationContext! { get set }
}
