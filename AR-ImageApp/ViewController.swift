//
//  ViewController.swift
//  AR-ImageApp
//
//  Created by shunichi hiraiwa on 2018/06/29.
//  Copyright © 2018年 shunichi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        configuration.detectionImages = referenceImages

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    // ARKit のデリゲート didUpdate でトラッキングが変更されるたび処理する命令を書く
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        // DispatchQueue 内で処理をかく
        DispatchQueue.main.async {
            
            // アンカーが画像認識用か調べる
            if let imageAnchor = anchor as? ARImageAnchor {
                
                //　ジオメトリが設定されていなければ、ジオメトリを設定
                if(node.geometry == nil){
                    let plane = SCNPlane()
                    
                    //　アンカーの大きさをジオメトリに反映させる
                    plane.width = imageAnchor.referenceImage.physicalSize.width
                    plane.height = imageAnchor.referenceImage.physicalSize.height
                    
                    // 画像を認識した画像の上に貼り付ける
                    plane.firstMaterial?.diffuse.contents = UIImage(named:"IMG_2397.png")
                    
                    // 設置しているノードへジオメトリを渡し描画する
                    node.geometry = plane
                }
                
                //　位置の変更
                node.simdTransform = imageAnchor.transform
                
                // 回転の変更
                node.eulerAngles.x = 0
                
            }
            
        }
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
