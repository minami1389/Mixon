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

    var cocktail: Cocktail?
    var step = 0
    var totalStep = 6
    
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
    
    let uuid = "EF6CE85F-95B6-F511-6394-A5EB127973CB"
    let serviceUUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
    let writeCharacteristicUUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
    let notifyCharacteristicUUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
    var mixon: CBPeripheral?
    var mixonService: CBService?
    var writeCharacteristic: CBCharacteristic?
    var notifyCharacteristic: CBCharacteristic?
    var centralManager: CBCentralManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 44)
        closeButton.setTitle(String.fontAwesomeIcon(name: .timesCircle), for: .normal)
        
        guard let cocktail = cocktail else {
            return
        }
        
        stepLabel.text = "STEP \(step)/\(totalStep)"
        cocktailNameLabel.text = cocktail.name
        cocktailNameEnLabel.text = cocktail.name
        
        nextButton.isHidden = (step > 2)
        nextLabel.isHidden = (step > 2)
        quantityLabel.isHidden = (step <= 2)
        imageView.isHidden = (step > 2)
        effectView.isHidden = (step > 2)
        
        switch step {
        case 1:
            detailLabel.text = "デバイスにグラスを乗せてください"
        case 2:
            detailLabel.text = "グラスに氷を入れてください"
        case 3:
            detailLabel.text = cocktail.material1
            quantityLabel.text = "\(cocktail.quantity1)ml"
            view.backgroundColor = UIColor.init(red: 193/255, green: 72/255, blue: 149/255, alpha: 1.0)
        case 4:
            detailLabel.text = cocktail.material2
            quantityLabel.text = "\(cocktail.quantity2)ml"
            view.backgroundColor = UIColor.init(red: 206/255, green: 75/255, blue: 75/255, alpha: 1.0)
        case 5:
            detailLabel.text = cocktail.material3
            quantityLabel.text = "\(cocktail.quantity3)ml"
            view.backgroundColor = UIColor.init(red: 75/255, green: 182/255, blue: 206/255, alpha: 1.0)
        case 6:
            detailLabel.text = cocktail.material4
            quantityLabel.text = "\(cocktail.quantity4)ml"
            view.backgroundColor = UIColor.init(red: 184/255, green: 206/255, blue: 75/255, alpha: 1.0)
        default:
            break
        }
        
    }
    
    func next() {
        switch step {
        case 3:
            if cocktail?.material2 == "" {
                return
            }
        case 4:
            if cocktail?.material3 == "" {
                return
            }
        case 5:
            if cocktail?.material4 == "" {
                return
            }
        case 6:
            return
        default:
            break
        }
        
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CocktailMakeViewController") as? CocktailMakeViewController {
            vc.cocktail = cocktail
            vc.step = (step+1)
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func didTap(_ sender: Any) {
        next()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        centralManager?.stopScan()
        if let mixon = self.mixon {
            centralManager?.cancelPeripheralConnection(mixon)
            if let characteristic = notifyCharacteristic {
                mixon.setNotifyValue(false, for: characteristic)
            }
        }
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        next()
    }
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
//        print("----- Discover Peripheral -----")
//        print("name: \(peripheral.name)")
//        print("advertisementData:\(advertisementData)")
//        print("uuid: \(peripheral.identifier.uuidString)")
//        print("-------------------------------")
        
        if peripheral.identifier.uuidString == uuid {
            print("Discover Mixon")
            mixon = peripheral
            mixon?.delegate = self
            centralManager?.connect(mixon!, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("")
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
                write()
            } else if characteristic.uuid.uuidString == notifyCharacteristicUUID {
                print("Discover Notify Characteristics")
                notifyCharacteristic = characteristic
                mixon?.setNotifyValue(true, for: notifyCharacteristic!)
            }
        }
    }
    
    func write() {
        guard let writeCharacteristic = writeCharacteristic else { return }
        let values:[CUnsignedChar] = [0x00, 0x01, 0x10, 0x02, 0x20, 0x04, 0x01, 0x00]
        for value in values {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                var v = value
                let data = NSData(bytes: &v, length: 1)
                self.mixon?.writeValue(
                    data as Data,
                    for: writeCharacteristic,
                    type: CBCharacteristicWriteType.withResponse
                )
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            let text = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print("Update Value:\(text)")
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
