import jugador.*
object escenario {
  var x = 0
  var y = 0
  const celdas = []
  method inicializar(){
    self.ponerCeldas()
    //aca se agregaran cosas como indicadores, tiempo, etc
  }
  method buscarCelda(posicionX, posicionY){
    
  }
  method ponerCeldas(){
    //pasar 10 como parametro
    self.agregarCeldas(10)
    celdas.forEach( {celda => game.addVisual(celda)})
    //fondo.celdas(5).forEach( { p=>game.addVisual(new Celda(position=p)); })
  }

  method agregarCeldas(longitudCuadrado) {
    longitudCuadrado.times({i => self.agregarFila(longitudCuadrado)})
    // filas.times({i => self.agregarFila(columnas)})
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

  method colocarMinas(){
    const cantCeldas= celdas.size()
    const cantidadMinas = (cantCeldas / 2) / 2
    cantidadMinas.times({i => self.colocarMina(cantCeldas)})
  }
  //method patoTirabombas()
  //celdas = [celda, dledlemdc. ]
  method colocarMina(max) {
    const indice = 0.randomUpTo(max-1)
    if(celdas.get(indice).tieneBomba()){
      self.colocarMina(max)
    } else {
      celdas.get(indice).colocarBomba()
    }
  }
}

class Celda {
  const posX
  const posY
  var property image = "bloque.png"
  var property position = game.at(posX, posY)
  var bomba = false

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

  method reaccionar() {
    if(bomba){
      image = "bomba1.png"
      //mostrar bombas
      //escenario.mostrarBombas()
    } else {
      //mostrar numero con cantidad de minas alrededor
      image = "bloqueVacio.jpg"
    }
  }
}