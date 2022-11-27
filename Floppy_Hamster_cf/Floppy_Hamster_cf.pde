import processing.sound.*;
SoundFile inicio, ambiente, punto, perdiste, ganaste, ouch, pop, boing;
import fisica.*;
import spout.*;

//fisica
FWorld mundo;
FWorld inicio_;

Spout spout;

// --- Variable del puerto para OSC
int PUERTO_OSC = 12345;

// --- BlobObjectTracker clases
Receptor receptor;
Administrador admin, admin2;

//Fuente
PFont texto;

//Imagenes
PImage platMov;
PImage platRot;
PImage platRotLarg;
PImage platAbajo;
PImage platdiagonal;
PImage bbolgrand;
PImage PinchosDer;
PImage PinchosIzq;
PImage PinchosAbajo;
PImage Ancla;
PImage Fondo;
PImage punito;
PImage Cadena;
PImage CircInmG;
PImage CircInmP;
PImage Ascensor;
PImage Caja;
PImage boxPunete;
PImage botonReiniciar;
//secuencia img


ArrayList <PlatRebo> platrebo;
ArrayList <Semilla> semillas;


//Parametros
String estado;
int puntos;


String Estado;

Pantalla p;
int xi, yi, xa, ya, xd, yd, aa;

int begin;
int duracion;
int listo;
int time, tiempo;
boolean termino;

boolean juegoEstaIniciado;
boolean noGanar;


//
Hamster hamster;
Plataforma base1, base2, base3, base4, base6, base7, base8, base11, base12, base13, base14, base17, base0, boton;

FCircle HamInicio;
FBox baseDeInicio;
FBox semiIni;
PImage FondoInicio;
PImage Instruc;
PImage Hamster;
PImage baseinicio;
PImage semillaIni;

// Fondos
PImage [] fondosInstrucciones;
int currentFondo, fondoLoop, fondoDelay, fondoValor;

// -- Reloj
Reloj relojInstrucciones;
Reloj relojFinalizar;

int contador;

void setup() {
  size(1550, 900, P3D);

  spout = new Spout(this);
  spout.createSender("Prueba");

  texto= createFont ("Sketchtica.ttf", 30);

  //fisica
  Fisica.init(this);
  mundo = new FWorld();
  mundo.setEdges();
  inicio_ = new FWorld();
  inicio_.setEdges();

  // --- Inicializo BlobObjectTracker clases
  setupOSC(PUERTO_OSC);
  receptor = new Receptor();
  admin = new Administrador(inicio_);
  admin2 = new Administrador(mundo);

  //Sonido
  inicio = new SoundFile (this, "ambiente1.mp3");
  ambiente = new SoundFile (this, "ambiente.mp3");
  perdiste= new SoundFile (this, "perdiste.mp3");
  ganaste= new SoundFile (this, "ganaste.mp3");
  punto= new SoundFile (this, "punto.mp3");
  ouch= new SoundFile (this, "ouch.mp3");
  pop= new SoundFile (this, "pop.mp3");
  boing= new SoundFile (this, "boing.mp3");


  xi = 340;
  yi = 110;
  xa = 350;
  ya = 25;
  xd = 720;
  yd = 50;
  aa = 100;

  //Contador
  time = duracion = 20;
  termino = false;

  tiempo = listo= 10;

  juegoEstaIniciado = false;
  noGanar= false;

  p = new Pantalla();


  //Imagenes
  platMov = loadImage("Plataforma_Que_Se_Puede_Sacar.png");
  platRot = loadImage("Plataforma_Que_Rota.png");
  platRotLarg = loadImage("PlatGiraLarg.png");
  bbolgrand = loadImage("BolaMasGrande.PNG");
  Fondo = loadImage("fondoPapel.png");
  PinchosAbajo = loadImage("Parte_De_Abajo.png");
  PinchosIzq = loadImage("CostadoIzq.png");
  PinchosDer = loadImage("CostadoDer.png");
  platAbajo = loadImage("Plat_De_Abajo.png");
  Ancla = loadImage("Ancla.png");
  punito = loadImage("punito.PNG");
  CircInmG = loadImage("circInm1.PNG");
  CircInmP = loadImage("circInm3.PNG");
  Cadena = loadImage("cadena.PNG");
  Ascensor = loadImage("ascensor.PNG");
  Caja = loadImage("Caja.PNG");
  boxPunete = loadImage("boxpuñete.PNG");
  botonReiniciar = loadImage("botonReinicio.png");
  platdiagonal = loadImage("platdiagonal.png");


  //Iniciar juego
  estado = "Inicio";
  inicio.loop();
  inicio.amp(0.5);

  FondoInicio = loadImage("inicio.png");

  Hamster = loadImage("HamsterG.png");
  baseinicio= loadImage("baseinicio.png");
  semillaIni= loadImage("semillaIni.png");

  HamInicio = new FCircle(300);
  HamInicio.attachImage(Hamster);
  HamInicio.setPosition(width/2, 400);
  HamInicio.setName("HamIni");
  inicio_.add(HamInicio);

  baseDeInicio = new FBox(250, 60);
  baseDeInicio.setPosition (width/2, 550);
  baseDeInicio.setGrabbable(false);
  baseDeInicio.setStatic(true);
  baseDeInicio.attachImage(baseinicio);
  inicio_.add(baseDeInicio);

  semiIni = new FBox(60, 140);
  semiIni.setPosition(width/2, 700);
  semiIni.setStatic(true);
  semiIni.setName("SemiIni");
  semiIni.attachImage(semillaIni);
  inicio_.add(semiIni);

  relojInstrucciones = new Reloj();
  relojFinalizar = new Reloj();

  semillas = new ArrayList <Semilla> ();
  for (int i = 0; i <3; i++) {
    Semilla s = new Semilla();
    semillas.add(s);
  }

  contador = 0;

  // Sprite fondos
  currentFondo = 0;
  fondoLoop = 8;
  fondoDelay = 0;
  fondoValor = 1;

  fondosInstrucciones = new PImage[fondoLoop];
  for ( int i = 0; i < fondosInstrucciones.length; i ++ ) {
    fondosInstrucciones[i] = loadImage( "fondo" + nf(i, 2) + ".png" );
  }
}

