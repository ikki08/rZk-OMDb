//
//  AppDIContainer.swift
//  rZk-OMDb
//
//  Created by Rizki on 08/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit

class AppDIContainer: NSObject {
    static func createDashBoardVC() -> UIViewController {
        let service = SearchService()
        let viewModel = DashboardViewModel(service: service)
        let dashboardVC = DashboardViewController(viewModel: viewModel)
        
        return dashboardVC
    }
}
