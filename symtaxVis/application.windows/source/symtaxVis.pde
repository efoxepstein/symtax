import krister.Ess.*;

FFT myfft;
AudioInput myinput;
int bufferSize=1024;

int timer;
 
float theta;
int state;

int redbackground;
int greenbackground;
int bluebackground;

int totalStates;

int transition_time;

void setup() {
  size(1024,400);
  frameRate(30);
  background(255);
  noStroke();
  fill(0);
  transition_time = 500;
  timer = transition_time;
  
  
  totalStates = 10;    // How many different visualizations do we have
  state = 0;
  redbackground=0;
  greenbackground=0;
  bluebackground=0;

  Ess.start(this);
  myinput=new AudioInput(bufferSize);
  myfft=new FFT(bufferSize*2);
  myinput.start();

  myfft.damp(.3);
  myfft.equalizer(true);
  myfft.limits(.005,.05);
}



void draw() {
  
  // wave form
  int red_intensity = 0;
  
  timer = timer - 1;

   if(timer < 0)
   {
     timer = transition_time;
     int current_state = state;
     while(current_state == state)
     {
       state = (int)(random(0,totalStates));
     }
   }  
   
   
  background(redbackground,greenbackground,bluebackground);
  
  
  
  
  for (int i=0; i<bufferSize;i++) 
  { 
    
    float scaledColor = constrain(myfft.spectrum[i]*400,0,255);
    
    if (state == 0)
    {
                 stroke(0,0,scaledColor);
        rect(i+10,height/2,1,(myfft.spectrum[i]*-400)*3);
        rect(i+10,height/2,1,(-myfft.spectrum[i]*-400)*3);
                stroke(0,scaledColor,0);
        rect(i+10,height/2,1,(myfft.spectrum[i]*-400)*2);
        rect(i+10,height/2,1,(-myfft.spectrum[i]*-400)*2);
            stroke(scaledColor,0,0);
        rect(i+10,height/2,1,myfft.spectrum[i]*-400);
        rect(i+10,height/2,1,-myfft.spectrum[i]*-400);
      
      
      if(i < bufferSize-4 && i > 0)
      {
          stroke(255-(i/width),255-(i/width),0);
          curve((float)i,(height/2)+myfft.spectrum[i]*-400,(float)i+1,(height/2)+myfft.spectrum[i+1]*400,(float)i+2,(height/2)+myfft.spectrum[i+2]*-400,(float)i+3,(height/2)+myfft.spectrum[i+3]*-400);
      }
    }
    else if (state == 1)
    {
      stroke((int)random(0,255),0,0);
      point(i,(height/2)+myfft.spectrum[i]*-400);
      point(i,(height/2)+myfft.spectrum[i]*400);
    }
    else if (state == 2)
    {
      stroke(0,(int)random(0,255),0);
      point(i,(height/2)+myfft.spectrum[i]*-400);
      point(i,(height/2)+myfft.spectrum[i]*400);
    }
    else if (state == 3)
    {
      stroke(0,0,(int)random(0,255));
      point(i,(height/2)+myfft.spectrum[i]*-400);
      point(i,(height/2)+myfft.spectrum[i]*400);
    }
    else if (state == 4)
    {      
      if(i < bufferSize-4 && i > 0)
      {
          stroke((int)random(0,255),(int)random(0,255),0);
          curve((float)i,(height/2)+myfft.spectrum[i]*-400,(float)i+1,(height/2)+myfft.spectrum[i+1]*400,(float)i+2,(height/2)+myfft.spectrum[i+2]*-400,(float)i+3,(height/2)+myfft.spectrum[i+3]*-400);
          stroke((int)random(0,255),0,(int)random(0,255));
          curve((float)i,(height/2)+myfft.spectrum[i]*-400-1,(float)i+1,(height/2)+myfft.spectrum[i+1]*400-1,(float)i+2,(height/2)+myfft.spectrum[i+2]*-400-1,(float)i+3,(height/2)+myfft.spectrum[i+3]*-400-1);
          stroke((int)random(0,255),0,0);
          curve((float)i,(height/2)+myfft.spectrum[i]*-400-1,(float)i+1,(height/2)+myfft.spectrum[i+1]*400-2,(float)i+2,(height/2)+myfft.spectrum[i+2]*-400-2,(float)i+3,(height/2)+myfft.spectrum[i+3]*-400-2);
      }
    }
    else if(state ==5)
    {
      if(i < bufferSize - 4)
      {
        int  randomBlue = (int)random(0,255);
        noFill();
        stroke(0,0,randomBlue);
        ellipse((width/2), (height/2), myfft.spectrum[i]*400, myfft.spectrum[i]*400);
        ellipse((width/2), (height/2), myfft.spectrum[i+1]*400, myfft.spectrum[i+1]*400);
        ellipse((width/2), (height/2), myfft.spectrum[i+2]*400, myfft.spectrum[i+2]*400);
        if(i+randomBlue>255)
        {fill(0,0,255);}
        else{
        fill(0,0,randomBlue+i);
      }
        ellipse((width/2), (height/2), myfft.spectrum[i+3]*400, myfft.spectrum[i+3]*400);
      }
    }
    else if(state ==6)
    {
      if(i < bufferSize - 4)
      {
        int  randomBlue = (int)random(0,255);
        noFill();
        stroke(0,0,randomBlue);
        ellipse((width/2), (height/2), myfft.spectrum[i]*400, myfft.spectrum[i]*400);
        ellipse((width/2), (height/2), myfft.spectrum[i+1]*400, myfft.spectrum[i+1]*400);
        ellipse((width/2), (height/2), myfft.spectrum[i+2]*400, myfft.spectrum[i+2]*400);
                if(i+randomBlue>255)
        {fill(0,0,255);}
        else{
        fill(0,0,randomBlue+i);}
        ellipse((width/2), (height/2), myfft.spectrum[i+3]*400, myfft.spectrum[i+3]*400);
                noFill();
        stroke(0,randomBlue,0);
        ellipse((width/1.5), (height/2), myfft.spectrum[i]*400, myfft.spectrum[i]*400);
        ellipse((width/1.5), (height/2), myfft.spectrum[i+1]*400, myfft.spectrum[i+1]*400);
        ellipse((width/1.5), (height/2), myfft.spectrum[i+2]*400, myfft.spectrum[i+2]*400);
                if(i+randomBlue>255)
        {fill(0,255,0);}
        else{
        fill(0,randomBlue+i,0);}
        ellipse((width/1.5), (height/2), myfft.spectrum[i+3]*400, myfft.spectrum[i+3]*400);
                noFill();
        stroke(0,randomBlue,0);
        ellipse((width/3), (height/2), myfft.spectrum[i]*400, myfft.spectrum[i]*400);
        ellipse((width/3), (height/2), myfft.spectrum[i+1]*400, myfft.spectrum[i+1]*400);
        ellipse((width/3), (height/2), myfft.spectrum[i+2]*400, myfft.spectrum[i+2]*400);
                if(i+randomBlue>255)
        {fill(0,255,0);}
        else{
        fill(0,randomBlue+i,0);}
        ellipse((width/3), (height/2), myfft.spectrum[i+3]*400, myfft.spectrum[i+3]*400);
      }
    }
    else if(state == 7)
    {
       int show = (int)random(0,50);
       
       if(show < 2)
       {

          stroke(0,(int)random(0,255),0);
          point(i,(height/2)+myfft.spectrum[i]*-400);
          point(i,(height/2)+myfft.spectrum[i]*400);
       }
    
    }
    else if(state == 8)
    {
      
      
      if(i < bufferSize-4)
      {
        stroke((int)random(0,255),0,0);
          point(i,(height/2)+(20*sin(myfft.spectrum[i]*-400)));
          point(i,(height/2)+(20*sin(myfft.spectrum[i]*400)));
        stroke((int)random(0,255),(int)random(0,255),0);
          point(i+1,(height/2)+(20*sin(myfft.spectrum[i+1]*-400)));
          point(i+1,(height/2)+(20*sin(myfft.spectrum[i+1]*400)));
        stroke((int)random(0,255),(int)random(0,255),0);
          point(i+2,(height/2)+(20*sin(myfft.spectrum[i+2]*-400)));
          point(i+2,(height/2)+(20*sin(myfft.spectrum[i+2]*400)));
        
          
      }
    }
    else if(state ==9)
    {
      int redvalue = 255;
      stroke(redvalue,0,0);
          point(myfft.spectrum[i]*400+(width/2),i);
          point(-myfft.spectrum[i]*400+(width/2),i);
       stroke(redvalue-10,0,0);   
          point(2*myfft.spectrum[i]*400+(width/2),i);
          point(2*-myfft.spectrum[i]*400+(width/2),i);
       stroke(redvalue-20,0,0);   
          point(4*myfft.spectrum[i]*400+(width/2),i);
          point(4*-myfft.spectrum[i]*400+(width/2),i);
        stroke(redvalue-30,0,0);  
          point(8*myfft.spectrum[i]*400+(width/2),i);
          point(8*-myfft.spectrum[i]*400+(width/2),i);
        stroke(redvalue-40,0,0);  
          point(16*myfft.spectrum[i]*400+(width/2),i);
          point(16*-myfft.spectrum[i]*400+(width/2),i);

    }
    else
    {      
      if(i < bufferSize-4 && i > 0)
      {
          stroke(255,255,0);
          curve((float)i,(height/2)+myfft.spectrum[i]*-400,(float)i+1,(height/2)+myfft.spectrum[i+1]*400,(float)i+2,(height/2)+myfft.spectrum[i+2]*-400,(float)i+3,(height/2)+myfft.spectrum[i+3]*-400);
          stroke(255,0,155);
          curve((float)i,(height/2)+myfft.spectrum[i]*-400-1,(float)i+1,(height/2)+myfft.spectrum[i+1]*400-1,(float)i+2,(height/2)+myfft.spectrum[i+2]*-400-1,(float)i+3,(height/2)+myfft.spectrum[i+3]*-400-1);
          stroke(255,0,0);
          curve((float)i,(height/2)+myfft.spectrum[i]*-400-1,(float)i+1,(height/2)+myfft.spectrum[i+1]*400-2,(float)i+2,(height/2)+myfft.spectrum[i+2]*-400-2,(float)i+3,(height/2)+myfft.spectrum[i+3]*-400-2);
        }
    }
    
  }
  
  
}

public void audioInputData(AudioInput theInput) {
  myfft.getSpectrum(myinput);
}




void branch(float h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
  
  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 2) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
}




