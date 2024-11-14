import wollok.game.*
import escenario.*
import jugador.*

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
      self.getCeldasAlrededor(cantCeldasPorFila, 1)
      escenario.sumarCeldaLibre()
      self.calcularBombasAlrededor()
      self.cambiarImagenSegunCantBombas()
      tipo.aplicarEfectos(self)
    }
  }
  
  method getCeldasAlrededor(cantCeldasPorFila, distancia) { 
    //x = 8
    // y = 8

    //modificar posjugadorx-1 por jugadorx - distancia
    // contemplar casos de espacios donde no hay celdas
      const posicionX = self.position().x() - 8
      const posicionY = self.position().y() - 8

      var posicionAgregarX = posicionX + distancia
      var posicionAgregarY = posicionY
      self.verificarYAgregarPosicion(posicionAgregarX, posicionAgregarY, cantCeldasPorFila) //derecha

      posicionAgregarX = posicionX - distancia
      posicionAgregarY = posicionY 
      self.verificarYAgregarPosicion(posicionAgregarX, posicionAgregarY, cantCeldasPorFila) //izquierda

      posicionAgregarX = posicionX
      posicionAgregarY = (posicionY + distancia) 
      self.verificarYAgregarPosicion(posicionAgregarX, posicionAgregarY, cantCeldasPorFila) //arriba

      posicionAgregarX = posicionX
      posicionAgregarY = (posicionY - distancia) 
      self.verificarYAgregarPosicion(posicionAgregarX, posicionAgregarY, cantCeldasPorFila) //abajo

      posicionAgregarX = posicionX - distancia
      posicionAgregarY = (posicionY + distancia) 
      self.verificarYAgregarPosicion(posicionAgregarX, posicionAgregarY, cantCeldasPorFila) //esq sup izq

      posicionAgregarX = posicionX + distancia
      posicionAgregarY = (posicionY + distancia) 
      self.verificarYAgregarPosicion(posicionAgregarX, posicionAgregarY, cantCeldasPorFila) //esq sup der

      posicionAgregarX = posicionX - distancia
      posicionAgregarY = (posicionY - distancia) 
      self.verificarYAgregarPosicion(posicionAgregarX, posicionAgregarY, cantCeldasPorFila) //esq sup izq

      posicionAgregarX = posicionX + distancia
      posicionAgregarY = (posicionY - distancia)
      self.verificarYAgregarPosicion(posicionAgregarX, posicionAgregarY, cantCeldasPorFila) //esq sup izq
  }
  method verificarYAgregarPosicion(x, y, celdasPorFila) {
    //verificar que sea posicion valida(sin x o y negativos)
    if ((x >= 0) && (y >= 0) && (x < celdasPorFila) && (y < celdasPorFila)) {
      self.agregarCeldaAlrededor(escenario.getCeldas().get(x + y * celdasPorFila))
    }
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
        self.liberarCeldasAlrededor(cantCeldasPorFila)

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

    

  method liberarCeldasAlrededor(cantCeldasPorFila) {
    celdasAlrededor.forEach({celda => self.liberarCeldaCercana(celda, cantCeldasPorFila)})
  }

  method liberarCeldaCercana(celda, cantCeldasPorFila){
    if (not celda.tieneBomba()) {
      celda.liberarCelda(cantCeldasPorFila)
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
