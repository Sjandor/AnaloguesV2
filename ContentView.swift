import SwiftUI
import AVFoundation
import Combine

struct CameraView: View {
    @StateObject private var model = DataModel()
    @State private var sliderValue = 0.5
    @State private var lensPosition: Float = 0.5
    let captureDevice = AVCaptureDevice.default(for: .video)
    
    
    private static let barHeightFactor = 0.15
    
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                ViewfinderView(image:  $model.viewfinderImage )
                    .overlay(alignment: .top) {
                        Color.black
                            .opacity(1)
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                    }
                    .overlay(alignment: .bottom) {
                        buttonsView()
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                            .background(.black.opacity(1))
                    }
                    .overlay(alignment: .center)  {
                        Color.clear
                            .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                            .accessibilityElement()
                            .accessibilityLabel("View Finder")
                            .accessibilityAddTraits([.isImage])
                    }
                    .background(.black)
            }
            
            .task {
                await model.camera.start()
                await model.loadPhotos()
                await model.loadThumbnail()
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .statusBar(hidden: true)
        }
    }
    
    private func adjustLensPositionManually(value : Float){
        guard let device = captureDevice else {
            print("Failed to get AVCaptureDevice")
            return
        }

        model.camera.adjustLensPositionManually(device, value)
    }
    
    private func buttonsView() -> some View {
        VStack {
            HStack {
                Slider(value: $lensPosition, in: 0...1, step: 0.01).onChange(of: self.lensPosition) { newPosition in
                    adjustLensPositionManually(value: newPosition)
                }
            }
            
            .onAppear {
                adjustLensPositionManually(value: 0.5)
            }
            
            HStack (spacing: 60){
                
                Spacer()
                
                Button {
                    model.camera.switchCaptureDevice()
                } label: {
                    Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button {
                    model.camera.takePhoto()
                } label: {
                    Label {
                        Text("Take Photo")
                    } icon: {
                        ZStack {
                            Circle()
                                .strokeBorder(.white, lineWidth: 3)
                                .frame(width: 62, height: 62)
                            Circle()
                                .fill(.white)
                                .frame(width: 50, height: 50)
                        }
                    }
                }
                
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            Spacer()
        }
    }
}

