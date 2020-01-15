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
        if status == .authorizedWhenInUse{
            
        }
    }
}

struct ContentView: View {
    
    
    
    
    var body: some View {
        Text("UNKNOWN!")
            .font(Font.system(.title, design: .rounded))
            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.gray)
           .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
