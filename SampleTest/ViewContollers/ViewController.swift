//
//  ViewController.swift
//  SampleTest
//
//  Created by differenz189 on 22/02/22.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    let btnGoogle: UIButton =  {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign In with Google", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .red
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(btnGoogle)
        self.btnGoogle.addTarget(self, action: #selector(btnGoogleClick), for: .touchUpInside)
        self.setCostraints()
        
        
        
//        self.view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
    }
    
    private func setCostraints() {
        NSLayoutConstraint.activate([
            btnGoogle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnGoogle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btnGoogle.heightAnchor.constraint(equalToConstant: 50),
            btnGoogle.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

}

//MARK: - ObJC Functions
extension ViewController {
    
    @objc private func btnGoogleClick() {
        configGoogleSignIN()
    }
}

extension ViewController {
    
    func configGoogleSignIN() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

          if let error = error {
              print(error.localizedDescription)
            return
          }

          guard let authentication = user?.authentication
          else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken ?? "",
                                                         accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                print(error.localizedDescription)
                } else {
                    let currentUser = Auth.auth().currentUser
                    let rootVC = HomeVC()
                    rootVC.setUser(withUser: currentUser!)
                    rootVC.modalPresentationStyle = .overCurrentContext
                    self.present(rootVC, animated: false)
                }
            }
        }
    }
}
