//
//  ViewController.swift
//  Dota Heroes List
//
//  Created by Yudha on 13/10/20.
//  Copyright © 2020 Yudha. All rights reserved.
//

import UIKit
import Blueprints
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import DropDown

class ViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    
    var viewModel: MainViewModelType!

    var disposeBag = DisposeBag()
    
    var heroList: [HeroRealm] = []
    var modifiedHeroList: [HeroRealm] = []
    
    var dropDown = DropDown()
    var rolesSection: [String] = ["All"]
    
    @IBOutlet weak var heroListCollectionView: UICollectionView! {
        didSet {
            heroListCollectionView.delegate = self
            heroListCollectionView.dataSource = self
            
            let heroItemCell = UINib(nibName: "HeroItemCollectionCell", bundle: nil)
            heroListCollectionView.register(heroItemCell, forCellWithReuseIdentifier: "heroItemCell")
            
            let blueprint = VerticalBlueprintLayout(itemsPerRow: 3, height: 120, minimumInteritemSpacing: 10, minimumLineSpacing: 10, sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10), stickyHeaders: false, stickyFooters: false)
            heroListCollectionView.collectionViewLayout = blueprint
        }
    }
    
    @IBOutlet weak var heroSectionTextField: UITextField! {
        didSet {
            heroSectionTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if NetworkManager.shared.isNetworkConnected() {
            setupRx()
        }
        else {
            print("get hero data from database")
            
            let alert = UIAlertController(title: "No internet connection", message: "Please check your internet connection", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.navigationController?.present(alert, animated: true, completion: nil)
            
            loadHeroDataFromRealm()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func setupRx() {
        viewModel.heroObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { item in
                for hero in item {
                    let item = HeroRealm(hero: hero)
                    self.heroList.append(item)
                }
                
                self.modifiedHeroList = self.heroList
                self.heroListCollectionView.reloadData()
                
                for hero in self.heroList {
                    for role in hero.roles {
                        if !self.rolesSection.contains(role) {
                            self.rolesSection.append(role)
                        }
                    }
                }
                
                self.setupDropDown()
                
                self.saveHeroListToRealm(list: item)
            })
            .disposed(by: disposeBag)
        
        viewModel.errorObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { error in
                print(error)
                
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                
                self.navigationController?.present(alert, animated: true, completion: nil)
                
                self.loadHeroDataFromRealm()
            })
            .disposed(by: disposeBag)
    }
    
    func setupDropDown() {
        dropDown.anchorView = heroSectionTextField
        
        dropDown.dataSource = rolesSection
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.heroSectionTextField.text = item
            
            if item == "All" {
                self.filterHeroList(text: "")
            }
            else {
                self.filterHeroList(text: item)
            }
        }
    }
    
    func filterHeroList(text: String) {
        guard text != "" else {
            modifiedHeroList = heroList
            heroListCollectionView.reloadData()
            return
        }
        
        let filterArray = heroList.filter { $0.roles.contains(text) }
        
        modifiedHeroList = filterArray
        heroListCollectionView.reloadData()
    }
    
    func getSimiliarHeroes(heroType: String) -> [HeroRealm] {
        var filterHeroes = heroList.filter { $0.primaryAttribute == heroType }
        
        if heroType == "str" {
            filterHeroes.sort { $0.baseMaxAttack > $1.baseMaxAttack }
        }
        else if heroType == "agi" {
            filterHeroes.sort { $0.moveSpeed > $1.moveSpeed }
        }
        else if heroType == "int" {
            filterHeroes.sort { $0.baseMana > $1.baseMana }
        }
        
        let similiarHeroes = [filterHeroes[0], filterHeroes[1], filterHeroes[2]]
        print(similiarHeroes)
        
        return similiarHeroes
    }
    
    func saveHeroListToRealm(list: [Hero]) {
        let heroList = RealmManager.instance.getObjects(type: HeroRealm.self)
            
        if let heroes = heroList, heroes.count != 0 {
            for hero in heroes {
                RealmManager.instance.deleteObject(objs: hero)
            }
        }
        
        for item in list {
            let model = HeroRealm(hero: item)
            RealmManager.instance.addObject(obj: model) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func loadHeroDataFromRealm() {
        let heroList = RealmManager.instance.getObjects(type: HeroRealm.self)
        
        if let heroes = heroList, heroes.count != 0 {
            for hero in heroes {
                print(hero.roles.first)
                self.heroList.append(hero)
            }
        }
        
        self.modifiedHeroList = self.heroList
        
        for hero in self.heroList {
            for role in hero.roles {
                if !self.rolesSection.contains(role) {
                    self.rolesSection.append(role)
                }
            }
        }
        
        self.setupDropDown()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modifiedHeroList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "heroItemCell", for: indexPath) as! HeroItemCollectionCell
        
        let model = modifiedHeroList[indexPath.row]
        
        cell.heroImage.kf.setImage(with: URL(string: "https://api.opendota.com" + model.image))
        cell.heroNameLabel.text = model.localizedName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = modifiedHeroList[indexPath.row]
        
        let similiarHeroes = getSimiliarHeroes(heroType: model.primaryAttribute)
        coordinator?.goToHeroDetail(heroModel: model, similiarHeroes: similiarHeroes)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        dropDown.show()
    }
}
