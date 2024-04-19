//
//  ImageCrowlerVC.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 16/04/24.
//

import UIKit

class ImageCrowlerVC: UIViewController {
    
    // view components
    var collectionView: UICollectionView!
    var viewModel: ImageCrowlerVM!
    var refreshControl: UIRefreshControl!
    var paginationLoaderView: PaginationLoaderView?
    
    class func `init`() -> UIViewController {
        let vc = ImageCrowlerVC()
        vc.viewModel = ImageCrowlerVM(apiService: ImageCrowlerAPIServiceDefaultImpl())
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.setupNavigationBar()
        self.layoutViewComponents()
        self.dataBinding()
        self.collectionView.reloadData()
        self.viewModel.fetchFeeds()
        self.view.showLoader(.black)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.barTintColor = .gray
        navigationController?.navigationBar.tintColor = .gray
    }
    
    @objc func refreshData() {
        self.viewModel.refreshData()
        self.viewModel.fetchFeeds()
    }
    
    func loadMoreData(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
           startBottomLoader()
            self.viewModel.fetchFeeds()
        }
    }
    
    private func startBottomLoader() {
        paginationLoaderView?.startAnimating()
        self.view.layoutIfNeeded()
    }
    
    private func stopBottomLoader() {
        UIView.animate(withDuration: 0.4) {
            self.paginationLoaderView?.stopAnimating()
            self.view.layoutIfNeeded()
        }
    }
    private func setupNavigationBar() {
        self.navigationItem.title = "Image Crowler"
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.barTintColor = .gray
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.addBottomLine()
    }
}

extension ImageCrowlerVC {
    func dataBinding() {
        self.viewModel.apiError.bind { [weak self] error in
            DispatchQueue.main.async {
                Toast.showErrorMessage(error: error ?? NetworkError.SomethingWentWrong)
                self?.refreshControl.endRefreshing()
                self?.stopBottomLoader()
                self?.view.removeLoader()
            }
        }
        self.viewModel.newlyAddedIndexPaths.bind {[weak self] indexPaths in
            guard let self else { return }
            DispatchQueue.main.async {
                if indexPaths.count == 0 {
                    self.collectionView.reloadData()
                    return
                }
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: indexPaths)
                }, completion: nil)
                self.refreshControl.endRefreshing()
                self.view.removeLoader()
                self.stopBottomLoader()
            }
        }
    }
}
