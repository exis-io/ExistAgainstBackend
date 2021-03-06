//
//  main.swift
//  FabAgainstBackend
//
//  Created by Mickey Barboi on 9/29/15.
//  Copyright © 2015 paradrop. All rights reserved.
//

import Foundation
import Riffle

// a silly little hack until I get the prefixes in place
let ID = "pd.demo.cardsagainst"

let ROOM_CAP = 6
let HAND_SIZE = 6
let PICK_TIME = 15.0
let CHOOSE_TIME = 8.0
let SCORE_TIME = 3.0
let EMPTY_TIME = 1.0
let MIN_PLAYERS = 2


class Session: RiffleSession {
    var rooms: [Room] = []
    
    var pg13 = Deck(questionPath: "q13", answerPath: "a13")
    var pg21 = Deck(questionPath: "q21", answerPath: "a21")
    
    override func onJoin() {
        print("Session joined")
        register("pd.demo.cardsagainst/play", getRoom)
    }
    
    func getRoom(player: String) -> AnyObject {
        let emptyRooms = rooms.filter { $0.players.count < ROOM_CAP }
        var room: Room
        
        if emptyRooms.count == 0 {
            room = Room(session: self, deck: pg13)
            rooms.append(room)
        } else {
            room = emptyRooms[Int(arc4random_uniform(UInt32(emptyRooms.count)))]
        }
        
        if let x = room.addPlayer(player) {
            return x
        }
        
        // This is temporary-- have to catch errors thrown on wrong numbers of args and call errors accordingly
        return [false, false, false, false]
    }
}

setFabric("ws://ubuntu@ec2-52-26-83-61.us-west-2.compute.amazonaws.com:8000/ws")
Session(domain: "pd.demo.cardsagainst").connect()
NSRunLoop.currentRunLoop().run()
