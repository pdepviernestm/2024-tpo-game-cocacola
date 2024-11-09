import escenario.*
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

  method liberarCelda(cantCeldasPorFila) {
    if (not abierto) {
      abierto = true
      //busca las celdas alrededor y las guarda
      self.getCeldasAlrededor(cantCeldasPorFila)
      escenario.sumarCeldaLibre()
      self.calcularBombasAlrededor()
      self.cambiarImagenSegunCantBombas()
      tipo.aplicarEfectos(self)
    }
  }
  
  method getCeldasAlrededor(cantCeldasPorFila) { 
      const posJugadorX = jugador.position().x() - 8
      const posJugadorY = jugador.position().y() - 8
      var posicionAgregar = (posJugadorX + 1) + (posJugadorY * cantCeldasPorFila)
      if(posicionAgregar >= 0)
      self.agregarCeldaAlrededor(escenario.getCeldas().get(posicionAgregar))  // derecha
      posicionAgregar = (posJugadorX - 1) + (posJugadorY * cantCeldasPorFila)
      if(posicionAgregar >= 0)
      self.agregarCeldaAlrededor(escenario.getCeldas().get(posicionAgregar))  // izquierda
      posicionAgregar = posJugadorX + ((posJugadorY + 1) * cantCeldasPorFila)
      if(posicionAgregar >= 0)
      self.agregarCeldaAlrededor(escenario.getCeldas().get(posicionAgregar))  // arriba
      posicionAgregar = posJugadorX + ((posJugadorY - 1) * cantCeldasPorFila)
      if(posicionAgregar >= 0)
      self.agregarCeldaAlrededor(escenario.getCeldas().get(posicionAgregar))  // abajo
      posicionAgregar = (posJugadorX + 1) + ((posJugadorY + 1) * cantCeldasPorFila)
      if(posicionAgregar >= 0)
      self.agregarCeldaAlrededor(escenario.getCeldas().get(posicionAgregar))  // diagonal sup derecha
      posicionAgregar = (posJugadorX - 1) + ((posJugadorY + 1) * cantCeldasPorFila)
      if(posicionAgregar >= 0)
      self.agregarCeldaAlrededor(escenario.getCeldas().get(posicionAgregar))  // diagonal sup izq
      posicionAgregar = (posJugadorX + 1) + ((posJugadorY - 1) * cantCeldasPorFila)
      if(posicionAgregar >= 0)
      self.agregarCeldaAlrededor(escenario.getCeldas().get(posicionAgregar))  // diagonal inf der
      posicionAgregar = (posJugadorX - 1) + ((posJugadorY - 1) * cantCeldasPorFila)
      if(posicionAgregar >= 0)
      self.agregarCeldaAlrededor(escenario.getCeldas().get(posicionAgregar))  // diagonal inf izq
      /*var celdaAgregar = escenario.getCeldaPorPosicion(position.up(distancia))
      self.agregarCeldaAlrededor(celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.down(distancia))
      self.agregarCeldaAlrededor(celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.left(distancia))
      self.agregarCeldaAlrededor(celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.right(distancia))
      self.agregarCeldaAlrededor(celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.right(distancia).up(distancia))
      self.agregarCeldaAlrededor(celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.right(distancia).down(distancia))
      self.agregarCeldaAlrededor(celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.left(distancia).up(distancia))
      self.agregarCeldaAlrededor(celdaAgregar)
      celdaAgregar = escenario.getCeldaPorPosicion(position.left(distancia).down(distancia))
      self.agregarCeldaAlrededor(celdaAgregar)*/

      //NO USAR FIND
      // ABC
      // DEF
      // GHI

      //E = POS
      //A = E.POS -4
      //USAR ACCESO DIRECTO
      //
  }

  method agregarCeldaAlrededor (celdaAAgregar) {
    celdasAlrededor.add(celdaAAgregar)
  }

    method reaccionar(cantCeldasPorFila) {
    if (not abierto) {
      if(bomba){
        image = "bomba.png"
        //ir de nuevo a menu o reinicio nivel
        escenario.mostrarBombas()
        game.stop()
      } else {
        //mostrar numero con cantidad de minas alrededor
        self.liberarCelda(cantCeldasPorFila)
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
}

class TipoCelda {
  method aplicarEfectos(celda) {}

  method esNormal() = false
}
object normal inherits TipoCelda{
  override method esNormal() = true
}

object expansiva inherits TipoCelda{
  override method aplicarEfectos(celda) {
    celda.getCeldasAlrededor(2)
  }
}

object revelaBomba inherits TipoCelda{
  override method aplicarEfectos(celda)  {
    2.times({i => self.elegirYRevelarBomba()})
  }

  method elegirYRevelarBomba() {
    const celdaElegida = self.elegirCeldaAleatoria()   
    celdaElegida.revelarBomba()
  }
  method elegirCeldaAleatoria() = escenario.celdasConBomba().get(0.randomUpTo(escenario.celdasConBomba().size()-1))
}
