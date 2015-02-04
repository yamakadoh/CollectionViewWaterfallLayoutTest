//
//  WebViewController.swift
//  CollectionViewWaterfallLayoutTest
//
//  Created by Hideki Yamakado on 2015/02/04.
//  Copyright (c) 2015年 Hideki Yamakado. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate {
    let webView = UIWebView()
    
    var toolbar = UIToolbar()
    var isShowToolBar = true // ツールバーの表示状態
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // -----------------------------
        // UIWebView
        // -----------------------------
        webView.delegate = self
        webView.frame = self.view.bounds
        self.view.addSubview(webView)
        
        let url = NSURL(string: /*"http://www.apple.com"*/"http://blog.livedoor.jp/kinisoku/archives/2979340.html")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
        // ジェスチャー
        // タップ
        var gestureTap = UITapGestureRecognizer(target: self, action: "onTapWebView:")
        gestureTap.delegate = self
        self.view.addGestureRecognizer(gestureTap)
        // ドラッグ
        var gesturePan = UIPanGestureRecognizer(target: self, action: "onPanWebView:")
        gesturePan.delegate = self
        self.view.addGestureRecognizer(gesturePan)
        
        // -----------------------------
        // UIToolbar
        // -----------------------------
        toolbar.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 40.0)
        toolbar.layer.position = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height - 20)
        //toolbar.barStyle = UIBarStyle.Default
        //toolbar.tintColor = UIColor.whiteColor()
        //toolbar.backgroundColor = UIColor.grayColor()
        
        let buttonBack = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Rewind, target: self, action: "onTapToolbarBack:")   // Todo:標準で戻るボタンのアイコンが無いので差し替える
        buttonBack.tag = 1
        
        let buttonSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action:nil)
        
        let buttonForward = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FastForward, target: self, action: "onTapToolbarForward:")   // Todo:標準で戻るボタンのアイコンが無いので差し替える
        
        let buttonSpace2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action:nil)
        
        let buttonComment = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "onTapToolbarComment:")   // Todo:標準で戻るボタンのアイコンが無いので差し替える
        
        let buttonSpace3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action:nil)
        
        let buttonMenu = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "onTapToolbarMenu:")
        
        toolbar.items = [buttonBack, buttonSpace1, buttonForward, buttonSpace2, buttonComment, buttonSpace3, buttonMenu]
        self.view.addSubview(toolbar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        println("webViewDidStartLoad")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        println("webViewDidFinishLoad")
    }
    
    // UIWebViewタップイベントハンドラ
    func onTapWebView(sender: UITapGestureRecognizer) -> Void {
        println("[onTapWebView]called")
        
        // ステータスバーとツールバーの表示を切り替える
        isShowToolBar = !isShowToolBar
        UIView.animateWithDuration(0.5, animations: {[unowned self]() -> Void in
            var toolbarFrame = self.toolbar.frame
            toolbarFrame.origin.y = self.toolbar.frame.origin.y + (44 * (self.isShowToolBar ? -1 : 1))
            self.toolbar.frame = toolbarFrame
        })
    }
    
    // UIWebViewドラッグイベントハンドラ
    func onPanWebView(sender: UIPanGestureRecognizer) -> Void {
        println("[onPanWebView]called")
        
        let point: CGPoint = sender.translationInView(self.view)
        println("Point = (\(point.x), \(point.y))")
        
        // 上方向にドラッグ(WebViewのボトムへの移動操作)：ステータスバーとツールバーを非表示にする
        // 下方向にドラッグ(WebViewのトップへの移動操作)：ステータスバーとツールバーを表示する
        if sender.state == UIGestureRecognizerState.Began {
            println(".Began")
        }
        if sender.state == UIGestureRecognizerState.Changed {
            println(".Changed")
        }
        if sender.state == UIGestureRecognizerState.Ended {
            println(".Ended")
            // WebViewのボトムへの移動操作か
            let isDragUp: Bool = point.y < 0    // TODO: しきい値を設定してちゃんと判定する
            if isDragUp {
                // ツールバーを非表示
                if isShowToolBar {
                    isShowToolBar = false
                    UIView.animateWithDuration(0.5, animations: {[unowned self]() -> Void in
                        var toolbarFrame = self.toolbar.frame
                        toolbarFrame.origin.y = self.toolbar.frame.origin.y + 44
                        self.toolbar.frame = toolbarFrame
                    })
                }
            }
            
            // WebViewのトップへの移動操作か
            let isDragDown: Bool = point.y > 0    // TODO: しきい値を設定してちゃんと判定する
            if isDragDown {
                // ツールバーを表示
                if !isShowToolBar {
                    isShowToolBar = true
                    UIView.animateWithDuration(0.5, animations: {[unowned self]() -> Void in
                        var toolbarFrame = self.toolbar.frame
                        toolbarFrame.origin.y = self.toolbar.frame.origin.y - 44
                        self.toolbar.frame = toolbarFrame
                    })
                }
            }
        }
    }
    
    // UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 本メソッドを実装しない(trueを返さない)と、自作したジェスチャイベントハンドラが呼ばれない
        return true
    }
    
    // UIToolbarタップイベントハンドラ
    func onTapToolbarBack(sender: UIBarButtonItem) {
        println("[onTapToolbarBack]")
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onTapToolbarForward(sender: UIBarButtonItem) {
        println("[onTapToolbarForward]")
    }
    
    func onTapToolbarComment(sender: UIBarButtonItem) {
        println("[onTapToolbarComment]")
    }
    
    func onTapToolbarMenu(sender: UIBarButtonItem) {
        println("[onTapToolbarMenu]")
    }
}