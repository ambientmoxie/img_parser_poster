/* autogenerated by Processing revision 1276 on 2022-07-01 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class img_parser_poster extends PApplet {

PGraphics main;
PGraphics seed;
PGraphics shapes_dict;
PGraphics copy_filter;
PGraphics lerp;

PGraphics pic_01;
PGraphics pic_02;
PGraphics pic_03;
PGraphics pic_04;
PGraphics pic_05;
PGraphics pic_06;

PImage seed_image;

// Dictionary variables //

IntDict inventory;
String storedColor;
int usableColor;
int starter;


int border;

float custom_width;
float custom_height;

 public void setup() {
    /* size commented out by preprocessor */; // A4 ratio

    /* pixelDensity commented out by preprocessor */;
    border = 30;
    
    main = createGraphics(width - border, height - border);
    seed = createGraphics(main.width, main.height);
    shapes_dict = createGraphics(main.width, main.height);
    copy_filter = createGraphics(main.width, main.height);
    lerp = createGraphics(main.width, main.height);

    pic_01 = createGraphics(main.width / 8, main.height / 12);
    pic_02 = createGraphics(main.width / 8, main.height / 12);
    pic_03 = createGraphics(main.width / 8, main.height / 12);
    pic_04 = createGraphics(main.width / 8, main.height / 12);
    pic_05 = createGraphics(main.width / 8, main.height / 12);
    pic_06 = createGraphics(main.width / 8, main.height / 12);

    seed_image = loadImage("seed_03.jpg");

    // Dict variables

    inventory = new IntDict();
    starter = 1; 

}

 public void draw() {
    background(200);
    drawSeed();

    drawShapesDict();
    drawCopyFilter();
    drawLerp();
    drawPic01();
    drawPic02();
    drawPic03();

    drawMain();

    pushMatrix();
    imageMode(CENTER);
    translate(width / 2, height / 2);
    image(main, 0, 0);
    popMatrix();

    //customCopy();

    // println(inventory.size());
}

 public void drawMain(){
    main.beginDraw();
    main.background(0);
    main.image(seed, 0, 0, (main.width / 4) * 3, (main.height / 6) * 4);
    main.image(shapes_dict, 0, (main.height / 6) * 4, (main.width / 4) * 3, (main.height / 12) * 3);
    main.image(copy_filter, 0, (main.height / 12) * 11,(main.width / 4) * 3, main.height / 12);
    main.image(lerp, (main.width / 4) * 3, 0, main.width / 4 + 2, main.height);
    main.image(pic_01, 0, (main.height / 12) * 11);
    main.image(pic_02, main.width / 8, (main.height / 12) * 11);
    main.image(pic_03, (main.width / 8) * 2, (main.height / 12) * 11);
    
    main.endDraw();
}

 public void drawSeed(){
    seed.beginDraw();
    seed.background(255,0,0);
    seed.image(seed_image, 0, 0, seed.width, seed.height);
    seed.endDraw();
}

 public void fillDict(){
    for (int i = 0; i < seed.width; ++i) {
        for (int j = 0; j < seed.height; ++j) {
            
            int pixelIndex = i + j * seed.width;
            int pixR = seed.pixels[pixelIndex];
            int pixG = seed.pixels[pixelIndex];
            int pixB = seed.pixels[pixelIndex];

            float cR = red(pixR);
            float cG = green(pixG);
            float cB = blue(pixB);

            storedColor = hex(color(cR, cG, cB));

            if (inventory.hasKey(storedColor) == true) {
                inventory.increment(storedColor);
            } else {
                inventory.set(storedColor, starter);
            }
        }
    }

    inventory.sortValuesReverse();
}

 public void drawShapesDict(){
    shapes_dict.beginDraw();

    shapes_dict.clear();

    fillDict();

    float per_row = 6; // number of square per row
    float per_column = 3; // number of square per column
    float amount = per_row * per_column;
    float shapes_w = shapes_dict.width / per_row;
    float shapes_h = shapes_dict.height / per_column;

    float col = 0;
    float row = 0;
    int index = 0;

    shapes_dict.translate(-shapes_w, 0);

    while (index < amount) {

        // remap la totalité des data du dictionnaire sur l'index d'incrementation pour une plus grand variété de couleurs

        float inventory_mapping = map(index, 0, amount, 0, PApplet.parseFloat(inventory.size()));
        usableColor = unhex(inventory.key(PApplet.parseInt(inventory_mapping))); // old --> usableColor = unhex(inventory.key(index);

        col += shapes_w;
        index++;
        shapes_dict.stroke(usableColor);
        shapes_dict.fill(usableColor);
        shapes_dict.rect(col,row, shapes_w, shapes_h);

        if(index % per_row == 0) {
            row += shapes_h;
            col = 0;
        }
    }

    shapes_dict.endDraw();
}

 public void drawCopyFilter() {
    copy_filter.beginDraw();
    
    float amount = 6;
    float shapes_w = copy_filter.width / amount;
    float shapes_h = copy_filter.height;

    float col = 0;
    int index = 0;

    copy_filter.translate(-shapes_w, 0);

    while (index < amount) {

        col += shapes_w;
        index++;

        // copy_filter.stroke(0 + index * 10, 0, 0);
        // copy_filter.fill(0 + index * 10, 0, 0);
        // copy_filter.rect(col,0, shapes_w, shapes_h);
        copy_filter.copy(seed_image, 0, 0, 400, 400, PApplet.parseInt(col), 0, PApplet.parseInt(shapes_w), PApplet.parseInt(shapes_h));

    }

    copy_filter.endDraw();
}

 public void drawLerp() {
    lerp.beginDraw();
    
    float amount = 6;
    float shapes_w = lerp.width;
    float shapes_h = lerp.height / amount;

    float row = 0;
    int index = 0;

    lerp.translate(0, -shapes_h);

    while (index < amount) {

        row += shapes_h;
        index++;
        lerp.stroke(0, 0 + index * 10, 0);
        lerp.fill(0, 0 + index * 10, 0);
        lerp.rect(0,row, shapes_w, shapes_h);
    }

    lerp.endDraw();
}

 public void drawPic01(){
    pic_01.beginDraw();
    pic_01.background(0, 255, 0);
    pic_01.image(seed, 0, 0, pic_01.width, pic_01.height);

    for (int i = 0; i < pic_01.width; ++i) {
        for (int j = 0; j < pic_01.height; ++j) {
            int copyColor = pic_01.get(i, j);

            float px_r = red(copyColor);
            float px_g = green(copyColor);
            float px_b = blue(copyColor);

            int new_copy_color = color(px_r, 0, 0);

            pic_01.stroke(new_copy_color);
            pic_01.strokeWeight(1);
            pic_01.point(i, j);
        }
    }

    pic_01.endDraw();
}

 public void drawPic02(){
    pic_02.beginDraw();
    pic_02.background(0, 255, 0);
    pic_02.image(seed, 0, 0, pic_02.width, pic_02.height);

    for (int i = 0; i < pic_02.width; ++i) {
        for (int j = 0; j < pic_02.height; ++j) {
            int copyColor = pic_02.get(i, j);

            float px_r = red(copyColor);
            float px_g = green(copyColor);
            float px_b = blue(copyColor);

            int new_copy_color = color(0, px_g, 0);

            pic_02.stroke(new_copy_color);
            pic_02.strokeWeight(1);
            pic_02.point(i, j);
        }
    }

    pic_02.endDraw();
}

 public void drawPic03(){
    pic_03.beginDraw();
    pic_03.background(0, 255, 0);
    pic_03.image(seed, 0, 0, pic_03.width, pic_03.height);

    for (int i = 0; i < pic_03.width; ++i) {
        for (int j = 0; j < pic_03.height; ++j) {
            int copyColor = pic_03.get(i, j);

            float px_r = red(copyColor);
            float px_g = green(copyColor);
            float px_b = blue(copyColor);
            float bright = brightness(copyColor);

            if(bright > 150) {
                copyColor = color(255,255,255);
            }else {
                copyColor = color(0, 0, px_b);
            }

            pic_03.stroke(copyColor);
            
            pic_03.strokeWeight(1);
            pic_03.point(i, j);
        }
    }

    pic_03.endDraw();
}

 public void keyPressed() {
    if (key == 's' || key == 'S') {
      save("export/export.tif");
      exit();
    }
}

// void customCopy(){

//     translate(0,100);

//     for (int i = 0; i < seed_image.width; ++i) {
//         for (int j = 0; j < seed_image.height; ++j) {
//             color copyColor = seed_image.get(i, j);
//             stroke(copyColor);
//             strokeWeight(2);
//             point(i, j);
//         }
//     }

// }


  public void settings() { size(700, 990);
pixelDensity(2); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "img_parser_poster" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
