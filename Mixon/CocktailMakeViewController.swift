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
    
    let defaultBrightness = 20
    var mixed = false
    
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
    
    var calcQuantities:[Float] = [0,0,0,0,0]
    
    let uuid1 = "4D670666-55B2-4727-8295-02F99D99866C"
    let uuid2 = "2D826528-C989-9D27-A8FA-0CBF3E5431E5"
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
    
    var red:Float = 0
    var green:Float = 0
    var blue:Float = 0
    var brightness:Float = 0
    
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
        
        imageView.image = UIImage(named: cocktail.image)
        
        contentView.isHidden = true
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
        } else if cocktail.quantity5 == 0 {
            totalStep = 6
        }
    }
    
    func updateView() {
        guard let cocktail = cocktail else {
            return
        }
        
        stepLabel.text = "STEP \(step)/\(totalStep)"
        cocktailNameLabel.text = cocktail.nameJp
        cocktailNameEnLabel.text = cocktail.nameEn
        mixedNameLabel.text = cocktail.nameJp
        mixedNameEnLabel.text = cocktail.nameEn
        
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
            red = 208
            green = 0
            blue = 237
            brightness = 0.2
            write(value: "1,\(Int(self.red*brightness)),\(Int(self.green*brightness)),\(Int(self.blue*brightness))")
            detailLabel.text = cocktail.material1
            quantityLabel.text = "\(cocktail.quantity1)ml"
            view.backgroundColor = UIColor.init(red: 193/255, green: 72/255, blue: 149/255, alpha: 1.0)
        case 4:
            red = 62
            green = 114
            blue = 255
            brightness = 0.2
            write(value: "1,\(Int(self.red*brightness)),\(Int(self.green*brightness)),\(Int(self.blue*brightness))")
            detailLabel.text = cocktail.material2
            quantityLabel.text = "\(cocktail.quantity2)ml"
            view.backgroundColor = UIColor.init(red: 75/255, green: 182/255, blue: 205/255, alpha: 1.0)
        case 5:
            red = 255
            green = 41
            blue = 23
            brightness = 0.2
            write(value: "1,\(Int(self.red*brightness)),\(Int(self.green*brightness)),\(Int(self.blue*brightness))")
            detailLabel.text = cocktail.material3
            quantityLabel.text = "\(cocktail.quantity3)ml"
            view.backgroundColor = UIColor.init(red: 205/255, green: 75/255, blue: 75/255, alpha: 1.0)
        case 6:
            red = 180
            green = 255
            blue = 29
            brightness = 0.2
            write(value: "1,\(Int(self.red*brightness)),\(Int(self.green*brightness)),\(Int(self.blue*brightness))")
            detailLabel.text = cocktail.material4
            quantityLabel.text = "\(cocktail.quantity4)ml"
            view.backgroundColor = UIColor.init(red: 183/255, green: 205/255, blue: 75/255, alpha: 1.0)
        case 7:
            red = 127
            green = 9
            blue = 255
            brightness = 0.2
            write(value: "1,\(Int(self.red*brightness)),\(Int(self.green*brightness)),\(Int(self.blue*brightness))")
            detailLabel.text = cocktail.material5
            quantityLabel.text = "\(cocktail.quantity5)ml"
            view.backgroundColor = UIColor.init(red: 141/255, green: 75/255, blue: 205/255, alpha: 1.0)
        case 8:
            effectView.isHidden = true
            mixed = true
            write(value: "1,255,255,255")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.close()
            }
        default:
            break
        }
        
        guard let text = quantityLabel.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: 2.0, range: NSRange(location: 0, length: text.characters.count))
        attributedString.addAttribute(NSFontAttributeName, value: quantityLabel.font, range: NSRange(location: 0, length: text.characters.count))
        quantityLabel.attributedText = attributedString

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
        dismiss(animated: true, completion: {
            self.write(value: "2")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.centralManager?.stopScan()
                if let mixon = self.mixon {
                    self.centralManager?.cancelPeripheralConnection(mixon)
                    if let characteristic = self.notifyCharacteristic {
                        mixon.setNotifyValue(false, for: characteristic)
                    }
                }
            }
        })
    }

    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        next()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        next()
    }
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        self.close()
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
        print(peripheral)
        var name = ""
        if let n = peripheral.name {
            name = n
        }
        if peripheral.identifier.uuidString == uuid1 || peripheral.identifier.uuidString == uuid2 || name.hasPrefix("Adafruit") {
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
                write(value: "1,255,255,255")
                UIView.animate(withDuration: 0.3, animations: { 
                    self.contentView.isHidden = false
                })
            } else if characteristic.uuid.uuidString == notifyCharacteristicUUID {
                print("Discover Notify Characteristics")
                notifyCharacteristic = characteristic
                mixon?.setNotifyValue(true, for: notifyCharacteristic!)
            }
        }
    }
    
    func write(value: String) {
        guard let writeCharacteristic = writeCharacteristic else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let v = "\(value),22"
            print(v)
            if let data = v.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                self.mixon?.writeValue(data, for: writeCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        if let text = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
            
            guard let value = Float(text) else { return }
            guard value > 100 && value < 1024 else { return }
            
            calcQuantities.append(value)
            calcQuantities.remove(at: 0)
            
            var sum:Float = 0
            for q in calcQuantities {
                sum += q
            }
            let avg = sum / Float(calcQuantities.count)
            
            let r1:Float = 10.0
            let rf = r1 * avg / (1024.0 - avg)
            let fg = 1054.5 / rf - 59.104
            
            quantity = fg
            //print("\(value) : \(avg) : \(fg)")
            guard threshold() != 0 else { return }
            
            let diff = quantity - zeroQuantity
            brightness = diff / threshold() * 0.8 + 0.2 // 0 - 1
            if brightness > 0 && brightness <= 1 {
                    if self.mixed { return }
                    self.write(value: "1,\(Int(self.red*self.brightness)),\(Int(self.green*self.brightness)),\(Int(self.blue*self.brightness))")
            }
            if diff > threshold() && step > 2 {
//                print("--- next ---")
//                print("threshold: \(threshold())")
//                print("zero: \(zeroQuantity)")
//                print("quantity: \(quantity)")
//                print("------------")
                next()
                zeroQuantity = quantity
            }
            
            
        }
    }
    
    func threshold() -> Float {
        switch step {
        case 3:
            return Float(20)
        case 4:
            return Float(140)
        case 5:
            return Float(cocktail.quantity3)
        case 6:
            return Float(cocktail.quantity4)
        case 7:
            return Float(cocktail.quantity5)
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
