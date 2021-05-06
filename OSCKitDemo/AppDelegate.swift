//
//  AppDelegate.swift
//  OSCKitDemo
//
//  Created by Sam Smallman on 06/05/2021.
//

import Cocoa
import OSCKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    @IBOutlet weak var oscAnnotationTextField: NSTextField!
    @IBOutlet weak var sendButton: NSButton!
    @IBOutlet var textView: NSTextView!
    
    private let client = OSCClient()
    private let server = OSCServer()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        server.port = 24601
        server.reusePort = true
        server.delegate = self
        
        client.port = 24602
        client.useTCP = false
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func sendButtonDidClick(_ sender: Any) {
        if let message = OSCAnnotation.oscMessage(for: oscAnnotationTextField.stringValue, with: .spaces) {
            client.send(packet: message)
        }
    }
    
    @IBAction func startButtonDidClick(_ sender: Any) {
        do {
            try server.startListening()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func stopButtonDidClick(_ sender: Any) {
        server.stopListening()
    }
}

extension AppDelegate: OSCPacketDestination {
    
    func take(message: OSCMessage) {
        let annotation = OSCAnnotation.annotation(for: message, with: .spaces, andType: true)
        print("annotation")
        textView.string += "\(annotation)\r"
    }
    
    func take(bundle: OSCBundle) {
        textView.string += "Bundle: \(bundle.timeTag.hex()) elements: \(bundle.elements.count)/r"
    }
    
}

