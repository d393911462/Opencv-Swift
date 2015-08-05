//
//  ViewController.swift
//  CameraCapture
//
//  Created by Dengzeyu on 15/8/4.
//  Copyright © 2015年 Dengzeyu. All rights reserved.
//

import UIKit
import AVFoundation
import CoreVideo
import CoreMedia
import CoreGraphics

class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    var frontCameraDevice:AVCaptureDevice?;
    var backCameraDevice:AVCaptureDevice?;
    var captureInput:AVCaptureInput?;
    var preLayer:AVCaptureVideoPreviewLayer?;
    var status:Int?;
    var stillImageOutput:AVCaptureVideoDataOutput?;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initCapture();
    }
    override func viewDidAppear(animated: Bool) {
        self.view!.layer.addSublayer(self.preLayer!);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initCapture()
    {
        let camera=CameraHelper.getInstance();
        
        let cameraDevices:[AnyObject]=AVCaptureDevice.devices();
        for device in cameraDevices
        {
            NSLog("Device name: %@", device.localizedName!!);
            if(device.hasMediaType(AVMediaTypeVideo))
            {
                if(device.position==AVCaptureDevicePosition.Back)
                {
                    self.backCameraDevice=device as? AVCaptureDevice;
                }
                else
                {
                    self.frontCameraDevice=device as? AVCaptureDevice;
                }
            }
            
        }
        do
        {
            try self.captureInput=AVCaptureDeviceInput(device: self.frontCameraDevice);
        }
        catch
        {
            print("摄像头加载失败！");
        }
        self.stillImageOutput=AVCaptureVideoDataOutput();
        self.stillImageOutput!.alwaysDiscardsLateVideoFrames=true;
        let queue=dispatch_queue_create("cameraQueue", nil);
        self.stillImageOutput!.setSampleBufferDelegate(self, queue: queue!);
        let key=kCVPixelBufferPixelFormatTypeKey;
        let value=NSNumber(unsignedInt: kCVPixelFormatType_32BGRA);
        let viewsittiong:NSDictionary=NSDictionary(object: value, forKey: key as String);
        self.stillImageOutput!.videoSettings=viewsittiong as [NSObject : AnyObject];
        camera.removeinputandoutput();
        camera.captureOutput=self.stillImageOutput!;
        camera.captureInput=self.captureInput;
        camera.captureSession!.sessionPreset=AVCaptureSessionPreset640x480;//设置采样分辨率 （）
        camera.addinputandoutput();
        self.preLayer=AVCaptureVideoPreviewLayer(session: camera.captureSession!);
        camera.startCapture();
        self.preLayer!.frame=CGRectMake(0, 0, 768, 1024);
        self.preLayer!.contentsGravity=kCAGravityResizeAspectFill;

    }
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        let imgBuffer=CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferLockBaseAddress(imgBuffer!, 0);
        let baseAddress = CVPixelBufferGetBaseAddress(imgBuffer!);
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imgBuffer!);
        let width = CVPixelBufferGetWidth(imgBuffer!);
        let height = CVPixelBufferGetHeight(imgBuffer!);
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let newContext = CGBitmapContextCreate(baseAddress,width, height, 8, bytesPerRow, colorSpace,(2 << 12)|2);
        
        
  
            CVWrapper.cvMatFromUIImage(UIImage(CGImage: CGBitmapContextCreateImage(newContext!)!));//UIimage 当前帧图片！
            
       

    }

}

