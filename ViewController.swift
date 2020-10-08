//
//  ViewController.swift
//  bruh
//
//  Created by Dev on 2020-10-07.
//  Copyright © 2020 Syritx. All rights reserved.
//

import Cocoa
import Metal
import MetalKit

class ViewController: NSViewController {

    var renderer: Renderer!
    var mtkView: MTKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mtkView = MTKView()
        mtkView.translatesAutoresizingMaskIntoConstraints = false
        
        preferredContentSize.width = 1000
        preferredContentSize.height = 720
        
        view.addSubview(mtkView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[mtkView]|", options: [], metrics: nil, views: ["mtkView" : mtkView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mtkView]|", options: [], metrics: nil, views: ["mtkView" : mtkView]))
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("metal not supported")
            return
        }
        mtkView.device = defaultDevice
        renderer = Renderer(mtkView: mtkView)
        mtkView.delegate = renderer
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

