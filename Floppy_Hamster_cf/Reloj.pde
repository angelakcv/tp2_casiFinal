/*
-- Clase RELOJ: objeto para controlar el tiempo y setear timers en seg. y no en frames.
 */
class Reloj {

  float tiempoAnterior, tiempoDelta;
  float timer;
  int r_tiempoDelta, r_tiempoAnterior, r_timer;

  Reloj() {
  }

  void actualizar() {
    tiempoDelta = (millis()-tiempoAnterior)/1000.0;
    tiempoAnterior = millis();
    if (timer > 0) {
      timer -= tiempoDelta;
    }
  }

  void resetear() {
    timer = 0;
  }

  void setTimer(float segundos) {
    if (terminoTiempo()) {
      timer = segundos;
    }
  }

  boolean terminoTiempo() {
    return timer <= 0;
  }
}
