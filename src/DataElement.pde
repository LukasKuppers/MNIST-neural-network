
public class dataElement {
  public float[] image;
  public int label;
  
  public dataElement() {
    image = new float[784];
    for(int i = 0; i < 784; i++) {
      image[i] = 0;
    }
    label = 0;
  }
  
  public dataElement(int[] _image, int _label) {
    image = new float[784];
    for(int i = 0; i < 784; i++) {
      image[i] = float(_image[i] & 0xff) / 255.0;
    }
    label = _label;
  }
  
  public dataElement(byte[] images, byte[] labels, int i) {
    image = new float[784];
    for(int j = 0; j < 784; j++) {
      image[j] = float(images[(i * 784) + j] & 0xff) / 255.0;
    }
    label = labels[i];
  }
  
  public void displayImage(float screenWidth) {
    float pixWidth = screenWidth / 28;
    for(int x = 0; x < 28; x++) {
      for(int y = 0; y < 28; y++) {
        fill(255 - (image[x + (y * 28)] * 255));
        rect(x * pixWidth, y * pixWidth, pixWidth, pixWidth);
      }
    }
  }
}
