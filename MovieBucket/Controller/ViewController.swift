//
//  ViewController.swift
//  MovieBucket
//
//  Created by Niklas Persson on 2018-03-20.
//  Copyright © 2018 Niklas Persson. All rights reserved.
//

import UIKit

enum discoverType: Int {
    case popular = 0
    case rating = 1
    case old = 2
}

class ViewController: UIViewController {
    
    @IBOutlet weak var moviePoster: UIImageView!
    var addedMovies = [String]()
    var movies = [Movies.Content]()
    var guideLabel:UILabel!
    var popularButton: UIButton!
    var goodGradeButton: UIButton!
    var oldMovieButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getDataForSelected(button: popularButton)
        self.becomeFirstResponder()
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(){
        self.view.backgroundColor = UIColor.black
        
        guideLabel = UILabel()
        guideLabel.textAlignment = .center
        guideLabel.font = UIFont(name: guideLabel.font.fontName, size:30)
        guideLabel.textColor = .white
        guideLabel.numberOfLines = 0
        self.view.addSubview(guideLabel)
        
        popularButton = UIButton()
        popularButton.backgroundColor = .green
        popularButton.setTitleColor(.black, for: .normal)
        popularButton.setTitle("Popular",for: .normal)
        popularButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        popularButton.titleLabel?.textAlignment = .center
        popularButton.tag = discoverType.popular.rawValue
        popularButton.addTarget(self, action: #selector(getDataForSelected(button:)), for: .touchUpInside)
        self.view.addSubview(popularButton)
        
        goodGradeButton = UIButton()
        goodGradeButton.backgroundColor = .gray
        goodGradeButton.setTitleColor(.black, for: .normal)
        goodGradeButton.setTitle("Good\r\nRating",for: .normal)
        goodGradeButton.titleLabel?.numberOfLines = 0
        goodGradeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        goodGradeButton.titleLabel?.textAlignment = .center
        goodGradeButton.tag = discoverType.rating.rawValue
        goodGradeButton.addTarget(self, action: #selector(getDataForSelected(button:)), for: .touchUpInside)
        self.view.addSubview(goodGradeButton)
        
        oldMovieButton = UIButton()
        oldMovieButton.backgroundColor = .gray
        oldMovieButton.setTitleColor(.black, for: .normal)
        oldMovieButton.setTitle("Before\r\n2000",for: .normal)
        oldMovieButton.titleLabel?.numberOfLines = 0
        oldMovieButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        oldMovieButton.titleLabel?.textAlignment = .center
        oldMovieButton.tag = discoverType.old.rawValue
        oldMovieButton.addTarget(self, action: #selector(getDataForSelected(button:)), for: .touchUpInside)
        self.view.addSubview(oldMovieButton)
        
        //Autolayout
        
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guideLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        guideLabel.text = "Shake the phone\r\nFor a movie suggestion"
        
        popularButton.translatesAutoresizingMaskIntoConstraints = false
        popularButton.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 10).isActive = true
        popularButton.widthAnchor.constraint(equalToConstant: (screenWidth/3)-20 ).isActive = true
        popularButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        popularButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true
        
        goodGradeButton.translatesAutoresizingMaskIntoConstraints = false
        goodGradeButton.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 10).isActive = true
        goodGradeButton.widthAnchor.constraint(equalToConstant: (screenWidth/3)-20 ).isActive = true
        goodGradeButton.leadingAnchor.constraint(equalTo: popularButton.trailingAnchor, constant: 5).isActive = true
        goodGradeButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true
        
        oldMovieButton.translatesAutoresizingMaskIntoConstraints = false
        oldMovieButton.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 10).isActive = true
        oldMovieButton.leadingAnchor.constraint(equalTo: goodGradeButton.trailingAnchor, constant: 5).isActive = true
        oldMovieButton.widthAnchor.constraint(equalToConstant: (screenWidth/3)-15 ).isActive = true
        oldMovieButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true
    }

    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if movies.count > 0 {
                let randomMovie = arc4random_uniform(UInt32(movies.count))
                hideElements(true)
                moviePoster.addImageFromURL(urlString: "https://image.tmdb.org/t/p/w500/\(movies[Int(randomMovie)].poster_path)")
            }
        }
    }
    
    func hideElements(_ status:Bool){
        guideLabel.isHidden = status
        popularButton.isHidden = status
        goodGradeButton.isHidden = status
        oldMovieButton.isHidden = status
    }
    
    @objc func getDataForSelected(button sender : UIButton){
        let selectedQuery = getQueryForSelected(button:sender)
        
        guard let url = URL(string: selectedQuery) else {return}
        URLSession.shared.dataTask(with:url) { (data, response, err)in
            guard let data = data else { return }
            
            do{
                let decoder = JSONDecoder()
                let movies = try decoder.decode(Movies.self, from: data)
                self.movies = movies.results
                
            } catch let jsonErr {
                print("Error serilise stuff", jsonErr)
            }
            }.resume()
    }
    
    func getQueryForSelected(button sender : UIButton)->String{
        var selectedQuery = ""
        switch sender.tag {
            case discoverType.popular.rawValue:
                selectedQuery = POPULAR_MOVIES
                sender.backgroundColor = .green
                goodGradeButton.backgroundColor = .gray
                oldMovieButton.backgroundColor = .gray
            case discoverType.rating.rawValue:
                selectedQuery = RATING_MOVIES
                sender.backgroundColor = .green
                popularButton.backgroundColor = .gray
                oldMovieButton.backgroundColor = .gray
            case discoverType.old.rawValue:
                selectedQuery = OLD_MOVIES
                sender.backgroundColor = .green
                popularButton.backgroundColor = .gray
                goodGradeButton.backgroundColor = .gray
            
        default:
            print("nothing")
        }
        return selectedQuery
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
}

extension UIImageView {
    func addImageFromURL(urlString: String) {
        guard let imgURL: NSURL = NSURL(string: urlString) else { return }
        let request: NSURLRequest = NSURLRequest(url: imgURL as URL)
        NSURLConnection.sendAsynchronousRequest(
            request as URLRequest, queue: OperationQueue.main,
            completionHandler: {(response: URLResponse? ,data: Data? ,error: Error? ) -> Void in
                if error == nil {
                    self.image = UIImage(data: data!)
                }
        })
    }
    
}
