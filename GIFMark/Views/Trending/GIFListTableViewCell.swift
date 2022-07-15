//
//  GIFListTableViewCell.swift
//  GIFMark
//
//  Created by Lal Castro on 15/07/22.
//

import UIKit
import FLAnimatedImage



class GIFListTableViewCell: UITableViewCell {
    
    var gifImageView: FLAnimatedImageView!
    var imageUrl: String?
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
        imageUrl = nil
        gifImageView.animatedImage = nil
        gifImageView.stopAnimating()
        gifImageView.backgroundColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        gifImageView = FLAnimatedImageView.init()
        gifImageView.contentMode = .scaleToFill
        self.contentView.addSubview(gifImageView)
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateLayouts() {
        gifImageView.leadingSpace(constant: 10).trailingSpace(constant: -10).topSpace(constant: 10).bottomSpace(constant: -10).heightConstraint(constant: 200)
    }
    
    func updateCell(for GIF: [String: Any]) {
        gifImageView.backgroundColor = UIColor.getRandomColor()
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
    
    func setImageWithData(data: Data?) {
        if let data = data {
            let image = FLAnimatedImage.init(animatedGIFData: data)
            self.gifImageView.animatedImage = image
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

