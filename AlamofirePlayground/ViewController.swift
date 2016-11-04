//
//  ViewController.swift
//  AlamofirePlayground
//
//  Created by salim on 11/3/16.
//  Copyright © 2016 salim. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    var queue: OperationQueue!
    let semaphore = DispatchSemaphore(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        queue.addOperation {
            
            Alamofire.request("http://reqres.in/api/users?delay=3").responseJSON { response in
                print("RESPONSE")
                self.semaphore.signal()
            }
            self.semaphore.wait()
            print("FINISHED")
            
        }
        
        queue.addOperation {
            
            Alamofire.request("http://reqres.in/api/users?delay=5").responseJSON { response in
                print("RESPONSE")
                self.semaphore.signal()
            }
            self.semaphore.wait()
            print("FINISHED")
            
        }
        
        queue.addOperation {
            
            Alamofire.request("http://reqres.in/api/users?delay=7").responseJSON { response in
                print("RESPONSE")
                self.semaphore.signal()
            }
            self.semaphore.wait()
            print("FINISHED")
            
        }
        
        
    }

}

