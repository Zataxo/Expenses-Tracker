//
//  LockView.swift
//  AppLockSample
//
//  Created by Hassan Abdalla on 09/01/1448 AH.
//

import LocalAuthentication
import SwiftUI

struct LockView<Content: View>: View {

    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesBackground: Bool = true

    @State private var pin: String = ""
    @ViewBuilder var content: Content
    //View properties
    var forgetPin: () -> Void = {}
    @State private var isUnlocked: Bool = false
    @State private var wrongPinAnimation: Bool = false
    @State private var noBiometricAccess: Bool = false
    let context = LAContext()
    @Environment(\.scenePhase) private var phase
    @State private var isAuthenticating = false

    var body: some View {
        GeometryReader { geo in

            let size = geo.size

            content
                .frame(width: size.width, height: size.height)

            if isEnabled && !isUnlocked {
                Rectangle()
                    .fill(.black)
                    .ignoresSafeArea()

                ZStack {
                    if (self.lockType == .both && !self.noBiometricAccess)
                        || self.lockType == .biometric
                    {

                        if noBiometricAccess {
                            VStack(spacing: 16) {
                                Image(systemName: "faceid")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.secondary)

                                Text(
                                    "Enable biometric authentication in Settings to unlock the view"
                                )
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            VStack(spacing: 24) {
                                Spacer()

                                Button {
                                    self.unlockView()
                                } label: {
                                    VStack(spacing: 12) {
                                        Image(systemName: "lock.fill")
                                            .font(
                                                .system(
                                                    size: 32,
                                                    weight: .semibold
                                                )
                                            )

                                        Text("Tap to unlock")
                                            .font(.footnote)
                                            .fontWeight(.medium)
                                    }
                                    .foregroundStyle(.primary)
                                    .frame(width: 140, height: 140)
                                    .background(
                                        .ultraThinMaterial,
                                        in: .rect(cornerRadius: 24)
                                    )

                                    .overlay {
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(
                                                .white.opacity(0.15),
                                                lineWidth: 0.5
                                            )
                                    }
                                }
                                .buttonStyle(.plain)

                                if lockType == .both {
                                    Button {
                                        withAnimation(.smooth) {
                                            self.noBiometricAccess = true
                                        }
                                    } label: {
                                        Label(
                                            "Enter Pin",
                                            systemImage: "keyboard"
                                        )
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(
                                            .ultraThinMaterial,
                                            in: .capsule
                                        )
                                        .overlay {
                                            Capsule()
                                                .stroke(
                                                    .white.opacity(0.15),
                                                    lineWidth: 0.5
                                                )
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }

                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }

                    } else {
                        NumberPadPinView()
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: size.height + 100))
            }

        }
        .disabled(isAuthenticating)
        .animation(.smooth, value: isAuthenticating)
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in

            if newValue {
                unlockView()
            }

        }
        .onChange(of: phase) { oldValue, newValue in

            if newValue != .active && lockWhenAppGoesBackground {
                self.isUnlocked = false
                pin = ""

            }

            if newValue == .active && isEnabled && !isUnlocked {
                self.unlockView()

            }

        }
    }

    private func unlockView() {
        self.isAuthenticating = true

        Task {

            if isBiometricAuthAvailable && lockType != .number {

                if let result = try? await context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: "Unlock the view"
                ), result {
                    print("Unlocked")
                    withAnimation(
                        .snappy,
                        completionCriteria: .logicallyComplete
                    ) {
                        isUnlocked = true

                    } completion: {
                        pin = ""
                    }
                }

                noBiometricAccess = !isBiometricAuthAvailable
            }
            self.isAuthenticating = false

        }

    }

    private var isBiometricAuthAvailable: Bool {

        let result = context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: nil
        )
        return result

    }

