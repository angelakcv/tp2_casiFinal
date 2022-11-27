
class Plat_Circular extends FCircle
{
 
  
  Plat_Circular(float _w)
  {
   
    super(_w);
  }
  
  void inicializar(float _x, float _y)
  {
   
    setPosition(_x, _y);
    setName ("platcirc");
    setStatic(true);
    //setGrabbable(false);
  }
}
