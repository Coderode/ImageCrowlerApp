//
//  File.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 20/04/24.
//

import Foundation
import UIKit

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
    func layoutViewComponents() {
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
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topSafeArea + navigationBarHeight).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCrowlerGridCVC.self, forCellWithReuseIdentifier: "\(ImageCrowlerGridCVC.self)")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.gray
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        let loaderView = PaginationLoaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        self.view.addSubview(loaderView)
        self.paginationLoaderView = loaderView
        
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bottomAnchor.constraint(equalTo: loaderView.topAnchor, constant: 0).isActive = true
        loaderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: bottomSafeArea).isActive = true
        loaderView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        loaderView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
    }
}
