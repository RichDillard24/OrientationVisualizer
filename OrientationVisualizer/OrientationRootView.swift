
import SwiftUI

struct OrientationRootView: View {
    @StateObject private var vm = MotionVM()
    @State private var hz: Double = 60
    @State private var showCube: Bool = false
    @State private var demoMode: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                BubbleLevelView(vm: vm, targetTolerance: 3, radius: 110)
                    .padding(.top, 8)
                
                VStack(spacing: 6) {
                    Text(String(format: "roll %.1f°  pitch %.1f°  yaw %.1f°",
                                vm.rollDeg, vm.pitchDeg, vm.yawDeg))
                    .font(.system(.body, design: .monospaced))
                    .padding(10)
                    Text(String(format: "Hz ~ %.0f", vm.sampleHz))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if showCube {
                    OrientationCubeView(
                        qx: vm.qx,
                        qy: vm.qy,
                        qz: vm.qz,
                        qw: vm.qw)
                    .frame(height: 220)
                    .padding(.vertical, 4)
                    .transition(.opacity.combined(with: .scale))
                }
                VStack(spacing: 12) {
                    HStack{
                        Toggle("Demo mode", isOn: $demoMode)
                            .onChange(of: demoMode) { _, new in
                                vm.start(updateHz: hz, demo: new) }
                        Spacer()
                        Toggle("Show cube", isOn: $showCube)
                            .toggleStyle(.switch)
                    }
                    
                    HStack {
                        Button("Start") { vm.start(updateHz: hz, demo: demoMode) }
                            .buttonStyle(.borderedProminent)
                        Button("Stop") { vm.stop() }
                            .buttonStyle(BorderlessButtonStyle())
                        Button("Calibrate") { vm.calibrate() }
                            .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.horizontal, 20)
                
                if let msg = vm.errorMessage {
                    Text(msg)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }
                
                Spacer(minLength: 0)
            }
            .padding()
            .navigationTitle("Get Leveled")
            .onAppear {
                vm.start(updateHz: hz, demo: demoMode) }
            .onDisappear { vm.stop() }
        }
    }
}
    
    
    #Preview {
        OrientationRootView()
    }

