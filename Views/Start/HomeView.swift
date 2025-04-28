////
////  HomeView.swift
////  Horizon
////
////  Created by Robert on 28/03/2025.
////
//

import SwiftUI
import MapKit
import SwiftData

struct HomeView: View {
//    let id: Int
    @Query var allPoints: [MyPoint]
    @Binding var path: NavigationPath

    @State private var showContent = false
    @Namespace private var animation
    @State private var showEgypt = false
    var body: some View {
        NavigationStack (path: $path){
            VStack(spacing: 10) {
                HeaderView()

                Text("Welcome to Next\na little piece of code to learn SwiftUI\n By :")
                    .font(.largeTitle)
                  .multilineTextAlignment(.center)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeIn(duration: 1.0), value: showContent)


                Image("egypt")
                    .resizable()
                    .scaledToFit()
                    .frame(width:600)
                    .scaleEffect(showContent ? 1 : 0.8)
                    .opacity(showContent ? 1 : 0)
                    .animation(.spring(response: 0.2, dampingFraction: 0.1), value: showContent)
                
                
                Button {
                    path.append(Destination.navigation(id: UUID()))
                } label: {
                    Image("agecano")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, 40)
                        .opacity(showContent ? 1 : 0)
                }
Spacer()
                Button("Navigation →") {
                    path.append(Destination.navigation(id: UUID()))
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
                destinationView(for: destination, path: $path, allPoints: allPoints)
            }
        }   // navigationstack
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.light)
    }  // body
} //View


//#Preview {
//    StatefulPreviewWrapper(NavigationPath()) { path in
//        HomeView(id: 1, path: path)
//    }
//}
