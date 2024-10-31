import jugador.*
import wollok.game.*

object escenario {
  var x = 0
  var y = 0
  var property celdasLibres = 0
  var property celdas = []
  var nivel = 0

  method setNivel(nuevoNivel) {
    nivel = nuevoNivel
  }

  method inicializar(){
    self.ponerCeldas()
    self.inicializarMinas()
    //aca se agregaran cosas como indicadores, tiempo, etc
    game.addVisualCharacter(jugador)
    keyboard.space().onPressDo({
      game.getObjectsIn(jugador.position()).get(0).marcarBloque()
    })
    keyboard.enter().onPressDo({
      game.getObjectsIn(jugador.position()).get(0).reaccionar(celdasLibres, celdas.size())
    })
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
    celdasLibres = 0
    celdas = []
    x = 0
    y = 0
    game.clear()
  }

  method liberarCelda() {
    celdasLibres += 1
  }
}

class Celda {
  var posX
  var posY
  var property image = "bloque.png"
  var property position = game.at(posX, posY)
  var bomba = false
  var bombasAlrededor = 0
  method setImagen(newImage) {
    image = newImage
  }
  method position(newPos) {
    position = newPos
  }
  method marcarBloque() {
    image = "bandera.png"
  }

  method tieneBomba() = bomba

  method colocarBomba() {
    bomba = true
  }

  method reaccionar(celdasLibres, celdasTotal) {
    if(bomba){
      image = "bomba1.png"
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
      self.cambiarImagenSegunCantBombas()
    }
  }
  
  method cambiarImagenSegunCantBombas() {
    
  }

  method liberarCelda() {
    image = "bloqueVacio.jpg"
    escenario.liberarCelda()
  }

  method liberarCeldasAlrededor() {
  //game.getObjectsIn(jugador.position()).get(0).marcarBloque()
  //celda a derecha
    var posInicial = jugador.position()
  //se debe contemplar los casos donde se trate de un bloque ubicado 
  //en una ubicacion donde no lo que hay alrededor es bloque

  // if getobjects().size() > 0
    var bloqueAChequear = game.getObjectsIn(posInicial.up(1))
    self.limpiarBloqueElegido(bloqueAChequear)

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
      } else {
        bombasAlrededor+=1
      }
    }
  }
}
