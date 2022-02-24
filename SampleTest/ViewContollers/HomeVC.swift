//
//  HomeVC.swift
//  SampleTest
//
//  Created by differenz189 on 23/02/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class HomeVC: UIViewController {
    // UI
    private var topView: UIView =  {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "Text"
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var addButton: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "circle.fill")
        btn.setImage(img, for: .normal)
        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var dataTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    
    // Parameters
    private var user: User?
    private var postData:[PostModel] = []
    private var selectedInSession: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(topView)
        self.topView.addSubview(titleLabel)
        self.topView.addSubview(addButton)
        self.addButton.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
        self.topViewConstarints()
        
        
        self.view.addSubview(dataTable)
        self.tableConstarints()
        self.dataTable.delegate = self
        self.dataTable.dataSource = self
        dataTable.register(HomeTableCell.self, forCellReuseIdentifier: "HomeTableCell")
        
        self.getFireBaseData()
        
    }

    func setUser(withUser user: User) {
        self.user = user
    }
    
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    
    private func uploadToFireBase(fileUrl: URL) {
        do {
            let ref = Database.database(url: "https://sample-test-57282-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
            
            let name = getRandom()
            let fileExtension = fileUrl.pathExtension
            let fileName = name + "\(fileExtension)"

            print(fileName)
            let storageReference = Storage.storage().reference().child(fileName)
            let currentTask = storageReference.putFile(from: fileUrl, metadata: nil, completion: {metaData,error in
                if let error = error {
                        print("Upload error: \(error.localizedDescription)")
                        return
                }
                
                storageReference.downloadURL { (url, error) in
                    ref.child("Post").childByAutoId().setValue(["name": self.user?.displayName,
                                                                "imageUrl": url?.absoluteString,
                                                                "like": 0,
                                                                "auther": self.user?.uid])
                    if let error = error {
                        print("")
                    }
                    self.getFireBaseData()
                }
            })
            
        }
    }
    
    
    func getRandom() -> String {
        let randomInt = Int.random(in: 1000..<9999)
        return "\(randomInt)."
    }
    
    private func getFireBaseData() {
        let ref = Database.database(url: "https://sample-test-57282-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        ref.child("Post").getData(completion: {error, val in
            let data = val.value as? NSDictionary
            var object = PostModel()
            self.postData = []
            for(k,v) in data ?? [:] {
                let val = v as? [String: Any]
                object.key = k as! String
                object.name = val?["name"] as? String
                object.imageUrl = val?["imageUrl"] as? String
                object.like = val?["like"] as? Int
                object.auther = val?["auther"] as? String
                
                self.postData.append(object)
                
                self.dataTable.reloadData()
            }
        })
    }
}

//MARK: - Button Click
extension HomeVC {
    @objc private func addButtonClick() {
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.getImage(fromSourceType: .camera)
        })
        
        let gallery = UIAlertAction(title: "Gallery", style: .default, handler: {action in
            self.getImage(fromSourceType: .photoLibrary)
        })
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        self.setActionSheet(Title:"Upload Image", Message:"Select your Images", actions: [camera,gallery,cancel])
    }
}

//MARK: - Constraints
extension HomeVC {
    
    func topViewConstarints() {
        
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.centerXAnchor.constraint(equalTo: self.topView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 32),
            addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor),
            addButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -12)
            
        ])
    }
    
    func tableConstarints() {
        NSLayoutConstraint.activate([
            dataTable.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 8),
            dataTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            dataTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            dataTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8)
        ])
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeTableCell
        let liked = selectedInSession.contains(where: {$0 == postData[indexPath.row].key})
        cell.configCell(withPost: postData[indexPath.row], isLiked: liked)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension HomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let url = info[.imageURL] as? URL
        self.dismiss(animated: true, completion: {    
            self.uploadToFireBase(fileUrl: url!)
        })

    }
}

extension HomeVC: HomeTableCellDelegate {
    func selected(postData: PostModel, isLiked: Bool) {
        
        if selectedInSession.contains(where: {$0 == postData.key}) {
            self.selectedInSession = self.selectedInSession.filter({$0 != postData.key})
        } else {
            self.selectedInSession.append(postData.key ?? "")
        }
        
        let ref = Database.database(url: "https://sample-test-57282-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        ref.child("Post").child("\(postData.key!)").setValue(["name": postData.name!,
                                                   "imageUrl": postData.imageUrl!,
                                                   "like": isLiked ? postData.like!+1 : postData.like!-1,
                                                   "auther": postData.auther!])
        self.getFireBaseData()
    }
}

