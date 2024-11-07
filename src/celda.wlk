import escenario.*
import jugador.*
class Celda {
  var posX
  var posY
  var tipo
  var property image = "bloque.png"
  var property position = game.at(posX, posY)
  var bomba = false
  var bombasAlrededor = 0
  var marcado = false
  var celdasAlrededor = []
  var abierto = false

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
    celdasAlrededor.add(game.getObjectsIn(position.up(distancia)))
      celdasAlrededor.add(game.getObjectsIn(position.down(distancia)))
      celdasAlrededor.add(game.getObjectsIn(position.left(distancia)))
      celdasAlrededor.add(game.getObjectsIn(position.right(distancia)))
      celdasAlrededor.add(game.getObjectsIn(position.right(distancia).up(distancia)))
      celdasAlrededor.add(game.getObjectsIn(position.right(distancia).down(distancia)))
      celdasAlrededor.add(game.getObjectsIn(position.left(distancia).up(distancia)))
      celdasAlrededor.add(game.getObjectsIn(position.left(distancia).down(distancia)))
  }
    method reaccionar() {
    if(bomba){
      image = "bomba.png"
      //ir de nuevo a menu o reinicio nivel
      escenario.mostrarBombas()
      game.stop()
    } else {
      //mostrar numero con cantidad de minas alrededor

      self.liberarCelda()
      self.liberarCeldasAlrededor()

      if (escenario.tableroTerminado()) {
        game.say(jugador, "Juego finalizado")
      }  
    }
  }

  method calcularBombasAlrededor() {
    bombasAlrededor = celdasAlrededor.filter({celda => self.hayCelda(celda) && celda.get(0).tieneBomba()}).size()
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

  method liberarCeldaCercana(espacioCelda){
    if (self.hayCelda(espacioCelda)) {
      if (not espacioCelda.get(0).tieneBomba()) {
        espacioCelda.get(0).liberarCelda()
        escenario.sumarCeldaLibre()
      }
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
    var celdaElegida = self.elegirCeldaAleatoria()   
    celdaElegida.revelarBomba()
  }
  method elegirCeldaAleatoria() = escenario.celdasConBomba().get(0.randomUpTo(escenario.celdasConBomba().size()-1))
  method esNormal() = true
}