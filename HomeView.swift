////
////  HomeView.swift
////  Horizon
////
////  Created by Robert on 28/03/2025.
////
//

import SwiftUI
import MapKit

struct HomeView: View {
    let id: Int
    @Binding var path: NavigationPath

    @State private var showContent = false
    @Namespace private var animation
    @State private var showEgypt = false
    var body: some View {
        NavigationStack (path: $path){
            VStack(spacing: 10) {
                HeaderView()

                Text("Welcome to Horizon\na little piece of code to learn SwiftUI")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeIn(duration: 1.0), value: showContent)

                Image("egypt")
//                    .resizable()
//                    .scaledToFit()
                    .frame(height: 100)
                    .scaleEffect(showContent ? 1 : 0.8)
                    .opacity(showContent ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.1), value: showContent)
                
                Text("Et le désir s'accroît quand l'effet se recule\n(kakemphaton de Pierre Corneille)")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: 1.2), value: showContent)

                Image("legofriend")
                  .resizable()
                  .scaledToFit()
                    .frame(height: 250)
                    .padding(.top, 40)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut(duration: 1.2).delay(0.3), value: showContent)
Spacer()
                Button("Navigation →") {
                    path.append(Destination.navigation(id: 2))
                }
                .buttonStyle(.borderedProminent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .scaleEffect(showContent ? 1 : 0.9)
                .animation(.spring(), value: showContent)

                Spacer()

                Text("Made with ❤️ in Crottet City")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut(duration: 1), value: showContent)
            }
            .padding()
            .onAppear {
                showContent = true
            }
            .navigationDestination(for: Destination.self) { destination in
                destinationView(for: destination, path: $path)
            }
        }
        .navigationBarBackButtonHidden(true)
    }  // body
} //View


#Preview {
    StatefulPreviewWrapper(NavigationPath()) { path in
        HomeView(id: 1, path: path)
    }
}