    @ViewBuilder
    private func NumberPadPinView() -> some View {
        VStack(spacing: 30) {

            Text("Enter your pin")
                .font(.title2.bold())
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .overlay(alignment: .leading) {
                    if lockType == .both && isBiometricAuthAvailable {
                        Button {
                            withAnimation(.smooth) {
                                pin = ""
                                noBiometricAccess = false
                            }
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .padding(12)
                                .background(.ultraThinMaterial, in: .circle)
                        }
                        .padding(.leading)
                    }
                }

            Spacer()

            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    let pinCharacters = pin.map { String($0) }

                    ForEach(0..<4, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                            .frame(width: 55, height: 60)
                            .background(
                                .white.opacity(
                                    index < pinCharacters.count ? 0.1 : 0.02
                                ),
                                in: .rect(cornerRadius: 12)
                            )
                            .overlay {
                                if index < pinCharacters.count {
                                    Text(pinCharacters[index])
                                        .font(.title.bold())
                                        .foregroundStyle(.white)
                                        .transition(
                                            .scale.combined(with: .opacity)
                                        )
                                }
                            }
                            .animation(.snappy, value: pin)
                    }
                }
                .keyframeAnimator(
                    initialValue: CGFloat.zero,
                    trigger: wrongPinAnimation,
                    content: { content, value in
                        content.offset(x: value)
                    },
                    keyframes: { _ in
                        KeyframeTrack {
                            CubicKeyframe(30, duration: 0.06)
                            CubicKeyframe(-30, duration: 0.06)
                            CubicKeyframe(20, duration: 0.06)
                            CubicKeyframe(-20, duration: 0.06)
                            CubicKeyframe(0, duration: 0.06)
                        }
                    }
                )

                Button("Forget Pin?", action: forgetPin)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            }

            Spacer()

            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible(), spacing: 15),
                    count: 3
                ),
                spacing: 15
            ) {
                ForEach(1...9, id: \.self) { number in
                    dialButton(text: "\(number)") {
                        if pin.count < 4 { pin.append("\(number)") }
                    }
                }

                Button {
                    if !pin.isEmpty { pin.removeLast() }
                } label: {
                    Image(systemName: "delete.backward")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .frame(height: 75)
                        .background(.white.opacity(0.05), in: .circle)
                }
                .tint(.white)

                dialButton(text: "0") {
                    if pin.count < 4 { pin.append("0") }
                }

                if (lockType == .biometric || lockType == .both)
                    && isBiometricAuthAvailable
                {
                    Button {
                        self.unlockView()
                    } label: {
                        Image(systemName: "faceid")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .frame(height: 75)
                            .background(.white.opacity(0.1), in: .circle)
                    }
                    .tint(.white)
                } else {
                    Color.clear.frame(height: 75)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

        }
        .sensoryFeedback(.error, trigger: wrongPinAnimation)
        .padding()
        .environment(\.colorScheme, .dark)
        .onChange(of: pin) { _, newValue in
            if newValue.count == 4 {
                if pin != lockPin {
                    Task {
                        try? await Task.sleep(for: .seconds(0.25))
                        wrongPinAnimation.toggle()
                        withAnimation(.easeInOut) {
                            pin = ""
                        }
                    }
                } else {
                    withAnimation(
                        .snappy,
                        completionCriteria: .logicallyComplete
                    ) {
                        isUnlocked = true
                    } completion: {
                        pin = ""
                        noBiometricAccess = !isBiometricAuthAvailable
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func dialButton(text: String, action: @escaping () -> Void)
        -> some View
    {
        Button(action: action) {
            Text(text)
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .frame(height: 75)
                .background(.white.opacity(0.08), in: .circle)
        }
        .tint(.white)
        .sensoryFeedback(.impact(weight: .light), trigger: pin)
    }
}

enum LockType: String {
    case biometric = "Bio Metric Auth"
    case number = "Custom Number Lock"
    case both =
        "Bio Metric is First then a Custom Number Lock if Biometric is not available"

}

#Preview {
    ContentView()
}
