public void keyPressed() {
  if (key == 'c' || key == 'C') {
    cali = !cali;
  }

  if (keyCode == RIGHT) {
    x++;
  } else if (keyCode == LEFT) {
    x--;
  }
  if (keyCode == UP) {
    y--;
  }
  if (keyCode == DOWN) {
    y++;
  }
  if (key == 'w' || key == 'W') {
    al++;
  } else if (key == 's' || key == 'S') {
    al--;
  }
  if (key == 'a' || key == 'A') {
    an--;
  } else if (key == 'd' || key == 'D') {
    an++;
  }
}

public void movieEvent(Movie m) {
  m.read();
}

public void seleccionar() {
  if (cali) {
    selectInput("Cargar un Archivo:", "fileSelected");
  }
}

public void fileSelected(File selection) {
  if (selection != null) {
    String sub = selection.getAbsolutePath();
    String formato = sub.substring(sub.length()-3, sub.length());

    if (formato.equals("mp4") || formato.equals("mov")) {
      video = new Movie(this, selection.getAbsolutePath());
      video.loop();
      siVideo = true;
      siImagen = false;
    } else if (formato.equals("jpg") || formato.equals("png") ||
      formato.equals("gif")) {
      imagen = loadImage(selection.getAbsolutePath());
      siImagen = true;
      siVideo = false;
    } else {
      println("Formato incompatible");
    }
  }
}