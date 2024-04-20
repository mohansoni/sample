//
//  ViewController.swift
//  Sample
//
//  Created by Mohan Soni on 18/04/24.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    // MARK:  Properties
    var profileImageArr = [String]()
    var asyncImagesCashArray = NSCache<NSString, UIImage>()
    private var currentURL: NSString?
    let clientId = "J-7qx3xAMSI0bCeo1NsOWAxAbryQNgQ5WeQwhuN353g"
    let placeholder = UIImage(named: "placeholder.jpg")
    
    // MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
    }
}

// MARK: - Private methods (API call + asyncImageLoad)
extension ViewController {
    private func getUserData() {
        var request = URLRequest(url: URL(string: "https://api.unsplash.com/photos/?client_id=\(clientId)")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let decoder = JSONDecoder()
                if let data = data,
                   let userData = try? JSONDecoder().decode(UserModel.self, from: data) {
                    
                    for obj in userData {
                        self.profileImageArr.append(obj.user.profileImage.large ?? "")
                    }
                }
                DispatchQueue.main.async {
                    // MARK: - As the profile array count marks 10, Copied the same data twice. Below is the code.
                    let copy = self.profileImageArr
                    for _ in 0..<2 {
                        self.profileImageArr.append(contentsOf: copy)
                    }
                    
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                }
            }
        })
        
        task.resume()
    }
    
    private func loadAsyncFrom(url: String, imgView: UIImageView) {
        let imageURL = url as NSString
        if let cashedImage = asyncImagesCashArray.object(forKey: imageURL) {
            imgView.image = cashedImage
            return
        }
        imgView.image = placeholder
        currentURL = imageURL
        guard let requestURL = URL(string: url) else { imgView.image = placeholder; return }
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if error == nil {
                    if let imageData = data {
                        if self.currentURL == imageURL {
                            if let imageToPresent = UIImage(data: imageData) {
                                self.asyncImagesCashArray.setObject(imageToPresent, forKey: imageURL)
                                imgView.image = imageToPresent
                            } else {
                                imgView.image = self.placeholder
                            }
                        }
                    } else {
                        imgView.image = UIImage(named: "ImageError")
                    }
                } else {
                    imgView.image = UIImage(named: "NetworkError")
                }
            }
        }.resume()
    }
}

// MARK: - UICollectionViewDataSource Methods
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        self.loadAsyncFrom(url: profileImageArr[indexPath.row], imgView: cell.displayImg)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        
        let size: CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size + 15)
    }
    
}
