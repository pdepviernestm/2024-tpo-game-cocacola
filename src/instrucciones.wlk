import wollok.game.*
import escenario.*
object instrucciones {
  method mostrar () {
    game.boardGround("instrucciones.png")

    keyboard.num1().onPressDo({
      escenario.setNivel(1)
      escenario.inicializar()
    })

    keyboard.num2().onPressDo({
      escenario.setNivel(2)
      escenario.inicializar()
    })

    keyboard.num3().onPressDo({
      escenario.setNivel(3)
      escenario.inicializar()
    })
  }
}