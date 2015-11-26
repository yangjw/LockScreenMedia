//
//  LockScreenSf.swift
//  LockScreenMedia
//
//  Created by njdby on 15/11/20.
//  Copyright © 2015年 njdby. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer


class LockScreenSf: UIViewController {

    override func restoreUserActivityState(activity: NSUserActivity) {
        super.restoreUserActivityState(activity)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        create()
    }
    
    func create(){
        let mpic = MPNowPlayingInfoCenter.defaultCenter()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyTitle:"This Is a Test",
            MPMediaItemPropertyArtist:"Matt Neuburg"
        ]
        
        let dict = NSMutableDictionary()
        dict.setValue("alex", forKey: "name")
        dict.setValue("123456", forKey: "password")
        print("\(dict)")
        
        var airs = [String:AnyObject]()
        
        airs["name"] = "alex"
        
//        airs.removeValueForKey("name")
//        airs.updateValue("joke", forKey: "name")
  
        var ary = [String]()
        ary.append("粤菜")
        ary.append("淮扬菜")
        
        airs["ary"] = ary
        
        var json = [String:AnyObject]()
        json["data"] = airs
    
        
        
        var nums = [Int](count: 0, repeatedValue: 0)
        for var i = 1 ; i <= 9 ;i++ {
            nums.append(i)
        }
        print("\(nums)")
        json["nums"] = nums
        
        
        let local = UILocalizedIndexedCollation.currentCollation()
        print("\(local.sectionIndexTitles)")
        json["local"] = local.sectionIndexTitles
        print("\(json)")
        
        
//        let decimalInteger = 17
//        let binaryInteger = 0b10001       // 17 in binary notation
//        let octalInteger = 0o12           // 17 in octal notation
//        let hexadecimalInteger = 0x11     // 17 in hexadecimal notation
        
        for num in 1..<9 {
            print("\(num)")
        }
        print("平均数\(avarage(nums))")
        
       print("平均数\(newAvarage(nums, sum: sums))")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func avarage(nums:[Int]) -> Int {
       
        func sum(nums:[Int]) -> Int {
            var sums = 0
            for num in nums {
                sums = sums + num
            }
            print("\(sums)")
            return sums
        }
        return sum(nums)/(nums.count)
    }
    
    
    func newAvarage(nums:[Int], sum: [Int] -> Int) -> Int
    {
        return sum(nums)/nums.count
    }
    func sums(nums:[Int]) -> Int {
        var sums = 0
        for num in nums {
            sums = sums + num
        }
        print("\(sums)")
        return sums
    }
}
