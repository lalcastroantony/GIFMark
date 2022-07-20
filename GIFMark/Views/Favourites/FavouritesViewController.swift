//
//  FavouritesViewController.swift
//  GIFMark
//
//  Created by lal.castro@icloud.com on 15/07/22.
//

import UIKit
import CoreData


/// This ViewController is responsible for showing the favourite GIF's user saved.
class FavouritesViewController: UIViewController {
    var segmentedController: UISegmentedControl!
    var collectionView: UICollectionView!
    var SCREEN_WIDTH = UIScreen.main.bounds.size.width
    var SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    
    private lazy var listCVLayout: UICollectionViewFlowLayout = {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionFlowLayout.itemSize = CGSize(width: SCREEN_WIDTH, height: 200)
        collectionFlowLayout.minimumInteritemSpacing = 0
        collectionFlowLayout.minimumLineSpacing = 5
        collectionFlowLayout.scrollDirection = .vertical
        return collectionFlowLayout
    }()
    
    private lazy var gridCVLayout: UICollectionViewFlowLayout = {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionFlowLayout.itemSize = CGSize(width: (SCREEN_WIDTH - 32 - 10)/3, height: (SCREEN_WIDTH - 32 - 10)/3)
        collectionFlowLayout.minimumInteritemSpacing = 5
        collectionFlowLayout.minimumLineSpacing = 5
        return collectionFlowLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.performWithoutAnimation {
            do {
                try fetchResultsController.performFetch()
                self.collectionView.reloadData()
            } catch let error as NSError {
                print("Fetching error: \(error), \(error.userInfo)")
            }
        }
    }
    
    lazy var fetchResultsController: NSFetchedResultsController<GIFEntity> = {
        let fetchRequest = GIFEntity.fetchRequest()
        fetchRequest.sortDescriptors = []
        let fetchResultsController = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: GIFDataBaseHandler.shared.coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: "gifs")
        fetchResultsController.delegate = self
        return fetchResultsController
    }()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    
    
    /// This will setup child views
    func setupViews() {
        SCREEN_WIDTH = self.view.frame.size.width
        SCREEN_HEIGHT = self.view.frame.size.height
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .systemBackground
        self.title = "FavouritesView.title".localized
        segmentedController = UISegmentedControl.init(items: ["Favourites.List".localized, "Favourites.grid".localized])
        self.view.addSubview(segmentedController)
        segmentedController.selectedSegmentIndex = 0
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        segmentedController.leadingSpace(constant: 16).trailingSpace(constant: -16).topSpace(with: self.view.safeTopAnchor, constant: 5).heightConstraint(constant: 40)
        segmentedController.addAction(UIAction.init(handler: { action in
            self.collectionView?.collectionViewLayout = self.segmentedController.selectedSegmentIndex == 1 ? self.gridCVLayout : self.listCVLayout
        }), for: .valueChanged)
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: listCVLayout)
        collectionView.register(FavouritesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topSpace(with: segmentedController.bottomAnchor, constant: 16).leadingSpace(constant: 16).trailingSpace(constant: -16).bottomSpace(with: self.view.safeBottomAnchor, constant: -8)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavouritesCollectionViewCell
        let object = fetchResultsController.object(at: indexPath)
        cell.updateCell(for: GIFViewModel.init(gifEntity: object))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = fetchResultsController.object(at: indexPath)
        let previewVC = ImagePreviewViewController()
        previewVC.viewModel = GIFViewModel.init(gifEntity: object)
        self.present(UINavigationController.init(rootViewController: previewVC), animated: true)
    }
}

extension FavouritesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller:
                                     NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func controller(_ controller:
                    NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
        case .update:
            let cell = collectionView.cellForItem(at: indexPath!) as! FavouritesCollectionViewCell
            cell.updateCell(for: cell.viewModel)
        case .move:
            collectionView.deleteItems(at: [indexPath!])
            collectionView.insertItems(at: [newIndexPath!])
        @unknown default:
            print("Unexpected NSFetchedResultsChangeType")
        }
    }
    
    func controllerDidChangeContent(_ controller:
                                    NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func controller(_ controller:
                    NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            collectionView.insertSections(indexSet)
        case .delete:
            collectionView.deleteSections(indexSet)
        default: break
        }
    }
}
