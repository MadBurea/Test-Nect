//
//  editJobNotifyVC.swift
//  PeopleNect
//
//  Created by BAPS on 11/7/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class editJobNotifyVC: UIViewController {

    @IBOutlet weak var topLbl: UILabel!
    var jobId = ""
    var userDic =  [String: Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       // data- notification_status = 5, job_id,job_title,employer_id
        self.jobId =  "\(userDic["job_id"]!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editJobClicked(_ sender: Any) {
        let empLastDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpLastDetailsVC") as! EmpLastDetailsVC
        empLastDetailsVC.jobid = self.jobId
        empLastDetailsVC.FreshJob = 1
        empLastDetailsVC.loadFrmOtherCtr = 1
        navigationController?.pushViewController(empLastDetailsVC, animated: true)
    }

    @IBAction func closeAction(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
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
