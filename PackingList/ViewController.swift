

import UIKit


enum Pages: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo
    case pageThree
    
    var name: String {
        switch self {
        case .pageZero:
            return "This is page zero"
        case .pageOne:
            return "This is page one"
        case .pageTwo:
            return "This is page two"
        case .pageThree:
            return "This is page three"
        }
    }
    
    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        case .pageTwo:
            return 2
        case .pageThree:
            return 3
        }
    }
}


class PageVC: UIViewController {
    
    //    var titleLabel: UILabel?
    
    var page: Pages
    let sliderView = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
    
    init(with page: Pages) {
        self.page = page
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.imageView.image = UIImage(named: "ic_onboarding_\(page.index)")
        self.view.addSubview(sliderView)
        setConstraint()
    }
    
    
    func setConstraint()  {
        let leading =  sliderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailing =  sliderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let top = sliderView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let bottom = sliderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        NSLayoutConstraint.activate([leading,trailing,top,bottom])
    }
    
    
    
}



class ViewController: UIViewController {
    
    //MARK:- IB outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    //MARK:- further class variables
    
    var slider: HorizontalItemList!
    var menuIsOpen = false
    var items: [Int] = [5, 6, 7]
    
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    
    
    //MARK:- class methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSlider()
        self.tableView?.rowHeight = 54.0
    }
    
    @IBAction func toggleMenu(_ sender: AnyObject) {
        menuIsOpen = !menuIsOpen
        titleLabel.text = menuIsOpen ? "Select Item " : "Packing List"
        menuHeightConstraint.constant  = menuIsOpen ? 200 : 80
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.view.layoutIfNeeded()
        })
        
    }
    
    
    
    
    func showItem(_ index: Int) {
        let imageView = makeImageView(index: index)
        
        view.addSubview(imageView)
        
        let conx =  imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let conBottom =  imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: imageView.frame.size.height)
        let conWidth = imageView.widthAnchor.constraint(equalTo:view.widthAnchor,multiplier: 0.3 ,constant: 50)
        let conHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        //
        NSLayoutConstraint.activate([conx,conBottom,conWidth,conHeight])
        //
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.8, animations: {
            conBottom.constant = -imageView.frame.size.height * 2
            conWidth.constant = 0
            self.view.layoutIfNeeded()
        }
        )
    }
    
    
    func transitionCloseMenu() {
        delay(seconds: 0.35, completion: {
            self.toggleMenu(self)
        })
    }
}
let itemTitles = ["Icecream money", "Great weather", "Beach ball", "Swim suit for him", "Swim suit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops"]

// MARK:- View Controller

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func makeImageView(index: Int) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "summericons_100px_0\(index).png"))
        imageView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func makeSlider() {
        slider = HorizontalItemList(inView: view)
        slider.didSelectItem = {index in
            self.items.append(index)
            self.tableView.reloadData()
            self.transitionCloseMenu()
        }
        self.titleLabel.superview?.addSubview(slider)
    }
    
    
    
    // MARK: Table View methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.accessoryType = .none
        cell.textLabel?.text = itemTitles[items[indexPath.row]]
        cell.imageView?.image = UIImage(named: "summericons_100px_0\(items[indexPath.row]).png")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItem(items[indexPath.row])
    }
    
}


class SplashViewController: UIViewController {
    //Page control
    private var pageController: UIPageViewController?
    private var pages: [Pages] = Pages.allCases
    private var currentIndex: Int = 0
    
    private func setupPageController() {
        
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .brown
        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChildViewController(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        let initialVC = PageVC(with: pages[0])
        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        self.pageController?.didMove(toParentViewController: self)
        
    }
    override func viewDidLoad() {
        //GCD
        let firstQueue = DispatchQueue(label: "queue1",qos: .userInitiated)
        let secondQueue = DispatchQueue(label: "queue2",qos: .userInitiated)
        firstQueue.async {
            for i in 1..<10 {
                print(i)
                
            }
        }
        //
        secondQueue.async {
            for i in 11..<20 {
                print(i)
                
            }
        }
        //
        setupPageController()
    }
}


extension SplashViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? PageVC else {
            return nil
        }
        
        var index = currentVC.page.index
        
        if index == 0 {
            return nil
        }
        
        index -= 1
        
        let vc: PageVC = PageVC(with: pages[index])
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? PageVC else {
            return nil
        }
        
        var index = currentVC.page.index
        
        if index >= self.pages.count - 1 {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                let story = UIStoryboard(name: "Main", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "Content")
                
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            })
            return nil
        }
        
        index += 1
        
        let vc: PageVC = PageVC(with: pages[index])
        
        return vc
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
    
    func hideContentController(content: UIViewController) {
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
}
