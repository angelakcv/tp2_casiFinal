class Bordes extends FBox {
  Boolean vivo;
  Bordes(float _w,float _h) {
    super(_w,_h);
  }

  void inicializar(float _x, float _y) {
    setName ("pinchos");
    setPosition(_x, _y);
    setStatic(true);
    setGrabbable(false);
  }

}
