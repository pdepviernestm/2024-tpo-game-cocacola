object jugador{
    var posX = 0
    var posY = 0
    const position = game.at(posX,posY)

    method getPosX() = posX
    method getPosY() = posY
    
    method esCelda() = false
    method position() = position
    method position(x, y) {
      //game.say(self, "hola")
      posX = x
      posY = y
    }
    method image() = "bloqueElegido.png"
}
