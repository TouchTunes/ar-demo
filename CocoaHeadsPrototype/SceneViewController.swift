//
//  ViewController.swift
//  CocoaHeadsPrototype
//
//  Created by Juan Garcia and Shirag Berejikian on 2017-08-28.
//  Copyright © 2017 Touchtunes. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Darwin

class SceneViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!

    @IBOutlet weak var debugLabelBackgroundView: UIView!
    @IBOutlet weak var debugLabelView: UIView!
    @IBOutlet weak var debugLabel: UILabel!

    @IBOutlet weak var showDebugOptionsButton: UIButton!

    @IBOutlet weak var enableDetectionSwitch: UISwitch!
    @IBOutlet weak var enableDetectionLabel: UILabel!

    @IBOutlet weak var enableDebugFeaturePointsSwitch: UISwitch!
    @IBOutlet weak var enableDebugFeaturePointsLabel: UILabel!

    @IBOutlet weak var drawFeaturePointsSwitch: UISwitch!
    @IBOutlet weak var drawFeaturePointsLabel: UILabel!
    @IBOutlet weak var drawFeaturePointsAim: UIImageView!
    
    @IBOutlet weak var drawHorizontalPlanesSwitch: UISwitch!
    @IBOutlet weak var drawHorizontalPlanesLabel: UILabel!

    @IBOutlet weak var restartTrackingButton: UIButton!
    @IBOutlet weak var placeObjectSwitch: UISwitch!
    @IBOutlet weak var placeObjectLabel: UILabel!

    // MARK - UI Helper Variables
    var isShowingDebugOptions = false
    
    // MARK - Instance Variables
    var touchTunesJukeDetector: TouchTunesJukeDetector!
    var lastInferenceTime = 0.0
    
    // MARK - Instance variables for coin placement
    var planes = [UUID:Plane]()
    var coinNode: Coin?
    var jukeDetectedBuffer = [Bool]()
    var jukeDetectedTrueCount = 0
    var jukeDetectedState = false
    var coinAdded = false
    
    // MARK - Class Constants
    let kInferencePeriod = 0.1 // run the scene input data against the CoreML model at this period

    var screenCenter: CGPoint?
    let serialQueue = DispatchQueue(label: "com.touchtunes.CocoaHeadsPrototype")

    var enableTrakingWithSpheres = false

    let standardConfiguration: ARConfiguration = {
        var configuration: ARConfiguration
        if ARWorldTrackingConfiguration.isSupported {
            configuration = ARWorldTrackingConfiguration()
            (configuration as! ARWorldTrackingConfiguration).planeDetection = .horizontal
        } else {
            configuration = AROrientationTrackingConfiguration()
        }

        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupScene()
        self.setupDebugUI()

        self.touchTunesJukeDetector = TouchTunesJukeDetector()
        self.touchTunesJukeDetector.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SceneViewController.tapSceneViewAction(sender:)))
        self.sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapSceneViewAction(sender: UITapGestureRecognizer) {
        if (self.coinAdded) {
            let url = URL(string: "touchtunes://v3/link?target=home");
            if UIApplication.shared.canOpenURL(url!)
            {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sceneView.session.run(self.standardConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sceneView.session.pause()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func showDebugOptions(_ sender: Any) {
        self.isShowingDebugOptions = !self.isShowingDebugOptions
        self.showDebugOptions(show: self.isShowingDebugOptions)
    }

    @IBAction func switchChangedValue(_ sender: UISwitch) {
        if self.enableDetectionSwitch.isOn {
            self.enableDebugFeaturePointsSwitch.isOn = false
            self.drawFeaturePointsSwitch.isOn = false
            self.drawHorizontalPlanesSwitch.isOn = false
        }

        if sender == self.enableDebugFeaturePointsSwitch {
            self.sceneView.debugOptions = self.enableDebugFeaturePointsSwitch.isOn ? ARSCNDebugOptions.showFeaturePoints : []
        }

        if self.enableDebugFeaturePointsSwitch.isOn {
            self.drawFeaturePointsSwitch.isOn = false
            self.drawHorizontalPlanesSwitch.isOn = false
        }

        if self.drawFeaturePointsSwitch.isOn {
            self.enableDebugFeaturePointsSwitch.isOn = false
            self.drawHorizontalPlanesSwitch.isOn = false
        }

        if self.drawHorizontalPlanesSwitch.isOn {
            self.drawFeaturePointsSwitch.isOn = false
            self.enableDebugFeaturePointsSwitch.isOn = false
        } else {
            self.clearHorizontalPlanes()
        }

        self.drawFeaturePointsAim.isHidden = !self.drawFeaturePointsSwitch.isOn
    }

    @IBAction func restartTracking() {
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) -> Void in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(self.sceneView.session.configuration ?? self.standardConfiguration, options: [ARSession.RunOptions.resetTracking])

        self.enableDetectionSwitch.isOn = false
        self.enableDebugFeaturePointsSwitch.isOn = false
        self.drawFeaturePointsSwitch.isOn = false
        self.drawHorizontalPlanesSwitch.isOn = false

        self.hideDetectionDebugSection()

        self.coinNode = nil
        self.coinAdded = false

        self.jukeDetectedState = false
    }
}




