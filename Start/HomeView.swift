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
    
    // MARK: -  body
    var body: some View {
        
        // MARK: - NavigationStack
        NavigationStack (path: $path){

                // MARK: - banner
                   BannerText(text:"Welcome aboard Buddy..", leftColor: .red, rightColor: .blue, textColor: .white, mySize: 40)
                Spacer()

                VStack {
                    Text("💡 Maxime du codeur :")
                        .font(.headline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(10)
                    Text("« En essayant continuellement, on finit par réussir. Donc : plus ça rate, plus on a de chances que ça marche. »")
                        .font(.footnote)
                        .italic()
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }//VStack
                Spacer()
                
                Button {
                    path.append(Destination.navigation(id: UUID()))
                } label: {
                    Image("agecano")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding( 40)
                        .opacity(showContent ? 1 : 0)
                }
                Spacer()
            
                Image("egypt")
                .resizable()
                .scaledToFit()
                .frame(width:600)
                .scaleEffect(showContent ? 1 : 0.8)
                .opacity(showContent ? 1 : 0)
                .animation(.spring(response: 0.2, dampingFraction: 0.1), value: showContent)
                .padding(30)
            
                Text("Made with ❤️ in Crottet City")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut(duration: 12), value: showContent)
          //  }  //vstack
            .padding()
            
            // MARK: - onAppear
            .onAppear {
                showContent = true
            }
            
            // MARK: - navigationDestination
            .navigationDestination(for: Destination.self) { destination in
                destinationView(for: destination, path: $path, allPoints: allPoints)
            }//.navigationDestination
            
            // MARK: - bottom button
            HStack(spacing: 30){
                Spacer()
                ButtonNav(title: "Navigation->", destination: .navigation(id: UUID()), path: $path,tint: .red, framsiz: 200)
                    .padding(.horizontal, 20)
            }    // Hstack
        }   // navigationstack
        
        // MARK: - navigationBar
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.light)
    }  // body
} //View
