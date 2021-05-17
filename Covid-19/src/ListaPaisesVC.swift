//
//  ViewController.swift
//  Covid-19
//
//  Created by Roberto Mtz. Román on 14/05/21.
//

import UIKit
import Alamofire

class ListaPaisesVC: UIViewController
{
    var arrPaises = [Pais]()
    @IBOutlet weak var tabla: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descargarListaPaises()
        
        
        /*      // Países de prueba, para no descargar de la red
        arrPaises.append(Pais(nombre: "México", casos: 100, dirBandera: ""))
        arrPaises.append(Pais(nombre: "USA", casos: 100, dirBandera: ""))
        arrPaises.append(Pais(nombre: "Brazil", casos: 100, dirBandera: ""))
         */
    }


    func descargarListaPaises() {
        let direccion = "https://corona.lmao.ninja/v3/covid-19/countries"
        AF.request(direccion)
            .responseJSON { response in
                if let json = response.value {
                    // Arreglo de diccionarios
                    let arrJsonPais = json as? [[String:AnyObject]] ?? [[String: AnyObject]]()
                    for dPais in arrJsonPais {  // Visita cada diccionario
                        let nombre = dPais["country"] as? String ?? "Desconocido"
                        let casos = dPais["cases"] as? Int ?? 0
                        let dInfo = dPais["countryInfo"] as? [String: AnyObject] ?? [String: AnyObject]()
                        let dirBandera = dInfo["flag"] as? String ?? ""
                        
                        let nuevoPais = Pais(nombre: nombre, casos: casos, dirBandera: dirBandera)
                        self.arrPaises.append(nuevoPais)
                    }
                    self.tabla.reloadData()
                }
            }
    }
    
    // Se ejecuta JUSTO antes de hacer la transición
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GraficaVC
        let indice = tabla.indexPathsForSelectedItems?[0].row ?? 0
        let pais = arrPaises[indice].nombre
        vc.pais = pais
    }
}

extension ListaPaisesVC: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPaises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "celdaPais", for: indexPath) as! CeldaPais
        
        let pais = arrPaises[indexPath.row]
        celda.lblPais.text = pais.nombre
        // Descargar bandera
        AF.request(pais.dirBandera)
            .responseData { response in
                if let datos = response.data {
                    let imagen = UIImage(data: datos)
                    celda.imgBandera.image = imagen
                } else {
                    celda.imgBandera.image = nil
                }
            }
        celda.layer.cornerRadius = 10       // Esquina redondeada
        celda.layer.masksToBounds = true    // Recorta la esquina
        celda.layer.borderColor = UIColor.green.cgColor
        celda.layer.borderWidth = 2
        
        return celda
    }
    
}
