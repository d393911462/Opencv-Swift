//
//  CameraHelper.swift
//  Swift-GoDrawing
//
//  Created by Dengzeyu on 15/8/1.
//  Copyright © 2015年 Dengzeyu. All rights reserved.
//

import UIKit
import AVFoundation
import CoreVideo
import CoreMedia
import CoreGraphics
class CameraHelper: NSObject {

    var captureSession:AVCaptureSession?;
     var captureInput:AVCaptureInput?;
     var captureOutput:AVCaptureOutput?;
    class func getInstance()->CameraHelper
    {
        struct MYSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:CameraHelper? = nil
        }
        dispatch_once(&MYSingleton.predicate, {
            MYSingleton.instance=CameraHelper();
            MYSingleton.instance!.captureSession=AVCaptureSession();
        })
                return MYSingleton.instance!;
    }
      func startCapture()
    {
        if(!self.captureSession!.running)
        {
        self.captureSession!.startRunning();
        }
    }
    func stopCapture()
    {
        if(self.captureSession!.running)
        {
            self.captureSession!.stopRunning();
        }
    }

    func removeinputandoutput()
    {
        stopCapture();
        self.captureSession!.beginConfiguration();
        self.captureSession!.removeOutput(self.captureOutput);
        self.captureSession!.removeInput(self.captureInput);
         self.captureSession!.commitConfiguration();
    }
    func addinputandoutput()
    {
        stopCapture();
        if(self.captureSession!.inputs.count==0)
        {
            self.captureSession!.addInput(self.captureInput);
        }
        else
        {
            print("已经存在input！不能添加，请执行removeInputandOutput后再添加！")
        }
        if(self.captureSession!.outputs.count==0)
        {
            self.captureSession!.addOutput(self.captureOutput);
        }
        else
        {
            print("已经存在output！不能添加，请执行removeInputandOutput后再添加！")
        }

        self.captureSession!.commitConfiguration();
    }
}