void draw() {
  //background(255);

  println(mouseX, mouseY);
  receptor.actualizar(mensajes);
  receptor.dibujarBlobs(width, height);

  // Eventos de entrada y salida
  for (Blob b : receptor.blobs) {

    if (b.entro) {
      admin.crearPuntero(b);
      println("--> entro blob: " + b.id);
    }
    if (b.salio) {
      admin.removerPuntero(b);
      println("<-- salio blob: " + b.id);
    }

    admin.actualizarPuntero(b);
  }

  relojInstrucciones.actualizar();
  relojFinalizar.actualizar();
  inicio_.step();
  switch(estado) {
  case "Inicio":
    image(FondoInicio, 0, 0);
    perdiste.stop();
    ganaste.stop();

    inicio_.draw();
    break;
  case "Instruc":
    p.dibujar(1);
    ganaste.stop();
    perdiste.stop();
    image(fondosInstrucciones[currentFondo], 0, 0);
    if (fondoDelay == 0) {
      currentFondo = ( currentFondo + fondoValor ) % fondoLoop;
    }
    fondoDelay = ( fondoDelay + 1 ) % 200 ;
    puntos = 0;
    if ( currentFondo == 7) {
      estado = "Sub-estado";
    }
    reciclarVar();
    break;

  case "Sub-estado":
    inicio_.draw();
    image(fondosInstrucciones[7], 0, 0);
    currentFondo = 0;
    // x: 1402 -1465 --- y_203 - 242
    for (Blob b : receptor.blobs) {
      admin.actualizarPuntero(b);
      admin.dibujar();
      if (b.entro) {
        println("entró 1");
        admin.crearPuntero(b);
        println("entró");
      }
      if (b.salio) {
        println("salió 1");
        admin.removerPuntero(b);
        println("salió");
      } else {
        //println("actualizar 1");
      }

      if ( (b.centroidX * width > 1402 && b.centroidX * width < 1465)
        && (b.centroidY * height > 203 && b.centroidY * height < 242) ) {
        //background(255, 0, 0);
        estado = "inicializaJuego";
      }
    }
    break;
  case "inicializaJuego":
    if (!juegoEstaIniciado) {
      iniciarJuego();
      inicio.stop();
      ambiente.loop();
      ambiente.amp(0.2);
      juegoEstaIniciado = true;
      estado = "estaJugando";
    } else {
      juegoEstaIniciado = false;
      mundo.clear();
    }
    break;
  case "estaJugando":
  for (Blob b : receptor.blobs) {

    if (b.entro) {
      admin2.crearPuntero(b);
      println("--> entro blob: " + b.id);
    }
    if (b.salio) {
      admin2.removerPuntero(b);
      println("<-- salio blob: " + b.id);
    }

    admin2.actualizarPuntero(b);
  }

    image(Fondo, 0, 0);
    contador++;
    println(contador);
    if ( contador == 3 ) {
      semillas.get(0).inicializar(540, 510);
      semillas.get(1).inicializar(1097, 527);
      semillas.get(2).inicializar(1497, 360);
    }
    mundo.step();
    mundo.draw();


    //-----------------------------------------------------------

    //Line
    stroke(10);
    line(0, height-100, width, height-100);

    //contador
    if (time > 0) {
      time = duracion -(millis()-begin)/1000;
      textSize(50);
      fill(0);
      textFont(texto);
      textAlign(CENTER);
      text("TIEMPO: "+ time, width/2, 840);
    } else {
      textSize(50);
      fill(0);
      textAlign(CENTER);
      textFont(texto);
      text("TIEMPO: "+ time, width/2, 840);
      termino = true;
      ambiente.stop();
      perdiste.play();
      perdiste.loop();
    }
    text("Puntos:"+puntos, width/2, 880);
    break;

  case "Perdiste":
    p.dibujar(2);
    perdiste.loop();
    perdiste.amp(0.5);
    hamster.morir();
    mundo.remove(hamster);
    relojFinalizar.setTimer(10);

    if ( relojFinalizar.timer <= 1 ) {
      estado= "Inicio";
      for (int i=0; i < semillas.size(); i++)
      {
        semillas.get(i).resetear();
      }
      inicio.loop();
      inicio.amp(0.5);
    }

    tiempo = listo -(millis()-begin)/1000;
    textSize(50);
    fill(0);
    textFont(texto);
    textAlign(CENTER);
    text("TIEMPO: "+ int(relojFinalizar.timer), width/2, 840);

    for (Blob b : receptor.blobs) {
      admin.removerPuntero(b);
      admin.actualizarPuntero(b);
    }
    break;

  case "Ganaste":
  
  if(!noGanar){
    estado= "Inicio";
    //noGanar = true;
      for (int i=0; i < semillas.size(); i++)
      {
        semillas.get(i).resetear();
      }
      inicio.loop();
      inicio.amp(0.5);
    }else {
  noGanar = true;
    p.dibujar(3);
    hamster.morir();
    ganaste.stop();
    perdiste.stop();
    mundo.remove(hamster);
    relojFinalizar.setTimer(10);
    textSize(50);
    fill(0);
    textFont(texto);
    textAlign(CENTER);
    text("TIEMPO: "+ int(relojFinalizar.timer), width/2, 840);

    if ( relojFinalizar.timer <= 1 ) {

      

    for (Blob b : receptor.blobs) {
      admin.removerPuntero(b);
      admin.actualizarPuntero(b);
    }
    }
    }
    
    break;
  }

  //Perder por tiempo
  if (getTermino()) {
    estado = "Perdiste";
    reciclarVar();
  }
  spout.sendTexture();
}



