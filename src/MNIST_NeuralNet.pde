NeuralNetwork nn;
DataManager dm;

byte[] trainingImages;
byte[] trainingLabels;
byte[] testingImages;
byte[] testingLabels;

dataElement[] trainingSet;
dataElement[] testingSet;

dataElement doodle;

int cycleIndex;

//usefull functions:

public int arrToNum(float[] arr) {
  int out = 0;
  float greatest = arr[0];
  for(int i = 1; i < 10; i++) {
    if(arr[i] > greatest) {
      greatest = arr[i];
      out = i;
    }
  }
  return out;
}

public float[] numToArr(int n) {
  float[] out = new float[10];
  for(int i = 0; i < 10; i++) {
    if(i == n) {  
      out[i] = 1;
    } else {
      out[i] = 0;
    }
  }
  return out;
}

//end///////////////////////////////////////////////////////////////////////////////

void setup() {
  size(1500, 1500);
  background(0);
  
  //data prep 
  
  trainingImages = loadBytes("trainingImageSet10000.bin");
  trainingLabels = loadBytes("trainingLabelSet10000.bin");
  testingImages = loadBytes("testImageSet500.bin");
  testingLabels = loadBytes("testLabelSet500.bin");
  
  trainingSet = new dataElement[10000];
  testingSet = new dataElement[500];
  for(int i = 0; i < 10000; i++) {
    trainingSet[i] = new dataElement(trainingImages, trainingLabels, i);
  }
  for(int i = 0; i < 500; i++) {
    testingSet[i] = new dataElement(testingImages, testingLabels, i);
  }
  
  //training AI
  
  nn = new NeuralNetwork(784, 3, new int[] {300, 50, 10});
  
  println("training...\n");
  int offset = 10000 / 10;
  for(int i = 0; i < 10000; i++) {
    nn.train(trainingSet[i].image, numToArr(trainingSet[i].label));
    if(i % offset == 0) {
      print("");
    }
  }
  println("\n trainingComplete \n");
  
  int correct = 0;
  for(int i= 0; i < 500; i++) {
    int guess = arrToNum(nn.predict(testingSet[i].image));
    if(guess == testingSet[i].label) {
      correct++;
    }
  }
  float percent = ((float)correct / 500.0) * 100;
  println("neural net completed 500 test images with " + percent + "% accuracy"); 
  
  //prep doodle
  doodle = new dataElement();
  
  cycleIndex = 0;
}

void mouseDragged() {
  int xCord = floor((28.0 / width) * mouseX);
  int yCord = floor((28.0 / height) * mouseY);
  doodle.image[xCord + (yCord * 28)] = 1.0;
}

void keyPressed() {
  if(key == 'r') {
    for(int i = 0; i < 784; i++) {
      doodle.image[i] = 0;
    }
  }
  if(key == 'g') {
    int guess = arrToNum(nn.predict(doodle.image));
    println(guess);
  }
  if(key == 'c') {
    doodle.image = testingSet[cycleIndex].image;
    cycleIndex++;
  }
}

void draw() {
  doodle.displayImage(width);
}
  
