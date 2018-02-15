//
//  EmpDash.swift
//  PeopleNect
//
//  Created by BAPS on 10/18/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader
import SDWebImage
import GoogleMaps
import CoreLocation

// MARK: - JobProgressCell -

class JobProgressCell: UITableViewCell {
    @IBOutlet weak var JobTitleLbl: UILabel!

}
class ProgressUserList: UITableViewCell {
    
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var userExpLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userPic.layer.cornerRadius = 20
        userPic.clipsToBounds = true
    }
}


class EmpDash: UIViewController ,GMUClusterManagerDelegate, GMSMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,SlideNavigationControllerDelegate {
    @IBOutlet weak var jobInProgresstblHeight: NSLayoutConstraint!

    // MARK: - Outlets -

    @IBOutlet weak var objScrollView: UIScrollView!
    @IBOutlet weak var JobInProgressTblView: UITableView!
    @IBOutlet weak var topSecondJobInProgreeView: UIView!
    @IBOutlet weak var topFirstJobInProgressView: UIView!
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var userTableHeight: NSLayoutConstraint!
    @IBOutlet weak var mapHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var btnFilterExpertise: UIButton!
    @IBOutlet weak var totalJobLbl: UILabel!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet var expertiseView: UIView!
    @IBOutlet var lblResultFrmAllCategory: UILabel!
    @IBOutlet weak var viewNotifyRedBadge: UIView!
    @IBOutlet weak var expertiseSubView: UIView!
    @IBOutlet var tblExpertise: UITableView!
    @IBOutlet weak var topThirdViewJobProgressView: UIView!
    @IBOutlet weak var JobProgressUserTbl: UITableView!
    @IBOutlet weak var jobProgressTitle: UILabel!
    @IBOutlet weak var jobUserTblHeight: NSLayoutConstraint!
    // MARK: - Variables -
    var isJobSekeer = 0
    var nearByCount = 0

    var userMarker = GMSMarker()
    let tapGesture = UITapGestureRecognizer()
    var clusterManager: GMUClusterManager!
    var arrayAllMarkers = NSMutableArray()
    var employerrListarray = NSMutableArray()
    var global = WebServicesClass()
    var itemInfo = ""
    var arrExpertise = NSMutableArray()
    var arrVisibleUser = NSMutableArray()
    var tempArrayUSerListing = NSMutableArray()
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var arrCategory = NSMutableArray()
    var totalVisibleJobArray = NSMutableArray()
    var arrSelectedExpertise = NSMutableArray()
    var allJobUserArray = NSMutableArray()
    var selectedExpertiseCategory = NSMutableArray()
    var firstTimeRegistered = false
    var employeelist = NSMutableArray()
    var catList = NSMutableArray()
    var categoryId = String()
    var expertiseCategoryId = String()
    var subCategoryCount = Int()
    var SettingDetailUPdated = false
    var jobInProgressJobList = NSMutableArray()
    var jobInProgressJobIndex = -1
    var jobUserProgressList = NSArray()

   

    let graySpotifyColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    
    
   

    // MARK: - View Life Cycle Methods -

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()

        mapHeightConstraints.constant = (UIScreen.main.bounds.size.height * 320)/667
        self.btnFilterExpertise.isHidden = true
        self.lblResultFrmAllCategory.isHidden = true
        
        btnProfilePic.layer.cornerRadius = btnProfilePic.bounds.size.width/2
        btnProfilePic.clipsToBounds = true
        
        totalJobLbl.font = UIFont(name: "Montserrat-Regular", size: 8.0)
        totalJobLbl.textColor = UIColor.darkGray

        if imageIsNull(imageName: ImgEmployerProfilepic )
        {
            self.setEmployerImage(btnProfilePic:btnProfilePic)
        }
        else
        {
            btnProfilePic.setImage(ImgEmployerProfilepic, for: .normal)
        }
        btnProfilePic.imageView?.contentMode = .scaleAspectFill

        addBtn.layer.cornerRadius = addBtn.frame.size.height / 2
        addBtn.layer.masksToBounds = true

        userTableView.tag = 100
        userTableView.delegate = self
        userTableView.dataSource = self
        
