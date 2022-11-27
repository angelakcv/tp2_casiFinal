class Pantalla {
  int nump;
  //arreglo de 3 fotos para el fondo
  int cant = 4;
  PImage [] screens = new PImage [cant];

  Pantalla() {

    //cargar las fotos del arreglo, pantallas
    for (int p=0; p<cant; p++) {
      screens[p] = loadImage("pantalla"+p+".png");
    }
  }
  void dibujar(int num) {
    nump = num;
    image(screens[nump], 0, 0);
  }
}
