object jugador{
    var position = game.at(0,0)
    
    method esCelda() = false
    method position() = position
    method position(newPos) {
      //game.say(self, "hola")
      position = newPos
    }
    method image() = "bloqueElegido.png"
}
