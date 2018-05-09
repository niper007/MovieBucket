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
    
    //var movieTitle:UILabel!
    
    @IBOutlet weak var moviePoster: UIImageView!

    
    var addedMovies = [String]()
    let API_ADDRESS:String = "https://api.themoviedb.org/3/movie/550?api_key="
    var movies = [Movies.Content]()
    var guideLabel:UILabel!
    var popularButton: UIButton!
    var goodGradeButton: UIButton!
    var oldMovieButton:UIButton!
    
    @IBOutlet weak var movieInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getData(popularButton)
         self.becomeFirstResponder() // To get shake gesture
 
}
    
    func setupView(){
        self.view.backgroundColor = UIColor.black
        guideLabel = UILabel()
        
        guideLabel.textAlignment = .center
        guideLabel.font = UIFont(name: guideLabel.font.fontName, size:30)
        guideLabel.textColor = .white
        guideLabel.numberOfLines = 0
        self.view.addSubview(guideLabel)
        
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guideLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        guideLabel.text = "Shake the phone\r\nFor a movie suggestion"
        
        popularButton = UIButton()
        popularButton.backgroundColor = .green
        popularButton.setTitleColor(.black, for: .normal)
        popularButton.setTitle("Popular Movies",for: .normal)
        popularButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        popularButton.tag = discoverType.popular.rawValue
        popularButton.addTarget(self, action: #selector(getData(_:)), for: .touchUpInside)
        self.view.addSubview(popularButton)
        
        goodGradeButton = UIButton()
        goodGradeButton.backgroundColor = .gray
        goodGradeButton.setTitleColor(.black, for: .normal)
        goodGradeButton.setTitle("Top rated Movies",for: .normal)
        goodGradeButton.addTarget(self, action: #selector(getData(_:)), for: .touchUpInside)
        goodGradeButton.tag = discoverType.rating.rawValue
        goodGradeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(goodGradeButton)
        
        oldMovieButton = UIButton()
        oldMovieButton.backgroundColor = .gray
        oldMovieButton.setTitleColor(.black, for: .normal)
        oldMovieButton.setTitle("Movies before 2000",for: .normal)
        oldMovieButton.addTarget(self, action: #selector(getData(_:)), for: .touchUpInside)
        oldMovieButton.tag = discoverType.old.rawValue
        oldMovieButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(oldMovieButton)
        
        popularButton.translatesAutoresizingMaskIntoConstraints = false
        popularButton.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 5).isActive = true
        popularButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popularButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
     
        popularButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true
        
        goodGradeButton.translatesAutoresizingMaskIntoConstraints = false
        goodGradeButton.topAnchor.constraint(equalTo: popularButton.bottomAnchor, constant: 10).isActive = true
        goodGradeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        goodGradeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        goodGradeButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true
        
        oldMovieButton.translatesAutoresizingMaskIntoConstraints = false
        oldMovieButton.topAnchor.constraint(equalTo: goodGradeButton.bottomAnchor, constant: 10).isActive = true
        oldMovieButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        oldMovieButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        oldMovieButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true
    }

    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if movies.count > 0 {
                let randomMovie = arc4random_uniform(UInt32(movies.count))
                hideElements()
                moviePoster.addImageFromURL(urlString: "https://image.tmdb.org/t/p/w500/\(movies[Int(randomMovie)].poster_path)")
            }
        }
    }
    
    func hideElements(){
        guideLabel.isHidden = true
        popularButton.isHidden = true
        goodGradeButton.isHidden = true
        oldMovieButton.isHidden = true
        guideLabel.removeFromSuperview()
        popularButton.removeFromSuperview()
        goodGradeButton.removeFromSuperview()
        oldMovieButton.removeFromSuperview()
    }
    
    @objc func getData(_ sender : UIButton){
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
        // Do any additional setup after loading the view, typically from a nib.
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override var prefersStatusBarHidden: Bool {
        return true
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

