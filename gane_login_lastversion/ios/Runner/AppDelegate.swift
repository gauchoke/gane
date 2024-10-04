import UIKit
import Flutter
import FirebaseMessaging
import CoreTelephony


@UIApplicationMain

@objc class AppDelegate: FlutterAppDelegate {
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //GeneratedPluginRegistrant.register(with: self)
      GeneratedPluginRegistrant.register(with: self)
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
      
      
      
               // 1
              let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
              
              // 2
              let deviceChannel = FlutterMethodChannel(name: "test.flutter.methodchannel/iOS",
                                                       binaryMessenger: controller.binaryMessenger)
              
              // 3
              prepareMethodHandler(deviceChannel: deviceChannel)
      
      
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    
    private func prepareMethodHandler(deviceChannel: FlutterMethodChannel) {
            
            // 4
            deviceChannel.setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                
                // 5
                if call.method == "getSimPlugOut" {
                    
                    // 6
                    self.receiveDeviceModel(result: result)
                    //self.reciiveTokenCard(result: result)
                }
                /*else if call.method == "getCreditCard" {
                    
                    // 6
                    //self.reciiveTokenCard(result: result)
                    
                    guard let args = call.arguments as? [String : Any] else {return}
                    let tcnumber = args["tcnumber"] as! String
                    let name = args["name"] as! String
                    let year = args["year"] as! String
                    let month = args["month"] as! String
                    let cvv = args["cvv"] as! String
                    
                    let conekta = Conekta()
                    //conekta.delegate = self
                    conekta.publicKey = "key_KJysdbf6PotS2ut2"
                    conekta.collectDevice()
                    
                    let card = conekta.card()
                    
                    card?.setNumber(tcnumber, name: name, cvc: cvv , expMonth: month, expYear: year)
                    
                    let token = conekta.token()
                    token?.card = card
                    
                    token?.create(success: { (data) -> Void in
                        if let data = data as NSDictionary? as! [String:Any]? {
                            //self.outTokenUI.text = data["id"] as? String
                            //self.outUUID_UI.text = conekta.deviceFingerprint()
                            let idTX = data["id"] as? String
                            print(idTX!)
                            result(idTX)
                            
                        }
                    }, andError: { (error) -> Void in
                        //print(error)
                        result("NoToken")
                    })
                    
                    
                }*/
                else {
                    // 9
                    result(FlutterMethodNotImplemented)
                    return
                }
                
            })
        }

    private func receiveDeviceModel(result: FlutterResult) {
            // 7
            //let deviceModel = UIDevice.current.model
        
            
            let info = CTTelephonyNetworkInfo()
            //var num = info.dataServiceIdentifier
            let num = info.subscriberCellularProvider?.mobileNetworkCode
            if(num==nil){
                result("NoSIM")
            }else {
                result(num)
            }
            
    }
    
    private func reciiveTokenCard(result : FlutterResult){
        
        
        /*let conekta = Conekta()
        //conekta.delegate = self
        conekta.publicKey = "key_KJysdbf6PotS2ut2"
        conekta.collectDevice()
        
        let card = conekta.card()
        
        card?.setNumber("4242424242424242", name: "Carlos Perez Perez", cvc: "123" , expMonth: "10", expYear: "2025")
        
        let token = conekta.token()
        token?.card = card
        
        token?.create(success: { (data) -> Void in
            if let data = data as NSDictionary? as! [String:Any]? {
                //self.outTokenUI.text = data["id"] as? String
                //self.outUUID_UI.text = conekta.deviceFingerprint()
                let idTX = data["id"] as? String
                print(idTX)
                
            }
        }, andError: { (error) -> Void in
            //print(error)
        })*/
        
        
    }

    
}




