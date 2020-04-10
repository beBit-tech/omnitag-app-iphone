//
//  ViewController.swift
//  omnicha-ios
//
//  Created by Eason on 2019/11/22.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit
import OmniSegment

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var menuTableView: UITableView!
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectPickerView: UIPickerView!
    @IBOutlet var selectView: UIView!
    let WIDTH = UIScreen.main.bounds.size.width
    let HEIGHT = UIScreen.main.bounds.size.height
    let selectArr : [String] = ["Choose One", "ATM", "Credit Card"]
    var currRow : Int = 0
    var menuItems:[MenuItem] = []
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initMenuItem()
        self.menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        menuTableView.tableFooterView = UIView()
        menuTableView.backgroundColor = .white
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.EVENT, dict: [PayloadType.EVENT_CATEGORY: EventCategoryType.PushNotification,
                                                                               PayloadType.EVENT_ACTION: EventActionType.RegisterToken,
                                                                               EventActionType.RegisterToken: "your_apns_token"])

    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectView.frame = CGRect(x: 0,
                              y: HEIGHT,
                              width: WIDTH,
                              height: 300)
        view.addSubview(selectView)
        selectPickerView.delegate = self
    }
    @IBAction func nextAction(_ sender: Any) {
        
    }
    
    //------------------
    //Select PickerView
    @IBAction func selectAction(_ sender: Any) {
        selectView.frame.origin.y == self.HEIGHT ? viewslide(false) : viewslide(true)
    }
    
    @IBAction func selectViewDoneAction(_ sender: Any) {
        selectView.frame.origin.y == self.HEIGHT ? viewslide(false) : viewslide(true)
        guard let currSelect = selectArr[currRow] as? String, currSelect != self.selectButton.currentTitle else {
            return
        }
        
        self.selectButton.setTitle(currSelect, for: .normal)
        OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.EVENT, dict: [PayloadType.EVENT_ACTION : EventActionType.CLICK_CHECKOUT,
                                                                               PayloadType.PRODUCT_ACTION : "custom_product_action",
                                                                               PayloadType.CHECKOUT_STEP_OPTION : currSelect,
                                                                               PayloadType.CHECKOUT_STEP : self.currRow])
    }
    
    @IBAction func selectViewCancelAction(_ sender: Any) {
        selectView.frame.origin.y == self.HEIGHT ? viewslide(false) : viewslide(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.selectArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(selectArr[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currRow = row
    }
    
    func viewslide(_ BOOL: Bool, completion: ((Bool) -> Void)! = nil) {
        self.tabBarController?.tabBar.isHidden = !BOOL
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: { () -> Void in
                        self.selectView.frame.origin.y = BOOL ? self.HEIGHT : self.HEIGHT - 300
        },
                       completion: nil)
    }
    //------------------
    
    //------------------
    //Table View
    func initMenuItem() {
        menuItems.append(MenuItem.init(title: "Login", callback: {
            OmniSegmentService.userID = "eason_ios"
        }))
        
        menuItems.append(MenuItem.init(title: "Logout", callback: {
            OmniSegmentService.userID = nil
        }))
        
        menuItems.append(MenuItem.init(title: "Complete Registration", callback: {
            var completeRegistration = CompleteRegistration()
            completeRegistration.birthdayYear = "1994"
            completeRegistration.city = "Taipei"
            completeRegistration.gender = GenderType.MALE
            completeRegistration.regType = "regType"
            
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.EVENT,
                                                   dict: [
                                                    PayloadType.EVENT_CATEGORY : EventCategoryType.COMPLETE_REGISTRATION,
                                                    PayloadType.EVENT_ACTION : EventActionType.COMPLETE_REGISTRATION,
                                                    EventActionType.COMPLETE_REGISTRATION : completeRegistration
                ])
        }))
        
        menuItems.append(MenuItem.init(title: "Content Group", callback: {
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.EVENT, dict: [PayloadType.CONTENT_GROUP : "Home"])
        }))
        
        menuItems.append(MenuItem.init(title: "Send Action Beacon", callback: {
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.EVENT, dict: [PayloadType.EVENT_LABEL : ["123" : "abc",
                                                                                                              "321" : 123],
                                                                                   PayloadType.EVENT_ACTION : EventActionType.CLICK_MENU,
                                                                                   PayloadType.EVENT_CATEGORY : "TestCategory",
                                                                                   PayloadType.EVENT_VALUE : 123])
        }))
        
        menuItems.append(MenuItem.init(title: "Product Impressions", callback: {
            var impression1 = Impression.init(id: "12345", name: "Triblend Android T-Shirt")
            impression1.price = "15.25"
            impression1.brand = "Google"
            impression1.category = "Apparel"
            impression1.variant = "Gray"
            impression1.list = "Search Results"
            impression1.position = "1"
            
            var impression2 = Impression.init(id: "123455", name: "Same list T-Shirt")
            impression2.price = "15.25"
            impression2.brand = "Google"
            impression2.category = "Apparel"
            impression2.variant = "Gray"
            impression2.list = "Search Results"
            impression2.position = "2"
            
            var impression3 = Impression.init(id: "67890", name: "Donut Friday Scented T-Shirt")
            impression3.price = "33.75"
            impression3.brand = "Google"
            impression3.category = "Apparel"
            impression3.variant = "Black"
            impression3.position = "1"
            
            let impressions : [Impression] = [impression1, impression2, impression3]
            
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.PAGEVIEW, dict: [PayloadType.CONTENT_GROUP : "default category list",
                                                                                      PayloadType.CURRENCY_CODE : "TWD",
                                                                                      DataType.IMPRESSIONS : impressions])
            
        }))
        
        menuItems.append(MenuItem.init(title: "Product Click", callback: {
            var product1 = Product.init(id: "product1_id", name: "product1_name", price: "10.10", quantity: 1)
            product1.brand = "Omni_Brand"
            product1.category = "Omni_Category"
            product1.variant = "Omni_Variant"
            product1.coupon = "Omni_Coupon"
            
            let products : [Product] = [product1]
            
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.EVENT, dict: [PayloadType.EVENT_ACTION : EventActionType.CLICK_PRODUCT,
                                                                                   PayloadType.PRODUCT_ACTION_LIST : "Search Results",
                                                                                   PayloadType.CURRENCY_CODE : "TWD",
                                                                                   DataType.PRODUCTS : products])
        }))
        
        menuItems.append(MenuItem.init(title: "Product Detail Impressions", callback: {
            var product1 = Product.init(id: "product1_id", name: "product1_name", price: "10.10", quantity: 1)
            product1.brand = "Omni_Brand"
            product1.category = "Omni_Category"
            product1.variant = "Omni_Variant"
            product1.coupon = "Omni_Coupon"
            
            let products : [Product] = [product1]
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.PAGEVIEW, dict: [PayloadType.PRODUCT_ACTION : ActionType.DETAIL,
                                                                                      PayloadType.PRODUCT_ACTION_LIST : "category list",
                                                                                      PayloadType.CURRENCY_CODE : "TWD",
                                                                                      DataType.PRODUCTS : products])
        }))
        
        menuItems.append(MenuItem.init(title: "Add To Cart", callback: {
            var product1 = Product.init(id: "product1_id", name: "product1_name", price: "10.10", quantity: 1)
            product1.brand = "Omni_Brand"
            product1.category = "Omni_Category"
            product1.variant = "Omni_Variant"
            product1.coupon = "Omni_Coupon"
            
            let products : [Product] = [product1]
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.EVENT, dict: [PayloadType.EVENT_ACTION : EventActionType.ADD_TO_CART,
                                                                                   PayloadType.CURRENCY_CODE : "TWD",
                                                                                   DataType.PRODUCTS : products])
        }))
        
        menuItems.append(MenuItem.init(title: "Remove From Cart", callback: {
            var product1 = Product.init(id: "product1_id", name: "product1_name", price: "10.10", quantity: 1)
            product1.brand = "Omni_Brand"
            product1.category = "Omni_Category"
            product1.variant = "Omni_Variant"
            product1.coupon = "Omni_Coupon"
            
            let products : [Product] = [product1]
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.EVENT, dict: [PayloadType.EVENT_ACTION : EventActionType.REMOVE_FROM_CART,
                                                                                   PayloadType.CURRENCY_CODE : "TWD",
                                                                                   DataType.PRODUCTS : products])
        }))
        
        menuItems.append(MenuItem.init(title: "Promotion Impressions", callback: {
            var promotion1 = Promotion.init(id: "JUNE_PROMO13", name: "June Sale")
            promotion1.creative = "banner1"
            promotion1.position = "slot1"
            
            var promotion2 = Promotion.init(id: "FREE_SHIP13", name: "Free Shipping Promo")
            promotion2.creative = "skyscraper1"
            promotion2.position = "slot2"
            
            let promotions : [Promotion] = [promotion1, promotion2]
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.PAGEVIEW, dict: [DataType.PROMOTIONS : promotions])
        }))
        
        menuItems.append(MenuItem.init(title: "Promotion Clicks", callback: {
            var promotion1 = Promotion.init(id: "JUNE_PROMO13", name: "June Sale")
            promotion1.creative = "banner1"
            promotion1.position = "slot1"
            
            let promotions : [Promotion] = [promotion1]
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.PAGEVIEW, dict: [PayloadType.EVENT_ACTION : EventActionType.CLICK_PROMOTION,
                                                                                      DataType.PROMOTIONS : promotions])
        }))
        
        menuItems.append(MenuItem.init(title: "Purchases", callback: {
            var product1 = Product.init(id: "product1_id", name: "product1_name", price: "10.10", quantity: 1)
            product1.brand = "Omni_Brand"
            product1.category = "Omni_Category"
            product1.variant = "Omni_Variant"
            product1.coupon = "Omni_Coupon"
            let product2 = Product.init(id: "product2_id", name: "product2_name", price: "12.12", quantity: 2)
            let product3 = Product.init(id: "product3_id", name: "product3_name", price: "15.15", quantity: 3)
            
            let products : [Product] = [product1, product2, product3]
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.EVENT, dict: [PayloadType.EVENT_ACTION : EventActionType.PURCHASE,
                                                                                   PayloadType.REVENUE : 20.20,
                                                                                   DataType.PRODUCTS : products])
        }))
        
        menuItems.append(MenuItem.init(title: "Full Refunds", callback: {
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.EVENT, dict: [PayloadType.EVENT_ACTION : EventActionType.REFUND,
                                                                                   PayloadType.TRANSACTION_ID : "ABC",
                                                                                   PayloadType.PRODUCT_ACTION : "custom_product_action"])
        }))
        
        menuItems.append(MenuItem.init(title: "Partial Refunds", callback: {
            var product1 = Product.init(id: "product1_id", name: "product1_name", price: "10.10", quantity: 1)
            product1.brand = "Omni_Brand"
            product1.category = "Omni_Category"
            product1.variant = "Omni_Variant"
            product1.coupon = "Omni_Coupon"
            let product2 = Product.init(id: "product2_id", name: "product2_name", price: "12.12", quantity: 2)
            let product3 = Product.init(id: "product3_id", name: "product3_name", price: "15.15", quantity: 3)
            
            let products : [Product] = [product1, product2, product3]
            OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.EVENT, dict: [PayloadType.EVENT_ACTION : EventActionType.REFUND,
                                                                                   PayloadType.TRANSACTION_ID : "ABC",
                                                                                   PayloadType.PRODUCT_ACTION : "custom_product_action",
                                                                                   DataType.PRODUCTS : products])
        }))
        
        menuItems.append(MenuItem.init(title: "Send local notification", callback: {
            let content = UNMutableNotificationContent()
            content.title = "title：測試本地通知 Title"
            content.subtitle = "subtitle：測試 subtitle"
            content.body = "body：測試 body"
            content.badge = 1
            content.sound = UNNotificationSound.default
            // 設置點擊通知後取得的資訊
            content.userInfo = ["omnisegment_tuid" : "53bc481c-5808-4375-8caa-c780429758d2_1_3"]
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                print("成功建立通知...")
            })
        }))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.menuTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        cell.textLabel?.text = self.menuItems[indexPath.section].title
        cell.textLabel?.numberOfLines = 0
        
        // add border and color
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        self.menuItems[indexPath.section].callback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //------------------

}

