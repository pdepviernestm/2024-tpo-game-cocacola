import celda.*
import escenario.*


//talvez sea mejor ponerlos como objetos en vez de clases
//carajomierda
class CeldaEspecial inherits Celda {
  override method liberarCelda() {
    super()
    self.activarPoder()
  }
  method activarPoder () 
}
class CeldaRevelaBomba inherits CeldaEspecial {
  override method activarPoder () {
    var celdaElegida = self.elegirCeldaAleatoria()
    celdaElegida.revelarBomba()   
  }

 method elegirCeldaAleatoria() = escenario.celdasConBomba().get(0.randomUpTo(escenario.celdasConBomba().size()-1))
}

class CeldaExpansiva inherits CeldaEspecial {
  override method activarPoder () {
    //agregar mas celdas alrededor
      celdasAlrededor.add(game.getObjectsIn(position.up(2)))
      celdasAlrededor.add(game.getObjectsIn(position.down(2)))
      celdasAlrededor.add(game.getObjectsIn(position.left(2)))
      celdasAlrededor.add(game.getObjectsIn(position.right(2)))
      celdasAlrededor.add(game.getObjectsIn(position.right(2).up(1)))
      celdasAlrededor.add(game.getObjectsIn(position.right(1).down(1)))
      celdasAlrededor.add(game.getObjectsIn(position.left(1).up(1)))
      celdasAlrededor.add(game.getObjectsIn(position.left(1).down(1)))
      self.getCeldasAlrededor(2)
  }
}

//la idea es poder agregar otros metodos y 
