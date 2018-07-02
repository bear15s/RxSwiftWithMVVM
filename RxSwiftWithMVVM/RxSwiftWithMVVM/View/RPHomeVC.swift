//
//  RPHomeVC.swift
//  RxSwiftWithMVVM
//
//  Created by zbmy on 2018/6/4.
//  Copyright © 2018年 HakoWaii. All rights reserved.
//

import UIKit
import RxSwift

class RPHomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,MyWaterFallFlowDelegate,TestColllectionViewCellDelegate {
    
    let homeViewModel = RPHomeViewModel()
    let disposeBag = DisposeBag()
    var collectionView:UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        self.title = "Swift瀑布流demo"
        
        let waterfall = MyWaterFallFlow.init()
        waterfall.columnCount = 2.0
        waterfall.delegate = self
        
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: waterfall)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.collectionView = collectionView
        collectionView.register(TestColllectionViewCell.classForCoder(), forCellWithReuseIdentifier: "colCell")
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
//        collectionView.rx.setDataSource(self).disposed(by: disposeBag)
        homeViewModel.template_array.asObservable().subscribe(onNext: { [weak self] templates in
            self?.collectionView?.reloadData()
        }).disposed(by: disposeBag)
        homeViewModel.fetchHomeViewData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func heightForViewExceptImage(collectionViewCell: TestColllectionViewCell, height: CGFloat) {
        if height > 0 {
            homeViewModel.extraHeight = Float(height)
        }
    }
    
    func heightForCellWidth(flowLayout: MyWaterFallFlow, cellWidth: CGFloat, indexPath: IndexPath) -> CGFloat {
        if(homeViewModel.template_array.value.count == 0){
            return 0
        }
        let template:Template = homeViewModel.template_array.value[indexPath.item]
        
        let height = (CGFloat)(template.video_height / template.video_width) * cellWidth + (CGFloat)(homeViewModel.extraHeight)
        return height
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //collectionView delegate & dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.template_array.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell:TestColllectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colCell", for: indexPath) as!TestColllectionViewCell
        collectionViewCell.template = homeViewModel.template_array.value[indexPath.item]
        collectionViewCell.delegate = self
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("didSelect collectionViewCell at \(indexPath.row)");
     
    }

}
