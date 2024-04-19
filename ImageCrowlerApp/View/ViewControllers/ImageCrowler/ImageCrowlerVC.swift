//
//  ImageCrowlerVC.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 16/04/24.
//

import UIKit

class ImageCrowlerVC: UIViewController {
    
    var collectionView: UICollectionView!
    var viewModel: ImageCrowlerVM!
    var refreshControl: UIRefreshControl!
    var paginationLoaderView: PaginationLoaderFooterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.navigationItem.title = "Image Crowler"
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.barTintColor = .gray
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.addBottomLine()
        self.setupCollectionView()
        self.dataBinding()
        self.collectionView.reloadData()
        self.viewModel.fetchFeeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.barTintColor = .gray
        navigationController?.navigationBar.tintColor = .gray
    }
    
    class func `init`() -> UIViewController {
        let vc = ImageCrowlerVC()
        vc.viewModel = ImageCrowlerVM(apiService: ImageCrowlerAPIServiceDefaultImpl())
        return vc
    }
    
    func dataBinding() {
        self.viewModel.apiError.bind { [weak self] error in
            DispatchQueue.main.async {
                Toast.showErrorMessage(error: error ?? NetworkError.SomethingWentWrong)
                self?.refreshControl.endRefreshing()
                self?.paginationLoaderView?.stopAnimating()
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
                self.paginationLoaderView?.stopAnimating()
            }
        }
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
            paginationLoaderView?.startAnimating()
            self.viewModel.fetchFeeds()
        }
    }
}

extension ImageCrowlerVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.feeds.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCrowlerGridCVC.self), for: indexPath) as! ImageCrowlerGridCVC
        cell.setData(thumbnail: self.viewModel.feeds.value[indexPath.row].thumbnail)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImageDetailViewerVC.`init`(data: self.viewModel.feeds.value[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: self.viewModel.isLoadingAPI ? 80 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: PaginationLoaderFooterView.self), for: indexPath) as? PaginationLoaderFooterView else { return UICollectionReusableView() }
            self.paginationLoaderView = footerView
            if self.viewModel.isLoadingAPI {
                self.paginationLoaderView?.startAnimating()
            }
            return footerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ImageCrowlerGridCVC, let operation = cell.imageLoadOperation {
            // cancel the image load operation for currently not visible cell
            operation.cancel()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.viewModel.feeds.value.count > 0 {
            loadMoreData(scrollView: scrollView)
        }
    }
}

extension ImageCrowlerVC {
    func setupCollectionView() {
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let topSafeArea = statusBarHeight + (view.window?.safeAreaInsets.top ?? 0)
        let bottomSafeArea = view.window?.safeAreaInsets.bottom ?? 0
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        let width = (view.frame.width - 6) / 3
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: bottomSafeArea).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topSafeArea + navigationBarHeight).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCrowlerGridCVC.self, forCellWithReuseIdentifier: "\(ImageCrowlerGridCVC.self)")
        collectionView.register(PaginationLoaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(PaginationLoaderFooterView.self)")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.gray
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        layout.footerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 80)
    }
}
