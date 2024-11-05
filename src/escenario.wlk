import jugador.*
import wollok.game.*
import celda.*
object escenario {
  var x = 0
  var y = 0
  var property celdasAbiertas = 0
  var property celdas = []
  var nivel = 0

  method setNivel(nuevoNivel) {
    nivel = nuevoNivel
  }

  //OK 

  method tableroTerminado() = celdasAbiertas == self.celdasSinBomba().size()

  method inicializar(){
    self.ponerCeldas()
    self.inicializarMinas()
    self.inicializarCeldasEspeciales()
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
    var celdaElegida = self.celdasSinBomba().get(0.randomUpTo(self.celdasSinBomba().size()-1))
    if (celdaElegida.tipo() == normal) {
      celdaElegida.tipo(tipo)
    }
  }

  method inicializarCeldasEspeciales() {
    self.inicializarCeldaEspecial(expansiva)
    self.incializarCeldaEspecial(revelaBomba)
  }
  
  method getCeldaPorPosicion(pos) = celdas.find({celda => celda.position() == pos})
  method celdasConBomba() = celdas.filter({celda => celda.tieneBomba()})
  method celdasSinBomba() = celdas.filter({celda => not celda.tieneBomba()})
  method ponerCeldas(){
    //pasar 10 como parametro
    var largo = nivel * 5
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
    celdas.add(new Celda(posX = x, posY = y))
    x+=1
  }

  method inicializarMinas(){
    var cantCeldas = celdas.size()
    var cantidadMinas = (cantCeldas / 2) / 2
    cantidadMinas.times({i => self.colocarMina(cantCeldas)})
  }
  
  method colocarMina(max) {
    var indice = 0.randomUpTo(max-1)
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

}
