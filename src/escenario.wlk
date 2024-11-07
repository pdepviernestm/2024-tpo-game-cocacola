import jugador.*
import wollok.game.*
import celda.*

object escenario {
  var x = 0
  var y = 0
  var property celdasAbiertas = 0
  var property celdas = []
  var property nivel = 0
  method mostrarInicio() {
    keyboard.enter().onPressDo({
        self.mostrarInstrucciones()
    })
  }

  method mostrarInstrucciones() {
    fondo.image("instrucciones1.png")
    keyboard.num1().onPressDo({
      self.setNivel(1)
      self.inicializar()
    })

    keyboard.num2().onPressDo({
      self.setNivel(2)
      self.inicializar()
    })

    keyboard.num3().onPressDo({
      self.setNivel(3)
      self.inicializar()
    })
  }
  method setNivel(nuevoNivel) {
    nivel = nuevoNivel
  }

  //OK 

  method tableroTerminado() = celdasAbiertas == self.celdasSinBomba().size()

  method inicializar(){
    //game.boardGround("fondo.jpg")
    fondo.image("fondo1.jpg")
    self.ponerCeldas()
    self.inicializarMinas()
    if (nivel != 1)  {
      self.inicializarCeldasEspeciales()
    }
    keyboard.space().onPressDo({
      self.getCeldaPorPosicion(jugador.position()).marcarBloque()
    })
    keyboard.enter().onPressDo({
      self.getCeldaPorPosicion(jugador.position()).reaccionar()
    })
    game.addVisualCharacter(jugador)
  }

  //agregar metodo de get celda aleatoria(con o sin bomba)
  method inicializarCeldaEspecial(tipo) {
    const celdaElegida = self.celdasSinBomba().get(0.randomUpTo(self.celdasSinBomba().size()-1))
    if (celdaElegida.tipo().esNormal()) {
      celdaElegida.tipo(tipo)
    }
  }

  method inicializarCeldasEspeciales() {
    2.times({i => 
      self.inicializarCeldaEspecial(expansiva)
      self.inicializarCeldaEspecial(revelaBomba)
    })
  }
  method getCeldaPorPosicion(pos) = celdas.findOrElse({celda => celda.position() == pos}, {0})
  method celdasConBomba() = celdas.filter({celda => celda.tieneBomba()})
  method celdasSinBomba() = celdas.filter({celda => not celda.tieneBomba()})
  method ponerCeldas(){
    const largo = nivel * 7
    self.agregarCeldas(largo)
    celdas.forEach( {p => game.addVisual(p)})
  }

  method agregarCeldas(longitudCuadrado) {
    longitudCuadrado.times({i => self.agregarFila(longitudCuadrado)})
  }
  method agregarFila(longitud) {
    longitud.times({i => self.hacerBloqueX()})
    y+=1
    x=0
  }
  method hacerBloqueX() {
    celdas.add(new Celda(posX = x, posY = y, tipo = normal))
    x+=1
  }

  method inicializarMinas(){
    const cantCeldas = celdas.size()
    const cantidadMinas = (cantCeldas / 2) / 2
    cantidadMinas.times({i => self.colocarMina(cantCeldas)})
  }
  
  method colocarMina(max) {
    const indice = 0.randomUpTo(max-1)
    if(celdas.get(indice).tieneBomba()){
      self.colocarMina(max)
    } else {
      celdas.get(indice).colocarBomba()
    }
  }

  method subirNivel() {
    nivel += 1
  }

  method reiniciar() {
    celdasAbiertas = 0
    celdas = []
    x = 0
    y = 0
    self.inicializar()
  }

  method sumarCeldaLibre() {
    celdasAbiertas += 1
  }
  method mostrarBombas() {
    self.celdasConBomba().forEach({celda => celda.revelarBomba()})
  }
}

object fondo {
  var property position = game.center()
  var property image = "inicio3.png"
  method esCelda() = false
   //var position = game.center()
  method image(nuevaImagen) {
    image = nuevaImagen
  }
}
