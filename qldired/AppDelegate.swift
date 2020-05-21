//
//  AppDelegate.swift
//  qldired
//
//  Created by HYUNGBO SHIM on 5/15/20.
//

//import Cocoa
//import SwiftUI
import Quartz

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, QLPreviewPanelDataSource, QLPreviewPanelDelegate {
    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return 1
    }
    
    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        let url = URL.init(fileURLWithPath: file)
        return url as QLPreviewItem
    }
    
    var file = CommandLine.arguments[1]
    var buffer = CommandLine.arguments[2]
    
    var panel = QLPreviewPanel.shared()
    //let vc = QLPreviewController(nibName: nil, bundle: nil)
    var dataSource: QLPreviewPanelDataSource!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        /*if let sharedPanel = QLPreviewPanel.shared() {
                    sharedPanel.delegate = self
                    sharedPanel.dataSource = self
                    sharedPanel.makeKeyAndOrderFront(self)
              }*/
        panel?.delegate = self
        panel?.dataSource = self
        panel?.makeKeyAndOrderFront(self)
        
        
        /*NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
            self.flagsChanged(with: $0)
            return $0
        }*/
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }

    }
    
    func keyDown(with event: NSEvent) {
        /*switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.command] where event.characters == "l",
             [.command, .shift] where event.characters == "l":
            print("command-l or command-shift-l")
        default:
            break
        }*/
        switch event.keyCode {
        case 53:
            print("Esc pressed")
            NSApplication.shared.terminate(self)
        case 49:
            print("SPC pressed")
            NSApplication.shared.terminate(self)
        case 35:
            print("p pressed")
            file = String(shell("/usr/local/bin/emacsclient -e '(with-current-buffer \"" + buffer + "\" (progn (dired-previous-line 1) (dired-get-file-for-visit)))'").dropLast(2).dropFirst())
            print(file)
            panel?.refreshCurrentPreviewItem()
            panel?.reloadData()
        case 45:
            print("n pressed")
            file = String(shell("/usr/local/bin/emacsclient -e '(with-current-buffer \"" + buffer + "\" (progn (dired-next-line 1) (dired-get-file-for-visit)))'").dropLast(2).dropFirst())
            print(file)
            panel?.refreshCurrentPreviewItem()
            panel?.reloadData()
        default:
            break
        }
    }
    
    /*func flagsChanged(with event: NSEvent) {
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.shift, .control, .option, .command]:
            print("shift-control-option-command")
        default:
            print("no modifier")
        }
    }*/
    
    func shell(_ command: String) -> String {
        let task = Process.init()
        task.launchPath = "/usr/local/bin/bash"
        task.arguments = ["-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

        return output
    }

}

