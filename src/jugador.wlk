object jugador{
    var position = game.at(8,8)
    
    method esCelda() = false
    method position() = position
    method position(newPos) {
      //game.say(self, "hola")
      position = newPos
    }
    method image() = "bloqueElegido.png"

    // var posX = 0
    // var posY = 0
    // var position = game.at(posX,posY)
    // method getPosX() = posX
    // method getPosY() = posY
    // method position(x, y) {
    //   //game.say(self, "hola")
    //   posX = x
    //   posY = y
    // }   
}
