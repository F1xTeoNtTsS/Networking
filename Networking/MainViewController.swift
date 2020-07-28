//
//  MainViewController.swift
//  Networking
//
//

import UIKit

enum Actions: String, CaseIterable {
    
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download file"
}

private let reuseIdentifier = "Cell"
private let url = "https://jsonplaceholder.typicode.com/posts"
private let uploadImage = "https://api.imgur.com/3/image"

class MainViewController: UICollectionViewController {
    
    let actions = Actions.allCases
    private var alert: UIAlertController!
    private let dataProvider = DataProvider()
    
    private func showAlert() {
        alert = UIAlertController(title: "Downloading...", message: "0 %", preferredStyle: .alert)
        
        let heightConstraint = NSLayoutConstraint(item: alert.view!,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 0,
                                                 constant: 170)
        
        alert.view.addConstraint(heightConstraint)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
            self.dataProvider.stopDowmload()
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true) {
            
            let sizeAI = CGSize(width: 40, height: 40)
            let pointAI = CGPoint(x: self.alert.view.frame.width / 2 - sizeAI.width / 2, y: self.alert.view.frame.height / 2 - sizeAI.height / 2)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: pointAI, size: sizeAI))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2))
            progressView.tintColor = .systemTeal
            
            self.dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + " %"
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
            
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        cell.label.text = actions[indexPath.row].rawValue
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .get:
            NetworkManager.getRequest(url: url)
        case .post:
            NetworkManager.postRequest(url: url)
        case .ourCourses:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .uploadImage:
            NetworkManager.uploadImage(url: uploadImage)
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        }
    }

}
