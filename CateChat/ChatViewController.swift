import UIKit
import Firebase

class ChatViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {

    let ref = Database.database().reference()
    var messages = [Message]()
    
    var account: Account? {
        didSet {
            navigationItem.title = account?.name
            observeMessages()
        }
    }
    
    let cellID = "cellID"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
        collectionView?.keyboardDismissMode = .interactive
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        scrollMessages(false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autoresizingMask = .flexibleHeight
        tf.backgroundColor = UIColor.white
        tf.delegate = self
        tf.placeholder = "Enter a message..."
        return tf
    }()
    
    lazy var inputContainerView: UIView = {
        let inputContainerView = UIView()
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width  + 100, height: 50)
        inputContainerView.backgroundColor = UIColor.white
        inputContainerView.isUserInteractionEnabled = true
        
        self.inputTextField.inputAccessoryView = inputContainerView
        
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor.black
        
        
        let sendButton = UIButton(type: .system)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        sendButton.backgroundColor = UIColor.white
        sendButton.isUserInteractionEnabled = true
        
        inputContainerView.addSubview(seperatorView)
        seperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        seperatorView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperatorView.widthAnchor.constraint(equalToConstant: inputContainerView.frame.width).isActive = true

        inputContainerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor).isActive = true
        
        inputContainerView.addSubview(self.inputTextField)
        self.inputTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor).isActive = true
        
        return inputContainerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    @objc func keyboardWillShow() {
        if messages.count > 0 {
            DispatchQueue.main.async {
                self.scrollMessages(false)
            }
        }
    }
    
    func scrollMessages(_ animated: Bool) {
        let collectionViewContentHeight = collectionView?.collectionViewLayout.collectionViewContentSize.height
        self.collectionView?.scrollRectToVisible(CGRect(x: 0, y: collectionViewContentHeight! - 1, width: 1, height: 1), animated: animated)
    }
    
    @objc func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toID = account?.id else {
            print("No current user")
            return
        }
        let userMessagesReference = Database.database().reference().child("user-messages").child(uid).child(toID)
        userMessagesReference.observe(.childAdded, with: { (snapshot) in
            
            
            let messageID = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageID)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                let message = Message(dictionary)
                self.messages.append(message)
            
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.scrollMessages(true)
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    @objc func sendMessage() {
        if inputTextField.text == "" {
            return
        }
        let childRef = ref.child("messages").childByAutoId()
        let fromID = Auth.auth().currentUser!.uid
        let toID = account!.id!
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toID": toID, "fromID": fromID, "timeStamp": timeStamp] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            self.inputTextField.text = nil
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID)
            .child(toID)
            let messageID = childRef.key
            userMessagesRef.updateChildValues([messageID: 1])
            Database.database().reference().child("user-messages").child(toID).child(fromID).updateChildValues([messageID: 1])
        }
    }
    
    // Mark: CollectionView functions
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 100
        
        if let text = messages[indexPath.item].text {
            height = textViewHeight(text).height + 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    func textViewHeight(_ text: String) -> CGRect{
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row]
        
        cell.textView.text = message.text
       
        if message.fromID == Auth.auth().currentUser?.uid {
            cell.backgroundTextView.backgroundColor = UIColor(r: 29, g: 78, b: 137)
            cell.backgroundRightAnchor?.isActive = true
            cell.backgroundLeftAnchor?.isActive = false
        } else {
            cell.backgroundTextView.backgroundColor = UIColor(r: 200, g: 200, b: 200)
            cell.backgroundLeftAnchor?.isActive = true
            cell.backgroundRightAnchor?.isActive = false
        }
        cell.backgroundWidthAnchor?.constant = textViewHeight(message.text!).width + 20
    
        return cell
    }
}
