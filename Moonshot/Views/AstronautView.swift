//
//  AstronautView.swift
//  Moonshot
//
//  Created by Mihai Leonte on 04/11/2019.
//  Copyright © 2019 Mihai Leonte. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    
    // Challenge #2: Modify AstronautView to show all the missions this astronaut flew on.
    let missions: [CrewMember]
    struct CrewMember {
        let role: String
        let mission: Mission
    }
    
    init(astronaut: Astronaut) {
        self.astronaut = astronaut
        let missions: [Mission] = Bundle.main.decode("missions.json")
        var matches = [CrewMember]()
        
        for mission in missions {
            for member in mission.crew {
                if member.name == astronaut.id {
                    matches.append(CrewMember(role: member.role, mission: mission))
                }
            }
        }
        
        self.missions = matches
    }
    // +END Challenge #2:
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    
                    Spacer()
                    
                    HStack {
                        Text("Missions:").fontWeight(.heavy)
                        Spacer()
                    }.padding(.leading)
                    
                    List {
                        ForEach(self.missions, id:\.role) { crew in
                            HStack {
                                Image(crew.mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                                
                                VStack(alignment: .leading) {
                                    Text(crew.mission.displayName)
                                        .font(.headline)
                                    Text(crew.role)
                                }
                            }
                        }
                    }
                }
            }
            
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
