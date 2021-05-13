//
//  ViewController.swift
//  wikisearch
//
//  Created by JORGE LUIS BALTAZAR PEREZ on 12/05/21.
//

import UIKit
import WebKit


class ViewController: UIViewController {

    @IBOutlet weak var buscarTextField: UITextField!
    @IBOutlet weak var WebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let urlYoutube = URL(string: "https://www.youtube.com/watch?v=IO9XlQrEt2Y"){
            WebView.load(URLRequest(url: urlYoutube))}
    }
    func buscarWikipedia(palabras: String) {
        if let urlApi = URL(string: "https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&titles=\(palabras.replacingOccurrences(of: " ", with: "%20"))"){
            let peticion = URLRequest(url: urlApi)
            let tarea = URLSession.shared.dataTask(with: peticion) { (datos, respuesta, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }else{
                    do {
                        let objJson = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        let querySubJson = objJson["query"] as! [String : Any]
                        let pagesSubJson = querySubJson["pages"] as! [String : Any]
                        let pageId = pagesSubJson.keys
                        
                        if pageId.elementsEqual(["-1"]){
                            DispatchQueue.main.sync {
                                self.WebView.loadHTMLString( "<H1>no ps no mi hermano</H1>", baseURL: nil)
                            }
                        }else{
                        let llaveExtracto = pageId.first!
                        
                        let idSubJson = pagesSubJson[llaveExtracto] as! [String : Any]
                        let extracto = idSubJson["extract"] as? String
                    
                        
                        DispatchQueue.main.sync {
                            self.WebView.loadHTMLString(extracto ?? "<H1>no ps no</H1>", baseURL: nil)
                        }
                        
                        
                    }
                    } catch  {
                        print("con el json\(error.localizedDescription)")
                    }
                }
            }
            tarea.resume()
        }
       
    }

    @IBAction func buscarPalabraButton(_ sender: UIButton) {
        buscarTextField.resignFirstResponder()
        guard let palabraABuscar = buscarTextField.text else { return  }
        buscarWikipedia(palabras: palabraABuscar)
    }
    
}

