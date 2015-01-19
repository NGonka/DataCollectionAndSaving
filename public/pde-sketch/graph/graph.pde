


PFont font;

//PImage grid;

int numValues = 1;    // number of input values or sensors

int[] values   = new int[numValues];

color[] valColor = new color[3];
float oldY;
float oldX =0; 
int[] maxValue = new int[numValues];
int[] minValue = new int[numValues];

//float partH;          // partial screen height

int steps;


float xPos = 0;
float yPos = 0;
String inString="";
boolean clear = false;
boolean startPvT=true;
boolean startPvP=true;

int axisCounter = 0;

int minimum;
int maximum;

int xStart;
int yStart;
int yEnd;
int xEnd;
String yLabel_PvT;
float timestamp_genau=0;
float timestamp_rnd=0;


void setup(){
    
    size(700,300,JAVA2D);
    font = createFont("Arial Bold",12);
    textFont(font);

    emptyPeakArray();
    //partH = (height*1)/ numValues;
    yPos=height;
    
    //Axis size definitions
    xStart=50;
    yStart=100;
    yEnd= height-15;
    xEnd= width-xStart;
    oldX=xStart;
    
    values[0] = 0;
    
    valColor[0] = color(255, 0, 0); // red
    valColor[1] = color(0, 255, 0); // green
    valColor[2] = color(0, 0, 255); // blue
    //println(width);
    //println(height);
    background(0,0,0,0);
}


void draw(){
    //background(0);
    

}

void drawPointVsTime(int Point,int timePoint,int xMin , int xMax, int xStep, String yLabel){
    yLabel_PvT=yLabel;
    //steps = step;
    // minimum=xMin;
    // maximum=xMax;
    int yMax=60;
    int yMin=0;
    int yStep=5;
    if(startPvT){
        drawPvTdivLines(xMin,xMax,xStep, yMin,yMax,yStep);
        startPvT=false;
    }

    
    
    inString = Point+","+timePoint;
    if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
 
    // split the string on the delimiters and convert the resulting substrings into an float array:
    //int[] valuesTemp = int(splitTokens(inString, ", \t"));
    values = int(splitTokens(inString, ", \t"));    // delimiter can be comma space or tab
    //println("inString: ",inString);
    //println(values);
    // if the array has at least the # of elements as your # of sensors, you know
    // you got the whole data packet.  Map the numbers and put into the variables:
    if (values.length >= numValues) {
      
        //values[i] = float(valuesTemp[i]);
        //print(i + ": " + values[i]);
        // print values:
        //println(values[numValues]);
        //Peak detection
        if(values[0]>maxValue[0])
        {
        maxValue[0]=values[0];
        }
        if(values[0]<minValue[0])
        {
        minValue[0]=values[0];
        }
        

        
        //little Textbox upper left corner
        textAlign(LEFT);
        fill(50);
        //noStroke();
        stroke(255,0,0);
        strokeWeight(1);
        rect(width-200, 1, 200, 24);
        fill(255);
        text(int(values[0]), width-200+10, 6+12);
        fill(128);
        text(minValue[0]+", "+maxValue[0], width-200+80, 6+12);
        

        /*
        if (Save)
        {
        newRow.setInt(column[i+1],values[i]);
        recording = true;
        }*/
        // map to the range of partial screen height:
        float mappedVal = map(values[0], xMin, xMax, 0, yEnd);
        
 
        // draw lines:
        stroke(valColor[0]);
        strokeWeight(1);
        if(!clear){
        //xPos=int(oldX)+int(ceil(values[1]/1000));
        timestamp_genau+=(values[1]/1000000);
        timestamp_rnd+=(values[1]/1000000);
        float mappedValY = map(timestamp_genau,yMin,yMax,0,xEnd);
        //xPos=int(oldX)+int(ceil(timestamp_genau));
        // xPos=int(oldX)+mappedValY;
        xPos=mappedValY+xStart;
        line(oldX, oldY, xPos, yEnd - mappedVal);

        oldY = yEnd - mappedVal;
        }
        else{
            background(0,0,0,0);
            xPos=xStart;
            oldY=yEnd;
            clear=false;
            axisCounter = 0; 
            emptyPeakArray();
            drawPvTdivLines(xMin,xMax,xStep, yMin,yMax,yStep);
            timestamp_genau=0;
            timestamp_rnd=0;
                
        }
        

        
        //println("\t"+mappedVal);   // <- uncomment this to debug values
        
       
      
      /*
       //println(str(values[values.length-1]));
      if(Save)
      {
        newRow.setInt(column[0],values[values.length-1]);
        recording=true;
      }
      */
     
      //println("Values: ",values);                   // <- uncomment this to debug values
 
      // if at the edge of the screen, go back to the beginning:
      if (xPos >= width) {
        //noLoop();
        
        xPos = 0;
        oldX=xStart;
        // two options for erasing screen, i like the translucent option to see "history"
        background(0,0,0,0);
        emptyPeakArray();
        drawPvTdivLines(xMin,xMax,xStep, yMin,yMax,yStep);
        timestamp_genau=0;
      }
      else {
        oldX = xPos;
        //xPos+=2;                    // increment the graph's horizontal position
    
      }
     
    
    }
    
  }
  /*
    //
    println("T_ceil: " + ceil(timestamp_genau));
    println("xPos: " + xPos);
    println("T_genau: " + timestamp_genau);
    
    
    println("T in usec: " + timestamp_rnd);
    println("AxisCounter: " + axisCounter);
    */
    
    
}



