//
//  CreateRideViewController.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-12-17.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import UIKit
import DropDown
import DatePickerDialog

class CreateEditRideViewController: UIViewController {
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var btnChooseLevel: UIButton!
    @IBOutlet weak var btnChooseTrajet: UIButton!
    @IBOutlet weak var btnChooseStartDate: UIButton!
    @IBOutlet weak var pickerStartTime: UIDatePicker!
    @IBOutlet weak var btnChooseFinishDate: UIButton!
    @IBOutlet weak var pickerFinishTime: UIDatePicker!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnCreateRide: UIButton!
    
    let rideService = RideService()
    let levelService = LevelService()
    let trajetService = TrajetService()
    
    var ride: CreateRideViewModel = CreateRideViewModel()
    var editRideId: Int? = nil
    var editRide: RideViewModel? = nil
    
    var createMode = true
    
    var levels = [LevelViewModel]()
    var trajets = [TrajetViewModel]()
    var dropDownLevel = DropDown()
    var dropDownTrajet = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblError.text = ""
        
        if(editRideId != nil)
        {
            createMode = false
            self.btnCreateRide.setTitle("Save", for: UIControlState.normal)
            rideService.GetRideById(rideId: self.editRideId!, completionHandler: { (_ride) in
                self.editRide = _ride
                
                self.ride.Title = (self.editRide?.Title)!
                self.ride.Description = (self.editRide?.Description)!
                self.ride.LevelId = (self.editRide?.Level?.levelId)!
                self.ride.TrajetId = self.editRide?.Trajet?.trajetId
                self.ride.DateDepart = self.editRide?.DateDepart
                self.ride.DateFin = self.editRide?.DateFin
                
                self.loadData()
                self.reloadInputViews()
            })
        }
        else
        {
            ride = CreateRideViewModel()
            loadData()
        } 
    }
    
    func loadData()
    {
        levelService.GetLevelList(completionHandler: { _levels in
            self.levels = _levels
            
            self.trajetService.GetTrajetList(completionHandler: { _trajets in
                self.trajets = _trajets
                self.loadGUI()
                self.reloadInputViews()
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func loadGUI()
    {
        DropDown.startListeningToKeyboard()
        
        //Set levels dropdown
        dropDownLevel = DropDown()
        dropDownLevel.anchorView = self.btnChooseLevel
        
        var levelsString = [String]()
        
        for level in levels
        {
            levelsString.append(level.name)
        }
        
        dropDownLevel.dataSource =  levelsString
        dropDownLevel.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btnChooseLevel.setTitle(item, for: UIControlState.normal)
            self.ride.LevelId = self.levels[index].levelId
        }
        
        
        // Set trajets dropdown
        dropDownTrajet = DropDown()
        dropDownTrajet.anchorView = self.btnChooseTrajet
        
        var trajetsString = [String]()
        
        for trajet in trajets
        {
            trajetsString.append(trajet.TrajetTitle)
        }
        
        dropDownTrajet.dataSource = trajetsString
        
        dropDownTrajet.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btnChooseTrajet.setTitle(item, for: UIControlState.normal)
            self.ride.TrajetId = self.trajets[index].trajetId
        }
        
        if(!createMode)
        {
            txtTitle.text = editRide?.Title
            txtDescription.text = editRide?.Description
            
            
            var levelIndex=0
            for level in self.levels
            {
                if level.levelId == editRide?.Level?.levelId
                {
                    dropDownLevel.selectRow(at: levelIndex)
                    self.btnChooseLevel.setTitle(level.name, for: UIControlState.normal)
                    dropDownLevel.reloadAllComponents()
                    break
                }
                levelIndex = levelIndex + 1
            }
            
            if(editRide?.Trajet != nil)
            {
                var trajetIndex=0
                for trajet in self.trajets
                {
                    if trajet.trajetId == editRide?.Trajet?.trajetId
                    {
                        dropDownTrajet.selectRow(at: trajetIndex)
                        self.btnChooseTrajet.setTitle(trajet.TrajetTitle, for: UIControlState.normal)
                        dropDownTrajet.reloadAllComponents()
                        break
                    }
                    trajetIndex = trajetIndex + 1
                }
            }
            
            self.pickerStartTime.date = (self.editRide?.DateDepart)!
            self.pickerFinishTime.date = (self.editRide?.DateFin)!
        }
    }
    
    func validateRide() -> Bool
    {
        var isValid = false
        var errStrings = [String]()
        
        self.ride.Title = txtTitle.text!
        self.ride.Description = txtDescription.text!
        
        self.ride.DateDepart = pickerStartTime.date
        self.ride.DateFin = pickerFinishTime.date
        
        // Title validation
        if((self.ride.Title.characters.count) <= 0)
        {
            errStrings.append("Title is required.")
        }
        
        //Level validation
        if ((self.ride.LevelId) <= 0)
        {
            errStrings.append("Level is required.")
        }
        
        //Date depart validation
        if(self.ride.DateDepart == nil)
        {
            errStrings.append("Date depart is required.")
        }
        else
        {
            self.ride.DateDepart = DateHelpers.setTimeOfDate(date: (self.ride.DateDepart!), newDate: pickerStartTime.date)
        }
        
        //Date fin validation
        if(self.ride.DateFin == nil)
        {
            errStrings.append("Date fin is required.")
        }
        else if(self.ride.DateDepart != nil)
        {
            self.ride.DateFin = DateHelpers.setTimeOfDate(date: (self.ride.DateFin!), newDate: pickerFinishTime.date)

            if(self.ride.DateDepart! >= self.ride.DateFin!)
            {
                errStrings.append("Date depart must be earlier than date fin.")
            }
        }
        
        //Display errors
        self.lblError.text = errStrings.flatMap({$0}).joined(separator: "\n")
        
        if(errStrings.count == 0)
        {
            isValid = true
        }
        
        return isValid
    }
    
    func create()
    {
        self.rideService.CreateRude(ride: self.ride, completionHandler: { isCreated in
            
            if(isCreated)
            {
                let alertController = UIAlertController(title: "Success", message: "Ride successfully created!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                
                //redirect to ride list
                self.performSegue(withIdentifier: "SearchRideViewSegue", sender: self)
            }
            else
            {
                let alertController = UIAlertController(title: "Error", message: "An error occured while creating the ride.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    func edit()
    {
        self.rideService.EditRide(rideId: self.editRideId!, ride: self.ride, completionHandler: { isCreated in
            
            if(isCreated)
            {
                let alertController = UIAlertController(title: "Success", message: "Ride successfully saved!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                
                //redirect to ride list
                self.performSegue(withIdentifier: "SearchRideSegue", sender: self)
            }
            else
            {
                let alertController = UIAlertController(title: "Error", message: "An error occured while creating the ride.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })

    }

    
    @IBAction func btnChooseLevel_Touch(_ sender: Any) {
        dropDownLevel.show()
    }
    
    @IBAction func btnChooseTrajet_Touch(_ sender: Any) {
        dropDownTrajet.show()
    }

    @IBAction func btnCreateRide_Touch(_ sender: Any) {
        if(validateRide())
        {
            if(createMode)
            {
                self.create()
            }
            else
            {
                self.edit()
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
