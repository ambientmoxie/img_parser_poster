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

void setup() {
    size(700, 990); // A4 ratio

    pixelDensity(2);
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

void draw() {
    background(200);
    drawSeed();

    drawShapesDict();
    drawCopyFilter();
    drawLerp();
    drawPic01();

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
    main.background(0);
    main.image(seed, 0, 0, (main.width / 4) * 3, (main.height / 6) * 4);
    main.image(shapes_dict, 0, (main.height / 6) * 4, (main.width / 4) * 3, (main.height / 12) * 3);
    main.image(copy_filter, 0, (main.height / 12) * 11,(main.width / 4) * 3, main.height / 12);
    main.image(lerp, (main.width / 4) * 3, 0, main.width / 4 + 2, main.height);
    main.image(pic_01, 0, (main.height / 12) * 11);
    
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

void drawCopyFilter() {
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
        copy_filter.copy(seed_image, 0, 0, 400, 400, int(col), 0, int(shapes_w), int(shapes_h));

    }

    copy_filter.endDraw();
}

void drawLerp() {
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

void drawPic01(){
    pic_01.beginDraw();
    pic_01.background(0, 255, 0);
    pic_01.image(seed, 0, 0, pic_01.width, pic_01.height);

    for (int i = 0; i < pic_01.width; ++i) {
        for (int j = 0; j < pic_01.height; ++j) {
            color copyColor = pic_01.get(i, j);
            stroke(copyColor);
            strokeWeight(2);
            point(i, j);
        }
    }

    pic_01.endDraw();
}

void keyPressed() {
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
