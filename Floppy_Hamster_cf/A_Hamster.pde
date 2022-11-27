class Hamster extends FCircle {
  Boolean vivo;
  PImage ham;
  Hamster(float _r) {
    super(_r);
    vivo=true;
    ham= loadImage("hamster.png");
  }

  void inicializar(float _x, float _y) {
    vivo=true;
    setName ("hamster");
    setPosition(_x, _y);
    //setDensity(20);
    attachImage(ham);
    
  }

  void morir() {
    vivo = false;
  }
}
