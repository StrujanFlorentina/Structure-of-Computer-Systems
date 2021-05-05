package mouseUART;


class MousePS2 implements PS2
{
	//33 biti
	public String data;
    public Object ob;
    
    
    public MousePS2(String data)
    {
    	this.data=data;
    }

    public void setPs2(Object obj)
    {
        if(obj instanceof MousePS2)
        {
            MousePS2 m = (MousePS2) obj;
            ob = m;
        }
    }
    public String inputFromPS2()
    {
        if(ob instanceof MousePS2)
        {
            ob = (MousePS2) ob;
            System.out.println("Get data" + data +" from PS2 Mouse");
        }
        return data;
    }
}