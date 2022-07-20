//
//  ImagePreviewViewController.swift
//  GIFMark
//
//  Created by lal.castro@icloud.com on 15/07/22.
//

import UIKit
import FLAnimatedImage

class ImagePreviewViewController: UIViewController {
    var favouriteButton: UIButton!
    var buttonContainer: UIView!
    var imageView: FLAnimatedImageView!
    var loader: UIActivityIndicatorView!
    var viewModel: GIFViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.title = "PreviewView.Title".localized
    
        let closeButton = UIBarButtonItem.init(image: UIImage.init(systemName: "xmark"), style: .plain, target: self, action: #selector(self.closeView(_:)))
        self.navigationItem.leftBarButtonItem  = closeButton
        
        let share = UIBarButtonItem.init(image: UIImage.init(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(self.share(_:)))
        self.navigationItem.rightBarButtonItem  = share
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.view.backgroundColor = .systemBackground
       
        imageView = FLAnimatedImageView()
        self.view.addSubview(imageView)
        self.imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topSpace(with: self.view.safeTopAnchor, constant: 60).bottomSpace(with: self.view.safeBottomAnchor, constant: -16).leadingSpace().trailingSpace()
        
        buttonContainer = UIView()
        self.view.addSubview(buttonContainer)
        buttonContainer.backgroundColor = .white
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton = UIButton.init(type: .custom)
        favouriteButton.tintColor = UIColor.getRandomColor()
        favouriteButton.setBackgroundImage(UIImage.init(systemName: "heart"), for: .normal)
        favouriteButton.setBackgroundImage(UIImage.init(systemName: "heart.fill"), for: .selected)
        favouriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonContainer.addSubview(favouriteButton)
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.addTarget(self, action: #selector(self.favouriteButtonDidTap(_:)), for: .touchUpInside)
        buttonContainer.topSpace(with: self.view.safeTopAnchor, constant: 16).trailingSpace(constant: -16).heightConstraint(constant: 40).widthConstraint(constant: 40)
        favouriteButton.widthConstraint(constant: 33).heightConstraint(constant: 33).centerXAlign().centerYAlign()
        buttonContainer.layer.cornerRadius = 10
        buttonContainer.clipsToBounds = true
        buttonContainer.layer.borderColor = UIColor.black.cgColor
        buttonContainer.layer.borderWidth = 2.0
        if let id = self.viewModel?.id {
            favouriteButton.isSelected = GIFDataBaseHandler.shared.isFavouriteGIF(id: id)
        }
        else {
            favouriteButton.isSelected = false
        }
        loader = UIActivityIndicatorView.init(style: .large)
        self.view.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerXAlign().centerYAlign()
        loader.hidesWhenStopped = true
        setImage()
    }
    
    @objc func favouriteButtonDidTap(_ sender: Any) {
        favouriteButton.isSelected = !favouriteButton.isSelected
        if let id = self.viewModel?.id {
            NotificationCenter.default.post(name: .updateFavourite, object: nil, userInfo: ["id": id])
        }

        if favouriteButton.isSelected {
            self.viewModel?.addToFavourite()
        }
        else {
            self.viewModel?.removeFromFavourite()
        }
    }
    
    @objc func closeView(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    @objc func share(_ sender: Any) {
        if let data = self.viewModel?.imageData {
            let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            self.navigationController?.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func setImage() {
        if let url = self.viewModel?.originalUrl {
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
        self.viewModel?.imageData = data
    }
}

extension Notification.Name {
    static var updateFavourite = Notification.Name("updateFavourite")
}
