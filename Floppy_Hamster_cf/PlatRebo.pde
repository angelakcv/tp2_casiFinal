class PlatRebo extends FBox {

  PlatRebo(float _w, float _h) {

    super(_w, _h);
  }

  void inicializar(float _x, float _y) {
    setName("platAbajo");
    setPosition(_x, _y);
    setStatic(true);
    setRestitution(2);
    attachImage(platAbajo);
  }
}
