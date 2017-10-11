import UIKit
import Firebase

class NewMessageViewController: UITableViewController {

    var cellID = "CellID"
    var ref = Database.database().reference()
    var accounts = [Account]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountCell.self, forCellReuseIdentifier: cellID)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelMessage))
        
        fetchUser()
    }
  
    @objc func cancelMessage() {
        dismiss(animated: true, completion: nil)
    }
    
    // Append users from database into model
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user signed in")
            return
        }
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let account = Account(dictionary)
                account.id = snapshot.key
                if account.id != uid {
                    self.accounts.append(account)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
}

// TableView datasource and delegate
extension NewMessageViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AccountCell
        let account = accounts[indexPath.row]
        cell.textLabel?.text = accounts[indexPath.row].name
        cell.detailTextLabel?.text = accounts[indexPath.row].email
        
        if let profileImageURL = account.profileImageURL {
            cell.profileImageView.loadImageUsingCacheWithURLString(URLString: profileImageURL)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let account = accounts[indexPath.row]
        let chatController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.account = account
        navigationController?.pushViewController(chatController, animated: true)
        return indexPath
    }
}
