//
//  CocktailMakeViewController.swift
//  Mixon
//
//  Created by Baba Minami on 2016/11/12.
//  Copyright © 2016年 Baba Minami. All rights reserved.
//

import UIKit
import CoreBluetooth

class CocktailMakeViewController: UIViewController {

    var cocktail: Cocktail!
    var step = 0
    var totalStep = 7
    var quantity: Float = 0
    var zeroQuantity:Float = 0
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var cocktailNameLabel: UILabel!
    @IBOutlet weak var cocktailNameEnLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailNextLabel: UILabel!
    
    let uuid = "2D826528-C989-9D27-A8FA-0CBF3E5431E5"
    let serviceUUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
    let writeCharacteristicUUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
    let notifyCharacteristicUUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
    var mixon: CBPeripheral?
    var mixonService: CBService?
    var writeCharacteristic: CBCharacteristic?
    var notifyCharacteristic: CBCharacteristic?
    var centralManager: CBCentralManager?
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var mixedView: UIView!
    @IBOutlet weak var mixedNameLabel: UILabel!
    @IBOutlet weak var mixedNameEnLabel: UILabel!
    
    var calcQuantityIndex = 0
    var calcQuantitySum:Float = 0
    
    //Color Debug
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 44)
        closeButton.setTitle(String.fontAwesomeIcon(name: .timesCircle), for: .normal)
        fetchTotalStep()
        updateView()
    }
    
    func fetchTotalStep() {
        totalStep = 7
        if cocktail.quantity1 == 0 {
            totalStep = 2
        } else if cocktail.quantity2 == 0 {
            totalStep = 3
        } else if cocktail.quantity3 == 0 {
            totalStep = 4
        } else if cocktail.quantity4 == 0 {
            totalStep = 5
        }
    }
    
    func updateView() {
        guard let cocktail = cocktail else {
            return
        }
        
        stepLabel.text = "STEP \(step)/\(totalStep)"
        cocktailNameLabel.text = cocktail.name
        cocktailNameEnLabel.text = cocktail.name
        mixedNameLabel.text = cocktail.name
        mixedNameEnLabel.text = cocktail.name
        
        nextButton.isHidden = (step > 2)
        nextLabel.isHidden = (step > 2)
        quantityLabel.isHidden = (step <= 2)
        detailNextLabel.isHidden = (step <= 2)
        imageView.isHidden = (step > 2 && step < 8)
        effectView.isHidden = (step > 2 && step < 8)
        
        contentView.isHidden = (step == 8)
        mixedView.isHidden = (step != 8)
        
        switch step {
        case 1:
            detailLabel.text = "デバイスにグラスを乗せてください"
        case 2:
            detailLabel.text = "グラスに氷を入れてください"
        case 3:
            zeroQuantity = quantity
            print("zero: \(zeroQuantity)")
            write(value: "1,193,72,149")
            detailLabel.text = cocktail.material1
            quantityLabel.text = "\(cocktail.quantity1)ml"
            view.backgroundColor = UIColor.init(red: 193/255, green: 72/255, blue: 149/255, alpha: 1.0)
        case 4:
            write(value: "1,206,75,75")
            detailLabel.text = cocktail.material2
            quantityLabel.text = "\(cocktail.quantity2)ml"
            view.backgroundColor = UIColor.init(red: 75/255, green: 182/255, blue: 205/255, alpha: 1.0)
        case 5:
            write(value: "1,75,182,206")
            detailLabel.text = cocktail.material3
            quantityLabel.text = "\(cocktail.quantity3)ml"
            view.backgroundColor = UIColor.init(red: 205/255, green: 75/255, blue: 75/255, alpha: 1.0)
        case 6:
            write(value: "1,184,206,75")
            detailLabel.text = cocktail.material4
            quantityLabel.text = "\(cocktail.quantity4)ml"
            view.backgroundColor = UIColor.init(red: 183/255, green: 205/255, blue: 75/255, alpha: 1.0)
        case 7:
            write(value: "1,141,75,205")
            detailLabel.text = cocktail.material1
            quantityLabel.text = "\(cocktail.quantity1)ml"
            view.backgroundColor = UIColor.init(red: 141/255, green: 75/255, blue: 205/255, alpha: 1.0)
        case 8:
            write(value: "1,255,255,255")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.write(value: "2")
                self.close()
            }
        default:
            break
        }
    }
    
    func next() {
        step += 1
        if totalStep < step {
            step = 8
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.updateView()
        })
    }
    
    func close() {
        print("close")
        dismiss(animated: true, completion: {
            self.centralManager?.stopScan()
            if let mixon = self.mixon {
                self.centralManager?.cancelPeripheralConnection(mixon)
                if let characteristic = self.notifyCharacteristic {
                    mixon.setNotifyValue(false, for: characteristic)
                }
            }
        })
    }

    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        //next()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        next()
    }
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        close()
    }
    
    @IBAction func didValueChangeRedSlider(_ sender: UISlider) {
        redLabel.text = Int(redSlider.value).description
    }
    
    @IBAction func didValueChangeGreenSlider(_ sender: UISlider) {
        greenLabel.text = Int(greenSlider.value).description
    }
    @IBAction func didValueChangeBlueSlider(_ sender: UISlider) {
        blueLabel.text = Int(blueSlider.value).description
    }
    @IBAction func didTapColorSendButton(_ sender: UIButton) {
        write(value: "1,\(Int(redSlider.value)),\(Int(greenSlider.value)),\(Int(blueSlider.value))")
    }
}

