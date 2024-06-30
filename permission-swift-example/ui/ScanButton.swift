//
//  SwiftUIView.swift
//  permission-swift-example
//
//  Created by Igor on 30.06.24.
//

import SwiftUI
import grand_access

struct ScanButton<Content: View>: View {
    
    // MARK: - State Variables
    @State private var showingAlert = false    // Indicates if the alert should be shown
    @State private var doScan = false          // Indicates if the scan view should be presented
    
    // MARK: - Config
    @Binding public var fromScanner: Progress  // Binding to the scanner progress state
    let systemName: String                     // System image name for the button
    let fontType: Font                         // Font type for the button label
    let weight: Font.Weight                    // Font weight for the button label
    let width: CGFloat?                        // Width of the button image
    let tint: Color                            // Tint color for the button label
    let scannerView: () -> Content             // Content view for the scanner
    
    // MARK: - Life Cycle
    
    public init(
        progress fromScanner: Binding<Progress>,
        systemName: String = "camera.circle",
        fontType: Font = .largeTitle,
        weight: Font.Weight = .thin,
        width: CGFloat? = nil,
        tint: Color? = nil,
        @ViewBuilder scannerView: @escaping () -> Content
    ) {
        self._fromScanner = fromScanner
        self.systemName = systemName
        self.fontType = fontType
        self.weight = weight
        self.width = width
        self.tint = tint ?? .accentColor
        self.scannerView = scannerView
    }
    
    var body: some View {
        scanButton
            .modifier(GrandAccessModifier(title: titleAlert, message: messageAlert, showingAlert: $showingAlert))
            .onChange(of: fromScanner) { _, newValue in
                handleProgressChange(newValue)
            }
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var scanButton: some View {
        Button(action: handleScan) {
            buttonLabel.foregroundColor(tint)
        }
        .fullScreenCover(isPresented: $doScan, onDismiss: handleDismiss) {
            scannerView()
        }
    }
    
    @ViewBuilder
    private var buttonLabel: some View {
        if let width = width {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: width)
                .font(.headline.weight(weight))
        } else {
            Image(systemName: systemName)
                .font(fontType.weight(weight))
        }
    }
    
    // MARK: - Private
    
    /// Handle the scan button action
    private func handleScan() {
        Task {
            if await Permission.isCameraGranted {
                doScan = true
            } else {
                showingAlert = true
            }
        }
    }
    
    /// Handle the dismissal of the scan view
    private func handleDismiss() {
        if fromScanner == .active {
            fromScanner = .idle
        }
    }
    
    
    /// Handle changes in the scanner progress
    /// - Parameter newValue: Progress state value
    private func handleProgressChange(_ newValue: Progress) {
        if newValue == .finished {
            doScan = false
        }
    }
}

// MARK: - Constants
fileprivate let titleAlert: LocalizedStringKey = "scanner_needs_access"    // Title for the alert
fileprivate let messageAlert: LocalizedStringKey = "grant_access"          // Message for the alert
