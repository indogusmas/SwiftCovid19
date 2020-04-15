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
            if self.data.data != nil{
                HStack(alignment:.top){
                    VStack(alignment: .leading, spacing: 15){
                        Text(getDatetime())
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text("Covid -19 Indonesia")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text(getValue(data: data.data.confirmed))
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
                        Text(getValue(data: data.data.deaths))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }.padding(.horizontal, 20)
                        .padding(.vertical,  30)
                        .background(Color.white)
                    .cornerRadius(12)
                    VStack(alignment: .leading, spacing: 15){
                        Text("Recovered")
                            .foregroundColor(Color.black.opacity(0.5))
                        Text(getValue(data: data.data.recovered))
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
                                      
                    Text(getValue(data: data.data.activeCare))
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
                        ForEach(data.provinsiList,id:\.self){i in
                            cellView()
                        }
                    }
                }
                .padding(.top, 15)
            }else{
                GeometryReader{_ in
                    VStack{
                        Indicator()
                    }
                }
            }
            
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
    var confirmed: Int = 0
    var recovered: Int = 0
    var deaths: Int = 0
    var activeCare: Int = 0
    
    private enum  ResponseKeys : String, CodingKey{
        case confirmed
        case recovered
        case deaths
        case activeCare
    }
    private enum ConfirmedKey: String, CodingKey{
        case value
    }
    private enum RecoveredKey: String, CodingKey{
        case value
    }
    private enum DeathsKey: String, CodingKey{
        case value
    }
    private enum ActiveCareKey: String, CodingKey{
        case value
    }
    
    init(from decoder: Decoder) throws {
        if let responseContainer = try? decoder.container(keyedBy: ResponseKeys.self){
            if let mainContainer = try? responseContainer.nestedContainer(keyedBy: ConfirmedKey.self, forKey: .confirmed){
                self.confirmed = try mainContainer.decode(Int.self, forKey:.value)
            }
            
            if let mainContainer = try? responseContainer.nestedContainer(keyedBy: RecoveredKey.self, forKey: .recovered){
            self.recovered = try mainContainer.decode(Int.self, forKey:.value)
                       }
            if let mainContainer = try? responseContainer.nestedContainer(keyedBy: DeathsKey.self, forKey: .deaths){
                self.deaths = try mainContainer.decode(Int.self, forKey:.value)
            }
            if let mainContainer = try? responseContainer.nestedContainer(keyedBy: ActiveCareKey.self, forKey: .activeCare){
                self.activeCare = try mainContainer.decode(Int.self, forKey:.value)
            }
            
            
            
        }
    }
}



class getData: ObservableObject {
    @Published var data : Response!
    @Published var  provinsiList: [WelcomeElement]!
    init() {
        updateData()
    }
    func updateData()  {
        let url = "https://kawalcovid19.harippe.id/api/summary"
        let urlProvinsi = "https://api.kawalcorona.com/indonesia/provinsi/"
        let session = URLSession(configuration: .default)
         let sessionProvinsi = URLSession(configuration: .default)
        
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
        
        sessionProvinsi.dataTask(with: URL(string: urlProvinsi)!){(data,_,Error) in
            
            if Error != nil{
                print((Error?.localizedDescription)!)
            }
            do{
             let json = try JSONDecoder().decode([WelcomeElement].self, from: data!)
             DispatchQueue.main.async {
                 self.provinsiList = json
             }
            print(json)
            }catch let jsonError{
                print("Json Error", jsonError)
            }
        }.resume()
        
    }
}
func getValue(data: Int) -> String {
    return String(data)
}

func getDatetime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm E, d MMM y"
    return formatter.string(from: Date())
}

struct Indicator: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
    }
}
struct WelcomeElement: Codable {
    var attributes: Attributes
}


struct Attributes: Codable {
    var fid, kodeProvi: Int
    var provinsi: String
    var kasusPosi, kasusSemb, kasusMeni: Int

    enum CodingKeys: String, CodingKey {
        case fid = "FID"
        case kodeProvi = "Kode_Provi"
        case provinsi = "Provinsi"
        case kasusPosi = "Kasus_Posi"
        case kasusSemb = "Kasus_Semb"
        case kasusMeni = "Kasus_Meni"
    }
}
