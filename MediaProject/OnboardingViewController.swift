//
//  OnboardingViewController.swift
//  MediaProject
//
//  Created by NAM on 2023/08/28.
//

import UIKit
import SnapKit


class FirstViewController: UIViewController {
    
    let backImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "egon")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        view.addSubview(backImageView)
        backImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
}

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
    }
    
}

class ThirdViewController: UIViewController {
    
    
    let okButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 50)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .magenta
        
        view.addSubview(okButton)
        okButton.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
        okButton.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.4)
            make.height.equalTo(30)
        }
    }
    
    @objc func okButtonClicked() {
        UserDefaults.standard.set(true, forKey: "isLaunched")
        print(UserDefaults.standard.bool(forKey: "isLaunched"))
        
//        let windwScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//        let sceneDelegate = windwScene?.delegate as? SceneDelegate
//        
//        let vc = TrendingViewController()
//        let nav = UINavigationController(rootViewController: vc)
//        
//        sceneDelegate?.window?.rootViewController = nav
//        sceneDelegate?.window?.makeKeyAndVisible()
    }
}




class OnboardingViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    var list: [UIViewController] = []
    
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list = [FirstViewController(), SecondViewController(), ThirdViewController()]
        
        view.backgroundColor = .lightGray
        delegate = self
        dataSource = self
        
        
        
        guard let first = list.first else { return }
        setViewControllers([first], direction: .forward, animated: true)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = list.firstIndex(of: viewController) else { return nil } //현재 사용자가 보고있는 VC
        
        let previousIndex = currentIndex - 1
        
        return previousIndex < 0 ? nil : list[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = list.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = currentIndex + 1
        
        return nextIndex >= list.count ? nil : list[nextIndex]
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return list.count
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        
        guard let first = viewControllers?.first, let index = list.firstIndex(of: first) else { return 0 }
        return index
    }
}

