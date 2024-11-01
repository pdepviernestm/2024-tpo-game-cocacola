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
  var numero = false//despues ver que joraca hacer con esto
  
  var vacio = false//la celda ya fue elegida??

  method setImagen(newImage) {
    image = newImage
  }
  method position(newPos) {
    position = newPos
  }
  method marcarBloque() {
    if (not vacio) {
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
    escenario.sumarCeldaLibre()
    self.calcularBombasAlrededor()
    self.cambiarImagenSegunCantBombas()
  }
  method reaccionar(celdasLibres, celdasTotal) {
    if(bomba){
      image = "bomba1.png"
      //ir de nuevo a menu o reinicio nivel

      //mostrar bombas
      //escenario.mostrarBombas()
    } else {
      //mostrar numero con cantidad de minas alrededor
      self.liberarCelda()
      self.liberarCeldasAlrededor()
      //image = "bloqueVacio.jpg"
      self.cambiarImagenSegunCantBombas()

      // if (escenario.celdasLibres() == escenario.celdasSinBomba()) {
      //   escenario.reiniciar()
      //   escenario.subirNivel()
      //   escenario.inicializar()
      // }  
    }
  }

  method calcularBombasAlrededor() {
        
  }
  
  method cambiarImagenSegunCantBombas() {
    //image = (bombasAlrededor) + ".png"
    if(bombasAlrededor == 0) image = "bloqueVacio.jpg"
    if (bombasAlrededor == 1) image = "1.png"
    if(bombasAlrededor == 2) image = "2.png"
    if (bombasAlrededor == 3) image = "3.png"
  }

    

  method liberarCeldasAlrededor() {
  //game.getObjectsIn(jugador.position()).get(0).marcarBloque()
  //celda a derecha
    var posInicial = jugador.position()
  //se debe contemplar los casos donde se trate de un bloque ubicado 
  //en una ubicacion donde no lo que hay alrededor es bloque
  var posIzq
  var posDer

  var posiciones = [posIzq, posDer]

  posiciones.size().times({i => posiciones.get(i).liberarCelda()})
  // if getobjects().size() > 0
    var bloqueAChequear = game.getObjectsIn(posInicial.up(1))
    self.limpiarBloqueElegido(bloqueAChequear) //lista de obj
    
    bloqueAChequear = game.getObjectsIn(posInicial.down(1))
    self.limpiarBloqueElegido(bloqueAChequear)

    bloqueAChequear = game.getObjectsIn(posInicial.left(1))
    self.limpiarBloqueElegido(bloqueAChequear)

    bloqueAChequear = game.getObjectsIn(posInicial.right(1))
    self.limpiarBloqueElegido(bloqueAChequear)

    //esquinas alrededor
    bloqueAChequear = game.getObjectsIn(posInicial.right(1).up(1))
    self.limpiarBloqueElegido(bloqueAChequear)

    bloqueAChequear = game.getObjectsIn(posInicial.right(1).down(1))
    self.limpiarBloqueElegido(bloqueAChequear)

    bloqueAChequear = game.getObjectsIn(posInicial.left(1).up(1))
    self.limpiarBloqueElegido(bloqueAChequear)

    bloqueAChequear = game.getObjectsIn(posInicial.left(1).down(1))
    self.limpiarBloqueElegido(bloqueAChequear)
  }

  method limpiarBloqueElegido(bloque){
    if (bloque.size() > 0) {
      if (not bloque.get(0).tieneBomba()) {
        bloque.get(0).liberarCelda()
      }
    }
  }
}