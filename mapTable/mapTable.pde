import TUIO.*; //<>//
import controlP5.*;
import processing.video.*;

TuioProcessing tuioClient;
ControlP5 cp5;

Movie video;
PImage imagen;

boolean verbose = false; // Imprime mensajes de Debug
boolean callback = true; // Actualiza solo luego de un callback
boolean cali = false; // Calibración manual
int an, al, x, y, z;
boolean centro = true;
boolean rotar = true;
boolean invertir;
boolean siVideo, siImagen;
float fov;
float asp;
float cameraZ;

void setup() {
  fullScreen(P3D);
  smooth(4);

  an = 100;
  al = 100;
  x = 0;
  y = (int)height/2;
  fov = PI/3.0;
  asp = 0.4;
  cameraZ = (height/2.0) / tan(fov/2.0);

  cp5 = new ControlP5(this);

  cp5.addButton("seleccionar")
    .setValue(0)
    .setPosition(30, 40)
    .setSize(240, 20)
    .setCaptionLabel("cargar archivo")
    ;
  cp5.addSlider("x")
    .setPosition(30, 70)
    .setWidth(240)
    .setHeight(20)
    .setRange(-width, width)
    .setColorLabel(0)
    .setCaptionLabel("x | flechas izquierda-derecha")
    .setValue(0)
    ;
  cp5.addSlider("y")
    .setPosition(30, 100)
    .setWidth(240)
    .setHeight(20)
    .setRange(0, height)
    .setColorLabel(0)
    .setCaptionLabel("y | flechas arriba-abajo")
    .setValue((int)height/2)
    ;
  cp5.addSlider("an")
    .setPosition(30, 130)
    .setWidth(240)
    .setHeight(20)
    .setRange(0, width)
    .setColorLabel(0)
    .setCaptionLabel("ancho | teclas A-D")
    .setValue(100)
    ;
  cp5.addSlider("al")
    .setPosition(30, 160)
    .setWidth(240)
    .setHeight(20)
    .setRange(0, height)
    .setColorLabel(0)
    .setCaptionLabel("alto | teclas W-S")
    .setValue(100)
    ;
  cp5.addSlider("z")
    .setPosition(30, 190)
    .setWidth(240)
    .setHeight(20)
    .setRange(0, 800)
    .setColorLabel(0)
    .setCaptionLabel("resolucion")
    .setValue(0)
    ;
  cp5.addToggle("centro")
    .setPosition(30, 220)
    .setSize(50, 20)
    .setColorLabel(0)
    .setMode(ControlP5.SWITCH)
    ;
  cp5.addToggle("invertir")
    .setPosition(100, 220)
    .setSize(50, 20)
    .setColorLabel(0)
    .setMode(ControlP5.SWITCH)
    ;
  cp5.addToggle("rotar")
    .setPosition(170, 220)
    .setSize(50, 20)
    .setColorLabel(0)
    .setMode(ControlP5.SWITCH)
    ;
  cp5.addSlider("asp")
    .setPosition(30, 260)
    .setWidth(240)
    .setHeight(20)
    .setRange(0, 5)
    .setColorLabel(0)
    .setCaptionLabel("aspecto")
    .setValue(0.4)
    ;

  cp5.hide();

  tuioClient  = new TuioProcessing(this);
}

void draw() {
  if (cali) {
    background(200);
    cursor();
  } else {
    background(0);
    noCursor();
  }

  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  if (tuioObjectList.size() == 0) {
    if (siVideo) {
      video.pause();
    }
  }
  for (int i=0; i<tuioObjectList.size(); i++) {
    TuioObject tobj = tuioObjectList.get(i);
    pushMatrix();

    perspective(fov, asp, cameraZ/10.0, cameraZ*10.0);

    if (invertir == false) {
      translate(map(tobj.getScreenX(width), 0, width, z, width-z), 0);
    } else {
      translate(map(tobj.getScreenX(width), 0, width, width-z, z), 0);
    }

    if (invertir == false) {
      translate(x, y);
    } else {
      translate(-x, y);
    }

    if (rotar) {
      rotateY(radians( map( tobj.getAngleDegrees(), 0, 360, 360, 0) ));
    } else {
      rotate(radians(0));
    }

    if (centro) {
      rectMode(CENTER);
      imageMode(CENTER);
    } else {
      rectMode(CORNER);
      imageMode(CORNER);
    }
    if (cali) {
      noFill();
      stroke(0);
      strokeCap(PROJECT);
      strokeWeight(2);
      if (centro) {
        line(0, -20, 0, 20);
        line(-20, 0, 20, 0);
      } else {
        line(an/2, al/2-20, an/2, al/2+20);
        line(an/2-20, al/2, an/2+20, al/2);
      }
      rect(0, 0, an, al);
    } else {
      noStroke();
      fill(255);
      rect(0, 0, an, al);
      if (siVideo) {
        image(video, 0, 0, an, al);
      }
      if (siImagen) {
        image(imagen, 0, 0, an, al);
      }
    }
    popMatrix();

    if (siVideo) {
      video.play();
    }
  }

  perspective(PI/3.0, float(width)/float(height), cameraZ/10.0, cameraZ*10.0);

  if (cali) {
    if (siVideo) {
      video.pause();
    }
    cp5.show();

    pushStyle();
    strokeWeight(2);
    noFill();
    if (mousePressed) {
      stroke(2);
      strokeWeight(4);
      ellipse(mouseX+5, mouseY+10, 40, 40);
      strokeWeight(2);
      ellipse(mouseX+5, mouseY+10, 30, 30);
    } else {
      stroke(40, 220);
      ellipse(mouseX+5, mouseY+10, 28, 28);
      ellipse(mouseX+5, mouseY+10, 20, 20);
    }
    popStyle();
  } else {
    if (siVideo) {
      video.play();
    }
    cp5.hide();
  }

  cameraZ = (height/2.0) / tan(fov/2.0);
}