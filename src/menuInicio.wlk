import wollok.game.*
import instrucciones.*
object menuInicio {
  var image = "menuInicio.png"
  //var position = game.center()

  method position() = game.center()
  method mostrar() {
    game.addVisual(self)
    keyboard.enter().onPressDo({
      game.removeVisual(self)

    })
  }
}