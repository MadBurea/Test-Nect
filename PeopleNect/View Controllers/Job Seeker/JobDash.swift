//
//  JobDash.swift
//  PeopleNect
//
//  Created by BAPS on 10/17/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader
import SDWebImage
import GoogleMaps
import CoreLocation
import SwiftLoader
import Alamofire

let keylat = "Latitude"
let keylong = "Longitude"
let keyrating = "rating"
let keyrate = "rate"
let keyisJob = "isJob"

class jobClusterMarkerObj: NSObject, GMUClusterItem{
    
    var name: [AnyHashable : Any]!
    var position: CLLocationCoordinate2D
    
    init(position: CLLocationCoordinate2D, name: [AnyHashable : Any]) {
        self.position = position
        self.name = name
    }
}

class ClusterMarkerObj: NSObject, GMUClusterItem {
    
    var name: [AnyHashable : Any]!
    var position: CLLocationCoordinate2D
    
    init(position: CLLocationCoordinate2D, name: [AnyHashable : Any]) {
        self.position = position
        self.name = name
    }
}

class CellCollectionJobInProgress: UICollectionViewCell{
    @IBOutlet var lblJob: UILabel!
    @IBOutlet var lblPaymentPerHour: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var imgRating: UIImageView!
    @IBOutlet var lblExpandJobInProgressTime: UILabel!
    @IBOutlet var lblJobInProgressLocation: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblExpandJobInProgressLocationLatLng: UILabel!
    
    @IBOutlet weak var minLeftArrow: UIImageView!
    @IBOutlet weak var maxRightArrow: UIImageView!
    @IBOutlet var lblBtnSeeOnMap: UILabel!
}
class JobDash: UIViewController,GMUClusterManagerDelegate, GMSMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,SlideNavigationControllerDelegate,  UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var noneLbl: UILabel!
    @IBOutlet weak var firstTimeRegsisterView: UIView!
    @IBOutlet var tblAvailibility: UITableView!
    @IBOutlet weak var notifyBadgeRed: UIView!
    @IBOutlet var viewAvailiobilityPerDay: UIView!
    @IBOutlet var viewAvailibilityOnOff: UIView!
    @IBOutlet var viewTurnYourAvailibiltyOn: UIView!
    @IBOutlet weak var totalJobCountLbl: UILabel!
    @IBOutlet weak var inMyareaBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var inMyareaBorderLbl: UILabel!
    @IBOutlet weak var allBorderLbl: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableContainerHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var CategoryTable: UITableView!
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet var lblAvaibilityTimeDay: UILabel!
    @IBOutlet var viewNMRangeSlider: UIView!
    @IBOutlet var SliderTimingNM: NMRangeSlider!
    @IBOutlet var lblLowerTime: UILabel!
    @IBOutlet var lblHigherTime: UILabel!
    @IBOutlet var constrainLowerLeading: NSLayoutConstraint!
    @IBOutlet var constrainHigherTrailing: NSLayoutConstraint!
    @IBOutlet weak var btnAvailibilityClose: UIButton!
    @IBOutlet weak var btnToggleAvail: UIButton!
   
    /* Notificatioon View Job In progress */
    @IBOutlet var viewJobInProgress: UIView!
    @IBOutlet var lblJobInProgrss: UILabel!
    @IBOutlet var imgJobInProgressDownArrow: UIImageView!
    @IBOutlet var btnJobInProgress: UIButton!
    
    /* Notificatioon expand Job In Progress */
    @IBOutlet var objCollectionJobInProgress: UICollectionView!
    @IBOutlet var viewExpandJobInProgress: UIView!
    @IBOutlet var imgRefresh: UIImageView!
    @IBOutlet var lblJobInProgress: UILabel!
    @IBOutlet var btnExpandJobInProgress: UIButton!
    @IBOutlet var constrainExpandJobCollectionHeight: NSLayoutConstraint!
   
    var userMarker = GMSMarker()
    var clusterManager: GMUClusterManager!
    var arrayAllMarkers = NSMutableArray()
    var status = false
    var CategoryName = String()
    var selectedTab = 0
    var previousMarker = GMSMarker()
    var arrayMySpecJobs = NSMutableArray()
    var tempArrayJob = NSMutableArray()
    var arrayAllSpecJobs = NSMutableArray()
    var isJobSekeer = 1
    var userLocation = CLLocationCoordinate2D()
    var isAvailibilty = 1
    var isSelected = false
    var fromLastDetail = false
    var StartTime = String()
    var EndTime = String()
    var currentDay = String()
    var type = 0
    var global = WebServicesClass()
    var locationManager = CLLocationManager()
    var arrDaysName = NSMutableArray()
    var arrDaysFull = NSMutableArray()
    var arrCopy = NSMutableArray()
    var arrDisplayDaysFull = NSMutableArray()
    var intTag = 100
    var currentIndex = -1
    var previousIndex = -1
    var JobID = String()
    var JobLat = ""
    var JobLng = ""
    var arrJobInProgress = NSMutableArray()
    var SettingDetailUPdated = false
    var today : String!
    
    var refreshControl = UIRefreshControl()
    var isForRefresh = false
    
    var toastLoginMessage = ""
    var toastLogin = false    // MARK: - UIVIew Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        /* job in progress view */
        self.viewJobInProgress.isHidden = true
        self.viewExpandJobInProgress.isHidden = true
        self.totalJobCountLbl.text = ""
        // Refresh Controller?
        self.refreshContoller()
        
        
//        self.SliderTimingNM.lowerValue = "00:00"
//        self.SliderTimingNM.upperValue
        
        self.noneLbl.isHidden = true
        self.CategoryTable.rowHeight = UITableViewAutomaticDimension
        self.CategoryTable.estimatedRowHeight = 80
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        
        self.firstTimeRegsisterView.isHidden = true
        
        if fromLastDetail {
            self.firstTimeRegsisterView.isHidden = false
        }
        if imageIsNull(imageName: ImgJobSeekerProfilepic )
        {
            self.setImageForJobSeeker(btnProfilePic:btnProfilePic)
        }
        else
        {
            btnProfilePic.setImage(ImgJobSeekerProfilepic, for: .normal)
        }
        btnProfilePic.imageView?.contentMode = .scaleAspectFill

        
        self.view.addSubview(viewAvailibilityOnOff)
        self.view.addSubview(viewAvailiobilityPerDay)
        self.view.addSubview(viewTurnYourAvailibiltyOn)
        
        
        viewAvailiobilityPerDay.isHidden = true
        viewAvailibilityOnOff.isHidden = true
        viewTurnYourAvailibiltyOn.isHidden = true
        
        
        arrDisplayDaysFull = [ Localization(string: "Sunday"),Localization(string: "Monday"),Localization(string: "Tuesday"),Localization(string: "Wednesday"),Localization(string: "Thursday"),Localization(string: "Friday"),Localization(string: "Saturday")]

     //   arrDaysName = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        
        arrDaysName = [ Localization(string: "Sun"),Localization(string: "Mon"),Localization(string: "Tue"),Localization(string: "Wed"),Localization(string: "Thu"),Localization(string: "Fri"),Localization(string: "Sat")]

        tblAvailibility.bounces = false
        tblAvailibility.separatorStyle = .none
    
        btnProfilePic.layer.cornerRadius = btnProfilePic.bounds.size.width/2
        btnProfilePic.clipsToBounds = true

        
        self.navigationController?.navigationBar.isHidden = true

        
        btnToggleAvail.backgroundColor = UIColor.clear
        btnToggleAvail.setImage(#imageLiteral(resourceName: "imgbtnon"), for: .normal)

        
        totalJobCountLbl.isHidden = true
    self.CategoryTable.register(UINib(nibName: "JobDashBoardMainCell", bundle: Bundle.main), forCellReuseIdentifier: "JobDashBoardMainCell")
        
    self.CategoryTable.register(UINib(nibName: "JobDashBoardInnerViewCell", bundle: Bundle.main), forCellReuseIdentifier: "JobDashBoardInnerViewCell")
        

        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.RightSwipe))
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.CategoryTable.addGestureRecognizer(swipeRight)
        swipeRight.delegate = self

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.LeftSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        swipeLeft.delegate = self
        self.CategoryTable.addGestureRecognizer(swipeLeft)
        
        allBorderLbl.isHidden = false
        inMyareaBorderLbl.isHidden = true
        
        
        self.setUpView()

        mapView.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        
        CategoryTable.rowHeight = UITableViewAutomaticDimension
        CategoryTable.estimatedRowHeight = 170
        CategoryTable.tag = 100
        
        CategoryTable.backgroundColor = UIColor.clear
        
        
        // NMRangeSlider
        
        
        SliderTimingNM.trackBackgroundImage = #imageLiteral(resourceName: "slider-default-track.png")
        
        SliderTimingNM.trackImage =  UIImage(named: "SliderPath")
        
        SliderTimingNM.lowerHandleImageNormal = UIImage(named: "FilterSlider")
        
        SliderTimingNM.upperHandleImageNormal = UIImage(named: "FilterSlider")
        
        SliderTimingNM.lowerHandleImageHighlighted = UIImage(named: "FilterSlider")
        
        SliderTimingNM.upperHandleImageHighlighted = UIImage(named: "FilterSlider")
        
        
        /*---------- Slider View ----------*/
        
        SliderTimingNM.minimumValue = Float(Int(00))
        SliderTimingNM.maximumValue = Float(Int(24))
        
        
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        
        let iconGenerator = CustomClusterIconGenerator()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,renderer: renderer)
        
        CategoryTable.delegate = self
        CategoryTable.dataSource = self
        
        self.registerNotification()
        
        // Badge Notification
        self.notifyBadgeRed.isHidden = true
        if appdel.showRedBadge{
            self.notifyBadgeRed.layer.cornerRadius = 7.5
            self.notifyBadgeRed.layer.masksToBounds = true
            self.notifyBadgeRed.isHidden = false
        }
        
        // toast
        if SettingDetailUPdated {
            self.view.makeToast(Localization(string:"Details Updated."), duration: 3.0, position: .bottom)
        }
        
       
        if toastLogin {
            self.view.makeToast(toastLoginMessage, duration: 1.0, position: .bottom)
        }
    }
    
    
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
    }
    
    
    
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        //2017-11-22 17:12:56
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: today)
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        var dateString = String()
        dateString = date!.getStringFromDate()
        let check = todayDate.getStringFromDate()
        
        if dateString == check {
            dateString = "Today"
        }else{
            dateString = date!.getStringFromDate()
        }
        
        return dateString
    }
    
    
    func getDateFromString() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: today)
        
        return date!
    }
    
    func getStringFromDate() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM"
