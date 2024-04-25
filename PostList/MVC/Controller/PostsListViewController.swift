//
//  PostsListViewController.swift
//  PostList
//
//  Created by Samreen kaur on 25/04/24.
//

import UIKit

class PostsListViewController: UIViewController 
{
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //MARK: Variables
    private var posts: [Post] = []
    private var currentPage = 1
    private let pageSize = 10
    private var isLoading = false
    
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        return control
    }()
    
    //MARK: Init Functions
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        setup()
    }
    
    //MARK: Private Functions
    private func setup()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = self.refreshControl

        showFooterLoader(true)
        fetchPosts()
    }
    
    @objc func refreshControlAction()
    {
        refreshControl.endRefreshing()
        
        currentPage = 1
        posts = []
        tableView.reloadData()
        
        showFooterLoader(true)
        fetchPosts()
    }
    
    private func showFooterLoader(_ show: Bool)
    {
        activityIndicatorView.isHidden = !show
        show ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
    }
    
    private func fetchPosts() 
    {
        isLoading = true
        
        if let url = URL(string: Constants.baseURL + "posts?_page=\(currentPage)&_limit=\(pageSize)")
        {
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                guard let data = data else { return }
                
                do
                {
                    let fetchedPosts = try JSONDecoder().decode([Post].self, from: data)
                    
                    DispatchQueue.main.async
                    {
                        if fetchedPosts.isEmpty {
                            // Stop pagination if the fetched list is empty
                            // You can also show a message indicating the end of the list to the user
                            self.showFooterLoader(false)
                            return
                        }
                        
                        if self.currentPage == 1 
                        {
                            self.posts = fetchedPosts
                        }
                        else
                        {
                            self.posts.append(contentsOf: fetchedPosts)
                        }
                        
                        self.tableView.reloadData()
                        self.isLoading = false
                        self.refreshControl.endRefreshing()
                        self.showFooterLoader(false)
                    }
                } 
                catch
                {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }
    }
}
//MARK: UITableViewDataSource, UITableViewDelegate
extension PostsListViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.postCellIdentifier, for: indexPath) as? PostTableViewCell
        {
            cell.post = posts[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) 
    {
        if indexPath.row == posts.count - 1 
        {
            currentPage += 1
            showFooterLoader(true)
            fetchPosts()
        }
    }
}
