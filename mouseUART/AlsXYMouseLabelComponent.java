package mouseUART;

import java.awt.Color;
import java.awt.Graphics;

import javax.swing.JComponent;

class AlsXYMouseLabelComponent extends JComponent
{
  public int x;
  public int y;
  
  public AlsXYMouseLabelComponent() {
    this.setBackground(Color.green);
  }

  // use the xy coordinates to update the mouse cursor text
  protected void paintComponent(Graphics g)
  {
    super.paintComponent(g);
    String coord = x + ", " + y;
    g.setColor(Color.black);
    g.drawString(coord, x, y);
  }
}