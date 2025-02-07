//
//  NetworkScanner.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/22.
//

import Foundation


import Foundation
import Network

class DeviceDiscovery: NSObject {
    var monitor: NWPathMonitor!
    var queue: DispatchQueue!
    
    override init() {
        
        self.queue = DispatchQueue(label: "NetworkMonitor")
        self.monitor = NWPathMonitor()
        
        super.init()
        
        self.monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            if path.status == .satisfied {
                self.discoverDevices()
            }
        }
        self.monitor.start(queue: self.queue)
        
    }
    
    func discoverDevices() {
        let discoverySession = NetServiceBrowser()
        discoverySession.delegate = self
        discoverySession.searchForServices(ofType: "_http._tcp.", inDomain: ".host")
    }
}

extension DeviceDiscovery: NetServiceBrowserDelegate {
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.resolve(withTimeout: 5.0)
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        guard let hostname = sender.hostName else { return }
        guard let addresses = sender.addresses else { return }
        for address in addresses {
            let addressString = String(describing: address)
            print("Hostname: \(hostname)")
            print("Address: \(addressString)")
        }
    }
}
