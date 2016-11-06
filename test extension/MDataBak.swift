//
//  MData.swift
//  MagicCube
//
//  Created by mengyun on 16/3/27.
//  Copyright © 2016年 mengyun. All rights reserved.
//

import Foundation
import UIKit

class MdataTest{
    var contentStr = "init1"
    
    static func encode(_ mData: MdataTest) {
        let mDataClassObject = self.HelperClass(mData: mData)
        //let type = 3
        print(self.HelperClass.path)
        if (NSKeyedArchiver.archiveRootObject(mDataClassObject, toFile: self.HelperClass.path())){
            print("cg")
        }
        else{
            print("fl")
        }
    }
    
    static func decode(_ type: Int) -> MdataTest? {
        let mDataClassObject = NSKeyedUnarchiver.unarchiveObject(withFile: self.HelperClass.path())
        if mDataClassObject == nil{
            let data = MdataTest()
            data.contentStr="init2"
            MdataTest.encode(data)
            return data
        }
        return (mDataClassObject as! HelperClass).mData
    }
}

extension MdataTest {
    class HelperClass: NSObject, NSCoding {
        
        var mData: MdataTest?
        init(mData: MdataTest) {
            super.init()
            self.mData = mData
        }
        
        static func path()->String{
            let file : Any = NSHomeDirectory() as NSString
            let path = (file as! NSString).appendingPathComponent("Documents/userInfoTest11.archive")
            return path
        }
        
        required init(coder aDecoder: NSCoder) {
            let contentStr = aDecoder.decodeObject(forKey: "contentStr") as? String
            super.init()
            self.mData = MdataTest()
            self.mData?.contentStr = contentStr!
        }
        
        override init() {
            super.init()
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(self.mData!.contentStr, forKey: "contentStr")
        }
    }
}

