//
//  AlertMessageVC.swift
//  PeopleNect
//
//  Created by Apple on 14/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class AlertMessageVC: UIViewController {

    @IBOutlet var lblAlertMessage: UILabel!
    let tapGesture = UITapGestureRecognizer()
    var strMessage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        tapGesture.addTarget(self, action: #selector(self.dismissView))
        
        self.view.addGestureRecognizer(tapGesture)
        
        
        if !(strMessage.isBlank)
        {
            lblAlertMessage.text = strMessage
        }
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
