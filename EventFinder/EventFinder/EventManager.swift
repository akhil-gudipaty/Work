//
//  EventManager.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/27/22.
//

import Foundation
import Firebase

class EventManager : ObservableObject {
    @Published var users = [User]()
    @Published var auth = false
    @Published var currentUser: User?
    @Published var events = [Event]()
    @Published var admits = [String:String]()
    @Published var currentEvent: Event?
    @Published var host : User = User.standard_host
    var hostEvents: [Event]?{
        if (self.currentUser != nil){
            var e = [Event]()
            for event in events{
                print(event)
                if event.host_username == self.currentUser!.username{
                    print(self.currentUser!.id)
                    e.append(event)
                }
            }
            return e
        }
        return nil
    }
    
    
    func addAdmit(event: Event){
        print("enter")
        admits[event.name] = event.id
    }
    
    func getEvents(){
        let db = Firestore.firestore()
        db.collection("event").getDocuments{ snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                        self.events = snapshot.documents.map{i in
                            return Event(id: i.documentID,
                                         name: i["name"] as? String ?? "",                   host_username: i["host_username"] as? String ?? "",
                                        date: i["date"] as? String ?? "",
                                        time: i["time"] as? String ?? "",
                                        description: i["description"] as? String ?? "",
                                         address: i["address"] as? String ?? "",
                                        rating: i["rating"] as? Float ?? 0,
                                        numRating: i["numRating"] as? Int ?? 0,
                                        population: i["population"] as? Int ?? 0,
                                        event_image: i["event_image"] as? String ?? "")
                        }
                    }
                    }
                }
        }
    
    func addEvent(event: Event){
        let db = Firestore.firestore()
        
        db.collection("event").addDocument(data: ["name": event.name, "address":event.address, "date": event.date, "description": event.description, "event_image": "standard_event", "host_username": event.host_username, "numRating":event.numRating, "numPopulation":event.population, "rating": event.rating, "time": event.time]) { error in
            
            // Check for errors
            if error == nil {

                self.getData()
            }
            else {
                // Handle the error
            }
        }
    }

    func getUser(ref:DocumentReference, completionHandler:@escaping(User)->()){
        ref.getDocument{d, error in
            if error==nil{
                if let d = d{
                    let user: User = User(id: d.documentID,
                                            name: d["name"] as? String ?? "",
                                            host: d["host"] as? Bool ?? false,
                                            username: d["username"] as? String ?? "",
                                            password: d["password"] as? String ?? "",
                                            profile_pic: d["profile_pic"] as? String ?? "",
                                            ratings : d["ratings"] as? Float ?? 0,
                                            numEvents: d["numEvents"] as? Int ?? 0
                                          )
                    completionHandler(user)
                }
            }

        }
    }
    
    func registerUser(user: User){
        let db = Firestore.firestore()
        
        db.collection("user").addDocument(data: ["name":user.name, "host": user.host, "numEvents": user.numEvents, "password": user.password, "profile_pic": user.profile_pic, "ratings":user.ratings, "username":user.username ]) { error in
            
            // Check for errors
            if error == nil {

                self.getData()
            }
            else {
                // Handle the error
            }
        }
    }
    
    func retrieveUserData(name: String){
        let db = Firestore.firestore()
        
        db.collection("user").whereField("username", isEqualTo: name).getDocuments() { snapshot, error in
            if error == nil{
                if let snapshot = snapshot {
                    for d in snapshot.documents{
                            print("Success")
                            self.host = User(id: d.documentID,
                                              name: d["name"] as? String ?? "",
                                              host: d["host"] as? Bool ?? false,
                                              username: d["username"] as? String ?? "",
                                              password: d["password"] as? String ?? "",
                                              profile_pic: d["profile_pic"] as? String ?? "",
                                              ratings : d["ratings"] as? Float ?? 0,
                                              numEvents: d["numEvents"] as? Int ?? 0
                                  )
                    }
                }
            }
            else{
                print("hi")
            }
        }
    }
    func authenticate(username: String, password: String){
        let db = Firestore.firestore()
        
        db.collection("user").whereField("username", isEqualTo: username).getDocuments() { snapshot, error in
            if error == nil{
                if let snapshot = snapshot {
                    for d in snapshot.documents{
                        if password == (d["password"] as? String ?? "") {
                            print("Success")
                            self.currentUser = User(id: d.documentID,
                                              name: d["name"] as? String ?? "",
                                              host: d["host"] as? Bool ?? false,
                                              username: d["username"] as? String ?? "",
                                              password: d["password"] as? String ?? "",
                                              profile_pic: d["profile_pic"] as? String ?? "",
                                              ratings : d["ratings"] as? Float ?? 0,
                                              numEvents: d["numEvents"] as? Int ?? 0
                                  )
                            print(self.currentUser)
                            self.auth = true
                        }


                    }
                }
            }
            else{
                print("hi")
            }
        }
    }
        
    func getData(){
        let db = Firestore.firestore()
        
        db.collection("user").getDocuments{ snapshot, error in
            if error == nil {
                // No errors
                
                if let snapshot = snapshot {
                    
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        
                        // Get all the documents and create Todos
                        self.users = snapshot.documents.map { d in
                            
                            // Create a Todo item for each document returned
                            return User(id: d.documentID,
                                        name: d["name"] as? String ?? "",
                                        host: d["host"] as? Bool ?? false,
                                        username: d["username"] as? String ?? "",
                                        password: d["password"] as? String ?? "",
                                        profile_pic: d["profile_pic"] as? String ?? "",
                                        ratings : d["ratings"] as? Float ?? 0,
                                        numEvents: d["numEvents"] as? Int ?? 0
                            )
                        }
                    }
                }
            }
            else{
                print("error in db while reading")
            }
        }
    }

}

