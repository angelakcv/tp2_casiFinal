class Puntero {

  float id;
  float x;
  float y;

  float ancho, alto;

  FWorld mundo; // puntero al mundo de fisica que está en el main


  FBox body;

  FMouseJoint mj;

  Puntero(FWorld _mundo, float _id, float _x, float _y) {
    mundo = _mundo;
    id = _id;
    x = _x;
    y = _y;
    ancho=150;
    alto=30;
    body = new FBox(ancho, alto);
    body.setPosition(x, y);
    
    
    //body.attachImage(platMov);
    body.setRotatable(false);
    
    
    mj = new FMouseJoint(body, x, y);

    mundo.add(body);
    mundo.add(mj);
  }

  void setTarget(float nx, float ny) {
    mj.setTarget(nx, ny);
  }

  void setID(float id) {
    this.id = id;
  }

  void borrar() {
    mundo.remove(mj);
    mundo.remove(body);
  }

  void dibujar() {

    pushStyle();
    noFill();
    stroke(255, 0, 0);

    rect(body.getX(), body.getY(), ancho, alto);
    popStyle();
  }
}
