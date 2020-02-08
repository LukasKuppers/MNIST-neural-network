
public static class Matrix {
  public int rows;
  public int cols;
  private float[][] data;
  
  public Matrix(int _rows, int _cols) {
    rows = _rows;
    cols = _cols;
    data = new float[rows][cols];
    
    memset(0);
  }
  
  //getters and setters
  
  public float getIndex(int i, int j) {
    if(i < 0 || i >= rows || j < 0 || j >= cols) {
      println("Matrix Error: getIndex: invalid index");
      return 0;
    }
    return data[i][j];
  }
  
  public void setIndex(int i, int j, float val) {
    if(i < 0 || i >= rows || j < 0 || j >= cols) {
      println("Matrix Error: setIndex: invalid index");
      return;
    }
    data[i][j] = val;
  } 
  
  //misc
  
  public static Matrix fromArray(float[][] array) {
    Matrix output = new Matrix(array.length, array[0].length);
    for(int i = 0; i < output.rows; i++) {
      for(int j = 0; j < output.cols; j++) {
        output.setIndex(i, j, array[i][j]);
      }
    }
    return output;
  }
  
  public static Matrix toColVector(float[] array) {
    Matrix output = new Matrix(array.length, 1);
    for(int i = 0; i < output.rows; i++) {
      output.setIndex(i, 0, array[i]);
    }
    return output;
  }
  
  public static Matrix toRowVector(float[] array) {
    Matrix output = new Matrix(1, array.length);
    for(int i = 0; i < output.cols; i++) {
      output.setIndex(0, i, array[i]);
    }
    return output;
  }
  
  public static float[][] toArray(Matrix m) {
    float[][] output = new float[m.rows][m.cols];
    for(int i = 0; i < m.rows; i++) {
      for(int j = 0; j < m.cols; j++) {
        output[i][j] = m.getIndex(i, j);
      }
    }
    return output;
  }
  
  public static Matrix transpose(Matrix m) {
    Matrix output = new Matrix(m.cols, m.rows);
    for(int i = 0; i < output.rows; i++) {
      for(int j = 0; j < output.cols; j++) {
        output.setIndex(i, j, m.getIndex(j, i));
      }
    }
    return output;
  }
  
  public void memset(float val) {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        data[i][j] = val;
      }
    }
  }
  
  public void printm() {
    println();
    for(int i = 0; i < rows; i++) {
      print("row[" + i + "]:  ");
      for(int j = 0; j < cols; j++) {
        print(data[i][j] + "  ");
      }
      println();
    }
    println();
  }
  
  //scalar ops
    //add
  public void scalarAdd(float val) {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        data[i][j] += val;
      }
    }
  }
  
  public static Matrix scalarAdd(Matrix m, float val) {
    Matrix output = new Matrix(m.rows, m.cols);
    for(int i = 0; i < m.rows; i++) {
      for(int j = 0; j < m.cols; j++) {
        output.setIndex(i, j, m.getIndex(i, j) + val);
      }
    }
    return output;
  }
  
    //multiply
  public void scalarMultiply(float val) {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        data[i][j] *= val;
      }
    }
  }
  
  public static Matrix scalarMultiply(Matrix m, float val) {
    Matrix output = new Matrix(m.rows, m.cols);
    for(int i = 0; i < m.rows; i++) {
      for(int j = 0; j < m.cols; j++) {
        output.setIndex(i, j, m.getIndex(i, j) * val);
      }
    }
    return output;
  }
  
  //element ops
    //add
  public void elementAdd(Matrix m) {
    if(rows != m.rows || cols != m.cols) {
      println("Matrix Error: elementAdd: Matrix dimensions don't match");
      return;
    }
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        data[i][j] += m.getIndex(i, j);
      }
    }
  }
  
  public void elementSubtract(Matrix m) {
    if(rows != m.rows || cols != m.cols) {
      println("Matrix Error: elementSubtract: Matrix dimensions don't match");
      return;
    }
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        data[i][j] -= m.getIndex(i, j);
      }
    }
  }
  
  public static Matrix elementAdd(Matrix a, Matrix b) {
    Matrix output = new Matrix(a.rows, a.cols);
    if(a.rows != b.rows || a.cols != b.cols) {
      println("Matrix Error: elementAdd: Matrix dimensions don't match");
      return output;
    }
    for(int i = 0; i < a.rows; i++) {
      for(int j = 0; j < a.cols; j++) {
        output.setIndex(i, j, a.getIndex(i, j) + b.getIndex(i, j));
      }
    }
    return output;
  }
  
  public static Matrix elementSubtract(Matrix a, Matrix b) {
    Matrix output = new Matrix(a.rows, a.cols);
    if(a.rows != b.rows || a.cols != b.cols) {
      println("Matrix Error: elementSubtract: Matrix dimensions don't match");
      return output;
    }
    for(int i = 0; i < a.rows; i++) {
      for(int j = 0; j < a.cols; j++) {
        output.setIndex(i, j, a.getIndex(i, j) - b.getIndex(i, j));
      }
    }
    return output;
  }
  
    //multiply
  public void elementMultiply(Matrix m) {
    if(rows != m.rows || cols != m.cols) {
      println("Matrix Error: elementMultiply: Matrix dimensions don't match");
      return;
    }
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        data[i][j] *= m.getIndex(i, j);
      }
    }
  }
  
  public static Matrix elementMultiply(Matrix a, Matrix b) {
    Matrix output = new Matrix(a.rows, a.cols);
    if(a.rows != b.rows || a.cols != b.cols) {
      println("Matrix Error: elementMultiply: Matrix dimensions don't match");
      return output;
    }
    for(int i = 0; i < a.rows; i++) {
      for(int j = 0; j < a.cols; j++) {
        output.setIndex(i, j, a.getIndex(i, j) * b.getIndex(i, j));
      }
    }
    return output;
  }
  
  //matrix ops
    //multiply
  public Matrix matrixMultiply(Matrix m) {
    Matrix output = new Matrix(rows, m.cols);
    if(cols != m.rows) {
      println("Matrix Error: matrixMultiply: cols not equal to m.rows");
      return output;
    }
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < m.cols; j++) {
        float sum = 0;
        for(int k = 0; k < cols; k++) {
          sum += getIndex(i, k) * m.getIndex(k, j);
        }
        output.setIndex(i, j, sum);
      }
    }
    return output;
  }
  
  public static Matrix matrixMultiply(Matrix a, Matrix b) {
    Matrix output = new Matrix(a.rows, b.cols);
    if(a.cols != b.rows) {
      println("Matrix Error: matrixMultiply: a.cols not equal to b.rows");
      return output;
    }
    for(int i = 0; i < a.rows; i++) {
      for(int j = 0; j < b.cols; j++) {
        float sum = 0;
        for(int k = 0; k < a.cols; k++) {
          sum += a.getIndex(i, k) * b.getIndex(k, j);
        }
        output.setIndex(i, j, sum);
      }
    }
    return output;
  }
}
