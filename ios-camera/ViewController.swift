//
//  ViewController.swift
//  ios-camera
//
//  Created by konojunya on 2017/07/06.
//  Copyright © 2017年 konojunya. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    
    @IBAction func takeIt(_ sender: Any) {
        let settingsForMonitoring = AVCapturePhotoSettings()
        
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        
        self.stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.captureSession = AVCaptureSession()
        self.stillImageOutput = AVCapturePhotoOutput()
        
        self.captureSession.sessionPreset = AVCaptureSessionPreset1920x1080
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            if self.captureSession.canAddInput(input) {
                self.captureSession.addInput(input)
                
                if self.captureSession.canAddOutput(self.stillImageOutput) {
                    self.captureSession.addOutput(self.stillImageOutput)
                    self.captureSession.startRunning()
                    
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                    self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                    self.previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                    
                    self.previewLayer?.bounds = self.cameraView.bounds
                    self.previewLayer?.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                    
                    self.cameraView.layer.addSublayer(self.previewLayer!)
                }
                
            }
        }
        catch {
            print(error)
        }
        
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: photoData!)
            
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
    }

}

