//
//  MusicListViewController.swift
//  Mindfulness
//
//  Created by Rishin Patel on 2024-04-17.
//

import UIKit

class MusicListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSongs()
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    func configureSongs() {
        songs.append(Song(name: "Perfect Beauty", relaxtionName: "Ambient Music", imageName: "mountain_cover", trackName: "Perfect Beauty"))
        songs.append(Song(name: "The Cradle of Your Soul", relaxtionName: "Ambient Music", imageName: "open_sky", trackName: "The Cradle of your soul"))
        songs.append(Song(name: "Deep Relaxation Meditation", relaxtionName: "Meditation Music", imageName: "meditation_cover", trackName: "Deep Relaxation Meditation"))
        songs.append(Song(name: "Tranquil Oasis", relaxtionName: "Meditation Music", imageName: "mountain", trackName: "Deep Meditation"))
        songs.append(Song(name: "Heaven", relaxtionName: "Ambient Music", imageName: "bridge", trackName: "Heaven"))
        songs.append(Song(name: "In The Light", relaxtionName: "Meditation Music", imageName: "moon", trackName: "In The Light"))
        songs.append(Song(name: "Serenity", relaxtionName: "Ambient Music", imageName: "serenity", trackName: "Serenity"))
        songs.append(Song(name: "Shrine Tranquilium", relaxtionName: "Peaceful Music", imageName: "shrine", trackName: "Shrine Tranquilium"))
        songs.append(Song(name: "Zen Harmony", relaxtionName: "Meditation Music", imageName: "meditation", trackName: "Tranquility"))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //configure cell
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.relaxtionName
        cell.imageView?.image = UIImage(named: song.imageName)
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //present the player
        let position = indexPath.row
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "player") as? MusicPlayerViewController else {
            return
        }
        vc.songs = songs
        vc.position = position
        present(vc,animated: true)
    }

}

