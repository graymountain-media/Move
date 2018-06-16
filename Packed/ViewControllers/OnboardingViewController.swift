//
//  OnboardingViewController.swift
//  Packed.
//
//  Created by Jake Gray on 6/15/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

protocol OnboardingDelegate: class {
    func presentLogin()
}

class OnboardingViewController: UIPageViewController {
    
    let initialPage = 0
    
    weak var loginDelegate: OnboardingDelegate?
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "OnboardingBackground"))
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    let fillerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up or Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue without creating an account.", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.frame
        view.sendSubview(toBack: backgroundImageView)
        
        dataSource = self
        delegate = self
        
        let viewedOnboarding = UserDefaults.standard.bool(forKey: "viewedOnboarding")
        
        setupPages()
        setPageControl()
        
        if viewedOnboarding {
            setupHelpView()
        } else {
            setupNewUserView()
        }
    }
    
    private func setupPages(){
        
        for i in 1...3 {
            let page = InstructionSlideViewController()
            page.card = UIImage(named: "OnboardingSlide\(String(i))")!
            pages.append(page)
        }
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
    }
    
    private func setPageControl() {
        pageControl.frame = CGRect()
        pageControl.currentPageIndicatorTintColor = mainColor
        pageControl.pageIndicatorTintColor = .white
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        
    }
    
    private func setupNewUserView() {
        
        view.addSubview(fillerView)
        view.sendSubview(toBack: fillerView)
        view.addSubview(pageControl)
        view.addSubview(logInButton)
        view.addSubview(skipButton)
        
        skipButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor).isActive = true
        skipButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        logInButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 40).isActive = true
        logInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        logInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalTo: fillerView.bottomAnchor, constant: 15).isActive = true
        pageControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fillerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        fillerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        fillerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        fillerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        
    }
    
    private func setupHelpView() {
        
        view.addSubview(fillerView)
        view.sendSubview(toBack: fillerView)
        view.addSubview(pageControl)
        view.addSubview(closeButton)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalTo: fillerView.bottomAnchor).isActive = true
        pageControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        pageControl.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fillerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        fillerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        fillerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        fillerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    // MARK - Button Actions
    
    @objc private func signUpButtonPressed(){
        UserDefaults.standard.set(true, forKey: "viewedOnboarding")
        dismiss(animated: true) {
            self.loginDelegate?.presentLogin()
        }
        
    }
    
    @objc private func dismissView(){
        UserDefaults.standard.set(true, forKey: "viewedOnboarding")
        dismiss(animated: true, completion: nil)
    }

}

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex == 0 {
                // wrap to last page in array
                return nil
            } else {
                // go to previous page in array
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                // wrap to first page in array
                return nil
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.index(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
}
