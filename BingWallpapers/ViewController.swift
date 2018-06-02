//
//  ViewController.swift
//  BingWallpapers
//
//  Created by Nabeel Omer on 06/05/18.
//  Copyright © 2018 Nabeel Omer. All rights reserved.
//

import Cocoa
import Fire

class ViewController: NSViewController {
    
    struct Bing : Codable {
        struct BingImage : Codable {
            let startdate: String
            let fullstartdate: String
            let enddate: String
            let url: String
            let urlbase: String
            let copyright: String
            let copyrightlink: String
            let quiz: String
            let wp: Bool
            let hsh: String
            let drk: Int
            let top: Int
            let bot: Int
            let hs: [Int]
        }

        struct BingTooltips : Codable {
            let loading: String
            let previous: String
            let next: String
            let walle: String
            let walls: String
        }
        
        let images: [BingImage]
        let tooltips: BingTooltips
    }
    
    var bingData: Bing?
    
    func downloadImage() -> Void {
        Fire.build(HTTPMethod: .GET, url: "https://www.bing.com/HPImageArchive.aspx?format=js&idx=-1&n=1&mkt=en-IN")
            .fireForString { (str, resp) -> Void in
                self.bingData = try! JSONDecoder().decode(Bing.self, from: str!.data)
                Fire.build(HTTPMethod: .GET, url: "https://www.bing.com/\(self.bingData!.images[0].url)").fireForData { (data, resp) in
                    self.view.layer!.contents = NSImage(data: data!)!
                    self.textLabel.stringValue = self.bingData!.images[0].copyright
//                    self.fileName = self.bingData.images[0].startdate
                }

        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.wantsLayer = true
        downloadImage()
    }
    
    
    @IBAction func wallpaperSetter(_ sender: Any) {
        let url = FileManager.default.urls(for: .cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0].appendingPathComponent("BingWallpaper-\(self.bingData!.images[0].startdate).jpeg")
        
        try! Data((self.view.layer!.contents! as! NSImage).tiffRepresentation!).write(to: url)
        
        let wkspace = NSWorkspace.shared
        for screen in NSScreen.screens {
            let screenoptions = wkspace.desktopImageOptions(for: screen)
            try! wkspace.setDesktopImageURL(url, for: screen, options: screenoptions!)
        }
    }
        
    @IBAction func helpClick(_ sender: Any) {
        let controller = NSViewController()
        controller.view = NSView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(290), height: CGFloat(50)))
        
        let popover = NSPopover()
        popover.contentViewController = controller
        popover.contentSize = controller.view.frame.size
        
        popover.behavior = .transient
        popover.animates = true
        
        popover.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        
        let txt = NSTextField(frame: NSMakeRect(10,25,50,22))
        txt.stringValue = "Press ⌘S to set the image as your wallpaper."
        txt.textColor = NSColor.white.withAlphaComponent(0.95)
        txt.backgroundColor = NSColor.clear
        txt.isEditable = false;
        txt.isBordered = false
        controller.view.addSubview(txt)
        txt.sizeToFit()
        popover.show(relativeTo: (sender as AnyObject).bounds, of: sender as! NSView, preferredEdge: NSRectEdge.maxY)
        
    }
    @IBOutlet weak var textLabel: NSTextField!
}

