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
    
    func downloadImage() -> Void {
        Fire.build(HTTPMethod: .GET, url: "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-IN")
            .fireForString { (str, resp) -> Void in
                var url = "https://www.bing.com/"
                print(resp?.statusCode as Any)
                let decoder = JSONDecoder()
                let bing = try! decoder.decode(Bing.self, from: str!.data)
                url.append(bing.images[0].url)
                Fire.build(HTTPMethod: .GET, url: url).fireForData { (data, resp) in
                    self.imageView.image = NSImage(data: data!)!
                    self.textLabel.stringValue = bing.images[0].copyright
                }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func wallpaperAction(_ sender: Any) {
        let url = URL(fileURLWithPath: FileManager.default.homeDirectoryForCurrentUser.absoluteString).appendingPathComponent("wallapaper.jpeg")
        try! Data(imageView.image!.tiffRepresentation!).write(to: url)
        let wkspace = NSWorkspace.shared
        for screen in NSScreen.screens {
            print("PLEB")
            let screenoptions = wkspace.desktopImageOptions(for: screen)
            try! wkspace.setDesktopImageURL(url, for: screen, options: screenoptions!)
        }
    }
        
    @IBOutlet weak var textLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
}

