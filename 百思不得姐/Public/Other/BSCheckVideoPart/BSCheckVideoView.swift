//
//  BSCheckVideoView.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/11/3.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
import AVFoundation

class BSCheckVideoView: UIView {

    
    
    var playerItem : AVPlayerItem?
    var avplayer = AVPlayer.init()
    var playerLayer = AVPlayerLayer.init()
    var link:CADisplayLink!
    var backBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !self.isEqual(nil) {
            self.addSubViews()
        }
    }
    
    func addSubViews() {
        backBtn = UIButton.init(type: UIButtonType.custom)
        backBtn.frame = CGRect.init(x: 15, y: 35, width: 30, height: 30)
        backBtn.layer.cornerRadius = 15
        backBtn.layer.masksToBounds = true
        backBtn.layer.borderColor = BSColor.colorWithHex(0x000000).cgColor
        backBtn.layer.borderWidth = 1
        backBtn.setImage( #imageLiteral(resourceName: "back_image.png"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(BSCheckVideoView.backMainFace), for: UIControlEvents.touchUpInside)
    }
    
    func setPlayer(url:NSString) {
        // 检测连接是否存在 不存在报错
        // guard let url = NSURL(string: "http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4") else { fatalError("连接错误") }
        
        playerItem = AVPlayerItem(url:URL.init(string: url as String)!)
        // 创建视频资源
        // 监听缓冲进度改变
        playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        // 监听状态改变
        playerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        // 将视频资源赋值给视频播放对象
        self.avplayer = AVPlayer(playerItem: playerItem)
        // 初始化视频显示layer
        playerLayer = AVPlayerLayer(player: self.avplayer)
        playerLayer.frame = CGRect.init(x: 0, y: (self.bounds.size.height-self.bounds.size.height*0.6)/2, width: self.bounds.size.width, height: self.bounds.size.height*0.6)
        // 设置显示模式
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        // 位置放在最底下
        self.layer.insertSublayer(playerLayer, at: 0)
        
        self.link = CADisplayLink(target: self, selector: #selector(update))
        self.link.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func backMainFace() {
        self.avplayer.pause()
        UIView.animate(withDuration: 0.25) {
            self.removeFromSuperview()
        }
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem?.removeObserver(self, forKeyPath: "status")
        
        playerItem = nil
        avplayer = AVPlayer.init()
        playerLayer = AVPlayerLayer.init()
        link=CADisplayLink.init()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else { return }
        if keyPath == "loadedTimeRanges"{
            //            通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
            let loadedTime = avalableDurationWithplayerItem()
            let totalTime = CMTimeGetSeconds(playerItem.duration)
            let percent = loadedTime/totalTime
            print("💖percent:"+"\(percent)")
            //            self.playerView.progressView.progress = Float(percent)
        }else if keyPath == "status"{
            //            AVPlayerItemStatusUnknown,AVPlayerItemStatusReadyToPlay, AVPlayerItemStatusFailed。只有当status为AVPlayerItemStatusReadyToPlay是调用 AVPlayer的play方法视频才能播放。
            print("💖status:"+"\(playerItem.status)")
            print("💖playerItem.status.rawValue:"+"\(playerItem.status.rawValue)")
            if playerItem.status == AVPlayerItemStatus.readyToPlay{
                // 只有在这个状态下才能播放
                self.avplayer.play()
            }else{
                print("加载异常")
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
//        if !playerLayer.playing{
//            return
//        }
//
//        let currentTime = CMTimeGetSeconds(self.avplayer.currentTime())
//        let totalTime   = TimeInterval((playerItem?.duration.value)!) / TimeInterval((playerItem?.duration.timescale)!)
//
//
//        let timeStr = "\(formatPlayTime(currentTime))/\(formatPlayTime(totalTime))"
//        playerView.timeLabel.text = timeStr
//        // 滑动不在滑动的时候
//        if !self.playerView.sliding{
//            // 播放进度
//            self.playerView.slider.value = Float(currentTime/totalTime)
//        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
