//
//  InfoViewController.swift
//  SDOSAlamofireSample
//
//  Created by Antonio Jesús Pallares on 27/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation

class InfoViewController: UIViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbExplanation: UILabel!
    
    var model: InfoModel? {
        didSet {
            loadStyleWithData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStyleWithData()
    }
    
    private func loadStyleWithData() {
        lbTitle?.text = model?.title
        lbExplanation?.text = model?.explanation
    }
    
}
