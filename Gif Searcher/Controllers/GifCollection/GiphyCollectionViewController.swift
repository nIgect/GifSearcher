//
//  GiphyCollectionViewController.swift
//  GiphyApi
//
//  Copyright © 2018 Stas Taraseivch. All rights reserved.
//

import UIKit
import SwiftyGif
import SVProgressHUD
class GiphyCollectionViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var gifCollectionView: UICollectionView!
    
    
    //MARK: - Properties
    var gifs = [GifModel]()
    var filtredGifs = [GifModel]()
    var isFiltred = false
    
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gifCollectionView.delegate = self
        self.gifCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getGifs()
    }
    
    //MARK: - Selectors
    
  private func getGifs() {
        
        ServerManager.shared.getTrendingGifs { (success, response, errorString) in
            if success {
                response["data"].arrayValue.forEach({ (trendingGif) in
                    let gif = GifModel.init(title: trendingGif["title"].stringValue,
                                            url: trendingGif["images"]["original"]["url"].stringValue,
                                            width: trendingGif["images"]["original"]["width"].stringValue,
                                            height: trendingGif["images"]["original"]["height"].stringValue,
                                            id: trendingGif["id"].intValue)
                    
                 //    print(trendingGif["title"].stringValue)
                    self.gifs.append(gif)
                })
                
                DispatchQueue.main.async {
                    self.gifCollectionView.reloadData()
                }
            } else {
                print(errorString)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.isFiltred = true
        self.filtredGifs.removeAll()
      //  SVProgressHUD.show()
        ServerManager.shared.gifSearch(stringForSearch: searchBar.text!) { (success, response, errorString) in
//            print("___")
//            print(searchBar.text!)
//            print("___")

          //  SVProgressHUD.dismiss()
            if success {
                response["data"].arrayValue.forEach({ (searchGif) in
                    let gif = GifModel.init(title: searchGif["title"].stringValue,
                                            url: searchGif["images"]["original"]["url"].stringValue,
                                            width: searchGif["images"]["original"]["width"].stringValue,
                                            height: searchGif["images"]["original"]["height"].stringValue,
                                            id: searchGif["id"].intValue)
                    
                   
                  
                        self.filtredGifs.append(gif)
                    })

                DispatchQueue.main.async {
                    self.gifCollectionView.reloadData()
                    
                }

              
            } else {
                print(errorString)
            }
        }
    }
    
    
    //MARK: - Actions
    @IBAction func gifSearchAction(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        DispatchQueue.main.async {
            self.present(searchController, animated: true, completion: nil)
        }
        
        
    }

}

//MARK: - Extension UICollectionViewDataSource
extension GiphyCollectionViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltred {
            return self.filtredGifs.count
        }
        return self.gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        let gif : GifModel
        
        if isFiltred {
            print(isFiltred)
             gif = self.filtredGifs[indexPath.row]
        } else {
             gif = self.gifs[indexPath.row]
        }
       
        
//        do {
//            let gifData = try Data.init(contentsOf: URL(string: gif.url + "?api_key=\(ServerManager.shared.apiKey)")!)
//        } catch let error {
//            print(error)
//        }
        cell.gifImageOutlet.setGifFromURL(URL(string: gif.url + "?api_key=\(ServerManager.shared.apiKey)")!)
        
//        let imageURL = UIImage.gifImageWithURL(gifUrl: gif.url + "?api_key=\(ServerManager.shared.apiKey)")
//        cell.backgroundColor = .red
//        let imageView = UIImageView(image: imageURL)
//
//        imageView.frame = CGRect(x: 0, y: 0, width: CGFloat(Int(gif.width)!), height: CGFloat(Int(gif.height)!))
//
//        cell.gifImageOutlet = imageView
        
        return cell
    }
}


//MARK: - Extension UICollectionViewDataSource
extension GiphyCollectionViewController : UICollectionViewDelegate {
  

}

//MARK: - Extension UICollectionViewDelegateFlowLayou
extension GiphyCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
         let gif = self.gifs[indexPath.row]
       
         return CGSize(width: CGFloat(Int(gif.width)!), height: CGFloat(Int(gif.height)!))
    }
}

//MARK: - Extension UICollectionViewDataSource
extension GiphyCollectionViewController :  UISearchBarDelegate {
    
}
