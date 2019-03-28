//
//  FirstViewController.swift
//  MyPlaces
//  Los métodos que vienen definidos en los protocolos del Delegate y DataSource, implementamos
//  el contenido unicamente para dar respuestas a la aplicación cuando esta nos hace
//  preguntas. No los llamamos nunca directamente se llaman internamente
//  Created by Grace Toa on 26/9/18.
//  Copyright © 2018 Grace Toa. All rights reserved.
//

import UIKit
import FirebaseAuth

class FirstViewController: UITableViewController {
  
    //MARK: images Background
    var images:[UIImage] = [UIImage(named: "fondo1.png")!,UIImage(named: "fondo2.png")!,UIImage(named: "fondo3.png")!,UIImage(named: "fondo4.png")!,UIImage(named: "fondo5.png")!,UIImage(named: "fondo6.png")!,UIImage(named: "fondo7.png")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
        addTabBar()
        let view = self.view as! UITableView
        view.delegate = self
        view.dataSource = self
    }
  
    //MARK: - TableView Methods
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManagerPlaces.shared.getCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceTableViewCell
        let placeCell = ManagerPlaces.shared.getItemAt(position: indexPath.item)!
        cell.backgroundImageView.image = randomImageCell()
        cell.bind(place: placeCell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        let indexPathCell = ManagerPlaces.shared.getItemAt(position: indexPath.row)
        ManagerPlaces.shared.remove(indexPathCell!)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        ManagerPlaces.shared.updateJson()
    }

    
    //MARK: Segues
    
    @IBAction func unwindAddEditPlaceDetail(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? AddEditPlaceTableViewController,
            let place = sourceViewController.place {
            
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow{
                let placeFind = ManagerPlaces.shared.getItemAt(position: selectedIndexPath.row)
                placeFind?.name = place.name
                placeFind?.descriptionP = place.descriptionP
                placeFind?.image = place.image
                placeFind?.location = place.location
                
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                ManagerPlaces.shared.updateJson()
            }
            else{
                ManagerPlaces.shared.append(place)
                ManagerPlaces.shared.updateJson()
                tableView.reloadData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlaceDetail" {
                if let dc = segue.destination as? DetailPlaceViewController{
                    let cell = sender as! PlaceTableViewCell
                    let indexPath = tableView.indexPath(for: cell )
                    let selectPlace = ManagerPlaces.shared.getItemAt(position: (indexPath?.row)!)
                    dc.place = selectPlace
                }
        }
    }
    
    //MARK: navigation Bar
    func addNavBarImage()  {
        let image = UIImage(named: "titulB.png")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
        
        let navBar = navigationController?.navigationBar
        navBar!.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        navBar?.backgroundColor = .clear
        
        navBar!.setBackgroundImage(UIImage(named: "navBar.png")!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
    }
    
    //MARK: navigation TabBar
    func addTabBar()  {
        let tabBar = tabBarController?.tabBar
        tabBar?.backgroundImage = UIImage(named: "tabBar.png")
        tabBar?.clipsToBounds = true
    }
    
    //MARK: func helper random image cell
    func randomImageCell() -> UIImage {
        let unsignedArrayCount = UInt32(images.count)
        let unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        let randomNumber = Int(unsignedRandomNumber)
        let generatedImage:AnyObject = images[randomNumber]
        return (generatedImage as? UIImage)!
    }
    
    //MARK: buttons helper
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "ShowAddEditPlace", sender: self)
    }
    
    
    @IBAction func signOutUser(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "ShowLogin", sender: self)

        } catch let signOutError as NSError {
            print ("Error signing out", signOutError)
        }
    }
    
}//end class

