object pepita{
    var position = game.at(0,0)

    method position() = position
    method position(newPos) {
      //game.say(self, "hola")
    position = newPos
  }

    method image() = "pepita.png"
}

object bandera {
    const position = game.at(50,10)

    method position() = position

    method image() = "bandera.png"

    method reaccionColision() = 2
}

object bomba {
  const position = game.at(2,15)

    method position() = position

    method image() = "bomba.png"

    method reaccionColision() = 3
}