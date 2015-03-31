
// Load image from hard drive into RAM.
PImage img = loadImage("The-Darkness-Wallpaper.jpg");

// Set the size of the sketch window.
size(400, 400);

// Draw raw image.
// image(img, 0, 0);

// Load the pixels into the "img.pixels" array.
img.loadPixels();

// img.pixels[...];

int totalPixels = img.width * img.height;

float totalBrightness = 0;

for (int i = 0; i < totalPixels; i = i + 1)
{
  totalBrightness += brightness(img.pixels[i]);
}

float averageBrightness = totalBrightness / totalPixels;

println("Average brightness of the image: " + averageBrightness);

// "Commit our changes to the pixel"
img.updatePixels();

// Draw the manipulated pixels.
image(img, 0, 0);

