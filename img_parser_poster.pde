PGraphics main;
PGraphics seed;
PGraphics shapes_dict;
PGraphics lerp;

PGraphics pic_01;
PGraphics pic_02;
PGraphics pic_03;
PGraphics pic_04;
PGraphics pic_05;
PGraphics pic_06;
PGraphics pic_07;

PImage seed_image;

// Dictionary variables //

IntDict inventory;
String storedColor;
int usableColor;
int starter;

int[] bright_numb;

int border;

float custom_width;
float custom_height;

void setup() {
    size(700, 990); // A4 ratio

    pixelDensity(2);
    border = 28;
    
    main = createGraphics(width - border, height - border);
    seed = createGraphics(main.width, main.height);
    shapes_dict = createGraphics(main.width, main.height);
    lerp = createGraphics(main.width, main.height);

    pic_01 = createGraphics(main.width / 8, main.height / 12);
    pic_02 = createGraphics(main.width / 8, main.height / 12);
    pic_03 = createGraphics(main.width / 8, main.height / 12);
    pic_04 = createGraphics(main.width / 8, main.height / 12);
    pic_05 = createGraphics(main.width / 8, main.height / 12);
    pic_06 = createGraphics(main.width / 8, main.height / 12);
    pic_07 = createGraphics(main.width / 8, main.height / 12);
    pic_07 = createGraphics(main.width / 8, main.height / 12);

    

    seed_image = loadImage("seed_03.jpg");

    // Dict variables

    inventory = new IntDict();
    starter = 1; 

}

void draw() {
    background(255);
    drawSeed();

    drawShapesDict();
    drawLerp();
    drawPic01();
    drawPic02();
    drawPic03();
    drawPic04();
    drawPic05();
    drawPic06();
    drawPic07();
    

    drawMain();

    pushMatrix();
    imageMode(CENTER);
    translate(width / 2, height / 2);
    image(main, 0, 0);
    popMatrix();

    //customCopy();

    // println(inventory.size());
}

void drawMain(){
    main.beginDraw();
    // main.image(pic_01, 0, 0);
    main.image(seed, 0, 0, (main.width / 4) * 3, (main.height / 6) * 4);
    main.image(shapes_dict, 0, (main.height / 6) * 4, (main.width / 4) * 3, (main.height / 12) * 3);
    main.image(lerp, (main.width / 4) * 3, 0, main.width / 4 + 2, main.height);
    main.image(pic_02, 0, (main.height / 12) * 11, main.width / 8, main.height / 12 + 2);
    main.image(pic_03, main.width / 8, (main.height / 12) * 11, main.width / 8, main.height / 12 + 2);
    main.image(pic_04, (main.width / 8) * 2, (main.height / 12) * 11, main.width / 8, main.height / 12 + 2);
    main.image(pic_05, (main.width / 8) * 3, (main.height / 12) * 11, main.width / 8, main.height / 12 + 2);
    main.image(pic_06, (main.width / 8) * 4, (main.height / 12) * 11, main.width / 8, main.height / 12 + 2);
    main.image(pic_07, (main.width / 8) * 5, (main.height / 12) * 11, main.width / 8, main.height / 12 + 2);

    main.noStroke();
    main.fill(0,0,255);
    main.rect((main.width / 150) * 167 ,0,main.width / 150, main.height);
    main.fill(0,255,0);
    main.rect((main.width / 150) * 166 ,0,main.width / 150, main.height);
    main.fill(255,0,0);
    main.rect((main.width / 150) * 165 ,0,main.width / 150, main.height);
    main.endDraw();
}

void drawSeed(){
    seed.beginDraw();
    seed.background(255,0,0);
    seed.image(seed_image, 0, 0, seed.width, seed.height);
    seed.endDraw();
}

