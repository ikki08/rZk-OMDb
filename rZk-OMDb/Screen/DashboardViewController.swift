//
//  DashboardViewController.swift
//  rZk-OMDb
//
//  Created by Rizki on 08/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var dataTableView: UITableView!
    
    private var viewModel: DashboardViewModel?
    
    // MARK: ViewController Lifecycle
    
    init(viewModel: DashboardViewModel) {
        super.init(nibName: "DashboardViewController", bundle: nil)
        
        self.viewModel = viewModel
        self.viewModel?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        initialLoad()
    }
    
    // MARK: Private
    
    private func setupTableView() {
        dataTableView.register(UINib(nibName: "VideoCell", bundle: nil),
                               forCellReuseIdentifier: "videoCell")
        
        dataTableView.tableFooterView = UIView()
        dataTableView.dataSource = self
    }
    
    private func initialLoad() {
        showLoading()
        viewModel?.searchVideo(term: "test")
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.videoList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell",
                                                 for: indexPath) as! VideoCell
        
        guard let `viewModel` = viewModel else { return cell }
        
        if viewModel.videoList.count > 0 {
            let videoData = viewModel.videoList[indexPath.row]
            cell.setup(with: videoData)
        }
        
        return cell
    }
}

extension DashboardViewController: DashboardVMDelegate {
    func searchDidSucceed() {
        dataTableView.reloadData()
        dismissLoading()
    }
    
    func searchDidFail() {
        dismissLoading()
        showAlert()
    }
}
