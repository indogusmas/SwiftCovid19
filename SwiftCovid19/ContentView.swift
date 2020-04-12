//
//  ContentView.swift
//  SwiftCovid19
//
//  Created by indo gusmas arung samudra on 06/04/20.
//  Copyright © 2020 indo gusmas arung samudra. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @ObservedObject var data = getData()
    var body: some View{
        VStack{
            HStack(alignment:.top){
                VStack(alignment: .leading, spacing: 15){
                    Text("Date")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Covid -19 Cases")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("361,635")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action:{
                    
                }){
                    Image(systemName: "arrow.clockwise")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 18)
            .padding()
                .padding(.bottom, 80)
            .background(Color.red)
            HStack(alignment: .center, spacing: 15 ){
                VStack(alignment: .leading, spacing: 15){
                    Text("Deaths")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black.opacity(0.5))
                    Text("cjnsodc")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }.padding(.horizontal)
                    .padding(.vertical,  30)
                    .background(Color.white)
                .cornerRadius(12)
                VStack(alignment: .leading, spacing: 15){
                    Text("Recovered")
                        .foregroundColor(Color.black.opacity(0.5))
                    Text("3655")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }.padding(.horizontal)
                    .padding(.vertical,  30)
                    .background(Color.white)
                .cornerRadius(12)
            }
            .offset(y: -70)
            .padding(.bottom, -60)
            .zIndex(25)
            VStack(alignment: .leading, spacing: 15){
                Text("Active Case")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.black.opacity(0.5))
                                  
                Text("3655")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
            }.padding(.horizontal)
                .padding(.vertical,30)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.top, 15)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 15){
                    ForEach(1...15,id:\.self){i in
                        cellView()
                    }
                }
            }
            .padding(.top, 15)
        }.edgesIgnoringSafeArea(.top)
            .background(Color.black.opacity(0.1).edgesIgnoringSafeArea(.all))
    }
}

struct cellView: View {
    var body: some View{
        VStack(alignment: .leading, spacing: 15){
            Text("USA")
                .fontWeight(.bold)
            
            HStack(spacing: 15){
                VStack(alignment: .leading, spacing: 15){
                    Text("Active Cases")
                        .font(.title)
                    Text("221,333")
                        .font(.title)
                }
                VStack(){
                VStack(alignment: .leading, spacing: 15){
                    Text("Deaths")
                        .font(.title)
                    Text("221")
                        .foregroundColor(.red)
                }
                Divider()
                VStack(alignment: .leading, spacing: 15){
                    Text("Recovered")
                        .font(.title)
                    Text("221")
                        .foregroundColor(.green)
                }
                Divider()
                VStack(alignment: .leading, spacing: 15){
                    Text("Criitcal")
                        .font(.title)
                    Text("221")
                        .foregroundColor(.yellow)
                }
            }
            }
        }
    .padding()
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
    .cornerRadius(20)
    }
}

struct Response: Decodable {
    var confirmed: Confirmed
    var recovered: Recovered
    var deaths: Deaths
    var activeCare: ActiveCare
}

struct Confirmed:Decodable {
    var value: Int
}
struct Recovered:Decodable {
    var value : Int
}

struct Deaths:Decodable {
    var value: Int
}
struct ActiveCare:Decodable{
    var value: Int
}

class getData: ObservableObject {
    @Published var data: Response!
    
    init() {
        updateData()
    }
    func updateData()  {
        let url = "https://kawalcovid19.harippe.id/api/summary"
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!){(data,_,Error) in
            
            if Error != nil{
                print((Error?.localizedDescription)!)
                return
            }
            do{
            let json = try JSONDecoder().decode(Response.self, from: data!)
            print(json)
            DispatchQueue.main.async {
                        self.data = json
                    }
            }catch let jsonError{
                print("Error", jsonError)
            }
           
        }.resume()
    }
}
