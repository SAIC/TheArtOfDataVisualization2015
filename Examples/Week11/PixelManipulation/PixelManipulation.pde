
// Load image from hard drive into RAM.
PImage img = loadImage("Puppy_2.jpg");

// Set the size of the sketch window.
size(400, 400);

// Draw raw image.
// image(img, 0, 0);

// Load the pixels into the "img.pixels" array.
img.loadPixels();

// img.pixels[...];

int totalPixels = img.width * img.height;

for (int i = 0; i < totalPixels; i = i + 5)
{
    img.pixels[i] = color(255, 255, 255);  
}

// "Commit our changes to the pixel"
img.updatePixels();

// Draw the manipulated pixels.
image(img, 0, 0);

