//
//  DashboardViewController.swift
//  rZk-OMDb
//
//  Created by Rizki on 08/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit
import Reachability

class DashboardViewController: UIViewController {
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var videoSearchBar: UISearchBar!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var noInternetLabel: UIView!
    
    private var viewModel: DashboardViewModel?
    private var reachability: Reachability?
    
    // MARK: ViewController Lifecycle
    
    init(viewModel: DashboardViewModel) {
        super.init(nibName: "DashboardViewController", bundle: nil)
        
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        do {
            try self.reachability = Reachability()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noInternetLabel.isHidden = true
        videoSearchBar.delegate = self
        setupTableView()
        setupReachabilityObserver()
        initialLoad()
    }
    
    // MARK: Action
    
    @IBAction func retryButtonTapped(_ sender: Any) {
        if let searchTerm = videoSearchBar.text {
            search(with: searchTerm)
        }
    }
    
    @objc func reachabilityChanged(notification: Notification)  {
        let aReachability = notification.object as! Reachability
        if aReachability.connection != .unavailable {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                
                self.noInternetLabel.isHidden = true
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                
                self.noInternetLabel.isHidden = false
            }
        }
    }
    
    // MARK: Private
        
    private func setupReachabilityObserver() {
        guard let `reachability` = reachability else { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged),
                                               name: .reachabilityChanged, object: reachability)

        do {
            try reachability.startNotifier()
        } catch {
            print("Could not strat notifier")
        }
    }
    
    private func setupTableView() {
        dataTableView.register(UINib(nibName: "VideoCell", bundle: nil),
                               forCellReuseIdentifier: "videoCell")
        dataTableView.register(UINib(nibName: "ShimmerCell", bundle: nil),
                               forCellReuseIdentifier: "shimmerCell")
        
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
        viewModel?.isRequestingToServer = true
        viewModel?.searchVideo(term: term)
        dataTableView.reloadData()
        dataTableView.isScrollEnabled = false
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
        guard let `viewModel` = viewModel else { return 0 }
        if viewModel.isRequestingToServer && viewModel.videoList.count == 0 {
            return 10
        } else {
            return viewModel.videoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let `viewModel` = viewModel else { return UITableViewCell() }
        
        let cell: UITableViewCell
        if viewModel.isRequestingToServer {
            let shimmerCell = tableView.dequeueReusableCell(withIdentifier: "shimmerCell",
                                                            for: indexPath) as! ShimmerCell
            cell = shimmerCell
        } else if viewModel.videoList.count > 0 {
            let videoData = viewModel.videoList[indexPath.row]
            let videoDataCell = tableView.dequeueReusableCell(withIdentifier: "videoCell",
                                                              for: indexPath) as! VideoCell
            videoDataCell.setup(with: videoData, cache: viewModel.imageCache)
            cell = videoDataCell
        } else {
            cell = UITableViewCell()
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
            
            self.viewModel?.isRequestingToServer = false
            self.dataTableView.isScrollEnabled = true
            self.dataTableView.reloadData()
        }
    }
    
    func searchDidFail(with message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.viewModel?.isRequestingToServer = false
            self.errorMessageLabel.text = message
            self.errorView.isHidden = false
            self.dataTableView.isHidden = true
            self.dataTableView.isScrollEnabled = true
        }
    }
}
