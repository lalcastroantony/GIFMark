//
//  FavouritesViewController.swift
//  GIFMark
//
//  Created by lal.castro@icloud.com on 15/07/22.
//

import UIKit


/// This ViewController is responsible for showing the favourite GIF's user saved.
class FavouritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setupViews()
    }

    
    /// This will setup child views
    func setupViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .systemBackground
        self.title = "FavouritesView.title".localized
    }

}
