//
//  BSFileManager.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/11/25.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

extension FileManager {
        
    /**  返回指定路径单个文件的大小 */
    func getFileSizeWithPath(filepath:String) -> CGFloat {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filepath as String) {
            
            do {
                let size = try (fileManager.attributesOfItem(atPath: filepath as String)) as NSDictionary
                let value = size.value(forKey: "NSFileSize") as! CGFloat
                return value/1024.0/1024.0
            } catch { }
        }
        return 0
    }
    
    /**  返回指定路径文件夹的大小 */
    func getFolderSizeWithPath(folderpath:String) -> CGFloat {
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: folderpath as String) {
            var folderSize : CGFloat = 0.0
            
            let childerFiles = fileManager.subpaths(atPath: folderpath as String)
            for fileName in childerFiles! {
                let absolutePath = "\(folderpath)"+"/"+"\(fileName)"
                folderSize += self.getFileSizeWithPath(filepath: absolutePath)
            }
            return folderSize
        }
        return 0
    }
    
    /**  删除指定路径的cache */
    func clearFolderWithPath(folderpath:String) -> Bool {
        
        var deleteSuccess:Bool = false
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: folderpath as String) {
             let childerFiles = fileManager.subpaths(atPath: folderpath as String)
            if (childerFiles?.count)! > 0 {
                for fileName in childerFiles! {
                    let absolutePath = "\(folderpath)"+"/"+"\(fileName)"
                    do {
                        
                        let what : () = try fileManager.removeItem(atPath: absolutePath)
                        
                        print(what)
                        deleteSuccess = true
                    } catch {
                        
                    }
                }
            }
            return true
        }
        return false
    }
    
    
}