void iniciarJuego() {

  //Personaje
  hamster = new Hamster(80);
  hamster.inicializar(140, 96);
  mundo.add(hamster);

  //Techo
  base0 = new Plataforma(width, 10);
  base0.setGrabbable(true);
  base0.inicializar (width/2, 0);
  base0.setFill(255);
  base0.setNoStroke();
  mundo.add(base0);

  //-------------PINCHOS-------------//

  //Pinchos del lado derecho
  Bordes pinchosder = new Bordes(30, 800);
  pinchosder.inicializar(50, 400);
  pinchosder.attachImage(PinchosIzq);
  mundo.add(pinchosder);

  //Pinchos del lado Izquierdo
  Bordes pinchosizq = new Bordes(30, 800);
  pinchosizq.inicializar(1530, 400);
  pinchosizq.attachImage(PinchosDer);
  mundo.add(pinchosizq);

  //Pinchos de abajo
  Bordes pinchosabajo = new Bordes(1600, 30);
  pinchosabajo.inicializar(800, 785);
  pinchosabajo.attachImage(PinchosAbajo);
  mundo.add(pinchosabajo);

  //-------------PLATAFORMAS QUE GIRAN-------------//

  //Donde esta: Abajo del Hamster
  PlatGira pgira0 = new PlatGira(200, 30);
  pgira0.inicializar(128, 303);
  mundo.add(pgira0.ancla);
  mundo.add(pgira0.movimiento);
  mundo.add(pgira0.revolute);

  //Donde esta: Abajo de la plataforma de arriba
  PlatGira pgira1 = new PlatGira(150, 30);
  pgira1.inicializar(225, 536);
  mundo.add(pgira1.ancla);
  mundo.add(pgira1.movimiento);
  mundo.add(pgira1.revolute);

  //Donde esta: Arriba de la segunda semilla (IZQUIERDA)
  PlatGira pgira2 = new PlatGira(150, 30);
  pgira2.inicializar(1030, 300);
  mundo.add(pgira2.ancla);
  mundo.add(pgira2.movimiento);
  mundo.add(pgira2.revolute);

  //Donde esta: Arriba de la segunda semilla (DERECHA)
  PlatGira pgira3 = new PlatGira(150, 30);
  pgira3.inicializar(1195, 300);
  mundo.add(pgira3.ancla);
  mundo.add(pgira3.movimiento);
  mundo.add(pgira3.revolute);

  //Donde esta:Final, es la larga
  FCircle ancla2 = new FCircle(20);
  ancla2.setPosition(1390, 655);
  ancla2.setStatic(true);
  ancla2.attachImage(Ancla);
  mundo.add(ancla2);
  FBox movimiento2 = new FBox(270, 30);
  movimiento2.setPosition(1390, 655);
  movimiento2.attachImage(platRotLarg);
  movimiento2.setNoStroke();
  mundo.add(movimiento2);
  FRevoluteJoint revolute2 = new FRevoluteJoint (ancla2, movimiento2);
  mundo.add(revolute2);

  //-----------------------------------------------------------

  //Bola demoledora
  BolaDemoler bolDem = new BolaDemoler(70, 70);
  bolDem.inicializar(1030, 400);
  bolDem.bola.attachImage(bbolgrand);
  mundo.add(bolDem.eje);
  mundo.add(bolDem.bola);
  mundo.add(bolDem.cadena);

  //Caja del Puñete
  FBox eje = new FBox(40, 40);
  eje.setStatic(true);
  eje.setPosition(400, 195);
  eje.attachImage(Caja);
  mundo.add(eje);

  //Puñete
  FCircle puño = new FCircle(70);
  puño.setPosition(480, 195);
  puño.attachImage(punito);
  puño.setRotatable(false);
  mundo.add(puño);

  FDistanceJoint cadena = new FDistanceJoint(eje, puño);
  cadena.setLength(350);
  mundo.add(cadena);

  //-----------------------------------------------------------
  //Bola de boliche para catapulta
  //bolBol 2 (9 - 39)
  BolaBol bolaBol2 = new BolaBol(70);
  bolaBol2.inicializar(1440, 170);
  mundo.add(bolaBol2);

  //base 8 (diagonal) /
  base8 = new Plataforma(150, 30);
  base8.setGrabbable(true);
  base8.inicializar (1270, 130);
  base8.setRotation(-7);
  base8.attachImage(platdiagonal);
  mundo.add(base8);

 //Plataforma donde resbala
  base2 = new Plataforma(150, 30);
  base2.setGrabbable(true);
  base2.inicializar (518, 560);
  base2.setRotation(10);
  base2.attachImage(platMov);
  mundo.add(base2);


  //---------PLATAFORMAS DE REBOTE---------//

  platrebo = new ArrayList <PlatRebo> ();
  for (int i = -10; i < 10; i++)
  {
    PlatRebo p = new PlatRebo(160, 40);
    p.inicializar(i*250, 747);
    mundo.add(p);
    platrebo.add(p);
  }

  //---------CADENA---------//
  FCircle cir1 = new FCircle(30);
  cir1.setPosition(xi, yi); //340,110
  cir1.attachImage(Cadena);
  cir1.setRotatable(false);
  //cir1.setStatic(true);
  cir1.setGrabbable(false);
  mundo.add(cir1);

  FCircle cir2 = new FCircle(30);
  cir2.setPosition(xi, yi-30);
  cir2.attachImage(Cadena);
  cir1.setRotatable(false);
  mundo.add(cir2);

  FCircle cir3 = new FCircle(30);
  cir3.setPosition(xa, ya);//350,30
  cir3.attachImage(Cadena);
  cir1.setRotatable(false);
  mundo.add(cir3);

  FCircle cir4 = new FCircle(30);
  cir4.setPosition(xa+30, ya);
  cir4.attachImage(Cadena);
  cir1.setRotatable(false);
  mundo.add(cir4);

  FCircle cir5 = new FCircle(30);
  cir5.setPosition(xa+60, ya);
  cir5.attachImage(Cadena);
  mundo.add(cir5);

  FCircle cir6 = new FCircle(30);
  cir6.setPosition(xa+90, ya);
  cir6.attachImage(Cadena);
  mundo.add(cir6);

  FCircle cir7 = new FCircle(30);
  cir7.setPosition(xa+120, ya);
  cir7.attachImage(Cadena);
  mundo.add(cir7);
  //-------------------------------------------------------------------------------------------------
  FCircle cir8 = new FCircle(30);
  cir8.setPosition(xa+150, ya);
  cir8.attachImage(Cadena);
  //mundo.add(cir8);

  FCircle cir9 = new FCircle(30);
  cir9.setPosition(xa+150, ya);
  cir9.attachImage(Cadena);
  mundo.add(cir9);
  //-------------------------------------------------------------------------------------------------
  FCircle cir10 = new FCircle(30);
  //cir10.setStatic(true);
  cir10.setPosition(xa+210, ya);
  cir10.attachImage(Cadena);
  //mundo.add(cir10);

  FCircle cir11 = new FCircle(30);
  cir11.setPosition(xa+180, ya);
  cir11.attachImage(Cadena);
  mundo.add(cir11);

  FCircle cir12 = new FCircle(30);
  //cir12.setPosition(xa+270, ya);
  cir12.setPosition(xa+240, ya);
  cir12.attachImage(Cadena);
  mundo.add(cir12);

  FCircle cir13 = new FCircle(30);
  //cir13.setPosition(xa+300, ya);
  cir13.setPosition(xa+270, ya);
  cir13.attachImage(Cadena);
  mundo.add(cir13);

  FCircle cir14 = new FCircle(30);
  cir14.setPosition(xd-30, ya);//680,50
  cir14.attachImage(Cadena);
  mundo.add(cir14);

  FCircle cir15 = new FCircle(30);
  cir15.setPosition(xd, yd);//710,50 // cambio 750 (xd, yd)
  //cir15.setStatic(true);
  cir15.attachImage(Cadena);
  mundo.add(cir15);

  FCircle cir16 = new FCircle(30);
  cir16.setPosition(xd, yd+30);
  cir16.attachImage(Cadena);
  mundo.add(cir16);

  FCircle cir17 = new FCircle(30);
  cir17.setPosition(xd, yd+60);
  cir17.attachImage(Cadena);
  mundo.add(cir17);

  FCircle cir18 = new FCircle(30);
  cir18.setPosition(xd, yd+90);
  cir18.attachImage(Cadena);
  mundo.add(cir18);

  FCircle cir19 = new FCircle(30);
  cir19.setPosition(xd, yd+120);
  cir19.attachImage(Cadena);
  mundo.add(cir19);

  FCircle cir20= new FCircle(30);
  cir20.setPosition(xd, yd+150);
  cir20.attachImage(Cadena);
  mundo.add(cir20);

  FCircle cir21= new FCircle(30);
  cir21.setPosition(xd, yd+180);
  cir21.attachImage(Cadena);
  mundo.add(cir21);

  FCircle cir22= new FCircle(30);
  cir22.setPosition(xd, yd+210);
  cir22.attachImage(Cadena);
  mundo.add(cir22);

  FCircle cir23= new FCircle(30);
  cir23.setPosition(xd, yd+240);
  cir23.attachImage(Cadena);
  mundo.add(cir23);

  FCircle cir24= new FCircle(30);
  cir24.setPosition(xd, yd+270);
  cir24.attachImage(Cadena);
  mundo.add(cir24);

  FCircle cir25= new FCircle(30);
  cir25.setPosition(xd, yd+300);
  cir25.attachImage(Cadena);
  mundo.add(cir25);

  FCircle cir26= new FCircle(30);
  cir26.setPosition(xd, yd+330);
  cir26.attachImage(Cadena);
  mundo.add(cir26);

  FCircle cir27= new FCircle(30);
  cir27.setPosition(xd, yd+360);
  cir27.attachImage(Cadena);
  mundo.add(cir27);

  FCircle cir28= new FCircle(30);
  cir28.setPosition(xd, yd+390);
  cir28.attachImage(Cadena);
  mundo.add(cir28);

  FCircle cir29= new FCircle(30);
  cir29.setPosition(xd, yd+420);
  cir29.attachImage(Cadena);
  mundo.add(cir29);

  FCircle cir30= new FCircle(30);
  cir30.setPosition(xd, yd+450);
  cir30.attachImage(Cadena);
  mundo.add(cir30);

  //--------------------------------------
  //Circulos grandes arriba
  //1
  FCircle polea1 = new FCircle(70);
  polea1.setStatic(true);
  polea1.setPosition(388, 76);
  polea1.setGrabbable(false);
  polea1.attachImage(CircInmG);
  mundo.add(polea1);
  //2
  FCircle polea2 = new FCircle(70);
  polea2.setStatic(true);
  polea2.setGrabbable(false);
  polea2.setPosition(660, 76);
  polea2.attachImage(CircInmG);
  mundo.add(polea2);

  //-----------------------------------
  //para cadena
  //junto a plataforma
  FCircle cirIzq0= new FCircle(30);
  cirIzq0.setPosition(614, 646);
  cirIzq0.attachImage(Cadena);
  mundo.add(cirIzq0);

  FCircle cirIzq= new FCircle(30);
  cirIzq.setPosition(614, 676);
  cirIzq.attachImage(Cadena);
  mundo.add(cirIzq);

  FCircle cirDer0= new FCircle(30);
  cirDer0.setPosition(803, 646);
  cirDer0.attachImage(Cadena);
  mundo.add(cirDer0);

  FCircle cirDer= new FCircle(30);
  cirDer.setPosition(803, 676);
  cirDer.attachImage(Cadena);
  mundo.add(cirDer);

  //Plataforma para el ascensor
  FBox box1 = new FBox(170, 30);
  box1.setPosition(702, 676);
  box1.attachImage (Ascensor);
  mundo.add(box1);

  //bola de boliche
  FCircle bolaPolea = new FCircle (50);
  //bolaPolea.setPosition(340, 160);
  bolaPolea.setPosition(340, 130);
  bolaPolea.setDensity(30);
  bolaPolea.attachImage (bbolgrand);
  mundo.add(bolaPolea);


  //------------------
  //Uniones
  FDistanceJoint cadenaPol0 = new FDistanceJoint(bolaPolea, cir1);
  cadenaPol0.setLength(30);
  cadenaPol0.setFill(231, 209, 146);
  mundo.add(cadenaPol0);


  FDistanceJoint cadenaPol1 = new FDistanceJoint(cir1, cir2);
  cadenaPol1.setLength(30);
  cadenaPol1.setFill(231, 209, 146);
  mundo.add(cadenaPol1);

  FDistanceJoint cadenaPol2 = new FDistanceJoint(cir2, cir3);
  cadenaPol2.setLength(30);
  cadenaPol2.setFill(231, 209, 146);
  mundo.add(cadenaPol2);

  FDistanceJoint cadenaPol3 = new FDistanceJoint(cir3, cir4);
  cadenaPol3.setLength(30);
  cadenaPol3.setFill(231, 209, 146);
  mundo.add(cadenaPol3);

  FDistanceJoint cadenaPol4 = new FDistanceJoint(cir4, cir5);
  cadenaPol4.setLength(30);
  cadenaPol4.setFill(231, 209, 146);
  mundo.add(cadenaPol4);

  FDistanceJoint cadenaPol5 = new FDistanceJoint(cir5, cir6);
  cadenaPol5.setLength(30);
  cadenaPol5.setFill(231, 209, 146);
  mundo.add(cadenaPol5);

  FDistanceJoint cadenaPol6 = new FDistanceJoint(cir6, cir7);
  cadenaPol6.setLength(30);
  cadenaPol6.setFill(231, 209, 146);
  mundo.add(cadenaPol6);

  FDistanceJoint cadenaPol7 = new FDistanceJoint(cir7, cir8);
  cadenaPol7.setLength(30);
  cadenaPol7.setFill(231, 209, 146);
  //mundo.add(cadenaPol7);

  FDistanceJoint cadenaPol8 = new FDistanceJoint(cir8, cir9);
  cadenaPol8.setLength(30);
  cadenaPol8.setFill(231, 209, 146);
  //mundo.add(cadenaPol8);

  FDistanceJoint cadenaPol9 = new FDistanceJoint(cir9, cir10);
  cadenaPol9.setLength(30);
  cadenaPol9.setFill(231, 209, 146);
  //mundo.add(cadenaPol9);

  FDistanceJoint cadenaPol10 = new FDistanceJoint(cir10, cir11);
  cadenaPol10.setLength(30);
  cadenaPol10.setFill(231, 209, 146);
  //mundo.add(cadenaPol10);
  //----------------------------------------------------------------------------------------------
  FDistanceJoint cadenaPol111 = new FDistanceJoint(cir7, cir9);
  cadenaPol10.setLength(30);
  cadenaPol10.setFill(231, 209, 146);
  mundo.add(cadenaPol111);

  FDistanceJoint cadenaPol112 = new FDistanceJoint(cir9, cir11);
  cadenaPol10.setLength(30);
  cadenaPol10.setFill(231, 209, 146);
  mundo.add(cadenaPol112);
  //----------------------------------------------------------------------------------------------
  FDistanceJoint cadenaPol11 = new FDistanceJoint(cir11, cir12);
  cadenaPol11.setLength(30);
  cadenaPol11.setFill(231, 209, 146);
  mundo.add(cadenaPol11);

  FDistanceJoint cadenaPol12 = new FDistanceJoint(cir12, cir13);
  cadenaPol12.setLength(30);
  cadenaPol12.setFill(231, 209, 146);
  mundo.add(cadenaPol12);

  FDistanceJoint cadenaPol13 = new FDistanceJoint(cir13, cir14);
  cadenaPol13.setLength(30);
  cadenaPol13.setFill(231, 209, 146);
  mundo.add(cadenaPol13);

  FDistanceJoint cadenaPol14 = new FDistanceJoint(cir14, cir15);
  cadenaPol14.setLength(30);
  cadenaPol14.setFill(231, 209, 146);
  mundo.add(cadenaPol14);

  FDistanceJoint cadenaPol15 = new FDistanceJoint(cir15, cir16);
  cadenaPol15.setLength(30);
  cadenaPol15.setFill(231, 209, 146);
  mundo.add(cadenaPol15);

  FDistanceJoint cadenaPol16 = new FDistanceJoint(cir16, cir17);
  cadenaPol16.setLength(30);
  cadenaPol16.setFill(231, 209, 146);
  mundo.add(cadenaPol16);

  FDistanceJoint cadenaPol17 = new FDistanceJoint(cir17, cir18);
  cadenaPol17.setLength(30);
  cadenaPol17.setFill(231, 209, 146);
  mundo.add(cadenaPol17);

  FDistanceJoint cadenaPol18 = new FDistanceJoint(cir18, cir19);
  cadenaPol18.setLength(30);
  cadenaPol18.setFill(231, 209, 146);
  mundo.add(cadenaPol18);

  FDistanceJoint cadenaPol19 = new FDistanceJoint(cir19, cir20);
  cadenaPol19.setLength(30);
  cadenaPol19.setFill(231, 209, 146);
  mundo.add(cadenaPol19);

  FDistanceJoint cadenaPol20 = new FDistanceJoint(cir20, cir21);
  cadenaPol20.setLength(30);
  cadenaPol20.setFill(231, 209, 146);
  mundo.add(cadenaPol20);

  FDistanceJoint cadenaPol21 = new FDistanceJoint(cir21, cir22);
  cadenaPol21.setLength(30);
  cadenaPol21.setFill(231, 209, 146);
  mundo.add(cadenaPol21);

  FDistanceJoint cadenaPol22 = new FDistanceJoint(cir22, cir23);
  cadenaPol22.setLength(30);
  cadenaPol22.setFill(231, 209, 146);
  mundo.add(cadenaPol22);

  FDistanceJoint cadenaPol23 = new FDistanceJoint(cir23, cir24);
  cadenaPol23.setLength(30);
  cadenaPol23.setFill(231, 209, 146);
  mundo.add(cadenaPol23);

  FDistanceJoint cadenaPol24 = new FDistanceJoint(cir24, cir25);
  cadenaPol24.setLength(30);
  cadenaPol24.setFill(231, 209, 146);
  mundo.add(cadenaPol24);

  FDistanceJoint cadenaPol25 = new FDistanceJoint(cir25, cir26);
  cadenaPol25.setLength(30);
  cadenaPol25.setFill(231, 209, 146);
  mundo.add(cadenaPol25);

  FDistanceJoint cadenaPol26 = new FDistanceJoint(cir26, cir27);
  cadenaPol26.setLength(30);
  cadenaPol26.setFill(231, 209, 146);
  mundo.add(cadenaPol26);

  FDistanceJoint cadenaPol27 = new FDistanceJoint(cir27, cir28);
  cadenaPol27.setLength(30);
  cadenaPol27.setFill(231, 209, 146);
  mundo.add(cadenaPol27);

  FDistanceJoint cadenaPol28 = new FDistanceJoint(cir28, cir29);
  cadenaPol28.setLength(30);
  cadenaPol28.setFill(231, 209, 146);
  mundo.add(cadenaPol28);

  FDistanceJoint cadenaPol29 = new FDistanceJoint(cir29, cir30);
  cadenaPol29.setLength(30);
  cadenaPol29.setFill(231, 209, 146);
  mundo.add(cadenaPol29);

  FDistanceJoint cadenaPol30 = new FDistanceJoint(cir30, cirIzq0);
  cadenaPol30.setLength(150);
  cadenaPol30.setFill(231, 209, 146);
  mundo.add(cadenaPol30);

  FDistanceJoint cadenaPol31 = new FDistanceJoint(cirIzq0, cirIzq);
  cadenaPol31.setLength(30);
  cadenaPol31.setFill(231, 209, 146);
  mundo.add(cadenaPol31);

  FDistanceJoint cadenaPol32 = new FDistanceJoint(cirIzq, box1);
  cadenaPol32.setLength(30);
  cadenaPol32.setFill(231, 209, 146);
  mundo.add(cadenaPol32);

  FDistanceJoint cadenaPol33 = new FDistanceJoint(box1, cirDer);
  cadenaPol33.setLength(30);
  cadenaPol33.setFill(231, 209, 146);
  mundo.add(cadenaPol33);

  FDistanceJoint cadenaPol34 = new FDistanceJoint(cirDer, cirDer0);
  cadenaPol34.setLength(30);
  cadenaPol34.setFill(231, 209, 146);
  mundo.add(cadenaPol34);

  FDistanceJoint cadenaPol35 = new FDistanceJoint(cirDer0, cir30);
  cadenaPol35.setLength(150);
  cadenaPol35.setFill(231, 209, 146);
  mundo.add(cadenaPol35);

  //-----------------------------------------------------------------------------------------------------------
  //Boton para reiniciar si no podes seguir jugando
  boton = new Plataforma(60, 60);
  boton.inicializar (1520, 850);
  boton.attachImage(botonReiniciar);
  mundo.add(boton);
}



