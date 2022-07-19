//
//  GIFListTableViewCell.swift
//  GIFMark
//
//  Created by lal.castro@icloud.com on 15/07/22.
//

import UIKit
import FLAnimatedImage



class GIFListTableViewCell: UITableViewCell {
    
    var gifImageView: FLAnimatedImageView!
    var imageUrl: String?
    var favouriteButton: UIButton!
    var buttonContainer: UIView!
    var id: String?
    var imageData: Data?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
        updateLayouts()
    }
    
    override func prepareForReuse() {
        favouriteButton.isSelected = false
        imageUrl = nil
        gifImageView.animatedImage = nil
        gifImageView.stopAnimating()
        gifImageView.backgroundColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initViews() {
        let randomColor = UIColor.getRandomColor()
        gifImageView = FLAnimatedImageView.init()
        gifImageView.contentMode = .scaleToFill
        self.contentView.addSubview(gifImageView)
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer = UIView()
        self.contentView.addSubview(buttonContainer)
        buttonContainer.backgroundColor = .white
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton = UIButton.init(type: .custom)
        favouriteButton.tintColor = randomColor
        favouriteButton.setBackgroundImage(UIImage.init(systemName: "heart"), for: .normal)
        favouriteButton.setBackgroundImage(UIImage.init(systemName: "heart.fill"), for: .selected)
        favouriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonContainer.addSubview(favouriteButton)
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.addTarget(self, action: #selector(self.favouriteButtonDidTap(_:)), for: .touchUpInside)
    }
    
    @objc func favouriteButtonDidTap(_ sender: Any) {
        favouriteButton.isSelected = !favouriteButton.isSelected
        if let id = id {
            if favouriteButton.isSelected {
                GIFDataBaseHandler.shared.addToFavourites(id: id, data: self.imageData)
            }
            else {
                GIFDataBaseHandler.shared.removeFromFavourites(id: id)
            }
        }
    }
    
    func updateLayouts() {
        gifImageView.leadingSpace(constant: 10).trailingSpace(constant: -10).topSpace(constant: 10).bottomSpace(constant: -10).heightConstraint(constant: 200)
        buttonContainer.topSpace(constant: 16).trailingSpace(constant: -16).heightConstraint(constant: 40).widthConstraint(constant: 40)
        favouriteButton.widthConstraint(constant: 33).heightConstraint(constant: 33).centerXAlign().centerYAlign()
        buttonContainer.layer.cornerRadius = 10
        buttonContainer.clipsToBounds = true
        buttonContainer.layer.borderColor = UIColor.black.cgColor
        buttonContainer.layer.borderWidth = 2.0
    }
    
    func updateCell(for GIF: [String: Any]) {
        gifImageView.backgroundColor = UIColor.getRandomColor()
        if let id = GIF["id"] as? String {
            self.id = id
            self.favouriteButton.isSelected = GIFDataBaseHandler.shared.isFavouriteGIF(id: id)
            if let images = GIF["images"] as? [String: Any], let preview = images["preview_gif"] as? [String: Any], let url = preview["url"] as? String {
                self.imageUrl = url
                let data = ImageDownloadCache.downloadImage(urlStr: url, completion: { data, url in
                    if self.imageUrl == url {
                        self.setImageWithData(data: data)
                    }
                })
                self.setImageWithData(data: data)
            }
        }
        
    }
    
    func setImageWithData(data: Data?) {
        if let data = data {
            self.imageData = data
            let image = FLAnimatedImage.init(animatedGIFData: data)
            self.gifImageView.animatedImage = image
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

