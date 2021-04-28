//
//  FavouriteViewController.swift
//  TestMediSage
//
//  Created by NIKHIL KISHOR PATIL on 27/04/21.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var tableViewFavourite: UITableView!
    fileprivate var listModel : [PostModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favourites"
        self.setUpComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Singleton.sharedInstance.titleSingleton = Array(Set(Singleton.sharedInstance.titleSingleton))
        self.tableViewFavourite?.reloadData()
    }
    
    fileprivate func setUpComponent() {
        self.tableViewFavourite?.tableFooterView = UIView()
        let postTVC = UINib(nibName: "PostDetailTabTVC", bundle: nil)
        self.tableViewFavourite?.register(postTVC, forCellReuseIdentifier: "PostDetailTabTVC")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FavouriteViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.sharedInstance.titleSingleton.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellMain = UITableViewCell()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTabTVC") as? PostDetailTabTVC
        else{
            return UITableViewCell()
        }
        let data = Singleton.sharedInstance.titleSingleton[indexPath.row]
        let body = Singleton.sharedInstance.bodySingleton[indexPath.row]
        cell.lblTitle?.text = data
        cell.lblExplanation?.text = body
        cell.btnFavourite?.isHidden = true
        cellMain = cell
        return cellMain
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
