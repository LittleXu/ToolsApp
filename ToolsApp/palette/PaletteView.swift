import SwiftUI

let defaultColors: [Color] = [
    Color(red: 255/255, green: 80/255, blue: 160/255),    // 鲜粉红
    Color(red: 255/255, green: 120/255, blue: 80/255),    // 珊瑚橙
    Color(red: 255/255, green: 220/255, blue: 50/255),    // 明黄
    Color(red: 180/255, green: 80/255, blue: 255/255),    // 紫罗兰
    Color(red: 50/255, green: 220/255, blue: 180/255),    // 青绿色
    Color(red: 80/255, green: 180/255, blue: 255/255)     // 天蓝
]

struct PaletteView: View {
    
    @StateObject var cameraVM = CameraViewModel()
    @State private var showColorPicker = false
    @State private var selectedColor: Color = defaultColors.first!
    
    @State private var showBrightnessSlider = false
    @State private var brightnessValue: Double = Double(UIScreen.main.brightness)
    @State private var colorBrightness: Double = 1.0
    
    @State private var showDefaultColorPicker = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showCamera = true
    @State private var showPreview = false
    
    @State private var hideUI = false
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let size = min(width, height) - 10
            
            ZStack {
                
                // 背景色
                selectedColor
                    .brightness(Double(colorBrightness - 1))
                    .ignoresSafeArea()
                
                CameraPreview(session: cameraVM.session)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                    )
                    .scaleEffect(showCamera ? 1 : 0.5)
                    .opacity(showCamera ? 1 : 0)
                    .shadow(color: Color.black.opacity(showCamera ? 0.3 : 0), radius: 8)
                    .animation(.easeInOut(duration: 0.4), value: showCamera)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .frame(width: width, height: height)
            .ignoresSafeArea()
            .overlay(
                Group {
                    if !hideUI {
                        VStack {
                            Spacer()
                            let buttonSpacing: CGFloat = width <= 390 ? 30 : 40
                            let buttonSize: CGFloat = width <= 390 ? 28 : 36
                            let captureOuter: CGFloat = width <= 390 ? 36 : 48
                            let captureInner: CGFloat = width <= 390 ? 28 : 36

                            HStack(spacing: buttonSpacing) {
                                Button(action: { showDefaultColorPicker.toggle() }) {
                                    Image(systemName: "paintbrush.fill")
                                        .resizable()
                                        .frame(width: buttonSize, height: buttonSize)
                                        .foregroundColor(.white)
                                }
                                Button(action: { showColorPicker.toggle() }) {
                                    Image(systemName: "paintpalette.fill")
                                        .resizable()
                                        .frame(width: buttonSize, height: buttonSize)
                                        .foregroundColor(.white)
                                }
                                Button(action: {
                                    if !showCamera {
                                        withAnimation(.easeInOut(duration: 0.4)) {
                                            showCamera.toggle()
                                        }
                                    } else {
                                        cameraVM.capturePhoto()
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.white.opacity(0.8), lineWidth: 6)
                                            .frame(width: captureOuter, height: captureOuter)
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: captureInner, height: captureInner)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .shadow(radius: 3)
                                Button(action: { showBrightnessSlider.toggle() }) {
                                    Image(systemName: "sun.max.fill")
                                        .resizable()
                                        .frame(width: buttonSize, height: buttonSize)
                                        .foregroundColor(.white)
                                }
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        showCamera.toggle()
                                    }
                                }) {
                                    Image(systemName: showCamera ? "eye.slash" : "eye")
                                        .resizable()
                                        .frame(width: buttonSize, height: buttonSize - 8)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, width < 350 ? 10 : 20)
                            .padding(.vertical, 12)
                            .background(
                                Color.black.opacity(0.4)
                                    .blur(radius: 0.5)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .padding(.bottom, 30)
                        }
                    }
                }
            )
            .onTapGesture {
                withAnimation {
                    hideUI.toggle()
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: hideUI ? nil : Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("补色板")
            }
            .foregroundColor(.black)
        }))
        .sheet(isPresented: $showColorPicker) {
            ColorPicker("选择补色板颜色", selection: $selectedColor, supportsOpacity: true)
                .padding()
                .presentationDetents([.fraction(0.15)])
        }
        
        .sheet(isPresented: $showBrightnessSlider) {
            VStack {
                Text("调节屏幕亮度")
                    .font(.headline)
                    .padding()
                
                Slider(value: $brightnessValue, in: 0...1, step: 0.01)
                    .padding()
                    .onChange(of: brightnessValue) { _, newValue in
                        UIScreen.main.brightness = CGFloat(newValue)
                    }
                
                Text("调节颜色亮度")
                          .font(.headline)
                          .padding(.top)
                      
                Slider(value: $colorBrightness, in: 0.5...1.5, step: 0.01)
                    .padding()
            }
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 20)
            .presentationDetents([.fraction(0.4)])
        }
        
        .sheet(isPresented: $showDefaultColorPicker) {
            VStack(spacing: 20) {
                Text("选择补色板颜色")
                    .font(.headline)
                
                // 一排颜色按钮
                HStack(spacing: 15) {
                    ForEach(defaultColors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: selectedColor == color ? 3 : 0)
                            )
                            .onTapGesture {
                                selectedColor = color
                                showDefaultColorPicker = false
                            }
                    }
                }
            }
            .padding()
            .presentationDetents([.fraction(0.25)])
        }
        
        .onChange(of: cameraVM.capturedImage) { oldValue, newValue in
            if newValue != nil {
                   showPreview = true
               }
        }
        
        .fullScreenCover(isPresented: $showPreview) {
            if let image = cameraVM.capturedImage {
                PreviewView(image: image, onRetake: {
                    cameraVM.capturedImage = nil
                    showPreview = false
                })
            }
        }
    }
}

#Preview {
    NavigationView {
        PaletteView()
    }}

