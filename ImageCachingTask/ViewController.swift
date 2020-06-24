//
//  ViewController.swift
//  AssignedTask1MG
//
//  Created by neelam panwar on 24/06/20.
//  Copyright © 2020 neelam panwar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK::- IBOutlets
    @IBOutlet weak var searchBar: UISearchBar?{
        didSet{
            searchBar?.delegate = self
        }
    }
    @IBOutlet weak var collectionView: UICollectionView?{
        didSet{
            collectionView?.delegate = self
            collectionView?.dataSource = self
        }
    }
    
    //MARK::- Properties
    var photoData : PhotoModel?
    private let refreshControl = UIRefreshControl()
    var currentPageCount : Int = 1
    var pagingStatus : InfiniteScrollStatus = .finishedLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshApiPaging(_:)), for: .valueChanged)
        getPhotosWebService()
    }
}


//MARK::- COllectionView DataSource and Delegate Implementation
extension ViewController : UICollectionViewDataSource , UICollectionViewDelegate  , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (photoData?.photosList?.count == 0 || photoData == nil) ? collectionView.setBgPlaceholderMessage("Welcome, Search Images here") : collectionView.restoreBg()
        return photoData?.photosList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.reuseableIdentifier, for: indexPath) as? PhotoCollectionCell else { return UICollectionViewCell()}
        cell.photoUrl = self.photoData?.photosList?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (ScreenSize.SCREEN_WIDTH - 48 )/2
        let height = width + 48
        return CGSize(width : width, height : height)
    }
    
    /////Infinite  Page Scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if refreshControl.isRefreshing {
            return // To terminate paging if Pull to Refresh is called
        }
        
        switch pagingStatus {
        case .noData , .loading:
        return // To terminate paging if api loading or there is no more data
        case .finishedLoading :
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            
            if offsetY > contentHeight - scrollView.frame.size.height {
                self.pagingStatus = .loading
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.currentPageCount = self.currentPageCount + 1
                    self.getPhotosWebService()
                }
            }
        }
    }
}

//MARK::- API Call
extension ViewController {
    
    func getPhotosWebService(){
        
        let apiURL = constructAPIURL(searchKeyword: searchBar?.text ?? "", page: currentPageCount , perPageItem: 10)
        
        let session = URLSession(configuration: .default)
        var dataTask : URLSessionDataTask?
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: apiURL, completionHandler: { [weak self](data, response, error) in
            if error != nil{
                self?.alert(message: error?.localizedDescription ?? "Api Failure", title: "Error")
            }else if let data = data ,(response as? HTTPURLResponse)?.statusCode == 200{
                do{
                    let decoder = JSONDecoder()
                    let respData = try decoder.decode(PhotoMainModel.self, from: data)
                    if self?.currentPageCount == 1{
                        self?.photoData = nil
                        self?.photoData = respData.photos
                    }else {
                        let photoList = (self?.photoData?.photosList ?? []) + (respData.photos?.photosList ?? [])
                        self?.photoData?.photosList = photoList
                    }
                    DispatchQueue.main.async {
                        self?.refreshControl.endRefreshing()
                        self?.collectionView?.reloadData()
                    }
                    self?.pagingStatus = self?.photoData?.photosList?.count == respData.photos?.totalPagesCount ? .noData : .finishedLoading
                }
                catch{
                    debugPrint("Data Failed to Map")
                }
            }
        })
        dataTask?.resume()
    }
    
    func constructAPIURL(searchKeyword : String , page : Int , perPageItem : Int) -> URL{
        var urlComponent = URLComponents.init(string: APIConstants.basePath)
        
        //Set Api Query Params
        let apiKey = URLQueryItem.init(name: "api_key", value: APIConstants.apiKey)
        let method = URLQueryItem.init(name: "method", value: "flickr.photos.search")
        let safeSearch = URLQueryItem.init(name: "safe_search", value: "1")
        let searchQuery = URLQueryItem.init(name: "text", value: searchKeyword )
        let responseFormat = URLQueryItem.init(name: "format", value: "json")
        let callBack = URLQueryItem.init(name: "nojsoncallback", value: "1")
        
        let currentPageCounter = URLQueryItem.init(name: "page", value: String(page))
        let perPageItemCounter = URLQueryItem.init(name: "per_page", value: String(perPageItem))
        urlComponent?.queryItems = [method, apiKey ,searchQuery,safeSearch , currentPageCounter , perPageItemCounter , responseFormat , callBack]
        
        return (urlComponent?.url)!
    }
    
    ///Refresh Page
    @objc func refreshApiPaging(_ sender : Any){
        currentPageCount = 1
        getPhotosWebService()
    }
}

//MARK::- Search Bar Delegate Implementation
extension ViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentPageCount = 1
        getPhotosWebService()
    }
}
