//
//  ContentView.swift
//  IBeaconDetector
//
//  Created by Jian Ma on 1/13/20.
//  Copyright © 2020 Jian Ma. All rights reserved.
//
import Combine
import CoreLocation
import SwiftUI


class BeaconDetector: NSObject, CLLocationManagerDelegate, ObservableObject{
    
    @Published var didChange = PassthroughSubject<Void, Never>()
    var locationManager: CLLocationManager?
    var lastDistance = CLProximity.unknown
    
    override init(){
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //if allowed to use
        if status == .authorizedWhenInUse{
            //if type of beacon available
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                //if range available
                if CLLocationManager.isRangingAvailable(){
                    startScaning()
                }
            }
            
        }
    }
    
    func startScaning(){
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let clBeaconIdentityConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        let beaconregion = CLBeaconRegion(beaconIdentityConstraint: clBeaconIdentityConstraint, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconregion)
        locationManager?.startRangingBeacons(satisfying: clBeaconIdentityConstraint)
        
    }
    
     func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else{
            update(distance: .unknown)
        }
    }
    
    func update(distance: CLProximity)
    {
        lastDistance = distance
        didChange.send(())
    }
}
struct ViewTextModifier: ViewModifier{
    func body(content: Content) -> some View{
        content
        .font(Font.system(.title, design: .rounded))
         .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
        
    }
}


struct ContentView: View {
    
    @ObservedObject var detector = BeaconDetector()
    
    var body: some View {
        switch detector.lastDistance{
        case .immediate:
             return Text("Right here!!!")
             .modifier(ViewTextModifier())
                  .background(Color.gray)
                .edgesIgnoringSafeArea(.all)
        case .unknown:
            return Text("UNKNOWN!")
            .modifier(ViewTextModifier())
                 .background(Color.blue)
               .edgesIgnoringSafeArea(.all)
        case .near:
            return Text("near!")
            .modifier(ViewTextModifier())
                 .background(Color.green)
               .edgesIgnoringSafeArea(.all)
        case .far:
            return Text("far!")
            .modifier(ViewTextModifier())
                 .background(Color.yellow)
               .edgesIgnoringSafeArea(.all)
//        @unknown default:
//            return Text("default")
        }
        
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
