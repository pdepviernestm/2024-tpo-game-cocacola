import escenario.*
import jugador.*
class Celda {
  var posX
  var posY
  var property image = "bloque.png"
  var property position = game.at(posX, posY)
  var bomba = false
  var bombasAlrededor = 0
  var marcado = false
  var celdasAlrededor = []
  var abierto = false
  
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

  method tieneBomba() = bomba

  method colocarBomba() {
    bomba = true
  }

  method liberarCelda() {
    if (not abierto) {
      abierto = true
      //busca las celdas alrededor y las guarda
      celdasAlrededor.add(game.getObjectsIn(position.up(1)))
      celdasAlrededor.add(game.getObjectsIn(position.down(1)))
      celdasAlrededor.add(game.getObjectsIn(position.left(1)))
      celdasAlrededor.add(game.getObjectsIn(position.right(1)))
      celdasAlrededor.add(game.getObjectsIn(position.right(1).up(1)))
      celdasAlrededor.add(game.getObjectsIn(position.right(1).down(1)))
      celdasAlrededor.add(game.getObjectsIn(position.left(1).up(1)))
      celdasAlrededor.add(game.getObjectsIn(position.left(1).down(1)))
      escenario.sumarCeldaLibre()
      self.calcularBombasAlrededor()
      self.cambiarImagenSegunCantBombas()
    }
  }
  method reaccionar(celdasLibres, celdasTotal) {
    if(bomba){
      image = "bomba.png"
      //ir de nuevo a menu o reinicio nivel

      //mostrar bombas
      //escenario.mostrarBombas()
    } else {
      //mostrar numero con cantidad de minas alrededor

      self.liberarCelda()
      self.liberarCeldasAlrededor()

      // if (escenario.celdasLibres() == escenario.celdasSinBomba()) {
      //   escenario.reiniciar()
      //   escenario.subirNivel()
      //   escenario.inicializar()
      // }  
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

