//
//  ViewController.swift
//  AlamofirePlayground
//
//  Created by salim on 11/3/16.
//  Copyright © 2016 salim. All rights reserved.
//

import UIKit
import Alamofire

class SerialOperationQueue {
    
    // MARK: - Type Aliases
    
    typealias OperationBlockHandler = (_ completion: @escaping (_ success: Bool) -> ()) -> ()
    
    // MARK: - Properties
    
    private let operationQueue = OperationQueue()
    private let semaphore = DispatchSemaphore(value: 0)
    private var cancelPendingOperations = false
    
    // MARK: - Initializer
    
    init() {
        operationQueue.underlyingQueue = DispatchQueue(label: "com.hiddenfounders.serial-operation.\(UUID().uuidString)")
    }
    
    // MARK: - Add Operation
    
    func add(operation: @escaping OperationBlockHandler) {
        
        let blockOperation = BlockOperation()
        blockOperation.addExecutionBlock {
            
            operation({ success in
                self.cancelPendingOperations = success
                self.semaphore.signal()
            })
            self.semaphore.wait()
            
        }
        blockOperation.completionBlock = {
            if !self.cancelPendingOperations { return }
            self.operationQueue.cancelAllOperations()
        }
        
        operationQueue.addOperation(blockOperation)

    }
    
}

class ViewController: UIViewController {

    let queue1 = SerialOperationQueue()
    let queue2 = SerialOperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue1.add { completion in
            
            print("1")
            Alamofire.request("http://reqres.in/api/users?delay=2").responseJSON { response in
                print("RESPONSE")
                completion(true)
            }
            
        }
        
        queue2.add { completion in
            
            print("2")
            Alamofire.request("http://reqres.in/api/users?delay=1").responseJSON { response in
                print("RESPONSE")
                completion(false)
            }
            
        }

        queue1.add { completion in
            
            print("3")
            Alamofire.request("http://reqres.in/api/users?delay=2").responseJSON { response in
                print("RESPONSE")
                completion(true)
            }
            
        }

        
    }

}

