//
//  ViewController.swift
//  SDOSAlamofire
//
//  Created by Antonio Jesús Pallares on 02/07/2019.
//  Copyright (c) 2019 Antonio Jesús Pallares. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        makeWSCall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeWSCall() {
        AF.request(Constants.WS.wsUserURL, method: .get, parameters: nil).validate().responseDecodable { (response: DataResponse<UserDTO>) in
            switch response.result {
            case .success(let user):
                print("Success with user: \(user)")
            case .failure(let error):
                print("Failure with error: \(error)")
            }
        }
    }

}

