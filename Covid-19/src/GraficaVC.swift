//
//  GraficaVC.swift
//  Covid-19
//
//  Created by Roberto Mtz. Román on 14/05/21.
//

import UIKit
import MSBBarChart      // Para graficar
import Alamofire        // Para redes

class GraficaVC: UIViewController
{
    var pais = ""
    
    @IBOutlet weak var grafica: MSBBarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // pais tiene el nombre correcto (asignado desde el controlador anterior)
        self.title = pais   // Título de esta pantalla cuando estás en NavigationController
        
        // Descarga los casos a través de la red
        descargarCasos(pais)
    }
    
    func descargarCasos(_ pais: String) {
        let direccion = "https://corona.lmao.ninja/v3/covid-19/historical/\(pais)?lastdays=30"
        AF.request(direccion)
            .responseJSON { response in
                if let json = response.value {
                    // Diccionario
                    let dJsonPais = json as? [String:AnyObject] ?? [String: AnyObject]()
                    let timeline = dJsonPais["timeline"] as? [String:AnyObject] ?? [String: AnyObject]()
                    let dCasos = timeline["cases"] as? [String: Int] ?? [String: Int]()
                    var valores = [Int]()
                    for fecha in dCasos {
                        valores.append(fecha.value)
                    }
                    
                    // Pasa el arreglo al objeto que grafica
                    // casos por día, ordenados
                    self.grafica.setDataEntries(values: self.acondicionar(valores))
                    self.grafica.start()
                }
            }
    }

    func acondicionar(_ datos: [Int]) -> [Int] {
        guard datos.count > 1 else {    // Verifica que hay, al menos, 2 datos
            return datos    // Si no es así, REGRESA
        }
        var ordenados = datos.sorted()
        
        for i in 0..<ordenados.count-1 {
            // resta para obtener los casos diarios
            ordenados[i] = ordenados[i+1] - ordenados[i]
        }
        
        ordenados.removeLast()
        
        return ordenados
    }
}