extension CocktailMakeViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Bluetooth Off")
        case .poweredOn:
            print("Bluetooth On")
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        case .resetting:
            print("Bluetooth Resetting")
        case .unauthorized:
            print("Bluetooth Unauthorized")
        case .unknown:
            print("Bluetooth Unknown")
        case .unsupported:
            print("Bluetooth Unsupported")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.identifier.uuidString == uuid {
            mixon = peripheral
            mixon?.delegate = self
            centralManager?.connect(mixon!, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        mixon?.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Fail To Connect: \(error)")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnect Peripheral: \(error)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discover Service")
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid.uuidString == serviceUUID {
                print("Discover Mixon Service")
                mixonService = service
                mixon?.discoverCharacteristics(nil, for: mixonService!)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        print("Discover Characteristics:\(characteristics)")
        for characteristic in characteristics {
            if characteristic.uuid.uuidString == writeCharacteristicUUID {
                print("Discover Write Characteristics")
                writeCharacteristic = characteristic
                write(value: "0")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.write(value: "1,255,255,255")
                }
            } else if characteristic.uuid.uuidString == notifyCharacteristicUUID {
                print("Discover Notify Characteristics")
                notifyCharacteristic = characteristic
                mixon?.setNotifyValue(true, for: notifyCharacteristic!)
            }
        }
    }
    
    func write(value: String) {
        guard let writeCharacteristic = writeCharacteristic else { return }
        if let data = value.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            self.mixon?.writeValue(data, for: writeCharacteristic, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        if let text = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
            
            guard text.characters.count == 6 else { return }
            guard let value = Float(text) else { return }
            
            calcQuantitySum += value
            calcQuantityIndex += 1
            let n = 10
            if calcQuantityIndex == n {
                quantity = calcQuantitySum / Float(n)
                print("quantity: \(quantity)")
                calcQuantityIndex = 0
                calcQuantitySum = 0
                if quantity - zeroQuantity > threshold() && step > 2 {
                    print("--- next ---")
                    print("threshold: \(threshold())")
                    print("zero: \(zeroQuantity)")
                    print("quantity: \(quantity)")
                    print("------------")
                    next()
                    zeroQuantity = quantity
                }
            }
            
        }
    }
    
    func threshold() -> Float {
        switch step {
        case 3:
            return Float(cocktail.quantity1)
        case 4:
            return Float(cocktail.quantity2)
        case 5:
            return Float(cocktail.quantity3)
        case 6:
            return Float(cocktail.quantity4)
        case 7:
            return Float(cocktail.quantity4)
        default:
            return 0
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Fail To Update Notify: \(error)")
        } else {
            print("Success To Update Notify: \(characteristic.isNotifying)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Write Error: \(error)")
        } else {
            print("Did Write Value")
        }
    }
    
    
    
}
