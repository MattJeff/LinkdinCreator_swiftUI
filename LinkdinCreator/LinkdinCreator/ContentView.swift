//
//  ContentView.swift
//  LinkdinCreator
//
//  Created by Mathis Higuinen on 07/09/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = VideoViewModel()
    @State var youtubeURLText = ""
    @State var currentTab = "house.fill"
    @Namespace var animation

    var body: some View {
        HStack(spacing:0){
            
            VStack(spacing:20){
                ForEach(["house.fill","square.and.arrow.down.fill","folder.fill.badge.plus","paperclip"],id:\.self) { image in
                    MenuButton(image: image)
                }
              
            }
            .padding(.top,60)
            .frame(width:85)
            .frame(maxHeight:.infinity,alignment: .top)
            .background(
                
                ZStack{
                    Color.white
                        .padding(.trailing,30)
                    Color.white
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.03), radius: 5,x:5,y:0)
                }
            
            
            )
            
            VStack(spacing:15) {
                HStack{
                  
                    TextField("Entrez un URL", text: $youtubeURLText)
                        .textFieldStyle(.plain)
                        .padding(.leading)
                        .font(.title)
                        .frame(height:50)
                        .background(.white)
                        .cornerRadius(15)
                    
                    Button {
                        viewModel.fetchVideoData(from: youtubeURLText)
                    } label: {
                        Text("Générez")
                            .font(.title)
                            .bold()
                            .padding(14)
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .disabled(youtubeURLText.isEmpty || viewModel.isFetching)
                }
                .padding(32)
                .padding(.top)
                
                if let data = viewModel.videoData {
                    Text(data.linkedinPost)
                        .padding()
                        .background(.white)
                }
                
                if let error = viewModel.error {
                    Text(error).foregroundColor(.red)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
           /* VStack(spacing: 20) {
                TextField("Entrez l'URL YouTube ici", text: $youtubeURLText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    viewModel.fetchVideoData(from: youtubeURLText)
                }) {
                    Text("Générer le post LinkedIn")
                }
                .disabled(youtubeURLText.isEmpty || viewModel.isFetching)
                .padding()
                
                if let data = viewModel.videoData {
                    TextEditor(text: .constant(data.linkedinPost))
                        .padding()
                }
                
                if let error = viewModel.error {
                    Text(error).foregroundColor(.red)
                }
            }*/
        }
        .frame(width: getRect().width / 1.75, height: getRect().height - 130, alignment: .leading)
        .buttonStyle(.borderless)
      
    }
    
    @ViewBuilder
    func MenuButton(image:String) -> some View{
      
            HStack{
                Spacer()
                Image(systemName: image)
                    .foregroundColor(image == currentTab ? .black : .gray)
                    .font(.system(size: 34))
                    .padding(image == currentTab ? 0 : 16)
                
                HStack{
                    
                    if currentTab == image {
                        Capsule()
                            .fill(Color.black)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                            .frame(width:3,height: 40)
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring()) {
                    currentTab = image
                }
            }
    }
    
  
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View{
    func getRect()->CGRect{
        return NSScreen.main!.visibleFrame
    }
}

