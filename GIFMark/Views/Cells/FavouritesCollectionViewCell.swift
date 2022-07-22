//
//  FavouritesCollectionViewCell.swift
//  GIFMark
//
//  Created by lal.castro@icloud.com on 20/07/22.
//

import UIKit
import FLAnimatedImage

class FavouritesCollectionViewCell: UICollectionViewCell {
    var gifImageView: FLAnimatedImageView!
    var viewModel: GIFViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        gifImageView.animatedImage = nil
        gifImageView.stopAnimating()
        gifImageView.backgroundColor = .systemGray
    }
    
    private func initViews() {
        gifImageView = FLAnimatedImageView.init()
        gifImageView.contentMode = .scaleToFill
        self.contentView.addSubview(gifImageView)
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        gifImageView.spaceAround()
    }
    
    func updateCell(for viewModel: GIFViewModel?) {
        self.viewModel = viewModel
        gifImageView.backgroundColor = UIColor.getRandomColor()
        if let imageData = self.viewModel?.imageData {
            self.setImageWithData(data: imageData)
        }
        else if let url = self.viewModel?.imageUrl {
            let data = ImageDownloadCache.downloadImage(urlStr: url, completion: { data, url in
                if self.viewModel?.imageUrl == url {
                    self.setImageWithData(data: data)
                }
            })
            self.setImageWithData(data: data)
        }
    }
    private func setImageWithData(data: Data?) {
        if let data = data {
            self.viewModel?.imageData = data
            let image = FLAnimatedImage.init(animatedGIFData: data)
            self.gifImageView.animatedImage = image
        }
    }
}
