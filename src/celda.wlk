import escenario.*
import jugador.*

import wollok.game.*

class Celda {
  const posX
  const posY
  var tipo
  var property image = "bloque.png"
  var property position = game.at(posX, posY)
  var bomba = false
  var bombasAlrededor = 0
  var marcado = false
  const celdasAlrededor = []
  var abierto = false
  method esCelda() = true
  method tipo() = tipo
  method tipo(nuevoTipo) {
    tipo = nuevoTipo
  }
  method image(nuevaImagen) {
    image = nuevaImagen
  }

  method estaAbierto() = abierto
  method position(newPos) {
    position = newPos
  }
  //si el bloque esta vacio, se puede marcar
  //verifica si ya esta marcado para desmarcarlo y viceversa
  method marcarBloque() {
    if (not abierto) {
      if (not marcado) {
        image = "bandera.png"
        marcado = true
      } else {
        image = "bloque.png"
        marcado = false
      }
    } 
  }

  method revelarBomba() {
    image = "bomba.png"
    abierto = true
  }
  
  method tieneBomba() = bomba

  method colocarBomba() {
    bomba = true
  }

  method liberarCelda() {
    if (not abierto) {
      abierto = true
      //busca las celdas alrededor y las guarda
      self.getCeldasAlrededor(1)
      escenario.sumarCeldaLibre()
      self.calcularBombasAlrededor()
      self.cambiarImagenSegunCantBombas()
      tipo.aplicarEfectos(self)
    }
  }
  
  method getCeldasAlrededor(distancia) {
    
      var celdaAgregar = escenario.getCeldaPorPosicion(position.up(distancia))
      self.agregarCeldaAlrededor(distancia, celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.down(distancia))
      self.agregarCeldaAlrededor(distancia, celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.left(distancia))
      self.agregarCeldaAlrededor(distancia, celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.right(distancia))
      self.agregarCeldaAlrededor(distancia, celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.right(distancia).up(distancia))
      self.agregarCeldaAlrededor(distancia, celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.right(distancia).down(distancia))
      self.agregarCeldaAlrededor(distancia, celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.left(distancia).up(distancia))
      self.agregarCeldaAlrededor(distancia, celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.left(distancia).down(distancia))
      self.agregarCeldaAlrededor(distancia, celdaAgregar)
  }

  method agregarCeldaAlrededor (distancia, celdaAAgregar) {
    if (celdaAAgregar == 0) {

    } else {
      celdasAlrededor.add(celdaAAgregar)
    }
  }

    method reaccionar() {
    if (not abierto) {
      if(bomba){
        image = "bomba.png"
        //ir de nuevo a menu o reinicio nivel
        escenario.mostrarBombas()
        game.stop()
      } else {
        //mostrar numero con cantidad de minas alrededor
        self.liberarCelda()
        self.liberarCeldasAlrededor()

        if(escenario.tableroTerminado()) {
          game.stop()
        }
      }
      }
    }

  method calcularBombasAlrededor() {
    bombasAlrededor = celdasAlrededor.filter({celda => celda.tieneBomba()}).size()
  }
  
  method cambiarImagenSegunCantBombas() {
    //image = bombasAlrededor + ".png"
    if(bombasAlrededor == 0) image = "bloqueVacio.jpg"
    if (bombasAlrededor == 1) image = "1.png"
    if(bombasAlrededor == 2) image = "2.png"
    if (bombasAlrededor == 3) image = "3.png"
    if (bombasAlrededor == 4) image = "4.png"
    if (bombasAlrededor == 5) image = "5.png"
  }

    

  method liberarCeldasAlrededor() {
    celdasAlrededor.forEach({celda => self.liberarCeldaCercana(celda)})
  }

  method liberarCeldaCercana(celda){
    if (not celda.tieneBomba()) {
      celda.liberarCelda()
    }
  }

  method hayCelda(espacioCelda) = espacioCelda.size() > 0

}

object normal {
  method aplicarEfectos(celda) {
  }

  method esNormal() = true
}

object expansiva {
  method aplicarEfectos(celda) {
    celda.getCeldasAlrededor(2)
  }
  method esNormal() = true
}

object revelaBomba {
  method aplicarEfectos(celda)  {
    2.times({i => self.elegirYRevelarBomba()})
  }
  method elegirYRevelarBomba() {
    const celdaElegida = self.elegirCeldaAleatoria()   
    celdaElegida.revelarBomba()
  }
  method elegirCeldaAleatoria() = escenario.celdasConBomba().get(0.randomUpTo(escenario.celdasConBomba().size()-1))
  method esNormal() = true
}