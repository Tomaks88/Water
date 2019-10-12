//
//  ViewController.swift
//  Water
//
//  Created by Максим Томилов on 09/10/2019.
//  Copyright © 2019 Tomily. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var counter_water: UILabel!
    private let fileReader = FileSave()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        counter_water.text = "0"
        self.updadeCounter()
        
        
    }

    @IBAction func add_water(_ sender: Any) {
        let alertC = UIAlertController(title: "Добавить воду", message: "Введите значение", preferredStyle: .alert)
            alertC.addTextField {(textField) in
                textField.placeholder = "значение"
                textField.keyboardType = .decimalPad
                
            }
            let action1 = UIAlertAction(title: "Добавить", style: .default) { (action) in
                if alertC.textFields != nil{
                    let textField = alertC.textFields![0] as UITextField
                    if textField.text != nil{
                        if let value = Float(textField.text!){
                            let newData = DataWater(value: abs(value))
                            self.fileReader.addWaterData(newData: newData)
                            self.updadeCounter()
                        }else {
                            self.ErrorAlert(type: "add")
                        }
                    }else {
                        self.ErrorAlert(type: "add")
                    }
                }
            }
            let action2 = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
            }
            alertC.addAction(action1)
            alertC.addAction(action2)
            
            self.present(alertC, animated: true, completion: nil)
        }
       
    
    @IBAction func del_water(_ sender: Any) {
        let alertC = UIAlertController(title: "Удалить воду", message: "Введите значение", preferredStyle: .alert)
        alertC.addTextField {(textField) in
            textField.placeholder = "значение"
            textField.keyboardType = .decimalPad
            
        }
        let action1 = UIAlertAction(title: "Удалить", style: .default) { (action) in
            if alertC.textFields != nil{
                let textField = alertC.textFields![0] as UITextField
                if textField.text != nil{
                    if let value = Float(textField.text!){
                        let newData = DataWater(value: value < 0 ? value : -value)
                        self.fileReader.addWaterData(newData: newData)
                        self.updadeCounter()
                    }else {
                        self.ErrorAlert(type: "del")
                    }
                }else {
                    self.ErrorAlert(type: "del")
                }
            }
        }
        let action2 = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
        }
        alertC.addAction(action1)
        alertC.addAction(action2)
        
        self.present(alertC, animated: true, completion: nil)
    }
    func ErrorAlert(type: String) {
        let alertC = UIAlertController(title: "Ошибка", message: "Введите значение", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Закрыть", style: .cancel) { (action:UIAlertAction) in
            if type == "del"{
                self.del_water(self)
            }else if type == "add"{
                self.add_water(self)
            }
        }
        alertC.addAction(action1)
        self.present(alertC, animated: true, completion: nil)
    }
    
    private func updadeCounter() {
        let data = fileReader.waterData
        var result: Float = 0
        for item in data {
            result += item.value
        }
        
        self.counter_water.text = String(result)
    }
}

