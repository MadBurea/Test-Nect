//
//  JobRegisterVC.swift
//  PeopleNect
//
//  Created by Apple on 11/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class JobRegisterVC: UIViewController {

    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var btnAlreadyRegister: UIButton!

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up view
        self.setupView()
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true

    }
    
    // MARK: - UIView Action

    @IBAction func clickRegister(_ sender: Any) {
        
        let JobSignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSignUpVC") as! JobSignUpVC
        navigationController?.pushViewController(JobSignUpVC, animated: true)

    }
    
    @IBAction func clickBack(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)

    }
    @IBAction func clickAlReadyRegistered(_ sender: Any) {
        let JobLogInVC = self.storyboard?.instantiateViewController(withIdentifier: "JobLogInVC") as! JobLogInVC
        navigationController?.pushViewController(JobLogInVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Class Method
    func setupView()
    {
        btnRegister.layer.cornerRadius = 10.0
        btnAlreadyRegister.titleLabel?.minimumScaleFactor = 0.5
        btnAlreadyRegister.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
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
