//
//  MissionView.swift
//  Moonshot
//
//  Created by Mihai Leonte on 04/11/2019.
//  Copyright © 2019 Mihai Leonte. All rights reserved.
//

import SwiftUI

extension Comparable
{
    func clamp<T: Comparable>(lower: T, _ upper: T) -> T {
        return min(max(self as! T, lower), upper)
    }
}

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let astronauts: [CrewMember]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    
                    GeometryReader { proxy in
                            Image(self.mission.image)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect( (proxy.frame(in: .global).minY / 88).clamp(lower: 0.8, 1) )
                                .blur(radius: (proxy.frame(in: .global).minY - 104).clamp(lower: 0, 10) )
                                .onTapGesture {
                                    print("Global minY: \(proxy.frame(in: .global).minY)")
                                }
                                
                    }
                    .frame(maxWidth: geometry.size.width * 0.85, maxHeight: geometry.size.height * 0.85)
                    .padding(.top)
                    //.background(Color.blue)

                    
                    Text(self.mission.formattedLaunchDate).font(.caption)
                    
                    Text(self.mission.description)
                        .padding()
                    
                    Spacer(minLength: 25)
                    
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                            
                            
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }.padding(.horizontal)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        
        self.astronauts = matches
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronatus.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