//----------------------------------------------------------------------------------------
void contactStarted(FContact contact) {

  FBody _cuerpo1 = contact.getBody1();
  FBody _cuerpo2 = contact.getBody2();

  /////////////////////////////SALTAR/////////////////////////////
  if (puntos>2 &&(_cuerpo1.getName() == "hamster" && _cuerpo2.getName() == "platAbajo")
    || (_cuerpo2.getName() == "hamster" && (_cuerpo1.getName() == "platAbajo" ))) {
    boing.play();
    boing.amp(0.7);
  }

  /////////////////////////////SUMAR PUNTOS/////////////////////////////
  //Si puntos es igual a tres, funcion ganar
  if (puntos == 3) {

    //Se para sonido ambiente y perdiste
    ambiente.stop();
    perdiste.stop();

    //empieza sonido ganaste
    ganaste.loop();
    ganaste.amp(0.5);
    estado= "Ganaste";
  }



  if (_cuerpo1.getName() == "hamster" && _cuerpo2.getName() == "semilla") {
    ((Semilla)_cuerpo2).agarrar();
    punto.play();
  } else if (_cuerpo2.getName() == "hamster" && _cuerpo1.getName() == "semilla") {
    ((Semilla) _cuerpo1).agarrar();
    punto.play();
  }


  /////////////////////////////PERDER/////////////////////////////
  else if ((_cuerpo1.getName() == "hamster" && _cuerpo2.getName() == "pinchos")
    || (_cuerpo2.getName() == "hamster" && (_cuerpo1.getName() == "pinchos" ))) {
    if (hamster.vivo) {
      //println("colision");

      //Se para sonido ambiente
      ambiente.stop();

      //Sonido ouch
      ouch.play();
      ouch.amp(0.2);

      //empieza sonido trist

      estado="Perdiste";
    }
  } else if ((_cuerpo1.getName() == "HamIni" && _cuerpo2.getName() == "SemiIni")
    || (_cuerpo2.getName() == "HamIni" && (_cuerpo1.getName() == "SemiIni" ))) {
    estado="Instruc";
  }
}




//------------------------------------------

//para tiempo
void setBegin(int tiempo_) {
  begin = tiempo_;
}

boolean getTermino() {
  return termino;
}

void reciclarVar() {
  time = duracion = 500;
  HamInicio.setPosition(width/2, 400);
  begin=millis();
  termino=false;
  contador = 0;
}

void reiniciarContador() {
  contador = 0;
}
