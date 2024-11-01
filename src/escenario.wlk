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

  method inicializar(){
    self.ponerCeldas()
    self.inicializarMinas()
    //self.inicializarCeldasConNumeros()
    //aca se agregaran cosas como indicadores, tiempo, etc
    game.addVisualCharacter(jugador)
    keyboard.space().onPressDo({
      game.getObjectsIn(jugador.position()).get(0).marcarBloque()
    })
    keyboard.enter().onPressDo({
      game.getObjectsIn(jugador.position()).get(0).reaccionar(celdasAbiertas, celdas.size())
    })
  }


  method inicializarCeldasConNumeros() {

  }

  method celdasSinBomba() = celdas.filter({celda => not celda.tieneBomba()}).size()
  method ponerCeldas(){
    //pasar 10 como parametro
    var largo = nivel * 5
    self.agregarCeldas(largo)
    celdas.forEach( {p => game.addVisual(p)})
    //fondo.celdas(5).forEach( { p=>game.addVisual(new Celda(position=p)); })
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
    var cantCeldas= celdas.size()
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
    game.clear()
  }

  method sumarCeldaLibre() {
    celdasAbiertas += 1
  }
}
