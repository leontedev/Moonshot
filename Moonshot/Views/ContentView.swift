//
//  ContentView.swift
//  Moonshot
//
//  Created by Mihai Leonte on 11/3/19.
//  Copyright © 2019 Mihai Leonte. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var isDisplayingLaunchDate = true
    
    
    var body: some View {
        
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination:
                MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        
                        if self.isDisplayingLaunchDate {
                            Text(mission.formattedLaunchDate)
                        } else {
                            VStack(alignment: .leading) {
                                ForEach(mission.crew, id:\.name) { crewMember in
                                    Text(self.astronauts.filter { $0.id == crewMember.name }.first!.name)
                                        .font(.footnote)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Moonshot"), displayMode: .inline)
            .navigationBarItems(trailing: Button(isDisplayingLaunchDate ? "Crew": "Launch Date") {
                self.isDisplayingLaunchDate.toggle()
            })
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
