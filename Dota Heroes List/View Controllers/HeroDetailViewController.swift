//
//  HeroDetailViewController.swift
//  Dota Heroes List
//
//  Created by Yudha on 14/10/20.
//  Copyright © 2020 Yudha. All rights reserved.
//

import Foundation
import UIKit
import Blueprints

class HeroDetailViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    
    @IBOutlet weak var detailTableView: UITableView! {
        didSet {
            detailTableView.delegate = self
            detailTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var othersCollectionView: UICollectionView! {
        didSet {
            othersCollectionView.delegate = self
            othersCollectionView.dataSource = self
            
            let cell = UINib(nibName: "SimiliarHeroCollectionCell", bundle: nil)
            othersCollectionView.register(cell, forCellWithReuseIdentifier: "similiarHeroCell")
            
            let header = UINib(nibName: "HeroDetailCollectionHeader", bundle: nil)
            othersCollectionView.register(header, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
            
            let blueprint = VerticalBlueprintLayout(itemsPerRow: 3, height: 80, minimumInteritemSpacing: 10, minimumLineSpacing: 10, sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10), stickyHeaders: false, stickyFooters: false)
            othersCollectionView.collectionViewLayout = blueprint
        }
    }
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var heroModel: HeroRealm!
    var similiarHeroes: [HeroRealm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeight.constant = detailTableView.contentSize.height
    }
    
    func setupView() {
        heroNameLabel.text = heroModel.localizedName
        heroImage.kf.setImage(with: URL(string: "https://api.opendota.com" + heroModel.image))
    }
}
