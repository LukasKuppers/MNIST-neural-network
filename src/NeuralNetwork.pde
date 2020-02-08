
public class NeuralNetwork {
  public int numOfInputNodes;
  public int numOfLayers;
  public int[] numOfHiddenNodes;
  private Matrix[] weights;
  private Matrix[] biases;
  private float learningRate;
  
  public NeuralNetwork(int _numOfInputNodes, int _numOfLayers, int[] _numOfHiddenNodes) {
    numOfInputNodes = _numOfInputNodes;
    numOfLayers = _numOfLayers;
    numOfHiddenNodes = new int[numOfLayers];
    for(int i = 0; i < numOfLayers; i++) {
      numOfHiddenNodes[i] = _numOfHiddenNodes[i];
    }
    learningRate = 0.1;
    
    weights = new Matrix[numOfLayers];
    biases = new Matrix[numOfLayers];
    
    weights[0] = new Matrix(numOfHiddenNodes[0], numOfInputNodes);
    biases[0] = new Matrix(numOfHiddenNodes[0], 1);
    for(int i = 0; i < weights[0].rows; i++) {
      biases[0].setIndex(i, 0, random(-1, 1));
      for(int j = 0; j < weights[0].cols; j++) {
        weights[0].setIndex(i, j, random(-1, 1));
      }
    }
    for(int x = 1; x < numOfLayers; x++) {
      weights[x] = new Matrix(numOfHiddenNodes[x], numOfHiddenNodes[x - 1]);
      biases[x] = new Matrix(numOfHiddenNodes[x], 1);
      for(int i = 0; i < weights[x].rows; i++) {
        biases[x].setIndex(i, 0, random(-1, 1));
        for(int j = 0; j < weights[x].cols; j++) {
          weights[x].setIndex(i, j, random(-1, 1));
        }
      }
    }
  }
  
  //sigmoid
  private float sigmoid(float x) {
    return 1 / (1 + (float)Math.exp(-x));
  }
  
  public void setLearningRate(float rate) {
    if(rate < 0) {
      println("NeuralNetwork: warning: learnig rate should probably be greater than 0");
    }
    learningRate = rate;
  }
    
  //feed forward function
  
  private Matrix calcLayerOutput(Matrix inputs, Matrix weights, Matrix biases) {
    Matrix output = Matrix.matrixMultiply(weights, inputs);
    output.elementAdd(biases);
    for(int i = 0; i < output.rows; i++) {
      output.setIndex(i, 0, sigmoid(output.getIndex(i, 0)));
    }
    return output;
  }
  
  public float[] predict(float[] inputs) {
    if(inputs.length != numOfInputNodes) {
      println("NeuralNetwork: feedForward: inputs out of range");
      return new float[] {0};
    }
    Matrix input = Matrix.toColVector(inputs);
    
    for(int i = 0; i < numOfLayers; i++) {
      input = calcLayerOutput(input, weights[i], biases[i]);
    }
    float[][] unformatOut = Matrix.toArray(input);
    float[] output = new float[input.rows];
    for(int i = 0; i < output.length; i++) {
      output[i] = unformatOut[i][0];
    }
    return output;
  }
  
  //back-propogation algorithm
  
  public void train(float[] inputs, float[] targets) {
    if(inputs.length != numOfInputNodes || targets.length != numOfHiddenNodes[numOfLayers - 1]) {
      println("NeuralNetwork: train: inputs or targets out of range");
      return;
    }
    
    //calculate activations
    Matrix input = Matrix.toColVector(inputs);
    Matrix[] activations = new Matrix[numOfLayers + 1];
    activations[0] = input;
    for(int i = 0; i < numOfLayers; i++) {
      activations[i + 1] = calcLayerOutput(input, weights[i], biases[i]);
      input = activations[i + 1];
    }
    
    //first back-prop step
      //calculate gradient
    Matrix target = Matrix.toColVector(targets);
    Matrix gradient_last = Matrix.elementSubtract(activations[activations.length - 1], target);
    for(int i = 0; i < numOfHiddenNodes[numOfLayers - 1]; i++) {
      float sigmoid = activations[activations.length - 1].getIndex(i, 0);
      float sigmoidPrime = sigmoid * (1 - sigmoid);
      gradient_last.setIndex(i, 0, gradient_last.getIndex(i, 0) * sigmoidPrime);
    }
      //calculate deltas (with learning rate)
    Matrix activations_last_T = Matrix.transpose(activations[activations.length - 2]);
    Matrix delta_weights_last = Matrix.matrixMultiply(gradient_last, activations_last_T); 
    delta_weights_last.scalarMultiply(learningRate);
    gradient_last.scalarMultiply(learningRate);
      //adjust weights and biases
    weights[numOfLayers - 1].elementSubtract(delta_weights_last);
    biases[numOfLayers - 1].elementSubtract(gradient_last);
      //remove learning rate from gradient
    gradient_last.scalarMultiply(1 / learningRate);
    
    //continue back-prop for the rest of the layers, i is the current layer 
    //i -> decreases to 0 (first layer)
      //setup l+1 gradient matrix
    Matrix gradient_l1 = gradient_last;
    for(int i = numOfLayers - 2; i >= 0; i--) {
      //calculate gradients for layer i
      Matrix weights_l1_T = Matrix.transpose(weights[i + 1]);
      Matrix gradient_l = Matrix.matrixMultiply(weights_l1_T, gradient_l1);
      for(int j = 0; j < numOfHiddenNodes[i]; j++) {
        float sigmoid = activations[i + 1].getIndex(j, 0);
        float sigmoidPrime = sigmoid * (1 - sigmoid);
        gradient_l.setIndex(j, 0, gradient_l.getIndex(j, 0) * sigmoidPrime);
      }
      
      //calculate deltas
      Matrix activations_l0_T = Matrix.transpose(activations[i]);
      Matrix delta_weights = Matrix.matrixMultiply(gradient_l, activations_l0_T);
      delta_weights.scalarMultiply(learningRate);
      gradient_l.scalarMultiply(learningRate);
        //adjust weights and biases;
      weights[i].elementSubtract(delta_weights);
      biases[i].elementSubtract(gradient_l);
        //set gradient_l1 to gradient_l and remove learning rate
      gradient_l.scalarMultiply(1 / learningRate);
      gradient_l1 = gradient_l;
    }
  }
  
  void display() {
    for(int i = 0; i < numOfLayers; i++) {
      println("layer " + i + " -----------------------------------------------------------");
      println("weights:");
      weights[i].printm();
      println("biases:");
      biases[i].printm();
    }
  }  
}
