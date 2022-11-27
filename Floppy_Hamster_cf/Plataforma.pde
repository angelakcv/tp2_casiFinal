
class Plataforma extends FBox
{

  
  Plataforma(float _w, float _h){
   
    super(_w, _h);
  }
  
  void inicializar(float _x, float _y){

    setPosition(_x, _y);
    setName ("plataforma");
    setGrabbable(false);
    setStatic(true);
  }
}
