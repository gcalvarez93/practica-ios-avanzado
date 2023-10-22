//
//  SplashViewController.swift
//  DragonBall
//
//  Created by Gabriel Castro on 19/10/23.
//

import UIKit

//MARK: - PROTOCOLO -
protocol SplashViewControllerDelegate {
    var viewState: ((SplashViewState) -> Void)? { get set }
    var loginViewModel: LoginViewControllerDelegate { get }
    var heroesViewModel: HeroesViewControllerDelegate { get }

    func onViewAppear()
}

enum SplashViewState{
    case loading (_ isLoading: Bool)
    case navigateToLogin
    case navigateToHeroes
}

class SplashViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: SplashViewControllerDelegate?
    
    //MARK: - Life of cycle
    override func viewDidLoad() {
            super.viewDidLoad()
            setObservers()
            viewModel?.onViewAppear()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SPLASH_TO_LOGIN":
            guard let loginViewController = segue.destination as? LoginViewController else { return }
            loginViewController.viewModel = viewModel?.loginViewModel
            
        case "SPLASH_TO_HEROES":
            guard let heroesViewController = segue.destination as? HeroesViewController else { return }
            heroesViewController.viewModel = viewModel?.heroesViewModel
            
        default:
            break
        }
    }

    private func setObservers() {
            viewModel?.viewState = { [weak self] state in
                DispatchQueue.main.async {
                    switch state {
                        case .loading(let isLoading):
                            self?.activityIndicator.isHidden = !isLoading

                        case .navigateToLogin:
                            self?.performSegue(withIdentifier: "SPLASH_TO_LOGIN", sender: nil)

                        case .navigateToHeroes:
                            self?.performSegue(withIdentifier: "SPLASH_TO_HEROES", sender: nil)
                    }
                }
            }
        }
    }
