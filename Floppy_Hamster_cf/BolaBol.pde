class BolaBol extends FCircle {

  BolaBol(float _r) {
    super(_r);
  }

  void inicializar(float _x, float _y) {
    setPosition(_x, _y);
    setDensity(20);
    attachImage(bbolgrand);
  }
}
