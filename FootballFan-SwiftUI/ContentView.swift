//
//  ContentView.swift
//  FootballFan-SwiftUI
//
//  Created by Fabian Magrini on 2/1/20.
//  Copyright © 2020 Fabian Magrini. All rights reserved.
//

import SwiftUI

/*
struct Response: Codable {
    var results: [Result]
}*/

struct Post: Codable {
    var id: String
    var link: String
    var v: Int
    var createdAt: String
    var feed: String
    var rank: Int
    var title : String
    var updatedAt: String
    var votes: Int
    var status: String
    var age: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case link
        case v = "__v"
        case createdAt = "created_at"
        case feed, rank, title
        case updatedAt = "updated_at"
        case votes, status, age
    }
}

struct ContentView: View {
    @State private var posts = [Post]()
    
    var body: some View {
        List(posts, id: \.id) { item in
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(item.feed)
            }
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        guard let url = URL(string: "https://afternoon-gorge-60512.herokuapp.com/api/posts") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Post].self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.posts = decodedResponse
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
