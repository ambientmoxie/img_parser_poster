PGraphics main;
PGraphics seed;
PGraphics shapes_dict;
PGraphics copy_filter;
PGraphics lerp;

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

    seed_image = loadImage("seed_02.jpg");

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

    drawMain();

    imageMode(CENTER);
    translate(width / 2, height / 2);
    image(main, 0, 0);

    // println(inventory.size());
}

void drawMain(){
    main.beginDraw();
    main.background(255,0,0);
    main.image(seed, 0, 0, (main.width / 4) * 3, (main.height / 6) * 4);
    main.image(shapes_dict, 0, (main.height / 6) * 4, (main.width / 4) * 3, (main.height / 12) * 3);
    main.image(copy_filter, 0, (main.height / 12) * 11,(main.width / 4) * 3, main.height / 12);
    main.image(lerp, (main.width / 4) * 3, 0, main.width / 4 + 2, main.height);
    
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
        copy_filter.stroke(0 + index * 10, 0, 0);
        copy_filter.fill(0 + index * 10, 0, 0);
        copy_filter.rect(col,0, shapes_w, shapes_h);
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

void keyPressed() {
    if (key == 's' || key == 'S') {
      save("export/export.tif");
      exit();
    }
}
