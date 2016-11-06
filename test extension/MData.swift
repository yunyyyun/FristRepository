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
    var currentTextureID: Int = 0
    var currentBackgroundColorID: NSNumber = 1
    var type: Int = 3 //2,3
    var dis: NSNumber = -11.0 //
    var numberOfRevert: NSNumber = 0 //还原次数
    var revertSteps:[NSNumber]=[0]
    var revertTimes:[NSNumber]=[0]
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
                path = (file as! NSString).appendingPathComponent("Documents/userInfo222.archive")
            }
            else{
                path = (file as! NSString).appendingPathComponent("Documents/userInfo333.archive")
            }
            return path
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard let currentTextureID = aDecoder.decodeObject(forKey: "currentTextureID") as? NSNumber else { mData = nil; super.init(); return nil }
            guard let currentBackgroundColorID = aDecoder.decodeObject(forKey: "currentBackgroundColorID") as? NSNumber else { mData = nil; super.init(); return nil }
            guard let type = aDecoder.decodeObject(forKey: "type") as? Int else { mData = nil; super.init(); return nil }
            guard let dis = aDecoder.decodeObject(forKey: "dis") as? NSNumber else { mData = nil; super.init(); return nil }
            guard let numberOfRevert = aDecoder.decodeObject(forKey: "numberOfRevert") as? NSNumber else { mData = nil; super.init(); return nil }
            guard let revertSteps = aDecoder.decodeObject(forKey: "revertSteps") as? [NSNumber] else { mData = nil; super.init(); return nil }
            guard let revertTimes = aDecoder.decodeObject(forKey: "revertTimes") as? [NSNumber] else { mData = nil; super.init(); return nil }
            guard let contentStr = aDecoder.decodeObject(forKey: "contentStr") as? String else { mData = nil; super.init(); return nil }
            mData = Mdata()
            mData?.currentTextureID = Int(currentTextureID)
            mData?.currentBackgroundColorID = currentBackgroundColorID
            mData?.type = Int(type)
            mData?.dis=dis
            mData?.numberOfRevert=numberOfRevert
            mData?.revertSteps = revertSteps
            mData?.revertTimes = revertTimes
            mData?.contentStr = contentStr
            super.init()
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(mData!.currentTextureID as NSNumber, forKey: "currentTextureID")
            aCoder.encode(mData!.currentBackgroundColorID, forKey: "currentBackgroundColorID")
            aCoder.encode(mData!.type as NSNumber, forKey: "type")
            aCoder.encode(mData!.dis, forKey: "dis")
            aCoder.encode(mData!.numberOfRevert, forKey: "numberOfRevert")
            aCoder.encode(mData!.revertSteps, forKey: "revertSteps")
            aCoder.encode(mData!.revertTimes, forKey: "revertTimes")
            aCoder.encode(mData!.contentStr, forKey: "contentStr")
        }
    }
}