void fillDict(){
    for (int i = 0; i < seed.width; ++i) {
        for (int j = 0; j < seed.height; ++j) {
            
            int pixelIndex = i + j * seed.width;
            color pixR = seed.pixels[pixelIndex];
            color pixG = seed.pixels[pixelIndex];
            color pixB = seed.pixels[pixelIndex];

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

void drawShapesDict(){
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

        float inventory_mapping = map(index, 0, amount, 0, float(inventory.size()));
        usableColor = unhex(inventory.key(int(inventory_mapping))); // old --> usableColor = unhex(inventory.key(index);

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

void drawLerp() {
    lerp.beginDraw();

    fillDict();
    bright_numb = new int[inventory.size()];

    for(int i = 0; i < inventory.size(); i++) {
        usableColor = unhex(inventory.key(i));

        int uc_bright = int(brightness(usableColor));
        bright_numb[i] = uc_bright;
    }

    int dark_bright = min(bright_numb); // plus sombre
    int light_bright = max(bright_numb); // plus clair

    float amount = 6;
    float shapes_w = lerp.width;
    float shapes_h = lerp.height / amount;

    float row = 0;
    int index = 0;

    lerp.translate(0, -shapes_h);

    while (index < amount) {

        row += shapes_h;
        index++;

        float incr_bright = ((light_bright - dark_bright) / amount) * index;

        lerp.stroke(incr_bright);
        lerp.fill(incr_bright);
        lerp.rect(0,row, shapes_w, shapes_h);
    }

    lerp.endDraw();
}

void drawPic01(){
    pic_01.beginDraw();
    pic_01.image(seed_image, 0, 0, pic_01.width, pic_01.height);
    pic_01.endDraw();
}

void drawPic02(){
    pic_02.beginDraw();
    
     for(int i = 0; i < pic_01.width; i++) {
        for(int j = 0; j < pic_01.height; j++) {
      
        color copyColor = pic_01.get(i, j);

        float px_r = red(copyColor);
        float px_g = green(copyColor);
        float px_b = blue(copyColor);

        color new_copy_color = color(px_r, 0, 0);
        
        pic_02.stroke(new_copy_color);
        pic_02.point(i, j);
      
    }
  }
    pic_02.endDraw();
}

void drawPic03(){
    pic_03.beginDraw();
    
     for(int i = 0; i < pic_01.width; i++) {
        for(int j = 0; j < pic_01.height; j++) {
      
        color copyColor = pic_01.get(i, j);

        float px_r = red(copyColor);
        float px_g = green(copyColor);
        float px_b = blue(copyColor);

        color new_copy_color = color(0, px_g, 0);
        
        pic_03.stroke(new_copy_color);
        pic_03.point(i, j);
      
    }
  }
    pic_03.endDraw();
}

void drawPic04(){
    pic_04.beginDraw();
    
     for(int i = 0; i < pic_01.width; i++) {
        for(int j = 0; j < pic_01.height; j++) {
      
        color copyColor = pic_01.get(i, j);

        float px_r = red(copyColor);
        float px_g = green(copyColor);
        float px_b = blue(copyColor);

        color new_copy_color = color(0, 0, px_b);
        
        pic_04.stroke(new_copy_color);
        pic_04.point(i, j);
    }
  }
    pic_04.endDraw();
}

void drawPic05(){
    
    pic_05.beginDraw();

    pic_05.colorMode(HSB, 360, 100, 100);
    
     for(int i = 0; i < pic_01.width; i++) {
        for(int j = 0; j < pic_01.height; j++) {
      
        color copyColor = pic_01.get(i, j);

        float px_h = hue(copyColor);
        float px_s = saturation(copyColor);
        float px_b = brightness(copyColor);

        color new_copy_color = color(px_h, px_s, px_b);
        
        pic_05.stroke(new_copy_color);
        pic_05.point(i, j);
      
    }
  }
    pic_05.endDraw();
}

void drawPic06(){
    
    pic_06.beginDraw();

    pic_06.colorMode(HSB, 360, 100, 100);
    
     for(int i = 0; i < pic_01.width; i++) {
        for(int j = 0; j < pic_01.height; j++) {
      
        color copyColor = pic_01.get(i, j);

        float px_h = hue(copyColor);
        float px_s = saturation(copyColor);
        float px_b = brightness(copyColor);

        color new_copy_color;

        if(px_b > 200) {
            new_copy_color = color(0, 100, 100);
        }else {
            new_copy_color = color(px_h, px_s, px_b);
        }
        

        
        pic_06.stroke(new_copy_color);
        pic_06.point(i, j);
      
    }
  }
    pic_06.endDraw();
}

void drawPic07(){
    
    pic_07.beginDraw();

    pic_07.colorMode(HSB, 360, 100, 100);
    
     for(int i = 0; i < pic_01.width; i++) {
        for(int j = 0; j < pic_01.height; j++) {
      
        color copyColor = pic_01.get(i, j);

        float px_h = hue(copyColor);
        float px_s = saturation(copyColor);
        float px_b = brightness(copyColor);

        color new_copy_color;

        if(px_s > 100) {
            new_copy_color = color(200, 0, 100);
        }else {
            new_copy_color = color(px_h, px_s, px_b);
        }
        
        pic_07.stroke(new_copy_color);
        pic_07.point(i, j);
      
    }
  }
    pic_07.endDraw();
}

void keyPressed() {
    if (key == 's' || key == 'S') {
      save("export/export.tif");
      exit();
    }
}
