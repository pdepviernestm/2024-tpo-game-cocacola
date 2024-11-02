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
    var celdaElegida = self.elegirCeldaSegunCriterio(criterioBomba)
    //falta esto metodo
    celdaElegida.revelarBomba()
  }

 method elegirCeldaSegunCriterio(criterio) = escenario.celdas().find({celda => criterio.cumple(celda) && not celda.abierto()})
}

class CeldaExplosiva inherits CeldaEspecial {
  override method activarPoder () {
    //deberia liberar la celdas alrededor de un radio de 3
  }
}
object criterioBomba {
  method cumple(celda) = celda.tieneBomba()
}

//la idea es poder agregar otros metodos y 