//
//  TermsUseVC.swift
//  PeopleNect
//
//  Created by Apple on 15/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class TermsUseVC: UIViewController {

    @IBOutlet var webViewObj: UIWebView!
    let tapGesture = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appdel.deviceLanguage == "pt-BR"
        {
            let url1 = Bundle.main.url(forResource: "index_pt", withExtension:"html")
            webViewObj.loadRequest(NSURLRequest.init(url: url1!) as URLRequest)
        }else
        {
            let url1 = Bundle.main.url(forResource: "index", withExtension:"html")
            webViewObj.loadRequest(NSURLRequest.init(url: url1!) as URLRequest)
        }
        
        tapGesture.addTarget(self, action: #selector(self.dismissView))
        self.view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }

    func dismissView()
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
