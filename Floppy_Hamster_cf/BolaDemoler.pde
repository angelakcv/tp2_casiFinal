class BolaDemoler
{
  FBox eje;
  FCircle bola;
  FDistanceJoint cadena;

  BolaDemoler(float _w, float _h)
  {
    eje = new FBox(_w, _h);
    bola = new FCircle(50);
    cadena = new FDistanceJoint(eje, bola);
  }

  void inicializar(float _x, float _y)
  {
    eje.setPosition(_x, _y);
    eje.setFill(173, 69, 17);
    //eje.setNoFill();
    eje.setStatic(true);
    eje.attachImage(Caja);
    bola.setPosition(895,335);
    bola.setDensity(20);
   
    cadena.setLength(150);
  }
}
