//
//  EmpRegisterVC.swift
//  PeopleNect
//
//  Created by Apple on 08/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class EmpRegisterVC: UIViewController {

    @IBOutlet var btnAlreadyRegister: UIButton!
    
    @IBOutlet var btnRegister: UIButton!
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        btnAlreadyRegister.setTitle("I'M ALREADY REGISTERED", for: .normal)
        // set up view
        self.setupView()
        
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UIView Action

    @IBAction func clickBack(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)

        
    }

    @IBAction func clickAlreadyRegister(_ sender: AnyObject) {
        
        let emploginVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpLoginVC") as! EmpLoginVC
        navigationController?.pushViewController(emploginVC, animated: true)
    }
    
    @IBAction func clickRegister(_ sender: AnyObject) {
        
        let empsignupVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpSignUpVC") as! EmpSignUpVC
        navigationController?.pushViewController(empsignupVC, animated: true)
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
