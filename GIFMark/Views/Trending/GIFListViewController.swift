//
//  GIFListViewController.swift
//  GIFMark
//
//  Created by lal-7695 on 15/07/22.
//

import UIKit


/// This View controller is responsible for showing the list of Trending GIFs and sllowing user to search
class GIFListViewController: UIViewController {
    
    var searchController: UISearchController?
    let viewModel = TrendingViewModel()
    var tableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    var timer: Timer?
    var searchQuery: String? {
        didSet {
            if let searchQuery = searchQuery, !searchQuery.isEmpty {
                if viewModel.GIFs.value.count == 0 {
                    activityIndicator.startAnimating()
                }
                viewModel.search(for: searchQuery) {
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .systemBackground
        setupViews()
        setupBinders()
        loadData()
    }
    
    func loadData() {
        if !viewModel.isSearching {
            activityIndicator.startAnimating()
            viewModel.getTrendingGifs {
            }
        }
    }
    
    /// This will setup child views
    func setupViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "ListView.NavigationTitle".localized
        setupSearchController()
                
        tableView = UITableView.init()
        self.view.addSubview(tableView)
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingSpace().trailingSpace().topSpace().bottomSpace()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GIFListTableViewCell.self, forCellReuseIdentifier: "gifCell")
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        activityIndicator = UIActivityIndicatorView.init(style: .large)
        self.tableView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.topSpace(constant: 100).centerXAlign()
        activityIndicator.hidesWhenStopped = true
        
        self.tabBarController?.delegate = self
    }
    
    func getFooterView() -> UIView? {
        if (searchQuery?.isValidSearch ?? false && viewModel.GIFs.value.count > 0) || viewModel.isSearching == false {
            let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
            let bottomSpinner = UIActivityIndicatorView.init(style: .medium)
            bottomSpinner.center = footerView.center
            footerView.addSubview(bottomSpinner)
            bottomSpinner.startAnimating()
            return footerView
        }
        return nil
    }
    
    func setupSearchController() {
        let searchResultsController = GIFListViewController()
        searchResultsController.viewModel.isSearching = true
        searchController = UISearchController.init(searchResultsController: searchResultsController)
        navigationItem.searchController = searchController
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.placeholder = "SearchBar.PlaceHolder".localized
    }
    
    func setupBinders() {
           viewModel.GIFs.bind { [weak self] message in
               DispatchQueue.main.async {
                   self?.tableView?.reloadData()
               }
           }
       }
}

extension GIFListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, let searchVc = searchController.searchResultsController as? GIFListViewController else {
            return
        }
        timer?.invalidate()
        if text.isValidSearch {
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                searchVc.viewModel.GIFs.value = []
                searchVc.searchQuery = text
            })
        }
        else {
            searchVc.viewModel.GIFs.value = []
        }
    }
}

extension GIFListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.viewModel.GIFs.value.count
        if count > 0 {
            activityIndicator.stopAnimating()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell", for: indexPath) as! GIFListTableViewCell
        cell.updateCell(for: self.viewModel.GIFs.value[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previewVC = ImagePreviewViewController()
        previewVC.gifData = self.viewModel.GIFs.value[indexPath.row]
        self.present(UINavigationController.init(rootViewController: previewVC), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (self.tableView.contentSize.height-scrollView.frame.size.height+150) {
            self.tableView.tableFooterView = getFooterView()
            self.viewModel.paginate {
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                }
            }
        }
    }
}

extension GIFListViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if (viewController as? UINavigationController)?.children[0] == self {
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}
