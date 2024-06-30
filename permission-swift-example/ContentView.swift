//
//  ContentView.swift
//  permission-swift-example
//
//  Created by Igor  on 30.06.24.
//

import SwiftUI

struct ContentView: View {
    
    @State var progress : Progress = .idle
    
    var body: some View {
        ZStack {
            Color.brown.ignoresSafeArea()
            ScanButton(
                progress: $progress,
                fontType: .largeTitle,
                weight: .thin,
                width: 150,
                tint: .yellow
            ){
                Color.indigo.overlay {
                    Text("Scanner")
                        .font(.system(size: 78))
                        .foregroundColor(.white)
                }
                .ignoresSafeArea()
                .onTapGesture {
                    progress = .finished
                    // Handle finish and then set to .idle
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { progress = .idle })
                }
            }
        }
        
    }
}

