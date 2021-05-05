package mouseUART;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import java.util.Scanner;

import javax.swing.JFrame;
import javax.swing.JLayeredPane;
import javax.swing.SwingUtilities;

public class MouseCursorXYLabel extends JFrame
{

  public static void main(String[] args)
  {
    SwingUtilities.invokeLater(new Runnable()
    {
      public void run()
      {
        displayJFrame();
      }
    });
  }

  static void displayJFrame()
  {
	Scanner scan = new Scanner(System.in);
		
	String mousePS2Model = scan.next();// User input the model of PS2 port mouse
				
		
	MousePS2 mouse = new MousePS2(mousePS2Model);// Generate PS2 port mouse object
	mouse.setPs2(mouse);// Connect the mouse to the PS2 port of the board
	String inputString=mouse.inputFromPS2();// Get the data entered from the mouse
		
	scan.close();

	//String inputString = "100000000100000001000000000000001";
	
	byte[] byteArray = inputString.getBytes();
	
	Character btnRight=inputString.charAt(16);
	Character btnLeft=inputString.charAt(17);
	Character btnMiddle=inputString.charAt(18);
	
	int xPos=Integer.parseInt(inputString.substring(0,7),2);
	int yPos=Integer.parseInt(inputString.substring(8,15),2);

			
    // create a jframe as usual
    JFrame jFrame = new JFrame();
    jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    jFrame.setTitle("Mouse Cursor");

    // set the jframe size and center it
    jFrame.setPreferredSize(new Dimension(600, 600));
    jFrame.pack();
    jFrame.setLocationRelativeTo(null);
    
    // create an instance of my custom mouse cursor component
    final AlsXYMouseLabelComponent alsXYMouseLabel = new AlsXYMouseLabelComponent();

    // add my component to the DRAG_LAYER of the layered pane (JLayeredPane)
    JLayeredPane layeredPane = jFrame.getRootPane().getLayeredPane();
    layeredPane.add(alsXYMouseLabel, JLayeredPane.DRAG_LAYER);
    alsXYMouseLabel.setBounds(0, 0, jFrame.getWidth(), jFrame.getHeight());
    
    jFrame.setBackground(Color.white);

    // add a mouse motion listener, and update my custom mouse cursor with the x/y
    // coordinates as the user moves the mouse
    
    
    //aici vom modifica in fct de x si y primit de la placuta
    jFrame.addMouseMotionListener(new MouseMotionAdapter() {
    	public void mouseMoved()
    	{
    		alsXYMouseLabel.x = xPos;
    		alsXYMouseLabel.y = yPos;
    		alsXYMouseLabel.repaint();
    	}
    	}
    );

    //efecte pentru verificare apasare butoane , se schimba forma cursorului
    jFrame.addMouseListener(new MouseAdapter() {
    	public void mouseClicked() {
    		//left button
    		if (btnRight.equals('1')) {
    			jFrame.setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
    		}
    		//right button
    		else if (btnLeft.equals('1')) {
    			jFrame.setCursor(new Cursor(Cursor.WAIT_CURSOR));

    		}
    		//middle button
    		else if (btnMiddle.equals('1')) {
    			jFrame.setCursor(new Cursor(Cursor.HAND_CURSOR));
    		}
    	}
    });

    // display the jframe
    jFrame.setVisible(true);
  }
  
}
