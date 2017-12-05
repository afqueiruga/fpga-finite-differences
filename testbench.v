`default_nettype none
  
module testbench();
   parameter WIDTH = 8;
   parameter NU = 10;
   
   reg [WIDTH*NU-1:0] u_Array;
   wire [WIDTH*NU-1:0] u_Outs;
   integer 	       i;
   
   initial begin
      $dumpfile("test.vcd");
      $dumpvars(0,testbench);
      
      
      // for(i=0; i<NU; i=i+1) begin
      // 	 u_Array[i*WIDTH+7:i*WIDTH+0] = 8'd0;
      // end
      
      u_Array[WIDTH*NU-1:0] = 0;
      
      #100 $finish;
      
   end
   
   jacobi jack(u_Array, u_Outs);
   
   reg clk = 0;
   always begin
      #5 clk = ~clk;
   end      

   always @(posedge clk) begin
     u_Array = u_Outs;
   end
endmodule // testbench