void drawPointVsPoint(int PointX, int PointY, String labelX ,String labelY,int Xmin , int Xmax, int Xstep,int Ymin , int Ymax, int Ystep){    
    if(startPvP||clear){
        drawPvPdivLines( Xmin ,  Xmax,  Xstep, Ymin ,  Ymax,  Ystep,labelX,labelY);
        startPvP=false;
        clear=false;
        axisCounter = 0;
    }
    inString = PointX+","+PointY;
        xPos=xStart+map(PointX,Xmin,Xmax, 0, xEnd);  
        yPos=yEnd-map(PointY,Ymin,Ymax,0,yEnd);
    
        //little Textbox upper left corner
        textAlign(LEFT);
        fill(50);

        stroke(0);
        strokeWeight(1);
        rect(width-200, 1, 200, 24);
        fill(255);
        text(labelX+": " + PointX,width-200+ 10, 6+12);
        //text(PointX,width-200+80,6+12)
        text (labelY+": " + PointY,width-200+105,6+12);
        //text(PointY,width-200+140,6+12 );
        //text ("mA",width-200+175,6+12);
        //
        


        if (xPos >= width) {
            xPos = width;
        }
        else if (xPos<=0){
            xPos=0;   
        }
        if (yPos >= height) {
            yPos = height;
        }
        else if (yPos<=0){
            yPos=0;    
        }
        
        // draw Points
        stroke(valColor[2]);
        strokeWeight(3.5);
        point(xPos,yPos);
            


            

    


}
    
void emptyPeakArray(){
  for (int i=0;i<numValues;i++)
  {
      minValue[i]=0;
      maxValue[i]=0;
  
  }
}

void clearPositions(){
    background(0,0,0,0);
    clear =true;
    
}


void drawMarkers(int length, char orientation, int midPointX,int midPointY, int counter, int xMinAxisRange, int xMaxAxisRange, int Xstep, int yMinAxisRange, int yMaxAxisRange, int Ystep, String labX,String labY){
    
    
    

    
    if (orientation=='y'){
        int[] yAxisRange = new int[length/Ystep];
        for (int i=1; i<= ((yMaxAxisRange-yMinAxisRange)/Ystep)+1;i++){
            yAxisRange[i-1]=yMinAxisRange+(i-1)*Ystep;
        }
        stroke (0);
        strokeWeight (1);
        textAlign(RIGHT);
        float normalY; 
        //println("yAxisRange: " +yAxisRange.length);
        int z;
        for (int i=0; i<yAxisRange.length-1; i++) {
            z=i;
            normalY = length-(length/(yAxisRange.length-1))*i;
            //println(normalY);
            line (midPointX, normalY, midPointX-3, normalY);
            fill (0);            
            text (int(yAxisRange[i]), midPointX-6, normalY+6);
        }
        
        textFont(font,8);
        text (labY, midPointX-2, length-(length/(yAxisRange.length-1))*(z+1)+6);
        textFont(font,12);
    }
    else if( orientation=='x'){
        int[] xAxisRange = new int[0];
        for (int i=1; i<= ((xMaxAxisRange-xMinAxisRange)/Xstep)+1;i++){
            xAxisRange[i-1]=xMinAxisRange+(i-1)*Xstep;    
        }
        stroke (0);
        
        textAlign(CENTER);
        float normalX;    
        int z;
        for (int i=0; i<xAxisRange.length-1; i++) {
            z=i;
            normalX = (length/(xAxisRange.length-1))*i+xStart;
            strokeWeight (1);
            line (normalX,midPointY-12,normalX,midPointY-15);
            fill (0);
            strokeWeight (0.1);
            text (int(xAxisRange[i])+(counter*(xMaxAxisRange-xMinAxisRange)),  normalX, midPointY);
        }
        
        textAlign(RIGHT);
        textFont(font,10);
        text (labX,  (length/(xAxisRange.length-1))*(z+1)+xStart, midPointY);
        textFont(font,12);
    }
        /*
    println(length);
    println(orientation);
    println(midPointX);
    println(midPointY);
    println(counter); 
    println("or: "+String(orientation));
    println(xAxisRange);
    println(yAxisRange);
    println("XStep Marker:"+Xstep);
    println("YStep Marker:"+Ystep);
    //println(yAxisRange);
*/
}


void drawPvTdivLines(int xMin,int xMax,int xStep, int yMin, int yMax, int yStep){
    // draw dividing lines:
    // vertical
    
    
    strokeWeight(1);
    stroke(0);
    line(xStart, 0, xStart, yEnd);
    // horizontal
    stroke(0);
    strokeWeight(1);
    line(xStart,yEnd,width,yEnd);
    
    drawMarkers(xEnd, 'x',height,height,axisCounter++,yMin,yMax,yStep,xMin,xMax,xStep,"s [uSec]",yLabel_PvT);
    drawMarkers(yEnd,'y',xStart,yEnd,0,yMin,yMax,yStep,xMin,xMax,xStep,"s [uSec]",yLabel_PvT);
    
    
}

void drawPvPdivLines(int Xmin , int Xmax, int Xstep,int Ymin , int Ymax, int Ystep, String labX,String labY){
    // draw dividing lines:
    // vertical
    //println("XStep:"+Xstep);
    //println(splitTokens(labX," ")[0]);
    strokeWeight(0.5);
    stroke(0);
    line(xStart, 0, xStart, yEnd);
    // horizontal
    stroke(0);
    line(xStart,yEnd,width,yEnd);
    
    drawMarkers(xEnd, 'x',height,height,0,Xmin,Xmax,Xstep,0,0 ,0 ,splitTokens(labX," ")[0],splitTokens(labY," ")[0] );
    drawMarkers(yEnd,'y',xStart,yEnd,0,0,0,0,Ymin,Ymax,Ystep,splitTokens(labX," ")[0],splitTokens(labY," ")[0]);
    
}


