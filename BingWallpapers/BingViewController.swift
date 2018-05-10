//
//  BingViewController.swift
//  BingWallpapers
//
//  Created by Nabeel Omer on 09/05/18.
//  Copyright © 2018 Nabeel Omer. All rights reserved.
//

import Cocoa
import Fire

class BingViewController: NSViewController {
    
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
    
    let index:UInt = 1
    let number = "1"
    let market = "en-IN"
    
    func downloadImage() -> Void {
        Fire.build(HTTPMethod: .GET, url: "https://www.bing.com/HPImageArchive.aspx?format=js&idx=\(index)&n=\(number)&mkt=\(market)")
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

    @IBOutlet weak var textLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    
    @IBAction func wallpaperSet(_ sender: Any) {
        let url = URL(fileURLWithPath: FileManager.default.homeDirectoryForCurrentUser.absoluteString).appendingPathComponent("wallapaper.jpeg")
        
        let wkspace = NSWorkspace.shared
        let screenoptions = wkspace.desktopImageOptions(for: NSScreen.screens[0])

        let image = imageView.image!
        try! Data(image.tiffRepresentation!).write(to: url)
        
        for screen in NSScreen.screens {
            try! wkspace.setDesktopImageURL(url, for: screen, options: screenoptions!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        downloadImage()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        self.imageView.image = nil
    }
}

extension BingViewController {
    static func freshController() -> BingViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "BingViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? BingViewController else {
            fatalError("Why cant i find QuotesViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
