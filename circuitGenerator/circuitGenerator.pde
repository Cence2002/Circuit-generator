int[][] b;
int x;
int y;
int ax;
int ay;
int pd;
boolean res;
boolean fin;
ArrayList<ArrayList<PVector>> s;
float t;
int n;
PImage map;
int stop;

void setup() {
  frameRate(60);
  size(800, 800);
  background(0);
  ax=60;
  ay=60;
  stop=2130;
  stop=9630;
  b=new int[ax][ay];
  for (int i=0; i<ax; i++) {
    for (int j=0; j<ay; j++) {
      b[i][j]=-1;
    }
  }
  s=new ArrayList<ArrayList<PVector>>();
  translate(width/ax/2, height/ay/2);
  setNew();
  pd=1;
  res=false;
  fin=false;
  t=0;
}

void draw() {
  println(frameRate);
  translate(width/ax/2, height/ay/2);
  for (int dt=0; dt<60.0/(101-min(frameCount/4, 100))+2; dt++) {
    if (n<=stop) {
      ArrayList<Integer> ds;
      ds=new ArrayList<Integer>();
      for (int max=0; max<3; max++) {
        if (ds.size()==0) {
          for (int i=0; i<8; i++) {
            if (res||min((i-pd+8)%8, (pd-i+8)%8)<=max+random(1.05)) {
              if (!rr(i)) {
                if (!cr(i)) {
                  ds.add(i);
                }
              }
            }
          }
        }
      }
      if (ds.size()==0) {
        res=true;
        b[x][y]=0;
        setNew();
      } else {
        res=false;
      }
      if (ds.size()>0) {
        int dir=ds.get(int(random(ds.size())));
        pd=dir;
        b[x][y]=dir;
        go(dir);
      }
    }
    if (n==stop) {
      background(0);
      for (ArrayList<PVector> ss : s) {
        stroke(20, 80, 255);
        strokeWeight(2);
        for (int i=0; i<ss.size()-1; i++) {
          line(ss.get(i).x, ss.get(i).y, ss.get(i+1).x, ss.get(i+1).y);
        }
        noStroke();
        fill(20, 130, 255);
        circle(ss.get(0).x, ss.get(0).y, 7);
        fill(0);
        circle(ss.get(0).x, ss.get(0).y, 3);
        if (ss.size()>1) {
          fill(20, 130, 255);
          circle(ss.get(ss.size()-1).x, ss.get(ss.size()-1).y, 7);
          fill(0);
          circle(ss.get(ss.size()-1).x, ss.get(ss.size()-1).y, 3);
        }
      }
      saveFrame("map.jpg");
      map=loadImage("map.jpg");
    }
  }
  if (n<=stop) {
    background(0);
    for (ArrayList<PVector> ss : s) {
      stroke(20, 80, 255);
      strokeWeight(2);
      for (int i=0; i<ss.size()-1; i++) {
        line(ss.get(i).x, ss.get(i).y, ss.get(i+1).x, ss.get(i+1).y);
      }
      noStroke();
      fill(20, 130, 255);
      circle(ss.get(0).x, ss.get(0).y, 7);
      fill(0);
      circle(ss.get(0).x, ss.get(0).y, 3);
      if (ss.size()>1) {
        fill(20, 130, 255);
        circle(ss.get(ss.size()-1).x, ss.get(ss.size()-1).y, 7);
        fill(0);
        circle(ss.get(ss.size()-1).x, ss.get(ss.size()-1).y, 3);
      }
    }
  } else {
    stroke(1, 0, 0);
    image(map, -width/ax/2, -height/ay/2);
    for (ArrayList<PVector> ss : s) {
      if (ss.size()>8) {
        stroke(40, 200, 255);
        strokeWeight(3);
        sig(ss);
      }
    }
  }
  t+=0.5;
  n++;
}

void sig(ArrayList<PVector> ss) {
  int i=int(t%ss.size());
  float j=t%ss.size()-i;
  PVector p1, p2, p3;
  if (i==0) {
    p1=ss.get(0).copy();
  } else {
    p1=ss.get(i-1).copy().lerp(ss.get(i), j);
  }
  p2=ss.get(i).copy();
  if (i==ss.size()-1) {
    p3=ss.get(ss.size()-1).copy();
  } else {
    p3=ss.get(i).copy().lerp(ss.get(i+1), j);
  }
  line(p1.x, p1.y, p2.x, p2.y);
  line(p2.x, p2.y, p3.x, p3.y);
}

void setNew() {
  do {
    x=int(random(ax));
    y=int(random(ay));
  } while ((b[x][y]!=-1||edge(0)));
  s.add(0, new ArrayList<PVector>());
  s.get(0).add(new PVector(width/ax*x, height/ay*y));
}

void go(int d) {
  int px=x;
  int py=y;
  switch(d) {
  case 0:
    if (x<ax-1) {
      x++;
    }
    break;
  case 1:
    if (x<ax-1&&y<ay-1) {
      x++;
      y++;
    }
    break;
  case 2:
    if (y<ay-1) {
      y++;
    }
    break;
  case 3:
    if (x>0&&y<ay-1) {
      x--;
      y++;
    }
    break;
  case 4:
    if (x>0) {
      x--;
    }
    break;
  case 5:
    if (x>0&&y>0) {
      x--;
      y--;
    }
    break;
  case 6:
    if (y>0) {
      y--;
    }
    break;
  case 7:
    if (x<ax-1&&y>0) {
      x++;
      y--;
    }
    break;
  }
  s.get(0).add(new PVector(width/ax*x, height/ay*y));
}

boolean rr(int d) {
  if (edge(1)) {
    return true;
  }
  switch(d) {
  case 0:
    if (x>=ax-1) {
      return true;
    } else {
      return b[x+1][y]!=-1;
    }
  case 1:
    if (x>=ax-1||y>=ay-1) {
      return true;
    } else {
      return b[x+1][y+1]!=-1;
    }
  case 2:
    if (y>=ay-1) {
      return true;
    } else {
      return b[x][y+1]!=-1;
    }
  case 3:
    if (x<=0||y>=ay-1) {
      return true;
    } else {
      return b[x-1][y+1]!=-1;
    }
  case 4:
    if (x<=0) {
      return true;
    } else {
      return b[x-1][y]!=-1;
    }
  case 5:
    if (x<=0||y<=0) {
      return true;
    } else {
      return b[x-1][y-1]!=-1;
    }
  case 6:
    if (y<=0) {
      return true;
    } else {
      return b[x][y-1]!=-1;
    }
  case 7:
    if (x>=ax-1||y<=0) {
      return true;
    } else {
      return b[x+1][y-1]!=-1;
    }
  }
  return true;
}

boolean cr(int d) {
  switch(d) {
  case 1:
    return b[x+1][y]==3||b[x][y+1]==7;
  case 3:
    return b[x][y+1]==5||b[x-1][y]==1;
  case 5:
    return b[x-1][y]==7||b[x][y-1]==3;
  case 7:
    return b[x][y-1]==1||b[x+1][y]==5;
  }
  return false;
}

boolean edge(int out) {
  return rec(10, 10, 10, 10, out)||rec(30, 10, 10, 10, out)||rec(10, 35, 30, 8, out)||rec(8, 33, 8, 8, out)||rec(34, 33, 8, 8, out)||rec(22, 21, 6, 10, out);
}

boolean rec(int x1, int y1, int x2, int y2, int out) {
  if (out==1) {
    return x>=x1&&x<x1+x2&&y>=y1&&y<y1+y2;
  }
  return x>x1&&x<x1+x2-1&&y>y1&&y<y1+y2-1;
}