//        let dateString = dateFormatter.string(from: date)
//
//        return dateString

        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    self.navigationController?.navigationBar.isHidden = true
        
        if (appdel.isNotificationCome == false)
        {
            DispatchQueue.main.async {
                self.jobInProgressAPI()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        
        tableContainerHeightConstraints.constant = UIScreen.main.bounds.size.height - (80 + sectionView.frame.size.height)
        
        if imageIsNull(imageName: ImgJobSeekerProfilepic )
        {
            self.setImageForJobSeeker(btnProfilePic:btnProfilePic)
        }
        else
        {
            btnProfilePic.setImage(ImgJobSeekerProfilepic, for: .normal)
        }

        
        viewAvailibilityOnOff.frame =  CGRect(x: self.view.bounds.origin.x , y: 80, width: self.view.bounds.width, height: self.view.bounds.height - 80)
        
        viewAvailiobilityPerDay.frame =  CGRect(x: 0 , y: (self.view.bounds.height/3)+80, width: self.view.bounds.width , height: self.view.bounds.height - 80 - (self.view.bounds.height/3))
        
        viewTurnYourAvailibiltyOn.frame =  CGRect(x: 0 , y: 80, width: self.view.bounds.width, height: 200)
        
        
        //upperHandle
        
        //self.lblHigherTime.frame = CGRect(x: self.SliderTimingNM.frame.origin.x, y: self.SliderTimingNM.frame.origin.y + 20, width: 30, height: 25)
        
        
         self.SliderTimingNM.trackImage = #imageLiteral(resourceName: "slider-default7-track.png")
       
        self.lblHigherTime.text = "23:59"
        
        
       self.SliderTimingNM.lowerValue = 0
        self.SliderTimingNM.upperValue = 24
        
         //self.lblHigherTime.frame = CGRect(x: UIScreen.main.bounds.width - 50, y: self.lblLowerTime.frame.origin.y, width: 30, height: 25)
        
        
        self.lblHigherTime.frame = CGRect(x: self.SliderTimingNM.frame.origin.x + self.SliderTimingNM.frame.width - 25 , y: self.lblLowerTime.frame.origin.y + 20, width: 30, height: 25)
        
      }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Google Mpas Delegate
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        if selectedTab == 0
        {
            self.setVisibleUser(array: arrayAllSpecJobs)
        }
        else
        {
            self.setVisibleUser(array: arrayMySpecJobs)
        }
    
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if  marker.userData is GMUCluster {
            
            let data = marker.userData as! GMUCluster
            
            if previousMarker.icon != nil {
                previousMarker.icon = self.getUIImageFromThisUIView(aUIView: self.customImageLabelMarker(Int(data.count),green: false))
            }

            marker.icon = self.getUIImageFromThisUIView(aUIView: self.customImageLabelMarker(Int(data.count),green: true))
            currentIndex = 0
            CategoryTable.reloadData()
            self.previousMarker = marker
            
        } else if marker.userData is ClusterMarkerObj {
            
            
            if previousMarker.icon != nil {
                previousMarker.icon = self.getUIImageFromThisUIView(aUIView: self.customImageLabelMarker(1,green: false))
            }

            marker.icon = self.getUIImageFromThisUIView(aUIView: self.customImageLabelMarker(1,green: true))

            currentIndex = 0
            CategoryTable.reloadData()
            self.previousMarker = marker

        }
        return true
    }
    

    func setVisibleUser(array:NSMutableArray)
     {
        let visibleUser = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: visibleUser)
        tempArrayJob.removeAllObjects()
        tempArrayJob = NSMutableArray()

        var lat:NSString
        var long:NSString
        var position = CLLocationCoordinate2D()

        if array.count > 0 {
            for index in 0...array.count-1
            {
                
                lat = (array.object(at: index) as! NSDictionary).object(forKey: "latitude")! as! NSString
                
                long = (array.object(at: index) as! NSDictionary).object(forKey: "longitude")! as! NSString
                
                position = CLLocationCoordinate2D(latitude:  CLLocationDegrees((lat ).floatValue) ,  longitude: CLLocationDegrees((long ).floatValue))
                
                if bounds.contains(position)
                {
                    tempArrayJob.add(array.object(at: index))
                }
                
            }
        }
        

        let nameDescriptor = NSSortDescriptor(key: "distance", ascending: true)
        let sortDescriptors = [nameDescriptor]
        let ordered = tempArrayJob.sortedArray(using: sortDescriptors) as NSArray
        
        tempArrayJob.removeAllObjects()
        tempArrayJob = NSMutableArray()
        
        tempArrayJob = ordered.mutableCopy() as! NSMutableArray
        
        if ordered.count == 0 {
            self.noneLbl.isHidden = false
        }else{
            self.noneLbl.isHidden = true
        }
        
        self.totalJobCountLbl.text = ("\(ordered.count) \(Localization(string: "jobs in")) \(self.CategoryName)")
        CategoryTable.reloadData()
     }
    
    // MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100
        {
            return self.tempArrayJob.count
        }
        else
        {
            // for availability
            return arrDaysFull.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 100 {
            
            if indexPath.row == currentIndex
            {
                currentIndex = -1
            }
            else
            {
                currentIndex = indexPath.row
            }
            
            CategoryTable.reloadData()
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 100 {
            
            if indexPath.row == currentIndex
            {
                let expandcell = tableView.dequeueReusableCell(withIdentifier: "JobDashBoardInnerViewCell", for: indexPath) as! JobDashBoardInnerViewCell
                
                expandcell.selectionStyle = .none
                previousIndex = currentIndex
    
                var tempDict = NSDictionary()
                tempDict = self.tempArrayJob.object(at: indexPath.row) as! NSDictionary
                
                let categoryList = tempDict.object(forKey: "category") as! String
                
                JobID = tempDict.object(forKey: "jobId") as! String
                
                let categories = categoryList.characters.split{$0 == ","}.map(String.init)
                
                expandcell.arrSubCatData.removeAllObjects()
                
                if categories.count > 0
                {
                    for i in 0...categories.count-1
                    {
                        if i <= 2
                        {
                            expandcell.arrSubCatData.add(categories[i])
                            
                            if expandcell.arrSubCatData.count > 2
                            {
                                expandcell.constrainHeightCollection.constant = 100
                            }
                        }
                    }
                }
                
                //jobRefuceStatus
                let jobRefuceStatus = tempDict.object(forKey: "jobRefuceStatus") as! Int
                
                let getUserSelectedStatus = tempDict.object(forKey: "userSelectedStatus") as! Int
                
                let getApplicationStatus = tempDict.object(forKey: "applicationStatus") as! Int
                
                let getUserInvitationStatus = tempDict.object(forKey: "userInvitedStatus") as! Int
                
                
                if jobRefuceStatus != 0
                {
                    // Red
                    expandcell.viewLeft.backgroundColor = ColorJobRefused
                    expandcell.viewPayment.backgroundColor = ColorJobRefused
                    expandcell.viewOnlyDays.backgroundColor = ColorJobRefused
                    expandcell.viewFromEndDate.backgroundColor = ColorJobRefused
                    expandcell.lblBottomBorder.backgroundColor = ColorJobRefused
                    
                    expandcell.textLabel?.textAlignment = .center
                    
                    expandcell.btnApplyAlReadyInvited.setTitle(Localization(string:"See details"), for: .normal)
                    expandcell.btnApplyAlReadyInvited.backgroundColor = ColorJobRefused
                    
                    expandcell.bottomLineB.backgroundColor = ColorseperatorDarkRed
                    expandcell.bottonLineA.backgroundColor = ColorseperatorDarkRed
                    
                    let imageName = "redmap"
                    expandcell.imgLocation.image = UIImage(named: imageName)
                }
                    
                else if getUserSelectedStatus == 1
                {
                    // Green
                    
                    expandcell.viewLeft.backgroundColor = ColorJobSelected
                    expandcell.viewPayment.backgroundColor = ColorJobSelected
                    expandcell.viewOnlyDays.backgroundColor = ColorJobSelected
                    expandcell.viewFromEndDate.backgroundColor = ColorJobSelected
                    expandcell.lblBottomBorder.backgroundColor = ColorJobSelected
                    expandcell.textLabel?.textAlignment = .center
                    
                    expandcell.btnApplyAlReadyInvited.setTitle(Localization(string:"See details"), for: .normal)
                    
                    
                    expandcell.btnApplyAlReadyInvited.accessibilityHint = "RED"
                    
                    expandcell.btnApplyAlReadyInvited.backgroundColor = ColorJobSelected
                    
                    expandcell.bottomLineB.backgroundColor = ColorseperatorDarkGreen
                    expandcell.bottonLineA.backgroundColor = ColorseperatorDarkGreen
                    
                    let imageName = "map3"
                    
                    expandcell.imgLocation.image = UIImage(named: imageName)
                }
                    
                else if getApplicationStatus == 1
                {
                    // Yellow
                    expandcell.viewLeft.backgroundColor = ColorJobAlRedyInvitedApplied
                    expandcell.viewPayment.backgroundColor = ColorJobAlRedyInvitedApplied
                    expandcell.viewOnlyDays.backgroundColor = ColorJobAlRedyInvitedApplied
                    expandcell.viewFromEndDate.backgroundColor = ColorJobAlRedyInvitedApplied
                    expandcell.lblBottomBorder.backgroundColor = ColorJobAlRedyInvitedApplied
                    
                    
                    
                    expandcell.btnApplyAlReadyInvited.setTitle( Localization(string:"Follow up"), for: .normal)
                    expandcell.textLabel?.textAlignment = .center
                    
                    expandcell.btnApplyAlReadyInvited.backgroundColor = ColorJobAlRedyInvitedApplied
                    
                    expandcell.bottomLineB.backgroundColor = ColorseperatorDarkYellow
                    expandcell.bottonLineA.backgroundColor = ColorseperatorDarkYellow
                    
                    let imageName = "map_yellow"
                    expandcell.imgLocation.image = UIImage(named: imageName)
                    
                }
                    
                else if getUserInvitationStatus == 1
                {
                    //
                    expandcell.viewLeft.backgroundColor = ColorJobAlRedyInvitedApplied
                    expandcell.viewPayment.backgroundColor = ColorJobAlRedyInvitedApplied
                    expandcell.viewOnlyDays.backgroundColor = ColorJobAlRedyInvitedApplied
                    expandcell.viewFromEndDate.backgroundColor = ColorJobAlRedyInvitedApplied
                    expandcell.lblBottomBorder.backgroundColor = ColorJobAlRedyInvitedApplied
                    
                    
                    
                    expandcell.btnApplyAlReadyInvited.setTitle(Localization(string:"Already invited"), for: .normal)
                    
                    expandcell.textLabel?.textAlignment = .center
                    
                    expandcell.btnApplyAlReadyInvited.backgroundColor = ColorJobAlRedyInvitedApplied
                    
                    expandcell.bottomLineB.backgroundColor = ColorseperatorDarkYellow
                    expandcell.bottonLineA.backgroundColor = ColorseperatorDarkYellow
                    
                    let imageName = "map_yellow"
                    expandcell.imgLocation.image = UIImage(named: imageName)
                    
                }
                    
                else
                {
                    // Blue
                    expandcell.viewLeft.backgroundColor = blueThemeColor
                    expandcell.viewPayment.backgroundColor = blueThemeColor
                    expandcell.viewOnlyDays.backgroundColor = blueThemeColor
                    expandcell.viewFromEndDate.backgroundColor = blueThemeColor
                    expandcell.lblBottomBorder.backgroundColor = blueThemeColor
                    expandcell.btnApplyAlReadyInvited.setTitle(Localization(string:"Apply"), for: .normal)
                    
                    
                    
                    expandcell.btnApplyAlReadyInvited.backgroundColor = blueThemeColor
                    
                    expandcell.bottomLineB.backgroundColor = ColorseperatorDarkBlue
                    expandcell.bottonLineA.backgroundColor = ColorseperatorDarkBlue
                    
                    expandcell.textLabel?.textAlignment = .center
                    
                    let imageName = "map2"
                    expandcell.imgLocation.image = UIImage(named: imageName)
                    
                }
                
                expandcell.objCollectionView.reloadData()
                
                expandcell.lblJob.text = "\(tempDict.object(forKey: "jobTitle")!)"
                
               
                let StartTime = "\(tempDict.object(forKey: "start_hour")!)"
                let Time = "\(tempDict.object(forKey: "start_date")!)" + ":" + "\(StartTime)"
                let newDate = convertDateFormater(Time)
                expandcell.lblDate.text = newDate
                expandcell.lblCompany.text =  "\(tempDict.object(forKey: "companyName")!)"
                
                
                let balance = "\(tempDict.object(forKey: "rate")!)" as NSString
                
                var balanceRS = Int()
                balanceRS = balance.integerValue
                
                if appdel.deviceLanguage == "pt-BR"
                {
                    let number = NSNumber(value: balance.floatValue)
                    expandcell.lblPayment.text = ConvertToPortuegeCurrency(number: number)
                }
                else
                {
                    expandcell.lblPayment.text = "$\(balanceRS.withCommas())" + ".00"
                }
                
                expandcell.lblRatings.text =  "\(tempDict.object(forKey: "rating")!)"
                expandcell.lblLocation.text =  "\(tempDict.object(forKey: "distance")!)km"
                expandcell.lblDescription.text =  "\(tempDict.object(forKey: "jobDescription")!)"
                
                let perDay = tempDict.object(forKey: "payment_type") as! String
                
                if perDay == "1"
                {
                    expandcell.lblPerHour.text = "/" + "\(Localization(string: "hour"))"
                }
                else if perDay == "2"
                {
                    expandcell.lblPerHour.text = "/" + "\(Localization(string: "job"))"
                }else{
                    expandcell.lblPerHour.text = "/" + "\(Localization(string: "month"))"
                }
                
                
                var endTime = "\(tempDict.object(forKey: "end_hour")!)"
                var endDate = tempDict.object(forKey: "end_date") as! String

                if endDate == "0000-00-00"
                {
                    endDate = "No end Date"
                }
                else
                {
                    let Time = "\(tempDict.object(forKey: "end_date")!)" + ":" + "\(tempDict.object(forKey: "end_hour")!)"
                    endDate = convertDateFormater(Time)
                }

                

                
                if endTime == "" {
                    
                    endTime = "00:00"
                    expandcell.lblFromEndDate.text =  "\(strFrom) \n \(newDate) \n \(strTo) \n \(endDate) \n | \n \(strFrom) \n \(self.UTCToLocal(date: tempDict.object(forKey: "start_hour")! as! String))h \n to \n \(strNoEndDate)"
                }else{
                    
                    expandcell.lblFromEndDate.text =  "\(strFrom) \n \(newDate) \n to \n \(endDate) \n | \n \(strFrom) \n \(self.UTCToLocal(date: tempDict.object(forKey: "start_hour")! as! String))h \n \(strTo) \n \(self.UTCToLocal(date:tempDict.object(forKey: "end_hour")! as! String))h"
                }
                
                let workingDays = tempDict.object(forKey: "working_day") as! String
                
                if workingDays == "0"
                {
                    expandcell.lblOnlyDays.text = strOnlyBussDays
                }
                else if workingDays == "1"
                {
                    expandcell.lblOnlyDays.text = strIncludesNonBussDays
                }
                expandcell.btnApplyAlReadyInvited.tag = indexPath.row
                expandcell.btnApplyAlReadyInvited.addTarget(self, action: #selector(self.applyStatus(sender:)), for: .touchUpInside)
                expandcell.backgroundColor = UIColor.clear
                
                
                expandcell.contentView.layer.cornerRadius = 2.0
                expandcell.contentView.layer.shadowColor = UIColor.gray.cgColor
                expandcell.contentView.layer.shadowOpacity = 0.5
                expandcell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
                expandcell.contentView.layer.shadowRadius = 2.0

                
                return expandcell
                
            }
            else
            {
                let mainCell = tableView.dequeueReusableCell(withIdentifier: "JobDashBoardMainCell", for: indexPath) as! JobDashBoardMainCell
                
                
                mainCell.selectionStyle = .none
                
                var tempDict = NSDictionary()
                tempDict = self.tempArrayJob.object(at: indexPath.row) as! NSDictionary
                
                JobID = tempDict.object(forKey: "jobId") as! String
                
                
                //jobRefuceStatus
                
                let jobRefuceStatus = tempDict.object(forKey: "jobRefuceStatus") as! Int
                
                let getUserSelectedStatus = tempDict.object(forKey: "userSelectedStatus") as! Int
                
                let getApplicationStatus = tempDict.object(forKey: "applicationStatus") as! Int
                
                let getUserInvitationStatus = tempDict.object(forKey: "userInvitedStatus") as! Int
                
                
                
                if jobRefuceStatus != 0
                {
                    // Red
                    mainCell.viewLeft.backgroundColor = ColorJobRefused
                    mainCell.lblBottomBorder.backgroundColor = ColorJobRefused
                    
                    let imageName = "redmap"
                    mainCell.imgLocation.image = UIImage(named: imageName)
                    
                }
                else if getUserSelectedStatus == 1
                {
                    // Green
                    mainCell.viewLeft.backgroundColor = ColorJobSelected
                    mainCell.lblBottomBorder.backgroundColor = ColorJobSelected
                    
                    let imageName = "map3"
                    mainCell.imgLocation.image = UIImage(named: imageName)
                }
                else if getApplicationStatus == 1
                {
                    // Yellow
                    mainCell.viewLeft.backgroundColor = ColorJobAlRedyInvitedApplied
                    mainCell.lblBottomBorder.backgroundColor = ColorJobAlRedyInvitedApplied
                    
                    let imageName = "map_yellow"
                    mainCell.imgLocation.image = UIImage(named: imageName)
                }
                else if getUserInvitationStatus == 1
                {
                    // Yellow
                    mainCell.viewLeft.backgroundColor = ColorJobAlRedyInvitedApplied
                    mainCell.lblBottomBorder.backgroundColor = ColorJobAlRedyInvitedApplied
                    
                    let imageName = "map_yellow"
                    mainCell.imgLocation.image = UIImage(named: imageName)

                }
                else
                {
                    // Blue
                    mainCell.viewLeft.backgroundColor = blueThemeColor
                    
                    mainCell.lblBottomBorder.backgroundColor = blueThemeColor
                    
                    let imageName = "map2"
                    mainCell.imgLocation.image = UIImage(named: imageName)
                    
                }
                
                mainCell.lblJob.text = "\(tempDict.object(forKey: "jobTitle")!)"
                
                let StartTime = "\(tempDict.object(forKey: "start_hour")!)"
                let Time = "\(tempDict.object(forKey: "start_date")!)" + ":" + "\(StartTime)"
                let newDate = convertDateFormater(Time)

                
              //  let newDate = convertDateFormater("\(tempDict.object(forKey: "start_date")!)")

                mainCell.lblDate.text = newDate
                
                mainCell.lblCompany.text =  "\(tempDict.object(forKey: "companyName")!)"
                
                mainCell.lblLocation.text =  "\(tempDict.object(forKey: "distance")!)km"
                mainCell.lblRating.text =  "\(tempDict.object(forKey: "rating")!)"
                
                
                let balance = "\(tempDict.object(forKey: "rate")!)" as NSString
                var balanceRS = Int()
                balanceRS = balance.integerValue
                
                if appdel.deviceLanguage == "pt-BR"
                {
                    let number = NSNumber(value: balance.floatValue)
                    mainCell.lblPayment.text = ConvertToPortuegeCurrency(number: number)
                }
                else
                {
                    mainCell.lblPayment.text = "$\(balanceRS.withCommas())" + ".00"
                }
                
                //mainCell.lblPayment.text =  "$\(tempDict.object(forKey: "rate")!)" + ".00"
                
                let perDay = tempDict.object(forKey: "payment_type") as! String
                
                if perDay == "1"
                {
                    mainCell.lblPerHour.text = "/" + "\(Localization(string: "hour"))"
                }
                else if perDay == "2"
                {
                    mainCell.lblPerHour.text = "/" + "\(Localization(string: "job"))"
                }else{
                    mainCell.lblPerHour.text = "/" + "\(Localization(string: "month"))"
                }
                
                mainCell.backgroundColor = UIColor.clear
                mainCell.contentView.layer.cornerRadius = 2.0
                mainCell.contentView.layer.shadowColor = UIColor.gray.cgColor
                mainCell.contentView.layer.shadowOpacity = 0.5
                mainCell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
                mainCell.contentView.layer.shadowRadius = 2.0

                return mainCell
            }
        }
        else
        {
            
            // Available Table 
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobAvailibilityOnOffCell",for: indexPath) as! JobAvailibilityOnOffCell
            
            cell.selectionStyle = .none
            
            cell.lblDay.text = arrDaysName.object(at: indexPath.row) as? String
            
            if indexPath.row == 0
            {
                let myCurrentDict = arrDaysFull.object(at: arrDaysFull.count-1) as! NSDictionary
                
                //let day = myCurrentDict.object(forKey: "day") as! String
                let start = myCurrentDict.object(forKey: "start_time") as! String
                let end = myCurrentDict.object(forKey: "end_time") as! String
                
                if start.isEmpty && end.isEmpty
                {
                    //
                    
                    cell.btnCancel.tag =  (arrDaysFull.count - 1) + 100

                    cell.btnCancel.accessibilityHint = "\(indexPath.row + 100)"
                    
                    cell.lblTime.text = strNotAvailability
                    
                    cell.btnCancel.setImage(#imageLiteral(resourceName: "plus_1"), for: .normal)
                    
                    cell.viewTblCell.backgroundColor = UIColor.clear
                    cell.viewTblCell.layer.borderWidth = 1
                    cell.viewTblCell.layer.borderColor = UIColor.white.cgColor
                    cell.lblDay.textColor = UIColor.white
                    cell.lblTime.textColor = UIColor.white
                }
                else
                {
                    //cell.btnCancel.tag = indexPath.row
                    
                    cell.btnCancel.tag = arrDaysFull.count - 1
                    
                    cell.lblTime.text = "\(self.UTCToLocal(date: start))" + " - " + "\(self.UTCToLocal(date: end))"
                    
                    cell.viewTblCell.layer.cornerRadius = 5
                    cell.viewTblCell.layer.borderWidth = 1
                    cell.viewTblCell.layer.borderColor = UIColor.clear.cgColor
                    
                    cell.btnCancel.setImage(#imageLiteral(resourceName: "close"), for: .normal)
                    
                    cell.viewTblCell.backgroundColor = UIColor.white
                    
                    cell.lblDay.textColor = blueThemeColor
                    cell.lblTime.textColor = blueThemeColor
                    
                }
            }
            else if indexPath.row == arrDaysFull.count-1
            {
                let myCurrentDict = arrDaysFull.object(at: 5) as! NSDictionary
                //let day = myCurrentDict.object(forKey: "day") as! String
                let start = myCurrentDict.object(forKey: "start_time") as! String
                let end = myCurrentDict.object(forKey: "end_time") as! String
                
                if start.isEmpty && end.isEmpty
                {
                    
                    cell.btnCancel.tag = 5 + 100


                    cell.btnCancel.accessibilityHint = "\(indexPath.row + 100)"

                    cell.lblTime.text = strNotAvailability
                    
                    cell.btnCancel.setImage(#imageLiteral(resourceName: "plus_1"), for: .normal)
                    
                    cell.viewTblCell.backgroundColor = UIColor.clear
                    cell.viewTblCell.layer.borderWidth = 1
                    cell.viewTblCell.layer.borderColor = UIColor.white.cgColor
                    cell.lblDay.textColor = UIColor.white
                    cell.lblTime.textColor = UIColor.white
                }
                else
                {
                    //cell.btnCancel.tag = indexPath.row
                    
                    cell.btnCancel.tag = 5

                    
                    cell.lblTime.text = "\(self.UTCToLocal(date: start))" + " - " + "\(self.UTCToLocal(date: end))"
                    
                    cell.viewTblCell.layer.cornerRadius = 5
                    cell.viewTblCell.layer.borderWidth = 1
                    cell.viewTblCell.layer.borderColor = UIColor.clear.cgColor
                    
                    cell.btnCancel.setImage(#imageLiteral(resourceName: "close"), for: .normal)
                    
                    cell.viewTblCell.backgroundColor = UIColor.white
                    
                    cell.lblDay.textColor = blueThemeColor
                    cell.lblTime.textColor = blueThemeColor
                    
                }
            } else{
                let myCurrentDict = arrDaysFull.object(at: indexPath.row-1) as! NSDictionary
                //let day = myCurrentDict.object(forKey: "day") as! String
                let start = myCurrentDict.object(forKey: "start_time") as! String
                let end = myCurrentDict.object(forKey: "end_time") as! String
                
                if start.isEmpty && end.isEmpty
                {
                    cell.btnCancel.tag = indexPath.row-1 + 100
                    
                    cell.lblTime.text = strNotAvailability
                    
                    
                    cell.btnCancel.accessibilityHint = "\(indexPath.row + 100)"

                    cell.btnCancel.setImage(#imageLiteral(resourceName: "plus_1"), for: .normal)
                    
                    
                    
                    cell.viewTblCell.backgroundColor = UIColor.clear
                    cell.viewTblCell.layer.borderWidth = 1
                    cell.viewTblCell.layer.borderColor = UIColor.white.cgColor
                    cell.lblDay.textColor = UIColor.white
                    cell.lblTime.textColor = UIColor.white
                }
                else
                {
                    cell.btnCancel.tag = indexPath.row-1
                    
                    
                    cell.lblTime.text = "\(self.UTCToLocal(date: start))" + " - " + "\(self.UTCToLocal(date: end))"
                    
                    cell.viewTblCell.layer.cornerRadius = 5
                    cell.viewTblCell.layer.borderWidth = 1
                    cell.viewTblCell.layer.borderColor = UIColor.clear.cgColor
                    
                    cell.btnCancel.setImage(#imageLiteral(resourceName: "close"), for: .normal)
                    
                    cell.viewTblCell.backgroundColor = UIColor.white
                    
                    cell.lblDay.textColor = blueThemeColor
                    cell.lblTime.textColor = blueThemeColor
                    
                }
            }
            
            cell.btnCancel.addTarget(self, action: #selector(methodviewDays), for: .touchUpInside)
            
            return cell

        }
    }

    //MARK:- UICollectionView Datasource/ Delegate - 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 1
       return arrJobInProgress.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCollectionJobInProgress", for: indexPath as IndexPath) as! CellCollectionJobInProgress
        
        let dict = arrJobInProgress.object(at: indexPath.row) as!NSDictionary
        

        let perDay = dict.object(forKey: "PaymentType") as! String
        
        if perDay == "1"
        {
            cell.lblPaymentPerHour.text =  "$" + "\(dict.value(forKey: "JobHourlyRate")!)/hour"
        }
        else if perDay == "2"
        {
            cell.lblPaymentPerHour.text =   "$" + "\(dict.value(forKey: "JobHourlyRate")!)/job"
        }else{
            cell.lblPaymentPerHour.text =   "$" + "\(dict.value(forKey: "JobHourlyRate")!)/month"
        }
        
        cell.lblRating.text = "\(dict.value(forKey: "rating")!)"
        cell.lblExpandJobInProgressTime.text = "\(dict.value(forKey: "StartHour")!)"
        
        cell.lblExpandJobInProgressTime.text = "\(self.UTCToLocal(date: dict.value(forKey: "StartHour")! as! String))"

        
        cell.lblJobInProgressLocation.text = "\(dict.value(forKey: "JobDistance")!)km"
        cell.lblDescription.text = "\(dict.value(forKey: "JobDescription")!)"
        cell.lblJob.text = "\(dict.value(forKey: "JobTitle")!)"
      
        
        
        
        //let streetName =  "\(dict.value(forKey: "street_name")!)"
        let address1 = "\(dict.value(forKey: "address1")!)"
        let address2 = "\(dict.value(forKey: "address2")!)"
        let city = "\(dict.value(forKey: "city")!)"
        let state = "\(dict.value(forKey: "state")!)"
        
        //let address = "\(streetName),\(address1), \(address2), \(city), \(state)"
        
        let address = "\(address1), \(address2), \(city), \(state)"
        
        
        cell.lblExpandJobInProgressLocationLatLng.text = address

        
        self.JobLat = dict.object(forKey: "lat") as! String
        self.JobLng = dict.object(forKey: "lng") as! String

        //cell.myLabel.text = self.items[indexPath.item]
        
        cell.maxRightArrow.isHidden = true
        cell.minLeftArrow.isHidden = true
        
        if arrJobInProgress.count == 1 {
            cell.maxRightArrow.isHidden = true
            cell.minLeftArrow.isHidden = true
        }else{
            
            if indexPath.item == 0{
                cell.maxRightArrow.isHidden = false
                cell.minLeftArrow.isHidden = true
            }
            else if indexPath.item >= 1{
                cell.maxRightArrow.isHidden = true
                cell.minLeftArrow.isHidden = false
            }else{
                cell.maxRightArrow.isHidden = false
                cell.minLeftArrow.isHidden = true
            }
        }
        
        return cell
    }
    
   
    // MARK: - Slide Navigation Delegates -
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }

   // MARK: - UIView Actions
    @IBAction func firstRegsiterClick(_ sender: Any) {
        self.firstTimeRegsisterView.isHidden = true
    }
    @IBAction func clickAllJob(_ sender: Any) {
        if selectedTab == 1
        {
             selectButton(status:true)
        }
    }
    @IBAction func ClickOnArea(_ sender: Any) {
        if selectedTab == 0
        {
            selectButton(status:false)
        }
    }
    @IBAction func backClicked(_ sender: Any) {
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)
    }
    @IBAction func chatClicked(_ sender: Any) {
        
        if  self.firstTimeRegsisterView.isHidden == true {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
            let ChatVC = storyBoard.instantiateViewController(withIdentifier: "chatList") as! chatList
            ChatVC.userType = "1"
            ChatVC.recieverId = "\(appdel.loginUserDict.object(forKey: "userId")!)"
            self.navigationController?.pushViewController(ChatVC, animated: true)
        }
    }
   
    @IBAction func clickAvailability(_ sender: Any) {

        if self.firstTimeRegsisterView.isHidden == true {
            if isAvailibilty == 1{
                
                isAvailibilty = 0
                btnToggleAvail.setImage(#imageLiteral(resourceName: "imgbtnon"), for: .normal)
                
                viewAvailibilityOnOff.isHidden = false
                viewTurnYourAvailibiltyOn.isHidden = true
                self.saveUserAvailabilityStatusApi(availabilityStatus: "0")
                
                self.view.makeToast(Localization(string: "Your availability has been updated"), duration: 1.0, position: .bottom)
                
            }
            else if isAvailibilty == 0{
                
                btnToggleAvail.setImage(#imageLiteral(resourceName: "Image"), for: .normal)
                
                
                viewAvailibilityOnOff.isHidden = true
                viewTurnYourAvailibiltyOn.isHidden = false
                self.saveUserAvailabilityStatusApi(availabilityStatus: "1")
                isAvailibilty = 1
                self.view.makeToast(Localization(string: "Your availability has been updated"), duration: 1.0, position: .bottom)

            }
        }
        
    }
    
    
    @IBAction func clickCancel(_ sender: Any) {
        
        if viewAvailibilityOnOff.isHidden == false{
            
            self.viewAvailibilityOnOff.isHidden = true
            self.viewAvailiobilityPerDay.isHidden = true
        }
        else  if viewTurnYourAvailibiltyOn.isHidden == false{
            self.viewTurnYourAvailibiltyOn.isHidden = true
            self.viewAvailiobilityPerDay.isHidden = true
        }
        
    }
    
    @IBAction func clickClose(_ sender: Any) {
        
        self.viewAvailibilityOnOff.isHidden = true
        
    }
    
    @IBAction func clickAvailibilityPerDaySAVE(_ sender: Any) {
        
        let myCurrentDict = NSMutableDictionary()
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm"
        
        
        if StartTime == "24:00" {
            StartTime = "23:59"
        }
        if EndTime == "24:00" {
            EndTime = "23:59"
        }
        
        let UTCStartTime = dateFormat.date(from: StartTime)
        let UTCEndTime = dateFormat.date(from: EndTime)

        
        myCurrentDict.setValue(UTCStartTime!.currentUTCTimeZoneTime, forKey: "start_time")
        myCurrentDict.setValue(UTCEndTime!.currentUTCTimeZoneTime, forKey: "end_time")
        myCurrentDict.setValue(currentDay, forKey: "day")
        
        
        let setDic = NSMutableDictionary()
        
        setDic.setValue(StartTime, forKey: "start_time")
        setDic.setValue(EndTime, forKey: "end_time")
        setDic.setValue(currentDay, forKey: "day")
        
        self.saveUserAvailabilityApi(availabilityStatus: "1", type: "0", dict: myCurrentDict,setDic: myCurrentDict)
        
    }
    
    
    @IBAction func clickProfileSel(_ sender: Any)
    {
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)
    }

    
    @IBAction func SelTimingChangeNM(_ sender: Any) {
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.view.endEditing(true)
            
            var lowerCenter = CGPoint.zero
            var upperCenter = CGPoint.zero
            
            let min = self.SliderTimingNM.lowerValue
            let max = self.SliderTimingNM.upperValue
            
            self.SliderTimingNM.trackImage = #imageLiteral(resourceName: "slider-default7-track.png")
            
            
            if self.SliderTimingNM.lowerHandle.isHighlighted == true {
                
                let countmin = Int(Double(min) * 60.0)
                
                let hours:Int = countmin/60
                
                let minutes = countmin - (hours*60)
                
                
                var minuteAppended = "\(minutes)"
                if (minutes < 10){
                    minuteAppended = "0\(minutes)"
                }
                
                var HourAppended = "\(hours)"
                if (hours < 10){
                    HourAppended = "0\(hours)"
                }
                

                if HourAppended == "24" {
                     self.lblLowerTime.text = "23:59"
                }else{
                    self.lblLowerTime.text = "\(HourAppended):\(minuteAppended)"
                }
                
                
                self.StartTime = self.lblLowerTime.text!
                
                self.constrainLowerLeading.constant = self.SliderTimingNM.lowerCenter.x
                
            }
                
            else if self.SliderTimingNM.upperHandle.isHighlighted == true {
                
                let countmin = Int(Double(max) * 60.0)
                
                let hours:Int = countmin/60
                
                let minutes = countmin - (hours*60)
                
                
                
                var minuteAppended = "\(minutes)"
                if (minutes < 10){
                    minuteAppended = "0\(minutes)"
                }
                
                var HourAppended = "\(hours)"
                if (hours < 10){
                    HourAppended = "0\(hours)"
                }
                
                
                if HourAppended == "24" {
                    self.lblHigherTime.text = "23:59"
                }else{
                    self.lblHigherTime.text = "\(HourAppended):\(minuteAppended)"
                }
                
               // 9006752633
                
                self.EndTime = self.lblHigherTime.text!
                
                self.lblHigherTime.frame = CGRect(x: self.SliderTimingNM.upperCenter.x + 15, y: self.SliderTimingNM.frame.origin.y + 20, width: 30, height: 25)
            }
            
            
            lowerCenter.x = (self.SliderTimingNM.lowerCenter.x + self.SliderTimingNM.frame.origin.x + 50)
            
            upperCenter.x = (self.SliderTimingNM.upperCenter.x + self.SliderTimingNM.frame.origin.x + 100)
            
        })
        
        
    }
    
    /* Job In Progress */
    @IBAction func clickJobInProgress(_ sender: Any)
    {
        self.viewJobInProgress.isHidden = true
        self.viewExpandJobInProgress.isHidden = false
    }
    
    // MARK: - CLLocationManagerDelegate Action
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        if appdel.userLocationLat == ""
        {
            appdel.userLocationLat = "\(locValue.latitude)"
            appdel.userLocationLng = "\(locValue.longitude)"
            self.afterGettingLocationCall()
        }
        appdel.userLocationLat = "\(locValue.latitude)"
        appdel.userLocationLng = "\(locValue.longitude)"
    }
    
    /* expand job in progrss */
    @IBAction func clickRefreshJobInProgress(_ sender: Any) {
    }
    @IBAction func clickExpandJobInProgressSeeOnMap(_ sender: Any)
    {
        drawRouteAppleMap(directionsURL:"http://maps.apple.com/?saddr=\(appdel.userLocationLat),\(appdel.userLocationLng)&daddr=\(self.JobLat),\(self.JobLng)")
    }
    
    @IBAction func clickExpandJobInProgressClose(_ sender: Any)
    {
        self.viewJobInProgress.isHidden = false
        self.viewExpandJobInProgress.isHidden = true
    }
    
    // MARK: - Api Call
    func jobsNearByAllSpecialityApi()
    {
        
        /*
         {
         "latitude": 23.0752071,
         "longitude": 72.5260402,
         "serachType": "1",
         "userId": "77",
         "language": "en",
         "methodName": "jobsNearBy"
         }
         */
        self.arrayAllSpecJobs.removeAllObjects()
        self.arrayAllSpecJobs = NSMutableArray()
        let param =  [WebServicesClass.METHOD_NAME: "jobsNearBy",
                      "latitude":appdel.userLocationLat,
                      "longitude":appdel.userLocationLng,
                      "serachType":"1",
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            

            if error != nil
            {
                SwiftLoader.hide()
                self.jobsNearByMySpecialityApi()
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                
                
                if self.isForRefresh {
                    self.refreshControl.endRefreshing()
                    self.isForRefresh = false
                }
                
                if status == 1
                {
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    {

                        if let allJobs = dataDict.object(forKey: "allJobs") as? [Any]
                        {
                            
                            self.arrayAllSpecJobs.removeAllObjects()
                            self.arrayAllSpecJobs.addObjects(from: allJobs)
                            self.prepareForMarker(array: self.arrayAllSpecJobs)
                        }
                        
                        if let category = dataDict.object(forKey: "categoryName") as? String {
                            self.CategoryName = category
                        }
                    }
                    
                }
                else
                {
                }
                
                self.jobsNearByMySpecialityApi()
            }
        }
    }
    
    func jobsNearByMySpecialityApi()
    {
        //SwiftLoader.show(animated: true)
        
        /*
         {
         "latitude": 23.0752071,
         "longitude": 72.5260402,
         "serachType": "1",
         "userId": "77",
         "language": "en",
         "methodName": "jobsNearBy"
         }
         */
        self.arrayMySpecJobs.removeAllObjects()
        self.arrayMySpecJobs = NSMutableArray()
        
        let param =  [WebServicesClass.METHOD_NAME: "jobsNearBy",
                      "latitude":appdel.userLocationLat,
                      "longitude":appdel.userLocationLng,
                      "serachType":"2",
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            
            if error != nil
            {
                
               SwiftLoader.hide()
            }
            else
            {
                 SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                
                
                
                
                if self.isForRefresh {
                    self.refreshControl.endRefreshing()
                    self.isForRefresh = false
                }
                
                
                if status == 1
                {
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    {
                        

                        
                        if let allJobs = dataDict.object(forKey: "allJobs") as? [Any]
                        {
                            self.arrayMySpecJobs.removeAllObjects()
                            self.arrayMySpecJobs.addObjects(from: allJobs)
                        }
                        
                        if let category = dataDict.object(forKey: "categoryName") as? String                        {
                            
                            self.CategoryName = category
                            self.totalJobCountLbl.isHidden = false
                            //self.totalJobCountLbl.text = ("\(self.arrayAllSpecJobs.count) jobs in \(category)")
                        }
                    }
                    
                }
                else
                {
                    
                }
                
            }
        }
    }
    
    func getTimeAvailabilityApi()
    {
        SwiftLoader.show(animated: true)
        
        
        let param =  [WebServicesClass.METHOD_NAME: "getUserAvailability",
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)"]as [String : Any]
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            
            if error != nil
            {
                self.jobsNearByAllSpecialityApi()
            }
            else
            {
                //  SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                
                let status = dictResponse.object(forKey: "status") as! Int
                if status == 1
                {
                    if let arrResponsegetUserAvailabilityDict = (dictResponse as AnyObject).object(forKey: "data") as? NSArray
                    {
                        self.arrDaysFull = arrResponsegetUserAvailabilityDict.mutableCopy() as! NSMutableArray
                        self.setGetAvailibilityResponse()
                    }
                }
                self.jobsNearByAllSpecialityApi()
                
            }
        }
        
    }
    func saveUserAvailabilityApi(availabilityStatus: String, type: String, dict: NSDictionary,setDic:NSDictionary)
    {
        /*
         {
         "availabilityStatus": "0",
         "daysOfWeek": "7",
         "end_time": "24:00",
         "start_time": "00:00",
         "type": "0",
         "userId": "77",
         "methodName": "saveUserAvailability"
         } (For remove add 00:00)
         */
        
        
        let start = dict.object(forKey: "start_time") as! String
        let end = dict.object(forKey: "end_time") as! String
        let day = dict.object(forKey: "day") as! String
        
        SwiftLoader.show(animated: true)
        
        let  EndTime  = "23:59"
        let StartTime = "00:00"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let startTimeLocal = formatter.date(from: StartTime)
        let EndTimeLocal = formatter.date(from: EndTime)
        
        
        let startAvailabilityTime = startTimeLocal?.currentUTCTimeZoneTime
        let endAvailabilityTime = EndTimeLocal?.currentUTCTimeZoneTime
        
        
//        local_start_time,
//        local_end_time,
//        local_diff = Utility.getLocalDiff();
        //"local_diff":"\(getTimeZoneValue())"
    
        let param =  [WebServicesClass.METHOD_NAME: "saveUserAvailability",
                      "availabilityStatus":"\(availabilityStatus)",
            "daysOfWeek":day,
            "end_time":end,
            "start_time":start,
            "type":"\(type)",
            "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)","local_start_time":startAvailabilityTime!,"local_end_time":endAvailabilityTime!,"local_diff":"\(getTimeZoneValue())"]as [String : Any]
        
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            
            if error != nil
            {               SwiftLoader.hide()
            }
            else
            {
                //  SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                

                let status = dictResponse.object(forKey: "status") as! Int
                
                SwiftLoader.hide()
                
                
                self.view.makeToast(Localization(string: "Availability updated"), duration: 1.0, position: .bottom)
                
                if status == 1
                {
                    
                    var myObjectIndex = Int()
                    
                    myObjectIndex = Int(day)!
                    
                    myObjectIndex = myObjectIndex - 1
                    
                    
                    
                    var myCurrentDict1 = NSMutableDictionary()
                    
                    if type == "1"
                    {
                        myCurrentDict1.setValue("", forKey: "end_time")
                        myCurrentDict1.setValue("", forKey: "start_time")
                        myCurrentDict1.setValue(day, forKey: "day")
                    }
                    else
                    {
                        myCurrentDict1 = setDic as! NSMutableDictionary
                        self.viewAvailiobilityPerDay.isHidden = true
                    }
                    
                    var MyCheckArray = NSMutableArray()
                    
                    MyCheckArray = self.arrDaysFull.mutableCopy() as! NSMutableArray
                    
                    MyCheckArray .replaceObject(at: myObjectIndex, with: myCurrentDict1)
                    
                    
                   
                    
                    self.arrDaysFull = MyCheckArray.mutableCopy() as! NSMutableArray

                    
                    self.tblAvailibility.reloadData()
                    
                    
                }
                else
                {
                    
                }
                
            }
        }
        
    }
    
    func applyForJobAPI(jobID:String,companyName:String,jobTitle:String,hasAcknowledge:String)
    {
        SwiftLoader.show(animated: true)
        
        /*
         {
         "jobId": "240",
         "userId": "77",
         "methodName": "applyForJob"
         }
         
         */
        
        
        let param =  [WebServicesClass.METHOD_NAME: "applyForJob",
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
            "jobId":jobID] as [String : Any]
        
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            

            if error != nil
            {
                SwiftLoader.hide()
                
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                
                SwiftLoader.hide()
                
                if status == 1
                {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "JobSeeker", bundle:nil)
                    
                    let jobFolloewUpStatusVC = storyBoard.instantiateViewController(withIdentifier: "JobApplyForJobVC") as! JobApplyForJobVC
                    jobFolloewUpStatusVC.companyName = companyName
                    jobFolloewUpStatusVC.jobTitle = jobTitle
                    jobFolloewUpStatusVC.employerStatus = ""
                    jobFolloewUpStatusVC.jobseekerStatus = ""
                    jobFolloewUpStatusVC.type = 100
                    jobFolloewUpStatusVC.isFromMap = true
                    self.navigationController?.pushViewController(jobFolloewUpStatusVC, animated: true)
                    
                }
                else if status == 2
                {
                    self.followUpAPI(jobId: jobID, METHOD_NAME: "followUpInvitations", companyName: companyName, jobTitle: jobTitle, type: 0,hasAcknowledge: hasAcknowledge)
                }
                
                
            }
        }
    }
    
    func followUpAPI(jobId:String,METHOD_NAME:String,companyName:String,jobTitle:String,type:NSNumber,hasAcknowledge:String)
    {
        SwiftLoader.show(animated: true)
        
        /*
         "job_id": "240",
         "jobseeker_id": "77",
         "methodName": "followUp"
         */
    
        
        let param =  [WebServicesClass.METHOD_NAME: METHOD_NAME,
                      "jobseeker_id":"\(appdel.loginUserDict.object(forKey: "userId")!)",
            "job_id":jobId] as [String : Any]
        
            global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            
            if error != nil
            {
                SwiftLoader.hide()
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
                if status == 1
                {
                    let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    let storyBoard : UIStoryboard = UIStoryboard(name: "JobSeeker", bundle:nil)
                    
                    let jobFolloewUpStatusVC = storyBoard.instantiateViewController(withIdentifier: "JobApplyForJobVC") as! JobApplyForJobVC
                    jobFolloewUpStatusVC.companyName = companyName
                    jobFolloewUpStatusVC.jobTitle = jobTitle
                    jobFolloewUpStatusVC.employerStatus = dataDict?.value(forKey: "employerStatus") as! String
                    jobFolloewUpStatusVC.jobseekerStatus = dataDict?.value(forKey: "jobseekerStatus") as! String
                    jobFolloewUpStatusVC.type = type
                    jobFolloewUpStatusVC.isFromMap = true
                    jobFolloewUpStatusVC.hasAcknowledge = hasAcknowledge
                    jobFolloewUpStatusVC.jobId = jobId
                    self.navigationController?.pushViewController(jobFolloewUpStatusVC, animated: true)
                }
                else
                {
                    
                }
                
                
            }
        }
    }
    
    
    
    func saveUserAvailabilityStatusApi(availabilityStatus :String)
    {
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "saveUserAvailabilityStatus",
                      "availabilityStatus":"\(availabilityStatus)",
            "jobSeekerId":"\(appdel.loginUserDict.object(forKey: "userId")!)"]as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            
            if error != nil
            {
                SwiftLoader.hide()

            }
            else
            {
                //  SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
                if status == 1
                {
                    
                }
            }
        }
        
    }
    
    func jobInProgressAPI()
    {

        /*
         "jobseekerId": "77",
         "methodName": "jobSeekerJobInProgress"
         
         */
        
        self.arrJobInProgress.removeAllObjects()
        self.arrJobInProgress = NSMutableArray()
        
        let param =  [WebServicesClass.METHOD_NAME: "jobSeekerJobInProgress",
                      "jobseekerId":"\(appdel.loginUserDict.object(forKey: "userId")!)"] as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {
                self.afterGettingLocationCall()
            }
            else
            {

                let dictResponse = Response as! NSDictionary
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                SwiftLoader.hide()
                
                if status == 1
                {
                   
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSArray
                    {
                        
                        for(_,element) in dataDict.enumerated() {
                           
                            let elemt = element as! NSDictionary
                            let startHour = elemt.object(forKey: "StartHour") as! String
                            let localServerTime =  self.UTCToLocal(date: startHour)

                           // let localServerTime =  startHour

                            let dateFormat = DateFormatter()
                            dateFormat.dateFormat = "HH:mm"
                            let localServerDate = dateFormat.date(from: localServerTime)
                            
                            let localTime = self.currentTime()
                            
                           // let date = Date()
                           // let localTime = localTime
                            
                           let  diff = Int((localServerDate?.timeIntervalSinceReferenceDate)! - localTime.timeIntervalSinceReferenceDate)
                            
                            var min = diff/60
                            min = abs(min)
                            
                            if min <= 60 {
                                self.arrJobInProgress.add(elemt)
                            }
                        }

                        if self.arrJobInProgress.count > 0 {
                            self.objCollectionJobInProgress.reloadData()
                            self.viewJobInProgress.isHidden = false
                            self.viewExpandJobInProgress.isHidden = true
                        }
                    }
                    self.afterGettingLocationCall()
                }
                else
                {
                    self.afterGettingLocationCall()
                }
                
                
            }
        }
    }
    
    
    
    
    // MARK: - Class Methods
    
    func prepareForMarker(array: NSMutableArray)
    {
        
        arrayAllMarkers.removeAllObjects()
        
        if array.count > 0
        {
            for index in 0...array.count-1
            {
                let lat = (array.object(at: index) as! NSDictionary).object(forKey: "latitude")!
                
                let long = (array.object(at: index) as! NSDictionary).object(forKey: "longitude")!
                
                let rate = (array.object(at: index) as! NSDictionary).object(forKey: "rate")!
                
                let jobId = (array.object(at: index) as! NSDictionary).object(forKey: "jobId")!
                
            arrayAllMarkers.add([keylat:lat,keylong:long,keyrate:rate,keyisJob:isJobSekeer,"jobId":jobId])
              
            }
        }
        
        self.generateClusterMarkers(array: array)
    }
    
    func generateClusterMarkers(array: NSMutableArray) {
        
        //mapView.clear()
        
        clusterManager.clearItems()
        
        var bounds = GMSCoordinateBounds()
        
        if arrayAllMarkers.count > 0
        {
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
        }
        
        clusterManager.cluster()
        self.setVisibleUser(array: array)
    }
    
    /// Returns a random value between -1.0 and 1.0.
    func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    
    func userLocationMarker(location: CLLocationCoordinate2D,marker:GMSMarker) {
        
        marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
    }
    func selectButton(status:Bool)  {
        
        if status{
            self.selectedTab = 0
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            self.CategoryTable.beginUpdates()
            self.CategoryTable.layer.add(transition, forKey: nil)
            self.CategoryTable.endUpdates()
            self.CategoryTable.reloadData()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.allBorderLbl.isHidden = false
                self.inMyareaBorderLbl.isHidden = true
                
                self.allBtn.setTitleColor(blueThemeColor, for: .normal)
                self.inMyareaBtn.setTitleColor(UIColor.darkGray, for: .normal)
                
            }, completion: { (Bool) in
                self.status = status
                self.currentIndex = -1
                
                if self.arrayAllSpecJobs.count == 0 {
                    
                    self.totalJobCountLbl.text = ("0 \(Localization(string: "jobs in")) \(self.CategoryName)")
                }
                
                if self.arrayAllSpecJobs.count == 0 {
                    self.noneLbl.isHidden = false
                }else{
                    self.noneLbl.isHidden = true
                }
                self.prepareForMarker(array: self.arrayAllSpecJobs)
            })
            
        }else{
            self.selectedTab = 1
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.CategoryTable.beginUpdates()
            self.CategoryTable.layer.add(transition, forKey: nil)
            self.CategoryTable.endUpdates()
            self.CategoryTable.reloadData()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.allBorderLbl.isHidden = true
                self.inMyareaBorderLbl.isHidden = false
                self.allBtn.setTitleColor(UIColor.darkGray, for: .normal)
                self.inMyareaBtn.setTitleColor(blueThemeColor, for: .normal)
            }, completion: { (Bool) in
                self.status = status
                self.currentIndex = -1
                if self.arrayMySpecJobs.count == 0 {
                    self.totalJobCountLbl.text = ("0 \(Localization(string: "jobs in")) \(self.CategoryName)")
                }
                
                if self.arrayMySpecJobs.count == 0 {
                    self.noneLbl.isHidden = false
                }else{
                    self.noneLbl.isHidden = true
                }
                
                self.prepareForMarker(array: self.arrayMySpecJobs)
            })
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func changeImage()  {
        btnProfilePic.setImage(ImgJobSeekerProfilepic, for: .normal)
    }
    func displayAvailability()  {
        viewTurnYourAvailibiltyOn.isHidden = true
        self.viewAvailibilityOnOff.isHidden = false
    }
    
    func removeAvailability()  {
        viewTurnYourAvailibiltyOn.isHidden = true
        self.viewAvailibilityOnOff.isHidden = true
    }
    
    func RightSwipe() {
        if selectedTab == 1 {
            selectButton(status:true)
        }
        
    }
    
    func LeftSwipe() {
        if selectedTab == 0 {
            selectButton(status:false)
        }
    }

    func moveMarkerOn(markerPosition: CLLocationCoordinate2D)
    {
        
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(1.0)
        userMarker.position = markerPosition
        
        CATransaction.commit()
        
        userMarker.icon = UIImage(named: "map_user")
        userMarker.appearAnimation = GMSMarkerAnimation.pop
        
        userMarker.map = self.mapView
        

        mapView.camera = GMSCameraPosition.camera(withTarget: markerPosition, zoom: 10)

        
        self.mapView.animate(toLocation: markerPosition)
        
    }
    func afterGettingLocationCall()
    {
        userLocation.latitude = CLLocationDegrees(appdel.userLocationLat)!
        userLocation.longitude = CLLocationDegrees(appdel.userLocationLng)!
        
        self.moveMarkerOn(markerPosition: userLocation)
        
        self.getTimeAvailabilityApi()
    }
    
    
    func setUpView()
    {
        self.allBtn.setTitleColor(blueThemeColor, for: .normal)
        self.allBorderLbl.backgroundColor = blueThemeColor
        self.inMyareaBorderLbl.backgroundColor = blueThemeColor
        
        
        if appdel.userLocationLat != ""
        {
            self.afterGettingLocationCall()
        }
        
        let avl = "\(appdel.loginUserDict.object(forKey: "availability")!)"
        
        //availability
        if avl == "1"
        {
            
            isAvailibilty = 1
        }
        else
        {
            isAvailibilty = 0
        }
        
    }

    func setGetAvailibilityResponse()
    {
        var myTestArray = NSMutableArray()
        
        myTestArray = self.arrDaysFull.mutableCopy() as! NSMutableArray
        
        for i in 0 ..< self.arrDaysName.count
        {
            
            var strTag = String()
            
            strTag = String(i + 1)
            
            let predicate = NSPredicate(format: "day contains %@",strTag)
            
            var dupArray = NSArray()
            
            dupArray = arrDaysFull.filtered(using: predicate) as NSArray
            
            if(dupArray.count > 0)
            {
                
                
            }
            else
            {
                let myCurrentDict1 = NSMutableDictionary()
                
                myCurrentDict1.setValue("", forKey: "end_time")
                myCurrentDict1.setValue("", forKey: "start_time")
                myCurrentDict1.setValue(strTag, forKey: "day")
                
                myTestArray.add(myCurrentDict1)
            }
        }
        
    
        let sorted =  (myTestArray as NSArray).sorted(by: { (($0 as! NSDictionary).object(forKey: "day") as! NSString).floatValue < (($1 as! NSDictionary).object(forKey: "day") as! NSString).floatValue })
        myTestArray.removeAllObjects()
        myTestArray.addObjects(from: sorted)
        
        self.arrDaysFull = myTestArray.mutableCopy() as! NSMutableArray
        
        tblAvailibility.reloadData()
        
    }
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        //2017-10-18
        dateFormatter.dateFormat = "yyyy-MM-dd:HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: date)
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter.string(from: dt!)
    }
    
    
    func applyStatus(sender: UIButton)
    {
        let buttonrow = sender.tag
        
        var tempDict = NSDictionary()
        tempDict = tempArrayJob.object(at: buttonrow) as! NSDictionary
        
        
        let title = sender.title(for: .normal)
        let jobRefuceStatus = tempDict.object(forKey: "jobRefuceStatus") as! Int
        
        let getUserSelectedStatus = tempDict.object(forKey: "userSelectedStatus") as! Int
        
        let getApplicationStatus = tempDict.object(forKey: "applicationStatus") as! Int
        
        let getUserInvitationStatus = tempDict.object(forKey: "userInvitedStatus") as! Int
        
        let jobId = tempDict.object(forKey: "jobId") as! String
        let jobTitle = tempDict.object(forKey: "jobTitle") as! String
        let companyName = tempDict.object(forKey: "companyName") as! String
        let hasAcknowledge = "\(tempDict.object(forKey: "has_acknowledge")!)"
 
        if title == "See details" && jobRefuceStatus == 0 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                let jobOnGoingDetailsVC = storyBoard.instantiateViewController(withIdentifier: "JobOnGoingDetailsVC") as! JobOnGoingDetailsVC
                jobOnGoingDetailsVC.hasAcknowledge = hasAcknowledge
                jobOnGoingDetailsVC.jobId = jobId
                jobOnGoingDetailsVC.type = "1"
                self.navigationController?.pushViewController(jobOnGoingDetailsVC, animated: true)
        }
        else if getUserInvitationStatus == 1
        {
            self.followUpAPI(jobId: jobId, METHOD_NAME: "followUpInvitations", companyName: companyName, jobTitle: jobTitle, type: 0,hasAcknowledge: "\(tempDict.object(forKey: "has_acknowledge")!)")
        }
       else if jobRefuceStatus == 1
        {
             self.followUpAPI(jobId: jobId, METHOD_NAME: "followUp", companyName: companyName, jobTitle: jobTitle, type: 1,hasAcknowledge: "\(tempDict.object(forKey: "has_acknowledge")!)")
            
        }
        else if getUserSelectedStatus == 1
        {
            self.followUpAPI(jobId: jobId, METHOD_NAME: "followUp", companyName: companyName, jobTitle: jobTitle, type: 1,hasAcknowledge: "\(tempDict.object(forKey: "has_acknowledge")!)")
        }
        else if getApplicationStatus == 1
        {
            self.followUpAPI(jobId: jobId, METHOD_NAME: "followUp", companyName: companyName, jobTitle: jobTitle, type: 1,hasAcknowledge: "\(tempDict.object(forKey: "has_acknowledge")!)")
        }
        else
        {
            self.applyForJobAPI(jobID: jobId,companyName:companyName,jobTitle:jobTitle,hasAcknowledge:hasAcknowledge)
        }
    }
    func getUIImageFromThisUIView(aUIView:UIView) -> UIImage {
        UIGraphicsBeginImageContext(aUIView.bounds.size)
        aUIView.drawHierarchy(in: aUIView.layer.bounds, afterScreenUpdates: true)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage!
    }
    
    func customImageLabelMarker(_ markerCount: Int,green:Bool) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let label = UILabel()
        let imageview = UIImageView()
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Regular", size: 12) ?? UIFont()
        label.text = "\(UInt(markerCount))"
        label.frame = CGRect(x: 0, y: 0, width: SizeOf_String(font:label.font,Text: label.text!)  + 20, height: SizeOf_String(font:label.font,Text: label.text!) + 20)
        let x: CGFloat = label.center.x - 8
        imageview.frame = CGRect(x: x, y: label.frame.size.height + 5, width: 15, height: 25)
        imageview.contentMode = .scaleAspectFill
        
        if green {
            imageview.image = UIImage(named: "map_marker_green")
            label.backgroundColor = UIColor.green
            label.textColor =  UIColor.white
        }else{
            imageview.image = UIImage(named: "map")
            label.backgroundColor = UIColor.lightGray
            label.textColor =  UIColor.init(colorLiteralRed: 61.0/255.0, green: 101.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        }
        
        view.frame = CGRect(x: 0, y: 0, width: label.frame.size.width, height: label.frame.size.height + imageview.frame.size.height + 10)
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
        view.addSubview(label)
        view.addSubview(imageview)
        return view
    }
    
    func SizeOf_String( font: UIFont,Text:String) -> CGFloat {
        let fontAttribute = [NSFontAttributeName: font]
        let size = Text.size(attributes: fontAttribute)
        return size.width
    }

    func methodviewDays(_sender : UIButton) {
        
        var buttonTag = Int()
        buttonTag = _sender.tag
        
        
      
        
        if(buttonTag >= 100)
        {
            //  available
            
            buttonTag = buttonTag - 100
            print("Selected index is",buttonTag)
            let myCurrentDict = arrDaysFull.object(at: buttonTag) as! NSDictionary
            
            EndTime  = "23:59"
            StartTime = "00:00"
            
            currentDay = myCurrentDict.object(forKey: "day") as! String
            
            
            viewAvailiobilityPerDay.isHidden = false
            
            var buttonAceesibleHint = Int()
            buttonAceesibleHint = Int(_sender.accessibilityHint!)!
            buttonAceesibleHint = buttonAceesibleHint - 100

            self.lblAvaibilityTimeDay.text = arrDisplayDaysFull.object(at:buttonAceesibleHint) as? String
            
            self.lblAvaibilityTimeDay.textColor = blueThemeColor
        }
        else
        {
            //Not avialable
            
            
            // API CALL NOT
            
            let myCurrentDict = arrDaysFull.object(at: buttonTag) as! NSDictionary
            
            self.saveUserAvailabilityApi(availabilityStatus: "1", type: "1",dict: myCurrentDict,setDic: myCurrentDict)
        }
        
    }

    // MARK: -  Notification -
    
    func registerNotification()  {
        // Define identifier
        let notificationName = Notification.Name("changeImage")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(JobDash.changeImage), name: notificationName, object: nil)
        
        
        // Define identifier
        let displayAvailability = Notification.Name("displayAvailability")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(JobDash.displayAvailability), name: displayAvailability, object: nil)
        
        
        
        // Define identifier
        let removeAvailability = Notification.Name("removeAvailability")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(JobDash.removeAvailability), name: removeAvailability, object: nil)
        
        // chat notification
        
        let chatNotification = Notification.Name("chatNotificationJOB")
        NotificationCenter.default.addObserver(self, selector: #selector(JobDash.chatNotification), name: chatNotification, object: nil)
        
        // got invitation notification
        let gotInvitation = Notification.Name("gotInvitation")
        NotificationCenter.default.addObserver(self, selector: #selector(JobDash.gotInvitation), name: gotInvitation, object: nil)
        
        
        
        // Rate Employer
        let RateEmployer = Notification.Name("RateEmployer")
        NotificationCenter.default.addObserver(self, selector: #selector(JobDash.RateEmployer), name: RateEmployer, object: nil)
        
        
        // See Detials of invited, Selected Job
        let SelectedJob = Notification.Name("SelectedJob")
        NotificationCenter.default.addObserver(self, selector: #selector(JobDash.SelectedJob), name: SelectedJob, object: nil)
        
        
        
        // Match Job Notification
        let MatchJobNotify = Notification.Name("MatchJobNotify")
        NotificationCenter.default.addObserver(self, selector: #selector(JobDash.MatchJobNotify), name: MatchJobNotify, object: nil)

    }
    
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
        
        chatScene.userType = "1"

        chatScene.chat_message_id = "\(dict["chat_message_id"]!)"
        
        let topVC = UIApplication.topViewController()
        if topVC is CustomChatScene {
        }else{
            self.navigationController?.pushViewController(chatScene, animated: true)
        }
        
    }
    func gotInvitation(notification: NSNotification)  {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let gotInvitation = storyBoard.instantiateViewController(withIdentifier: "gotInvitationNotifyVC") as! gotInvitationNotifyVC
        let dict = notification.object as! [String: Any]
        gotInvitation.userDic = dict
        
        let topVC = UIApplication.topViewController()
        if topVC is gotInvitationNotifyVC {
        }else{
            self.navigationController?.pushViewController(gotInvitation, animated: true)
        }
    }

    func RateEmployer(notification: NSNotification)  {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let rateEmp = storyBoard.instantiateViewController(withIdentifier: "RateEmployee") as! RateEmployee
        let dict = notification.object as! [String: Any]
        rateEmp.userDic = dict
        
        let topVC = UIApplication.topViewController()
        if topVC is RateEmployee {
        }else{
            self.navigationController?.pushViewController(rateEmp, animated: true)
        }
    }
    func SelectedJob(notification: NSNotification)  {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let select = storyBoard.instantiateViewController(withIdentifier: "JobOnGoingDetailsVC") as! JobOnGoingDetailsVC
        let dict = notification.object as! [String: Any]
        select.userDic = dict
        
        
        let topVC = UIApplication.topViewController()
        if topVC is JobOnGoingDetailsVC {
        }else{
            self.navigationController?.pushViewController(select, animated: true)
        }
        
    }
    func MatchJobNotify(notification: NSNotification)  {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let matchJob = storyBoard.instantiateViewController(withIdentifier: "MatchJobNotifyVC") as! MatchJobNotifyVC
        let dict = notification.object as! [String: Any]
        matchJob.userDic = dict
        
        let topVC = UIApplication.topViewController()
        if topVC is MatchJobNotifyVC {
        }else{
            self.navigationController?.pushViewController(matchJob, animated: true)
        }
    }

    // MARK: -  refreshContoller -
    func refreshContoller()  {
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        refreshControl.tintColor = blueThemeColor
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        if #available(iOS 10.0, *) {
            CategoryTable.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
    }
    func refreshTable(refreshControl: UIRefreshControl) {
        
        isForRefresh = true
        if self.isForRefresh {
            
            if selectedTab == 1 {
                self.jobsNearByAllSpecialityApi()
            }
            if selectedTab == 0 {
                self.jobsNearByMySpecialityApi()
            }
        }
    }
    
}
