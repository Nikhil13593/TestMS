//
//  PostViewController.swift
//  TestMediSage
//
//  Created by NIKHIL KISHOR PATIL on 27/04/21.
//

import UIKit
import CoreData

class PostViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableviewPost: UITableView!
    
    fileprivate var listModel : [PostModel] = []
    var postTitle: String?
    var filteredData = [PostModel]()
    fileprivate var isSearching = false
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            postTitle = "\(String(describing: post.title))"
        }
    }
    lazy var coreDataStack = CoreDataMainStack(modelName: "TestMediSage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Post"
        self.isSearching = false
        self.searchBar?.text = ""
        searchBar?.alwaysShowCancelButton()
        self.setComponents()
        self.APICall()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setComponents() {
        let btnLogOut : UIButton = UIButton.init(type: .custom)
        btnLogOut.setTitle("LogOut", for: .normal)
        btnLogOut.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        btnLogOut.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnLogOut.setTitleColor(UIColor.blue, for: .normal)
        let addButton = UIBarButtonItem(customView: btnLogOut)
        navigationItem.setRightBarButtonItems([addButton], animated: true)
        
        self.tableviewPost?.tableFooterView = UIView()
        let postTVC = UINib(nibName: "PostDetailTabTVC", bundle: nil)
        tableviewPost?.register(postTVC, forCellReuseIdentifier: "PostDetailTabTVC")
    }
    
    @objc func logOutTapped(){
        if let logInPageVc = self.storyboard?.instantiateViewController(withIdentifier: "LogInPageVC") as? LogInPageVC {
            self.hidesBottomBarWhenPushed  = true
            self.navigationController?.pushViewController(logInPageVc, animated: true)
            self.hidesBottomBarWhenPushed  = false
        }
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
//
extension PostViewController{
    
    func APICall(){
        
        let url = WebApiConstants.APIList()
        RESTfulApiServices.makeRESTApiCall(endpointURL: url, requestMethod: "GET", customCompletionHandler: getList)
    }
    
    fileprivate func getList(data : Data?, response : URLResponse?, error : Error?) -> Void {
        
        if error != nil {
            
        } else  {
            do {
                if let httpResponse = response as? HTTPURLResponse {
                    if (httpResponse.statusCode == 401 || httpResponse.statusCode == 402) {
                        return
                    }
                }
                
                let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:Any]]
                
                let context = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
                let newToDo = Post(context: context)
                
                for obj in parsedData {
                    
                    let context = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
                    let newToDo = Post(context: context)
                    let Model = PostModel()
                    
                    if let id = obj["id"] as? Int{
                        Model.id = id
                    }
                    
                    if let title = obj["title"] as? String {
                        Model.title = title
                        newToDo.title = title as NSObject
                    }
                    
                    if let body = obj["body"] as? String {
                        Model.explanation = body
                    }
                    
                    listModel.append(Model)
                    Singleton.sharedInstance.postListData.append(Model)
                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                }
                
                self.tableviewPost?.reloadData()
            }catch _ as NSError {
            }
        }
    }
    
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

extension PostViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true{
            return filteredData.count
        }else{
            return listModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellMain = UITableViewCell()
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTabTVC") as? PostDetailTabTVC else{
            return UITableViewCell()
        }
        var data = listModel[indexPath.row]
        
        if self.isSearching {
            data = self.filteredData[indexPath.row]
        } else {
            data = self.listModel[indexPath.row]
        }
        
        cell.lblTitle?.text = data.title
        cell.lblExplanation?.text = data.explanation
        cell.btnFavourite?.titleLabel?.tag = indexPath.row
        
        if data.id == indexPath.row{
            cell.btnFavourite?.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnFavourite?.isHidden = false
        }else{
            cell.btnFavourite?.isHidden = true
        }
        
        cellMain = cell
        return cellMain
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = listModel[indexPath.row]
        
        Singleton.sharedInstance.titleSingleton.append(data.title ?? "")
        Singleton.sharedInstance.bodySingleton.append(data.explanation ?? "")
        data.id = indexPath.row
        
        let cell = tableviewPost.cellForRow(at: indexPath) as? PostDetailTabTVC
        cell?.btnFavourite.isHidden = false
        cell?.btnFavourite.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.tableviewPost.reloadData()
    }
    
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.isSelected {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
    }
}

extension UISearchBar {
    func alwaysShowCancelButton() {
        for subview in self.subviews {
            for ss in subview.subviews {
                if #available(iOS 13.0, *) {
                    for s in ss.subviews {
                        self.enableCancel(with: s)
                    }
                }else {
                    self.enableCancel(with: ss)
                }
            }
        }
    }
    
    private func enableCancel(with view:UIView) {
        if NSStringFromClass(type(of: view)).contains("UINavigationButton") {
            (view as! UIButton).isEnabled = true
        }
    }
}

extension PostViewController: UITextViewDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchString = searchText.trimWhiteSpace()
        searchBar.showsCancelButton = true
        if searchText == "" {
            self.isSearching = false
            view.endEditing(true)
            self.tableviewPost?.reloadData()
            
        } else {
            
            if searchString != "", searchString.count > 0 {
                let getFilterData = listModel.filter {
                    return $0.title?.range(of: searchString, options: .caseInsensitive) != nil
                }
                self.isSearching = true
                filteredData = getFilterData
                self.tableviewPost?.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.showsCancelButton = true
        if searchBar.text == "" {
            view.endEditing(true)
            
            if searchBar.text == "" {
                self.isSearching = false
                view.endEditing(true)
                self.tableviewPost?.reloadData()
            }
        }
    }
}

extension String {
    func trimWhiteSpace() -> String {
        let string = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return string
    }
}
