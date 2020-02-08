
public class DataManager {
  
  
  
  //MNIST data prep
  
  public void saveImageData(String dataFile, int numOfImages, String newFileName) {
    byte[] rawData = loadBytes(dataFile);
    byte[] images = new byte[784 * numOfImages];
    int len = rawData.length / 784;
    if(numOfImages > len) {
      return;
    }
    
    for(int i = 0; i < numOfImages; i++) {
      for(int j = 0; j < 784; j++) {
        images[(784 * i) + j] = rawData[(784 * i) + j + 16];
      }
    }
    saveBytes(newFileName + ".bin", images);
    println("\n\n save complete \n");
  }
  
  public void saveLabelData(String dataFile, int numOfImages, String newFileName) {
    byte[] rawData = loadBytes(dataFile);
    byte[] labels = new byte[numOfImages];
    int len = rawData.length;
    if(numOfImages > len) {
      return;
    }
    
    for(int i = 0; i < numOfImages; i++) {
      labels[i] = rawData[i + 8];
    }
    saveBytes(newFileName + ".bin", labels);
    println("\n\n save complete \n");
  }
  
}