        let notificationName = Notification.Name("changeImageEmployer")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(EmpDash.changeImage), name: notificationName, object: nil)
        
        // Register to chat  notification and push to custom chat
        let chatNotification = Notification.Name("chatNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(EmpDash.chatNotification), name: chatNotification, object: nil)
        
        
        // jobSeekerRating
        let jobSeekerRating = Notification.Name("jobSeekerRating")
        NotificationCenter.default.addObserver(self, selector: #selector(EmpDash.jobSeekerRating), name: jobSeekerRating, object: nil)
        
        // editjobNotify
        let editjobNotify = Notification.Name("editjobNotify")
        NotificationCenter.default.addObserver(self, selector: #selector(EmpDash.editjobNotify), name: editjobNotify, object: nil)
        
        // selection Screen
        let selection = Notification.Name("selection")
        NotificationCenter.default.addObserver(self, selector: #selector(EmpDash.selection), name: selection, object: nil)
        
        
        
        // setup
        self.setUpView()
        
        mapView.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        // API Call
        
        
        
        userTableView.register(UINib(nibName: "EmpDashboardMainCell", bundle: Bundle.main), forCellReuseIdentifier: "EmpDashboardMainCell")
        
        userTableView.register(EmpFilterExpertiseCell.self, forCellReuseIdentifier: "EmpFilterExpertiseCell")

        //userTableView.register(
        //EmpFilterExpertiseCell
        
        userTableView.rowHeight = UITableViewAutomaticDimension
        userTableView.estimatedRowHeight = 120
        
        userTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        NotificationCenter.default.addObserver(self, selector: #selector(self.filterByExpertise(notification:)), name: NSNotification.Name(rawValue: "FilteringProcess"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tableviewReload(notification:)), name: NSNotification.Name(rawValue: "ReloadTableView"), object: nil)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.RightSwipe))
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.userTableView.addGestureRecognizer(swipeRight)
        swipeRight.delegate = self
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.LeftSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        swipeLeft.delegate = self
        self.userTableView.addGestureRecognizer(swipeLeft)
        
        // Do any additional setup after loading the view.
        
        
        // Badge Notification
        self.viewNotifyRedBadge.isHidden = true
        if appdel.showRedBadge{
            self.viewNotifyRedBadge.layer.cornerRadius = 7.5
            self.viewNotifyRedBadge.layer.masksToBounds = true
            self.viewNotifyRedBadge.isHidden = false
        }
        
        // toast
        if SettingDetailUPdated {
            self.view.makeToast(Localization(string:"Details Updated."), duration: 3.0, position: .bottom)
        }
        
      
        self.topFirstJobInProgressView.isHidden = true
        self.topSecondJobInProgreeView.isHidden = true
        self.topThirdViewJobProgressView.isHidden = true
        
        self.JobInProgressTblView.tag = 1000
        self.JobInProgressTblView.delegate = self
        self.JobInProgressTblView.dataSource = self
        
        self.JobProgressUserTbl.tag = 2000
        self.JobProgressUserTbl.delegate = self
        self.JobProgressUserTbl.dataSource = self
        
        print("user detail is",appdel.loginUserDict)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("called")
        
        if (appdel.isNotificationCome == false)
        {
            let when = DispatchTime.now() + 0 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                
                if self.tempArrayUSerListing.count == 0 {
                    self.jobInProgressAPI()
                }
                
            }

        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideNavigationBar()
        
        
        userTableHeight.constant = objScrollView.frame.size.height - sectionView.frame.size.height
    }
    
    // MARK: - UIView Action -
    @IBAction func clickProfile(_ sender: Any) {
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)
    }

    @IBAction func chatClick(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let ChatVC = storyBoard.instantiateViewController(withIdentifier: "chatList") as! chatList
        ChatVC.userType = "0"
        ChatVC.recieverId = "\(appdel.loginUserDict.object(forKey: "employerId")!)"
        self.navigationController?.pushViewController(ChatVC, animated: true)
    }
    
    
    func ProgressUserChat(_ sender: UIButton) {
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let ChatScene = storyBoard.instantiateViewController(withIdentifier: "CustomChatScene") as! CustomChatScene
        
        var userDataDic = NSDictionary()
        userDataDic = self.jobUserProgressList.object(at: sender.tag) as! NSDictionary
        
        ChatScene.userName = ((self.jobUserProgressList.object(at: sender.tag) as! NSDictionary).value(forKey: "name") as! String?)!
        ChatScene.userprofilePic = ((self.jobUserProgressList.object(at: sender.tag) as! NSDictionary).value(forKey: "image_url") as! String?)!
        
        
        if userDataDic["categoryName"] != nil  {
            ChatScene.userCategory = userDataDic["categoryName"] as! String
        }else{
            ChatScene.userCategory = ""
        }
        
        ChatScene.userID = "\(appdel.loginUserDict.object(forKey: "employerId")!)"
        
        ChatScene.receiver_id = ((self.jobUserProgressList.object(at: sender.tag) as! NSDictionary).value(forKey: "employeeId") as! String?)!
        
        ChatScene.userType = "0"
        
        ChatScene.receiver_Name = ((self.jobUserProgressList.object(at: sender.tag) as! NSDictionary).value(forKey: "name") as! String?)!
        
        self.navigationController?.pushViewController(ChatScene, animated: true)
        
    }
    
    
    @IBAction func balanceClicked(_ sender: Any) {
        let empBalanceVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpBalanceVC") as! EmpBalanceVC
        self.navigationController?.pushViewController(empBalanceVC, animated: true)
    }
    
    @IBAction func clickOnAdd(_ sender: Any)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let repostVC = storyBoard.instantiateViewController(withIdentifier: "EmpRepostJobVC") as! EmpRepostJobVC
        self.navigationController?.pushViewController(repostVC, animated: true)
    }
    func clickFilter()
    {
        let catIdDict = NSMutableDictionary()
        print(categoryId)
        catIdDict.setValue(categoryId, forKey: "categoryId")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowFilterView"), object: catIdDict)
    }
    
    
    @IBAction func clickFilterByExpertise(_ sender: Any) {
        print("expertiseCategoryId is ",expertiseCategoryId)
        self.expertiseView.isHidden = false
        self.ExpertiseList(categoryId: expertiseCategoryId)
    }

    @IBAction func clickHideSecondJobInProgress(_ sender: Any) {
        self.topSecondJobInProgreeView.isHidden = true
    }
    @IBAction func clickShowSecondJobInProgress(_ sender: Any) {
        self.topSecondJobInProgreeView.isHidden = false
    }
    @IBAction func clickThirdProgessBtn(_ sender: Any) {
        self.topSecondJobInProgreeView.isHidden = true
        self.topThirdViewJobProgressView.isHidden = true
        self.topFirstJobInProgressView.isHidden = false
    }
    @IBAction func clickBackThirdProgress(_ sender: Any) {
        self.topSecondJobInProgreeView.isHidden = false
        self.topThirdViewJobProgressView.isHidden = true
    }
    @IBAction func clickExpertiseFilter(_ sender: Any) {
        
        self.expertiseView.isHidden = true
        
        if self.selectedExpertiseCategory.count > 0 {
            let filterArray = NSMutableArray()
            for i in 0...self.tempArrayUSerListing.count-1
            {
                var dict = NSDictionary()
                dict = self.tempArrayUSerListing.object(at: i) as! NSDictionary
                
                for j in 0...self.selectedExpertiseCategory.count-1 {
                    
                    let selectedSubcategory = self.selectedExpertiseCategory.object(at: j)
                    
                    if (selectedSubcategory as AnyObject).isEqual(dict.object(forKey: "subCategoryId") as! NSString)
                    {
                        filterArray.add(dict)
                    }
                    self.lblResultFrmAllCategory.text = "\(Localization(string: "Result from")) \(selectedExpertiseCategory.count) sub-category"
                }
            }
            self.tempArrayUSerListing.removeAllObjects()
            self.tempArrayUSerListing = filterArray.mutableCopy() as! NSMutableArray
            self.prepareForMarker(array: self.tempArrayUSerListing)
        }else{
            self.lblResultFrmAllCategory.text = Localization(string: "Result from All sub-category")
            
            
            
        }
    }
    
    // MARK: - USER LOCATION MARKER -

    func moveMarkerOn(markerPosition: CLLocationCoordinate2D)
    {
        
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(1.0)
        userMarker.position = markerPosition
        CATransaction.commit()
        userMarker.icon = UIImage(named: "map_green")
        userMarker.appearAnimation = GMSMarkerAnimation.pop
        userMarker.accessibilityHint = "user"
        userMarker.map = self.mapView
        self.mapView.animate(toLocation: markerPosition)
        
    }
    // MARK: - Google Mpas Delegate -

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        self.setVisibleUser()
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
 
        if tempArrayUSerListing.count > 0  && marker.accessibilityHint != "user"{
            let jobDetail = self.storyboard?.instantiateViewController(withIdentifier: "EmpJobSeekerStatusVC") as! EmpJobSeekerStatusVC
            jobDetail.ArrayUserListing = tempArrayUSerListing
            jobDetail.currentIndex = 0
            jobDetail.fromDash = true
            self.navigationController?.pushViewController(jobDetail, animated: true)
        }
        
        // tap on marker navigate to details page
        return true
    }
    
    func setVisibleUser()
    {
     
        let visibleUser = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: visibleUser)
        totalVisibleJobArray.removeAllObjects()
         self.tempArrayUSerListing = NSMutableArray()

        if arrayAllMarkers.count > 0
        {
            for index in 0...arrayAllMarkers.count-1
            {
                
                let lat = (arrayAllMarkers.object(at: index) as! NSDictionary).object(forKey: keylat)!
                
                let lng = (arrayAllMarkers.object(at: index) as! NSDictionary).object(forKey: keylong)!
                
                let position = CLLocationCoordinate2D(latitude:  CLLocationDegrees((lat as! NSString).floatValue) ,  longitude: CLLocationDegrees((lng as! NSString).floatValue))
                
                if bounds.contains(position)
                {
                    self.tempArrayUSerListing.add(arrVisibleUser.object(at: index))
                }
            }
        }
        
        print("Actual array is",tempArrayUSerListing)
        
        let nameDescriptor = NSSortDescriptor(key: "distance", ascending: true)
        let sortDescriptors = [nameDescriptor]
        let ordered = tempArrayUSerListing.sortedArray(using: sortDescriptors) as NSArray
        
        tempArrayUSerListing.removeAllObjects()
        tempArrayUSerListing = NSMutableArray()
        
        tempArrayUSerListing = ordered.mutableCopy() as! NSMutableArray
        print("sorted array is",tempArrayUSerListing)

        self.totalJobLbl.text = "\(self.tempArrayUSerListing.count) \(Localization(string: "Professionals"))"
        self.userTableView.reloadData()
    }
    
    
    func setVisibleUserFromArray(allUser:NSArray)
    {
        let visibleUser = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: visibleUser)
        totalVisibleJobArray.removeAllObjects()
        self.tempArrayUSerListing = NSMutableArray()
        
        if allUser.count > 0
        {
            for index in 0...allUser.count-1
            {
                
                let lat = (allUser.object(at: index) as! NSDictionary).object(forKey: "lat")!
                
                let lng = (allUser.object(at: index) as! NSDictionary).object(forKey: "lng")!
                
                let position = CLLocationCoordinate2D(latitude:  CLLocationDegrees((lat as! NSString).floatValue) ,  longitude: CLLocationDegrees((lng as! NSString).floatValue))
                
                if bounds.contains(position)
                {
                    self.tempArrayUSerListing.add(allUser.object(at: index))
                }
                
            }
        }
        
        self.totalJobLbl.text = "\(self.tempArrayUSerListing.count) \(Localization(string: "Professionals"))"
        

        self.userTableView.reloadData()
        
    }
    
    
    
    //MARK:- Cluster Method -
    /*
     
     clusterManager:didTapCluster: is called when the user taps a cluster of markers.
     clusterManager:didTapClusterItem: is called when the user taps an individual cluster item (marker).
     */
    func prepareForMarker(array: NSMutableArray)
    {
        //  print("prepareForMarker")
        arrVisibleUser = array.mutableCopy() as! NSMutableArray
        arrayAllMarkers.removeAllObjects()
        //  print("arrVisibleUser",arrVisibleUser.count)
        
        if array.count>0 {
            for index in 0...array.count-1
            {
                let lat = (array.object(at: index) as! NSDictionary).object(forKey: "lat")!
                
                let long = (array.object(at: index) as! NSDictionary).object(forKey: "lng")!
                
                let rating = (array.object(at: index) as! NSDictionary).object(forKey: "rating")!
                
                arrayAllMarkers.add([keylat:lat,keylong:long,keyrating:rating,keyisJob:isJobSekeer])
                
            }
            
            print("arrayAllMarkers",arrayAllMarkers.count)
            
            print("arrayAllMarkers value",arrayAllMarkers)
            
        }
        self.generateClusterMarkers()

      
    }
    
    func generateClusterMarkers() {
        
        
       //mapView.clear()
      clusterManager.clearItems()
        
        var bounds = GMSCoordinateBounds()
        
        for index in 0..<arrayAllMarkers.count
        {
            //var marker = GMSMarker()
            
            let lat = (arrayAllMarkers.object(at: index) as! NSDictionary).object(forKey: keylat)!
            
            let lng = (arrayAllMarkers.object(at: index) as! NSDictionary).object(forKey: keylong)!
            

            
            var indexData = NSDictionary()
            
            indexData = arrayAllMarkers.object(at: index) as! NSDictionary
            
            let item =
                ClusterMarkerObj(position: CLLocationCoordinate2D(latitude:  CLLocationDegrees((lat as! NSString).floatValue) ,  longitude: CLLocationDegrees((lng as! NSString).floatValue)), name: indexData as! [AnyHashable : Any])
            
            bounds  = bounds.includingCoordinate(item.position)
            
            clusterManager.add(item)
        }
        
        clusterManager.cluster()
        self.setVisibleUser()
    }
    
    /// Returns a random value between -1.0 and 1.0.
    func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    
    func userLocationMarker(location: CLLocationCoordinate2D,marker:GMSMarker) {
        
        marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        // marker.icon = UIImage(named: "map_user")
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
    }
    
    // MARK: - CLLocationManagerDelegate Action -
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        if appdel.userLocationLat == ""
        {
            appdel.userLocationLat = "\(locValue.latitude)"
            appdel.userLocationLng = "\(locValue.longitude)"
        }
        appdel.userLocationLat = "\(locValue.latitude)"
        appdel.userLocationLng = "\(locValue.longitude)"
        
    }
    // MARK: - UITableview Datasource Method -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 100 {
            return self.tempArrayUSerListing.count
        }else if tableView.tag == 1000{
            return jobInProgressJobList.count
        }
        else if tableView.tag == 2000{
            return jobUserProgressList.count
        }
        else{
            return self.arrExpertise.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1000 {
            jobInProgressJobIndex = indexPath.row
            var tempDict = NSDictionary()
            tempDict = jobInProgressJobList.object(at: indexPath.row) as! NSDictionary
            
            jobProgressTitle.text = "\(tempDict.object(forKey: "jobTitle")!)"
            jobUserProgressList = tempDict.object(forKey: "JobSeekerData") as! NSArray
            
            // Show third progress view

            self.topThirdViewJobProgressView.isHidden = false
            self.topSecondJobInProgreeView.isHidden = true

            // reload table for user
            
            
            self.JobProgressUserTbl.reloadData()
            
            self.jobUserTblHeight.constant = 1000
            let indexPath = NSIndexPath(item: jobUserProgressList.count-1, section: 0)
            self.JobProgressUserTbl.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
            let indexPathStart = NSIndexPath(item: 0, section: 0)
            self.JobProgressUserTbl.scrollToRow(at: indexPathStart as IndexPath, at: .bottom, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 100 {
            
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "EmpDashboardMainCell", for: indexPath) as! EmpDashboardMainCell
            
            mainCell.selectionStyle = .none
            
            var tempDict = NSDictionary()
            tempDict = tempArrayUSerListing.object(at: indexPath.row) as! NSDictionary
            
            let categoryList = tempDict.object(forKey: "subCategoryName") as! String
            
            
            let categories = categoryList.characters.split{$0 == ","}.map(String.init)
            
            mainCell.subCategoryArray.removeAllObjects()
            
            if categories.count > 0
            {
                
                for i in 0...categories.count-1
                {
                    if i <= 2
                    {
                        mainCell.subCategoryArray.add(categories[i])
                        
                        //       print("mainCell.subCategoryArray",mainCell.subCategoryArray)
                        
                    }
                }
            }
            
            
            mainCell.innerCollectionView.reloadData()
            
            mainCell.lblName.text = "\(tempDict.object(forKey: "name")!)"
            
            mainCell.lblfloat.text =  "\(tempDict.object(forKey: "rating")!)"
            mainCell.lblYears.text = "\(tempDict.object(forKey: "exp_years")!) years / \(tempDict.object(forKey: "distance")!) km"
            mainCell.lblRatingCount.text = "(\(tempDict.object(forKey: "userRatingCount")!))"
            
            
            if tempDict.object(forKey: "image_url") is NSNull
            {
                let placeHolderImage = "male-user"
                mainCell.imgProfilePic.image = UIImage(named: placeHolderImage)
            }
            else
            {
                let imagUrlString = tempDict.object(forKey: "image_url") as! String
                
                let url = URL(string: imagUrlString)
                let placeHolderImage = "male-user"
                let placeimage = UIImage(named: placeHolderImage)
                
                mainCell.imgProfilePic.sd_setImage(with: url, placeholderImage: placeimage)
                
                //mainCell.imgProfilePic.sd_setImage(with: url)
            }
            
            mainCell.lblMore.isHidden = true
            mainCell.moreLblHeightConstraints.constant = 0
            mainCell.MoreBottomConstraints.constant = 0

            if categories.count > 3
            {
                mainCell.lblMore.isHidden = false
                mainCell.moreLblHeightConstraints.constant = 20
                mainCell.MoreBottomConstraints.constant = 5

            }
            
            mainCell.heightContraintOfCollectionView.constant = mainCell.innerCollectionView.collectionViewLayout.collectionViewContentSize.height
            
            let btnMainCell = UIButton(frame: CGRect(x: 0, y: 0, width: mainCell.frame.size.width, height: mainCell.frame.size.height))
            btnMainCell.tag = indexPath.row
            btnMainCell.addTarget(self, action: #selector(self.clickMainCell), for: .touchUpInside)
            mainCell.addSubview(btnMainCell)
            
            mainCell.backgroundColor = UIColor.clear
           // mainCell.backgroundColor = UIColor(colorLiteralRed: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
            return mainCell

            
        } else if tableView.tag == 1000 {
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "JobProgressCell", for: indexPath) as! JobProgressCell
            
            var tempDict = NSDictionary()
            tempDict = jobInProgressJobList.object(at: indexPath.row) as! NSDictionary

            
            mainCell.JobTitleLbl.text = "\(tempDict.object(forKey: "jobTitle")!)"
            
            if indexPath.row == jobInProgressJobList.count-1 {
                
                let height = UIScreen.main.bounds.size.height - 177
                if self.JobInProgressTblView.contentSize.height > height {
                    self.jobInProgresstblHeight.constant = height
                }else{
                    self.jobInProgresstblHeight.constant = self.JobInProgressTblView.contentSize.height
                }
            }
            return mainCell
        }else if tableView.tag == 2000 {
             let mainCell = tableView.dequeueReusableCell(withIdentifier: "ProgressUserList", for: indexPath) as! ProgressUserList
            
            var tempDict = NSDictionary()
            tempDict = jobUserProgressList.object(at: indexPath.row) as! NSDictionary
            
            mainCell.userNameLbl.text = "\(tempDict.object(forKey: "name")!)"
            
            mainCell.userExpLbl.text =  "$" + "\(tempDict.object(forKey: "ratePerHour")!)" + "/hour"

            mainCell.chatBtn.tag = indexPath.row
            mainCell.chatBtn.addTarget(self, action: #selector(self.ProgressUserChat(_:)), for: .touchUpInside)
            if tempDict.object(forKey: "image_url") is NSNull
            {
                let placeHolderImage = "user"
                 mainCell.userPic.image = UIImage(named: placeHolderImage)
            }
            else
            {
                let imagUrlString = tempDict.object(forKey: "image_url") as! String
                let url = URL(string: imagUrlString)
                let placeHolderImage = "user"
                let placeimage = UIImage(named: placeHolderImage)
                 mainCell.userPic.sd_setImage(with: url, placeholderImage: placeimage)
            }

            
            if indexPath.row == jobUserProgressList.count-1 {
                let height = UIScreen.main.bounds.size.height - 177
                if self.JobProgressUserTbl.contentSize.height > height {
                    self.jobUserTblHeight.constant = height
                }else{
                    self.jobUserTblHeight.constant = self.JobProgressUserTbl.contentSize.height
                }
            }
            
            return mainCell
        }
        
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmpFilterExpertiseCell", for: indexPath) as! EmpFilterExpertiseCell
            
            var tempDict = NSDictionary()
            tempDict = arrExpertise.object(at: indexPath.row) as! NSDictionary
            cell.lblExpertiseName.text = "\(tempDict.object(forKey: "subCategoryName")!)"
            let subcategory = "\(tempDict.object(forKey: "subCategoryId")!)"
            cell.btnCheckExpertise.isSelected = false
            
            if  selectedExpertiseCategory.contains(subcategory){
                cell.btnCheckExpertise.isSelected = true
            }else{
                cell.btnCheckExpertise.isSelected = false
            }
            cell.btnCheckExpertise.tag = indexPath.row
            cell.btnCheckExpertise.addTarget(self, action: #selector(self.clickSelectExpertise(sender:)), for: .touchUpInside)
            return cell
        }
    }
    // MARK: - Select Subcategory From Expertise Table -
    func clickSelectExpertise(sender: UIButton)
    {
        let index = sender.tag
        print("index is",index)
        var tempDict = NSDictionary()
        tempDict = arrExpertise.object(at: index) as! NSDictionary
        let subCategoryId   = "\(tempDict.object(forKey: "subCategoryId")!)"

        if sender.isSelected {
            sender.isSelected = false
            selectedExpertiseCategory.remove(subCategoryId)
        }else{
            sender.isSelected = true
            selectedExpertiseCategory.add(subCategoryId)
        }
        print("selectedExpertiseCategory is",selectedExpertiseCategory)
    }
    // MARK: - Api Call -
    
    func getCategoryList()
    {
        
        /*
         {
         
         {
         "userId": "77",
         "language": "en",
         "methodName": "categoryList"
         }
         
         }
         
         */
       
        
        
        let param =  [WebServicesClass.METHOD_NAME: "categoryList","userId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage] as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            self.getUserList()

            if error != nil
            {
                print("Category Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                print(dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                if status == 1
                {
                    
                    if let catArray = dictResponse.object(forKey: "categoryList") as? [Any]
                        
                    {
                        self.arrCategory.addObjects(from: catArray)
                        
                        self.topTabCreate()
                    }
                    
                    print("arrCategory list",self.arrCategory)
                    
                    
                }
                
            }
        }
        
        
    }
    func getUserList()
    {
        /*
         nearByEmployees	"{
         ""categoryId"": ""0"",(0 - category id means all)
         ""employerId"": ""37"",
         ""latitude"": 23.0497364,
         ""longitude"": 72.5117241,
         ""language"": ""en"",
         ""methodName"": ""nearByEmployees""
         }"
         */
        
        let param =  [WebServicesClass.METHOD_NAME: "nearByEmployees","language":appdel.userLanguage,"employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","categoryId":"0","latitude":userLocation.latitude,"longitude":userLocation.longitude] as [String : Any]
        
        print("param of user list is",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()

            if error != nil
            {
                print("User Error",error?.description as String!)
                 self.getUserList()
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                print(dictResponse)
                
                let totalRecords = dictResponse.object(forKey: "totalRecords") as! Int
                
                if self.firstTimeRegistered {
                    
                    let alertController = UIAlertController(title: "", message: Localization(string: "Great! Now You have 60 days to post your jobs for free"), preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                if totalRecords > 0
                {
                    if let dataDict = (dictResponse.object(forKey: "data")) as? [Any]
                    {
                        //     print("dataDict",dataDict)
                        self.employerrListarray.addObjects(from: dataDict)
                        self.tempArrayUSerListing = self.employerrListarray
                        self.allJobUserArray = self.tempArrayUSerListing
                        
                        self.totalJobLbl.text = "\(self.tempArrayUSerListing.count) \(Localization(string: "Professionals"))"
                        
                        self.userTableView.reloadData()
                        
                       // self.buttonBarView.isHidden = false
                        
                       // self.reloadPagerTabStripView()
                        
                        
                        //  self.reloadPagerTabStripView()
                        
                        self.prepareForMarker(array: self.employerrListarray)
                        
                        //    self.prepareForMarker(array: self.employerrListarray)
                        
                        
                    }
                    
                }
                else
                {
                    
                }
                
                
            }
        }
        
    }
    
    func ExpertiseList(categoryId: String)
    {
        SwiftLoader.show(animated: true)
        
        /*
         {
         
         "categoryId": "108",
         "userId": "77",
         "language": "en",
         "methodName": "subCategoryList"
         
         }
         
         
         */
       
        
        let param =  [WebServicesClass.METHOD_NAME: "subCategoryList","categoryId":"\(categoryId)","userId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage] as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()

            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                if status == 1
                {
                    self.arrExpertise.removeAllObjects()
                    if let subCatArray = dictResponse.object(forKey: "subCategoryList") as? [Any]
                        
                    {
                        self.arrExpertise.addObjects(from: subCatArray)
                        print("arrExpertise",self.arrExpertise)
                        self.tblExpertise.reloadData()
                    }
                    else
                    {
                        self.tblExpertise.reloadData()
                        print(Response.object(forKey: "message")!)
                    }
                    
                }
            }
        }
    }
    
    
    func jobInProgressAPI()
    {
        
        /*
         {
         "employerId": "37",
         "language": "en",
         "methodName": "jobInProgress"
         }
         */
        
        SwiftLoader.show(animated: true)

        
        
        let param =  [WebServicesClass.METHOD_NAME: "jobInProgress",
                      "employerId":"65"] as [String : Any]
        
        print("jobInProgressAPI param",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            
            if error != nil
            {
                self.getCategoryList()

                print("ErrorProgress",error?.description as String!)
                
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                
                print("jobInProgressAPI dictResponse",dictResponse)

                if status == 1
                {
                    
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSArray
                    {
                        for(_,element) in dataDict.enumerated() {
                            let elemt = element as! NSDictionary
                            
                            let JobSeekerData = elemt.object(forKey: "JobSeekerData") as! NSArray
                            
                            let startHour = elemt.object(forKey: "startHour") as! String
                            let localServerTime =  self.UTCToLocal(date: startHour)
                            
                            let dateFormat = DateFormatter()
                            dateFormat.dateFormat = "HH:mm"
                            let localServerDate = dateFormat.date(from: localServerTime)
                            
                            let localTime = self.currentTime()
                            
                            
                            let  diff = Int((localServerDate?.timeIntervalSinceReferenceDate)! - localTime.timeIntervalSinceReferenceDate)
                            
                            var min = diff/60
                            min = abs(min)
                            
                            print("min is",min)
                            
                            if JobSeekerData.count > 0 {
                                if min <= 60 {
                                    self.jobInProgressJobList.add(elemt)
                                }
                            }
                        }
                        
                        

                        
                        if self.jobInProgressJobList.count > 0 {
                            self.topFirstJobInProgressView.isHidden = false
                            self.topSecondJobInProgreeView.isHidden = true
                            
                            self.JobInProgressTblView.reloadData()

                            self.jobInProgresstblHeight.constant = 1000
                            let indexPath = NSIndexPath(item: self.jobInProgressJobList.count-1, section: 0)
                            self.JobInProgressTblView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                            let indexPathStart = NSIndexPath(item: 0, section: 0)
                            self.JobInProgressTblView.scrollToRow(at: indexPathStart as IndexPath, at: .bottom, animated: true)
                        }
                        self.JobInProgressTblView.reloadData()
                    }
                    
                    self.getCategoryList()

                }
                else
                {
                    self.getCategoryList()
                }
                
                
            }
        }
    }

    
    
    // MARK: - Main Cell Click -
    
    func clickMainCell(_sender : UIButton)
    {
        print(_sender.tag)
//        let jobDetail = self.storyboard?.instantiateViewController(withIdentifier: "EmpJobSeekerDetailsVC") as! EmpJobSeekerDetailsVC
//        jobDetail.ArrayUserListing = tempArrayUSerListing
//        jobDetail.currentIndex = _sender.tag
//        self.navigationController?.pushViewController(jobDetail, animated: true)
        
        let jobDetail = self.storyboard?.instantiateViewController(withIdentifier: "EmpJobSeekerStatusVC") as! EmpJobSeekerStatusVC
        jobDetail.ArrayUserListing = tempArrayUSerListing
        jobDetail.currentIndex = _sender.tag
        jobDetail.fromDash = true
        self.navigationController?.pushViewController(jobDetail, animated: true)
    }
    // MARK: - change image From Notifier -
    func changeImage()  {
        btnProfilePic.setImage(ImgEmployerProfilepic, for: .normal)
    }

    // MARK: - Tab Swipe -
    func RightSwipe() {
        print("Swiped right")
        
        if nearByCount == 0 {
            
        }else{
            let btn = UIButton()
            btn.tag = nearByCount-1
            self.tabBtnClick(sender: btn)
        }
    }
    
    func LeftSwipe() {
        print("Swiped left")
        if nearByCount == arrCategory.count - 1 {
            
        }else{
            let btn = UIButton()
            btn.tag = nearByCount+1
            self.tabBtnClick(sender: btn)
        }
        
        
    }
    
    // MARK: - Tab Create -

    func topTabCreate()  {
        
        var distX = CGFloat()
        distX = 0
        let height = 40
        let width = 100
        
        for index in 0...self.arrCategory.count-1 {
            
            let category = (arrCategory.object(at: index) as! NSDictionary).object(forKey: "categoryName")! as! String
            
            let categoryID = (arrCategory.object(at: index) as! NSDictionary).object(forKey: "categoryId")! as! String
            let btnAddTemp = UIButton()
            btnAddTemp.frame = CGRect(x: 0, y: 0, width: width, height: height)
            btnAddTemp.setTitle(category, for: .normal)
            btnAddTemp.sizeToFit()
            
            let btnAddActual = UIButton()
            btnAddActual.frame = CGRect(x: Int(distX), y: 0, width: Int(btnAddTemp.frame.size.width), height: height)
            btnAddActual.setTitle(category, for: .normal)
            
            btnAddActual.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 15.0)
            
            let label = UILabel()
            label.frame = CGRect(x: distX, y: self.categoryScrollView.frame.size.height - 2, width: btnAddActual.frame.size.width, height: 2)
            label.backgroundColor = blueThemeColor
            label.tag = index
            if index == 0 {
                btnAddActual.setTitleColor(blueThemeColor, for: .normal)
                label.isHidden = false
                self.btnFilterExpertise.isHidden = true
                self.lblResultFrmAllCategory.isHidden = true

            }else{
                btnAddActual.setTitleColor(UIColor.darkGray, for: .normal)
                label.isHidden = true
            }
            btnAddActual.tag = index
            btnAddActual.accessibilityHint = categoryID
            btnAddActual.addTarget(self, action: #selector(EmpDash.tabBtnClick), for: .touchUpInside)
            
            self.categoryScrollView.addSubview(btnAddActual)
            self.categoryScrollView.addSubview(label)
            
            distX = btnAddActual.frame.size.width + 10 + distX
            
            //scrollWidh = distX - spacer
            
        }
        self.categoryScrollView.contentSize = CGSize(width: distX, height: 0)
        self.categoryScrollView.showsVerticalScrollIndicator = false
        self.categoryScrollView.showsHorizontalScrollIndicator = false
        
        
    }
    // MARK: - Tab Select -

    func tabBtnClick(sender:UIButton)  {
        
        let selectedIndex = sender.tag
        selectedExpertiseCategory.removeAllObjects()
        let spacer = 10
        var categoryId = ""
        if selectedIndex == 0 {
            self.btnFilterExpertise.isHidden = true
            self.lblResultFrmAllCategory.isHidden = true

        }else{
            self.btnFilterExpertise.isHidden = false
            self.lblResultFrmAllCategory.isHidden = false

        }
        for view in self.categoryScrollView.subviews {
            
            if let btn = view as? UIButton {
                
                if btn.tag ==  selectedIndex {
                    btn.setTitleColor(blueThemeColor, for: .normal)
                    categoryId = btn.accessibilityHint!
                    expertiseCategoryId = btn.accessibilityHint!
                    print("category id", categoryId)
                    let point = CGPoint(x: CGFloat(Int(btn.frame.origin.x) - Int(spacer)), y: 0)
                    self.categoryScrollView.setContentOffset(point, animated: true)
                    
                }else{
                    btn.setTitleColor(UIColor.darkGray, for: .normal)
                }
            }
            
            if let label = view as? UILabel {
                
                if label.tag ==  selectedIndex {
                    label.isHidden = false
                }else{
                    label.isHidden = true
                }
                
            }
        }
        
        if nearByCount > selectedIndex {
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            self.userTableView.beginUpdates()
            self.userTableView.layer.add(transition, forKey: nil)
            self.userTableView.endUpdates()
            self.userTableView.reloadData()
            
            
        }
        if nearByCount <= selectedIndex {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.userTableView.beginUpdates()
            self.userTableView.layer.add(transition, forKey: nil)
            self.userTableView.endUpdates()
            self.userTableView.reloadData()
            
        }
        
        if self.allJobUserArray.count > 0 {
            self.filterUser(categoryId: categoryId)
        }
        nearByCount = selectedIndex
    }
    func filterUser(categoryId:String)  {
        
        print("categoryId inside filter user",categoryId)
        
        UIView.animate(withDuration: 0.6, animations: {
            
        }, completion: { (Bool) in
            
            if categoryId == "0"
            {
                self.tempArrayUSerListing.removeAllObjects()
                self.tempArrayUSerListing = self.allJobUserArray.mutableCopy() as! NSMutableArray
                
                self.prepareForMarker(array: self.tempArrayUSerListing)
                
            }
            else
            {
                let filterArray = NSMutableArray()
                
                for i in 0...self.allJobUserArray.count-1
                {
                    var dict = NSDictionary()
                    dict = self.allJobUserArray.object(at: i) as! NSDictionary
                    
                    if categoryId.isEqual(dict.object(forKey: "categoryId") as! NSString)
                    {
                        filterArray.add(dict)
                    }
                }
                self.tempArrayUSerListing.removeAllObjects()
                self.tempArrayUSerListing = filterArray.mutableCopy() as! NSMutableArray
                self.prepareForMarker(array: self.tempArrayUSerListing)
            }
        })
        
    }
    
    // MARK: - Slide Navigation Delegates -

    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
   
    // MARK: - Gesture  Delegates -

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: self.expertiseSubView))! {
            return false
        }else{
            return true
        }
    }
    // MARK: - General  Methods -

    func filterByExpertise(notification: NSNotification)
    {
        
        if let tempDict = notification.object as? NSArray
        {
            
            var filterArray = NSMutableArray()
            
            if self.tempArrayUSerListing.count > 0
            {
                subCategoryCount = tempDict.count
                print(tempDict.count)
                print(self.tempArrayUSerListing.count)
                
                for i in 0...tempDict.count-1
                {
                    
                    let strCompare = tempDict.object(at: i) as! String
                    
                    print(strCompare)
                    
                    let predicate = NSPredicate(format: "subCategoryName contains %@",strCompare)
                    
                    var dupArray = NSArray()
                    dupArray = self.tempArrayUSerListing.filtered(using: predicate) as NSArray
                    print(dupArray)
                    
                    filterArray.addingObjects(from: dupArray as [AnyObject])
                    print("filterArray",filterArray)
                    
                }
                
                
                if filterArray.count > 0
                {
                    print("filterArray",filterArray)
                    let uniqueValues = NSMutableArray()
                    
                    for e: Any in filterArray {
                        if !uniqueValues.contains(e) {
                            uniqueValues.addObjects(from: [e])
                        }
                    }
                    
                    print("uniqueValues",uniqueValues.count)
                    
                    self.tempArrayUSerListing.removeAllObjects()
                    
                    self.tempArrayUSerListing = uniqueValues.mutableCopy() as! NSMutableArray
                    
                    print("tempArray",self.tempArrayUSerListing.count)
                    
                }
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMarker"), object: self.tempArrayUSerListing)
        }
    }
    
    func tableviewReload(notification: NSNotification)
    {
        let tempDict = notification.object as! NSArray
        
        //  print("tempDict",tempDict.count)
        
        self.tempArrayUSerListing = tempDict.mutableCopy() as! NSMutableArray
        
        //   print("tempArray",tempArray.count)
        
        self.userTableView.reloadData()
    }
    
    
    func setUpView()
    {
        tapGesture.addTarget(self, action: #selector(self.dismissView))
        self.expertiseView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        tblExpertise.delegate = self
        tblExpertise.dataSource = self
        
        expertiseView.isHidden = true
        
        let Dict = NSMutableDictionary()
        Dict.setValue("All", forKey: "categoryName")
        Dict.setValue("0", forKey: "categoryId")
        arrCategory.add(Dict)
        
        
        let lat = appdel.loginUserDict.object(forKey: "lat") as! NSString
        let long = appdel.loginUserDict.object(forKey: "lng") as! NSString
        
        
        userLocation.latitude = CLLocationDegrees(lat.floatValue)
        userLocation.longitude = CLLocationDegrees(long.floatValue)
        
        let cameraPosition = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: 11.0)
        mapView?.animate(to: cameraPosition)
        
//        GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude:latitude
//            longitude:longitude
//            zoom:11.0];
//        
//        [self.mapView animateToCameraPosition:cameraPosition];
        
        self.moveMarkerOn(markerPosition: userLocation)
        
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        
        let iconGenerator = CustomClusterIconGenerator()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showFilterExpertiseView(notification:)), name: NSNotification.Name(rawValue: "ShowFilterView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateMarkerAfterFiter(notification:)), name: NSNotification.Name(rawValue: "updateMarker"), object: nil)
        
    }
    func showFilterExpertiseView(notification: NSNotification)
    {
        arrSelectedExpertise.removeAllObjects()
        let dict = notification.object as! NSDictionary
        let catId = dict["categoryId"] as! String
        print("catId",catId)
        expertiseView.isHidden = false
        self.view.alpha = 0.95
    }
    
    func dismissView()
    {
        self.expertiseView.isHidden = true
        
    }
    
    func updateMarkerAfterFiter(notification: NSNotification) {
        
        let dict = notification.object as! NSArray
        
        //   print("Notification Dict",dict.count)
        self.expertiseView.isHidden = true
        
        var tempArray = NSMutableArray()
        
        if dict.count > 0
        {
            tempArray = dict.mutableCopy() as! NSMutableArray
            self.prepareForMarker(array: tempArray)
        }
        
    }
    
    // MARK: -  Notification Screen -
    func chatNotification(notification: NSNotification)  {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let chatScene = storyBoard.instantiateViewController(withIdentifier: "CustomChatScene") as! CustomChatScene
        let dict = notification.object as! [String: Any]
        chatScene.fromNotify = true
        
        chatScene.userName = "\(dict["sender_name"]!)"
        chatScene.userprofilePic = "\(dict["profile_pic"]!)"
        
        if dict["categoryName"] != nil  {
            chatScene.userCategory = dict["categoryName"] as! String
        }else{
            chatScene.userCategory = ""
        }
        chatScene.userID = "\(dict["userID"]!)"
        chatScene.receiver_id = "\(dict["sender_id"]!)"
        //chatScene.userType = "\(dict["userStatus"]!)"
        
        chatScene.userType = "0"

        chatScene.chat_message_id = "\(dict["chat_message_id"]!)"
        
        let topVC = UIApplication.topViewController()
        if topVC is CustomChatScene {
        }else{
            self.navigationController?.pushViewController(chatScene, animated: true)
        }
        
    }
    func jobSeekerRating(notification: NSNotification)  {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let reviewJob = storyBoard.instantiateViewController(withIdentifier: "ReviewJobNotifierVC") as! ReviewJobNotifierVC
        let dict = notification.object as! [String: Any]
        reviewJob.userDic = dict
        
        let topVC = UIApplication.topViewController()
        if topVC is ReviewJobNotifierVC {
        }else{
            self.navigationController?.pushViewController(reviewJob, animated: true)
        }
    }
    func editjobNotify(notification: NSNotification)  {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let editJob = storyBoard.instantiateViewController(withIdentifier: "editJobNotifyVC") as! editJobNotifyVC
        let dict = notification.object as! [String: Any]
        editJob.userDic = dict
        
        let topVC = UIApplication.topViewController()
        if topVC is editJobNotifyVC {
        }else{
            self.navigationController?.pushViewController(editJob, animated: true)
        }
    }
    
    func selection(notification: NSNotification)  {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let selection = storyBoard.instantiateViewController(withIdentifier: "selctionViewController") as! selctionViewController
        let dict = notification.object as! [String: Any]
        selection.userDic = dict
        
        let topVC = UIApplication.topViewController()
        if topVC is selctionViewController {
        }else{
            self.navigationController?.pushViewController(selection, animated: true)
        }
    }
}
