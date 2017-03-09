//
//  BSUrl.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/26.
//  Copyright © 2016年 bruce. All rights reserved.
//

import Foundation
import UIKit

extension NSURL {
    
    /*
     + (NSURL *)imgUrlWithUrlString:(NSString *)urlString imgSize:(CGSize)size {
     if (!urlString || [urlString isEqualToString:@""] || ![urlString containsString:@"http"]) {
     return nil;
     }
     NSString *customSuffix = [NSString stringWithFormat:@"?imageView2/1/w/%zd/h/%zd",(NSUInteger)size.width, (NSUInteger)size.height];
     urlString = [urlString stringByAppendingString:customSuffix];
     return [NSURL URLWithString:urlString];
     }
     
     
     + (NSURL *)imgUrlWithUrl:(NSURL *)url imgSize:(CGSize)size {
     NSString *urlString = url.absoluteString;
     return [self imgUrlWithUrlString:urlString imgSize:size];
     }
     */
    func imgUrlWithUrlAndSize(url:URL,size:CGSize) -> URL {
        var urlString = url.absoluteString
        /*
        if (urlString != nil) || (urlString.isEmpty) || !(urlString.contains("http")) {
            
        }
         */
        
        let customSuffix = "imageView2/1/w/"+"\(size.width)"+"/h/"+"\(size.height)"
        urlString = urlString.appending(customSuffix)
        return URL.init(string: urlString)!
    }
}
