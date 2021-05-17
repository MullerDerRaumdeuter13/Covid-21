//
//  Pais.swift
//  Covid-19
//
//  Created by Roberto Mtz. Román on 14/05/21.
//

import Foundation

class Pais
{
    var nombre: String
    var casos: Int
    var dirBandera: String
    
    init(nombre: String = "desconocido", casos: Int = 0, dirBandera: String = "") {
        self.nombre = nombre
        self.casos = casos
        self.dirBandera = dirBandera
    }
}
