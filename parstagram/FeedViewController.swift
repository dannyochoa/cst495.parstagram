//
//  FeedViewController.swift
//  parstagram
//
//  Created by Daniel  Ochoa Aguila on 2/25/19.
//  Copyright © 2019 Daniel  Ochoa Aguila. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    let myRefreshControl = UIRefreshControl()
    
    var numberOfPost: Int!
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        myRefreshControl.addTarget(self, action: #selector(viewDidAppear), for: .valueChanged)
        tableView.refreshControl = myRefreshControl

    }
    
    func loadPosts(_ amount: Int) {
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        
        query.limit = amount
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            } else {
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
          numberOfPost = 5
//        let query = PFQuery(className:"Posts")
//        query.includeKey("author")
//        query.limit = numberOfPost
//
//        query.findObjectsInBackground{ (posts, error) in
//            if posts != nil {
//                self.posts = posts!
//                self.tableView.reloadData()
//                self.myRefreshControl.endRefreshing()
//            } else {
//
//            }
//        }
        loadPosts(numberOfPost)
    }
    
    func loadMorePosts(){
        numberOfPost = numberOfPost + 5
        loadPosts(numberOfPost)
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[(posts.count - 1) - indexPath.row]
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        
        cell.captionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoVoew.af_setImage(withURL: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 3 == posts.count {
            loadMorePosts()
        }
    }

}
