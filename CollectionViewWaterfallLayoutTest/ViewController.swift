//
//  ViewController.swift
//  CollectionViewWaterfallLayoutTest
//
//  Created by Hideki Yamakado on 2015/02/04.
//  Copyright (c) 2015年 Hideki Yamakado. All rights reserved.
//

import UIKit

class MyCollectionViewHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()

        let image = UIImage(named: "top1.png")!
        let imageSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.width * image.size.height / image.size.width)
        println("HeaderImageSize = \(imageSize)")
        let imageView = UIImageView(frame: CGRect(origin: CGPointZero, size: imageSize))
        imageView.image = image
        addSubview(imageView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyCollectionViewFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.redColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyCollectionViewCell: UICollectionViewCell {
}

class ViewController: UIViewController, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate, UIGestureRecognizerDelegate, UINavigationBarDelegate {

    @IBOutlet var collectionView: UICollectionView!
    var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    lazy var cellSizes: [CGSize] = {
        var _cellSizes = [CGSize]()
        
        for _ in 0...10 {
            let random = Int(arc4random_uniform((UInt32(100))))
            
            _cellSizes.append(CGSize(width: 140, height: 50 + random))
        }
        
        return _cellSizes
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("[ViewController]viewDidLoad")
        
        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)    // コンテンツ部のマージン
        layout.headerInset = UIEdgeInsets(top: /*20*/0, left: 0, bottom: 0, right: 0)   // ヘッダ部のマージン(20はステータスバーの高さ)
        layout.headerHeight = 170
        layout.footerHeight = 50
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        //collectionView.backgroundColor = UIColor.blackColor()
        collectionView.collectionViewLayout = layout
        collectionView.registerClass(/*UICollectionReusableView.self*/MyCollectionViewHeader.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionFooter, withReuseIdentifier: "Footer")
        
        // ジェスチャー
        // タップ
        var gestureTap = UITapGestureRecognizer(target: self, action: "onTapScrollView:")
        gestureTap.delegate = self
        self.view.addGestureRecognizer(gestureTap)

        // 落ちるからいったんコメントアウト
        //self.navigationController?.navigationBar.delegate = self
        //appDelegate.navigationController.navigationBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIBarPositioningDelegate
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellSizes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
        
        if let label = cell.contentView.viewWithTag(1) as? UILabel {
            label.text = String(indexPath.row)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String!, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView? = nil
        
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as? /*UICollectionReusableView*/MyCollectionViewHeader
            
//            if let view = reusableView {
//                view.backgroundColor = UIColor.redColor()
//            }
        }
        else if kind == CollectionViewWaterfallElementKindSectionFooter {
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath) as? UICollectionReusableView
            if let view = reusableView {
                view.backgroundColor = UIColor.blueColor()
            }
        }
        
        return reusableView!
    }
    
    // MARK: WaterfallLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        println("cellSizes[indexPath.item]=\(cellSizes[indexPath.item])")
        return cellSizes[indexPath.item]
    }

    // UIScrollViewタップイベントハンドラ
    func onTapScrollView(sender: UITapGestureRecognizer) -> Void {
        println("[onTapScrollView]called")
        // 画面遷移
        let webViewController = WebViewController()
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
}

