class PlatGira
{
  FCircle ancla;
  FBox movimiento;
  FRevoluteJoint revolute;

  PlatGira(float _w, float _h)
  {
    ancla = new FCircle(20);
    movimiento = new FBox(_w, _h);
    revolute = new FRevoluteJoint (ancla, movimiento);
  }

  void inicializar(float _x, float _y)
  {
    ancla.setPosition(_x, _y);
    ancla.setStatic(true);
    ancla.attachImage(Ancla);
    ancla.setGrabbable(false); 

    movimiento.setPosition(_x, _y);
    movimiento.attachImage(platRot);
    movimiento.setName ("plataforma");
  }
}
