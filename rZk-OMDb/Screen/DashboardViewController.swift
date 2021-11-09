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
    @IBOutlet weak var videoSearchBar: UISearchBar!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
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

        videoSearchBar.delegate = self
        setupTableView()
        initialLoad()
    }
    
    // MARK: Action
    
    @IBAction func retryButtonTapped(_ sender: Any) {
        if let searchTerm = videoSearchBar.text {
            search(with: searchTerm)
        }
    }
    
    // MARK: Private
    
    private func setupTableView() {
        dataTableView.register(UINib(nibName: "VideoCell", bundle: nil),
                               forCellReuseIdentifier: "videoCell")
        
        dataTableView.tableFooterView = UIView()
        dataTableView.dataSource = self
        dataTableView.delegate = self
    }
    
    private func initialLoad() {
        search(with: "test")
    }
    
    private func search(with term: String) {
        errorView.isHidden = true
        dataTableView.isHidden = false

        viewModel?.searchVideo(term: term)
    }
}

extension DashboardViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            initialLoad()
        } else {
            viewModel?.clearVideoList()
            dataTableView.reloadData()
            search(with: searchText)
        }
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.videoList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell",
                                                 for: indexPath) as! VideoCell
        
        guard let `viewModel` = viewModel else { return cell }
        
        if viewModel.videoList.count > 0 {
            let videoData = viewModel.videoList[indexPath.row]
            cell.setup(with: videoData, cache: viewModel.imageCache)
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension DashboardViewController: DashboardVMDelegate {
    func searchDidSucceed() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.dataTableView.reloadData()
        }
    }
    
    func searchDidFail(with message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.errorMessageLabel.text = message
            self.errorView.isHidden = false
            self.dataTableView.isHidden = true
        }
    }
}
