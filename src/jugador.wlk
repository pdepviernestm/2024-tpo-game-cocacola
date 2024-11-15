object jugador{
    var position = game.at(8,8)
    
    method esCelda() = false
    method position() = position
    method position(newPos) {
      //game.say(self, "hola")
      position = newPos
    }
    method image() = "bloqueElegido.png"
}
