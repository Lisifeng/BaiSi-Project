//
//  BSCheckVideoController.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/11/3.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
import AVFoundation

class BSCheckVideoController: UIViewController {
    var playerItem : AVPlayerItem?
    var avplayer = AVPlayer.init()
    var playerLayer = AVPlayerLayer.init()
    var link:CADisplayLink!
    var backBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BSColor.themeColor()
        self.addPlayView()
        // Do any additional setup after loading the view.
    }
    func addPlayView() {
        backBtn = UIButton.init(type: UIButtonType.custom)
        backBtn.frame = CGRect.init(x: 15, y: 35, width: 30, height: 30)
        backBtn.layer.cornerRadius = 15
        backBtn.layer.masksToBounds = true
        backBtn.layer.borderColor = BSColor.colorWithHex(0x000000).cgColor
        backBtn.layer.borderWidth = 1
        backBtn.setImage( #imageLiteral(resourceName: "back_image.png"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(BSCheckVideoController.backMainFace), for: UIControlEvents.touchUpInside)
        self.view.addSubview(backBtn)
    }
    
    func setPlayerViewWithUrl(url:NSString) {
        // 检测连接是否存在 不存在报错
        playerItem = AVPlayerItem(url:URL.init(string: url as String)!) // 创建视频资源
        // 监听缓冲进度改变
        playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        // 监听状态改变
        playerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        // 将视频资源赋值给视频播放对象
        self.avplayer = AVPlayer(playerItem: playerItem)
        // 初始化视频显示layer
        playerLayer = AVPlayerLayer(player: self.avplayer)
        playerLayer.frame = CGRect.init(x: 0, y: (self.view.bounds.size.height-self.view.bounds.size.height*0.6)/2, width: self.view.bounds.size.width, height: self.view.bounds.size.height*0.6)
        let bottomLayer = CALayer.init()
        bottomLayer.backgroundColor = BSColor.colorWithHex(0x000000).cgColor
        bottomLayer.frame = playerLayer.frame
        
        // 设置显示模式
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        // 位置放在最底下
        self.view.layer.insertSublayer(playerLayer, at: 1)
        self.view.layer.insertSublayer(bottomLayer, at: 0)
        
        self.link = CADisplayLink(target: self, selector: #selector(update))
        self.link.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    deinit{
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem?.removeObserver(self, forKeyPath: "status")
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else { return }
        if keyPath == "loadedTimeRanges"{
            //            通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
            let loadedTime = avalableDurationWithplayerItem()
            let totalTime = CMTimeGetSeconds(playerItem.duration)
            let percent = loadedTime/totalTime
            JBLog("💖percent:"+"\(percent)")
            //            self.playerView.progressView.progress = Float(percent)
        }else if keyPath == "status"{
            //            AVPlayerItemStatusUnknown,AVPlayerItemStatusReadyToPlay, AVPlayerItemStatusFailed。只有当status为AVPlayerItemStatusReadyToPlay是调用 AVPlayer的play方法视频才能播放。
            JBLog("💖status:"+"\(playerItem.status)")
            JBLog("💖playerItem.status.rawValue:"+"\(playerItem.status.rawValue)")
            if playerItem.status == AVPlayerItemStatus.readyToPlay{
                // 只有在这个状态下才能播放
                self.avplayer.play()
            }else{
                JBLog("加载异常")
            }
        }
    }
    func avalableDurationWithplayerItem()->TimeInterval{
        guard let loadedTimeRanges = avplayer.currentItem?.loadedTimeRanges,let first = loadedTimeRanges.first else {fatalError()}
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    
    func update(){
        //暂停的时候
        //        if !self.playerView..playing{
        //            return
        //        }
        
        //        let currentTime = CMTimeGetSeconds(self.avplayer.currentTime())
        //        let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
        
        
        //        let timeStr = "\(formatPlayTime(currentTime))/\(formatPlayTime(totalTime))"
        //        playerView.timeLabel.text = timeStr
        //        // 滑动不在滑动的时候
        //        if !self.playerView.sliding{
        //            // 播放进度
        //            self.playerView.slider.value = Float(currentTime/totalTime)
        //        }
        
    }
    
    func backMainFace() {
        self.avplayer.pause()
        
        self.dismiss(animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
