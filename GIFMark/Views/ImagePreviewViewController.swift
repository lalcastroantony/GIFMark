//
//  ImagePreviewViewController.swift
//  GIFMark
//
//  Created by Lal Castro on 15/07/22.
//

import UIKit
import FLAnimatedImage

class ImagePreviewViewController: UIViewController {
    var imageView: FLAnimatedImageView!
    var gifData: [String: Any]?
    var loader: UIActivityIndicatorView!
    var imageData: Data?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        self.title = "PreviewView.Title".localized
    
        let closeButton = UIBarButtonItem.init(image: UIImage.init(systemName: "xmark"), style: .plain, target: self, action: #selector(self.closeView(_:)))
        self.navigationItem.leftBarButtonItem  = closeButton
        
        let share = UIBarButtonItem.init(image: UIImage.init(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(self.share(_:)))
        self.navigationItem.rightBarButtonItem  = share
        self.navigationItem.rightBarButtonItem?.isEnabled = false
//        self.navigationController?.navigationBar.l
        
        self.view.backgroundColor = .systemBackground
       
        imageView = FLAnimatedImageView()
        self.view.addSubview(imageView)
        self.imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = UIColor.getRandomColor()
        imageView.topSpace(with: self.view.safeTopAnchor).bottomSpace(with: self.view.bottomAnchor).leadingSpace().trailingSpace()
        
        loader = UIActivityIndicatorView.init(style: .large)
        self.view.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerXAlign().centerYAlign()
        loader.hidesWhenStopped = true
        setImage()
    }
    
    @objc func closeView(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    @objc func share(_ sender: Any) {
        if let data = imageData {
            let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            self.navigationController?.present(activityVC, animated: true, completion: nil)
        }
     
//        self.navigationController?.dismiss(animated: true)
    }
    
    func setImage() {
        if let images = gifData?["images"] as? [String: Any], let original = images["original"] as? [String: Any], let url = original["url"] as? String {
            loader.startAnimating()
            if let imageData = ImageDownloadCache.downloadImage(urlStr: url, completion: { [weak self] data, url in
                self?.setupAnimatedImage(data: data)
            }) {
                self.setupAnimatedImage(data: imageData)
            }
        }
        
        
    }
    
    func setupAnimatedImage(data: Data?) {
        self.loader.stopAnimating()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        let image = FLAnimatedImage.init(animatedGIFData: data)
        self.imageView?.animatedImage = image
        self.imageData = data
        
     
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
