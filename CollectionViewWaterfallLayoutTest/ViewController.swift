//
//  ViewController.swift
//  CollectionViewWaterfallLayoutTest
//
//  Created by Hideki Yamakado on 2015/02/04.
//  Copyright (c) 2015年 Hideki Yamakado. All rights reserved.
//

import UIKit

protocol MyCollectionViewHeaderDelegate: class {
    func onTapMenuButton(sender: UIButton)
}

class MyCollectionViewHeader: UICollectionReusableView {
    var buttonMenu = UIButton()
    let delegate: MyCollectionViewHeaderDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        
        // トップ画像
        let image = UIImage(named: "top1.png")!
        let imageSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.width * image.size.height / image.size.width)
        println("HeaderImageSize = \(imageSize)")
        let imageView = UIImageView(frame: CGRect(origin: CGPointZero, size: imageSize))
        imageView.image = image
        addSubview(imageView)
        
        // メニューボタン
        let buttonSize: CGFloat = 30
        let icon = FAKIonIcons.naviconRoundIconWithSize(buttonSize)
        icon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let buttonImage = icon.imageWithSize(CGSize(width: buttonSize, height: buttonSize))
        buttonMenu.frame = CGRect(x: CGFloat(UIScreen.mainScreen().bounds.width - buttonSize - 5), y: 20, width: buttonSize, height: buttonSize)
        buttonMenu.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        buttonMenu.addTarget(self.delegate?, action: "onTapMenuButton:", forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(buttonMenu)
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
    var thumbnail = UIImageView()
    var title = UILabel()
    var source = UILabel()
    var category = UIImageView()
    
    var number = UILabel()  // TODO: デバッグ用。あとで消す
    
    override init(frame: CGRect) {
        println("[MyCollectionViewCell]init called")
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        
        // サムネイル
        let rectThumbnail = CGRect(x: 3, y: 3, width: frame.size.width - 3*2, height: 0)
        thumbnail.frame = rectThumbnail
        contentView.addSubview(thumbnail)
        
        // タイトル
        contentView.addSubview(title)
        
        // ソース
        contentView.addSubview(source)
        
        // カテゴリ
        contentView.addSubview(category)
        
        // セル番号
        let rectNumber = CGRect(x: 0, y: 0, width: frame.size.width, height: UIFont.smallSystemFontSize())
        //println("frame = \(frame)")
        //println("textFrame = \(rectNumber)")
        number.frame = rectNumber
        number.textAlignment = NSTextAlignment.Left
        number.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        number.textColor = UIColor.blackColor()
        contentView.addSubview(number)
    }

    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate, UIGestureRecognizerDelegate, MyCollectionViewHeaderDelegate {

    @IBOutlet var collectionView: UICollectionView!
    var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    lazy var cellSizes: [CGSize] = {
        var _cellSizes = [CGSize]()
        
        for i in 0...13 {
            //let random = Int(arc4random_uniform((UInt32(100))))
            let image = UIImage(named: "\(i).jpg")!
            let widthCell: CGFloat = 140
            let heightCell: CGFloat = widthCell * image.size.height / image.size.width
            _cellSizes.append(CGSize(width: widthCell, height: heightCell + 80))
        }
        
        return _cellSizes
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("[ViewController]viewDidLoad")
        self.view?.backgroundColor = UIColor.whiteColor()
        
        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)    // コンテンツ部のマージン
        layout.headerInset = UIEdgeInsets(top: /*20*/0, left: 0, bottom: 0, right: 0)   // ヘッダ部のマージン(20はステータスバーの高さ)
        let image = UIImage(named: "top1.png")!
        layout.headerHeight = Float(UIScreen.mainScreen().bounds.width * image.size.height / image.size.width)
        layout.footerHeight = 0
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView.backgroundColor = UIColor.lightGrayColor()
        collectionView.collectionViewLayout = layout
        collectionView.registerClass(/*UICollectionReusableView.self*/MyCollectionViewHeader.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionFooter, withReuseIdentifier: "Footer")
        collectionView.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        // ジェスチャー
        // タップ
        var gestureTap = UITapGestureRecognizer(target: self, action: "onTapScrollView:")
        gestureTap.delegate = self
        self.view.addGestureRecognizer(gestureTap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellSizes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        println("[cellForItemAtIndexPath indexPath:\(indexPath.row)]called")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as MyCollectionViewCell
        cell.number.text = String(indexPath.row)
        let thumbnail = UIImage(named: "\(indexPath.row).jpg")
        cell.thumbnail.image = thumbnail
        cell.thumbnail.frame.size = CGSize(width: cell.thumbnail.frame.size.width, height: cell.thumbnail.frame.width * thumbnail!.size.height / thumbnail!.size.width)
        println("cell.thumbnail.frame.size = \(cell.thumbnail.frame.size)")
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String!, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView? = nil
        
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as? /*UICollectionReusableView*/MyCollectionViewHeader
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
        println("[sizeForItemAtIndexPath]cellSizes[\(indexPath.item)]=\(cellSizes[indexPath.item])")
        return cellSizes[indexPath.item]
    }
    
    // UIScrollViewタップイベントハンドラ
    func onTapScrollView(sender: UITapGestureRecognizer) -> Void {
        println("[onTapScrollView]called")
        // 画面遷移
        let webViewController = WebViewController()
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    // メニューボタン タップイベントハンドラ
    func onTapMenuButton(sender: UIButton) -> Void {
        println("[onTapMenuButton]called")
    }
}

