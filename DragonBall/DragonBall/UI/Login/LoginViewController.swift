//
//  ViewController.swift
//  DragonBall
//
//  Created by Gabriel Castro on 18/10/23.
//

import UIKit

// MARK: - View Protocol -
protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? { get set }
    var heroesViewModel: HeroesViewControllerDelegate { get }
    func onLoginPressed(email: String?, password: String?)
}

// MARK: - View State -
enum LoginViewState {
    case loading(_ isLoading: Bool)
    case showErrorEmail(_ error: String?)
    case showErrorPassword(_ error: String?)
    case navigateToNext
}

class LoginViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailFieldError: UITextField!
    @IBOutlet weak var passwordFieldError: UITextField!
    @IBOutlet weak var loadingView: UITextField!
    
    // MARK: - IBAction -
    @IBAction func onLoginPressed() {
    // Obtener el email y password introducidos por el usuario
    // y enviarlos al servicio del API de Login
    viewModel?.onLoginPressed(
        email: emailField.text,
        password: passwordField.text
    )
}

// MARK: - Public Properties -
var viewModel: LoginViewControllerDelegate?

private enum FieldType: Int {
    case email = 0
    case password
}

// MARK: - Lifecycle -
override func viewDidLoad() {
    self.navigationController?.isNavigationBarHidden = true
    super.viewDidLoad()
    initViews()
    setObservers()
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "LOGIN_TO_HEROES",
          let heroesViewController = segue.destination as? HeroesViewController else {
        return
    }

    heroesViewController.viewModel = viewModel?.heroesViewModel
}

// MARK: - Private functions -
private func initViews() {
    emailField.delegate = self
    emailField.tag = FieldType.email.rawValue
    passwordField.delegate = self
    passwordField.tag = FieldType.password.rawValue

    view.addGestureRecognizer(
        UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
    )
}

@objc func dismissKeyboard() {
    // Ocultar el teclado al pulsar en cualquier punto de la vista
    view.endEditing(true)
}

private func setObservers() {
    viewModel?.viewState = { [weak self] state in
        DispatchQueue.main.async {
            switch state {
                case .loading(let isLoading):
                    self?.loadingView.isHidden = !isLoading

                case .showErrorEmail(let error):
                    self?.emailFieldError.text = error
                    self?.emailFieldError.isHidden = (error == nil || error?.isEmpty == true)

                case .showErrorPassword(let error):
                    self?.passwordFieldError.text = error
                    self?.passwordFieldError.isHidden = (error == nil || error?.isEmpty == true)

                case .navigateToNext:
                    self?.performSegue(withIdentifier: "LOGIN_TO_HEROES",
                                       sender: nil)
            }
        }
    }
}
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch FieldType(rawValue: textField.tag) {
            case .email:
                emailFieldError.isHidden = true

            case .password:
                passwordFieldError.isHidden = true

            default: break
        }
    }
}

    
    
    

   


