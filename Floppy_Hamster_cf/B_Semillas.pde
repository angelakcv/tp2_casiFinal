class Semilla extends FBox {
  boolean agarrada =false;
  PImage semilla;
  Semilla() {
    super(30, 60);
    semilla= loadImage("semilla.png");
  }

  void inicializar(float _x, float _y) {
    setName ("semilla");
    setPosition(_x, _y);
    setSensor(true);
    setStatic(true);
    attachImage(semilla);
    setGrabbable(false);
    setRotatable(false);
    mundo.add(this);
  }

  void agarrar() {
    //println("entra");
    //si la semilla no fue agarrada, si esta agarrada, se suman los puntos
    if (!agarrada) {
    //println("entra x 2");
      agarrada = true;
      puntos++;
      mundo.remove(this);
    }
  }

  void resetear() {
    //se resetean las semillas, si habian quedado se borra, y se vuelven a dibujar
    mundo.remove(this);
    //mundo.add(this);
    agarrada = false;
  }
}
