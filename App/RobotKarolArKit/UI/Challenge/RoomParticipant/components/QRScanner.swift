//
//  QRScanner.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 13.04.25.
//

import SwiftUI
import VisionKit
import AVKit

struct QRScanner: View {
    @State private var session: AVCaptureSession = .init()
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    @StateObject private var qrDelegate = QRScannerDelegate()
    @Binding var scannedCode: String
    @Binding var codeDetected: Bool
    
    @State var rotation: UIDeviceOrientation = UIDevice.current.orientation
    
    var size: Double = 300
    
    var body: some View {
        VStack(alignment: .center) {
            CameraView(frameSize: CGSize(width: size, height: size), session: $session, rotation: $rotation)
        }.frame(width: size, height: size)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .padding(15)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            rotation = UIDevice.current.orientation
        }
        .onChange(of: qrDelegate.scannedCode) { _, newValue in
            if let code = newValue {
                scannedCode = code
                codeDetected = true
                session.stopRunning()
                qrDelegate.scannedCode = nil
            }
            
        }
        .onAppear(perform: checkCameraPermissions)
        .onAppear {
            scannedCode = ""
            codeDetected = false
        }
        .onDisappear {
            session.stopRunning()
        }
        
    }
    
    func checkCameraPermissions() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setupCamera()
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    setupCamera()
                }
            case .denied, .restricted:
                break
            default: break
            }
        }
    }
    
    func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera], mediaType: .video, position: .back).devices.first else {
                print("Could not find capture device")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                print("Wrong camera setup")
                return
            }
            
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            qrOutput.metadataObjectTypes = [.qr]
            
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            
            
        } catch {
            print("Error setting up camera")
        }
        
    }
}

class QRScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String?
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObejct = metaObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let Code = readableObejct.stringValue else {return}
            scannedCode = Code
        }
    }
}
