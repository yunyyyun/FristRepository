//
//  MData.swift
//  MagicCube
//
//  Created by mengyun on 16/3/27.
//  Copyright © 2016年 mengyun. All rights reserved.
//

import Foundation
import UIKit

class Mdata{
    var type: Int = 3 //2,3
    var contentStr:String="i111111"
    
    static func encode(_ mData: Mdata) {
        let mDataClassObject = HelperClass(mData: mData)
        let type = mData.type
        if NSKeyedArchiver.archiveRootObject(mDataClassObject, toFile: HelperClass.path(type)) {
            print("归档成功！")
        }
        else{
            print("归档失败！")
        }
    }
    
    static func decode(_ type: Int) -> Mdata? {
        let path=HelperClass.path(type)
        print("path==",path)
        let mDataClassObject = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? HelperClass
        if mDataClassObject == nil{
            print("解档失败！")
            let data = Mdata()
            //data.type=type
            data.contentStr="i2222222222"
            Mdata.encode(data)
            return data
        }
        print("解档成功！")
        return mDataClassObject?.mData
    }
}

extension Mdata {
    class HelperClass: NSObject, NSCoding {
        
        var mData: Mdata?
        init(mData: Mdata) {
            super.init()
            self.mData = mData
        }

        static func path(_ type: Int)->String{           
            let file : Any = NSHomeDirectory() as NSString
            var path:String!
            if type==2 {
                path = (file as! NSString).appendingPathComponent("Documents/userInfo2.archive")
            }
            else{
                path = (file as! NSString).appendingPathComponent("Documents/userInfo3.archive")
            }
            return path
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard let type = aDecoder.decodeObject(forKey: "type") as? Int else { mData = nil; super.init(); return nil }
            guard let contentStr = aDecoder.decodeObject(forKey: "contentStr") as? String else { mData = nil; super.init(); return nil }
            mData = Mdata()
            mData?.type = Int(type)
            mData?.contentStr = contentStr
            super.init()
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(mData!.type as NSNumber, forKey: "type")
            aCoder.encode(mData!.contentStr, forKey: "contentStr")
        }
    }
}
