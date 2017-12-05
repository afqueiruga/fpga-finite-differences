`default_nettype none
  
module tl_fdm1d
  (
   input wire clk40mhz,

   input wire RX,
   output wire TX,

   input wire reset,
   output wire led_reset,
   output wire led_done,
   output wire led_calc,
   output wire led_tx
   );

   /*
    * Define the global paramters
    */
   parameter NITER = 100;
   parameter NU = 10;
   parameter WIDTH = 32;
   parameter EXPON = 16;
   
   /*
    * Define the global states
    * We start with done.
    */
   reg 	       st_calc = 0;
   reg [31:0]  st_calc_cnt = 0;
   reg 	       st_tx = 0;
   reg [31:0]  st_tx_cnt = 0;
   reg 	       st_done = 1;
   
   /*
    * Define and generate the UART clock signals
    * Doesn't bother to reset.
    */
   wire 	       clkbaud;
   baudgen bg0 ( clk40mhz, 1'b0, clkbaud );
   
   /*
    * Define the U array and instantiate it to 0
    */
   reg [NU*WIDTH-1:0] u_Array = 0;
   wire [NU*WIDTH-1:0] u_Outs;

   
   /*
    * Manage the states
    */
   always @(posedge clk40mhz) begin
      if (reset) begin
	 st_calc = 1;
	 st_calc_cnt = 0;
	 st_done = 0;
	 st_tx = 0;
	 u_Array = 0; // Reinitialize
      end 
      else if (st_calc) begin
	 u_Array = u_Outs;
	 st_calc_cnt = st_calc_cnt + 1;
	 if (st_calc_cnt == NITER) begin
	    st_calc = 0;
	    st_tx = 1;

	 end
      end
      else if (st_tx) begin
	 if (st_tx_cnt == 10*NU) begin
	    st_tx = 0;
	    st_done = 1;
	 end
      end
   end // always @ (posedge clk40mhz)
   /* This counter increments on baud since its 
    counting signal duration */
   always @(posedge clkbaud) begin
      st_tx_cnt = st_tx_cnt + 1;
      if ( !st_tx ) begin
      	 st_tx_cnt = 0;
      end
   end      

   
   /*
    * Perform iteration on clk40mhz
    */
   jacobi #(.NU(NU), .WIDTH(WIDTH), .EXPON(EXPON) ) jack
     (u_Array,u_Outs);
   //always @(posedge clk40mhz) begin
   //   if(st_calc) begin

   //   end
   //end

   
   /*
    * Set up the transmit module
    */
   sendstring #(.N(4*NU)) sender
     ( u_Array, st_tx, clkbaud, reset, TX);

   
   /*
    *   Hook up some led's as a sanity check
    */
   assign led_done = st_done;
   assign led_reset = reset;
   assign led_tx = st_tx;
   assign led_calc = st_calc;
   
endmodule // tl_fdm1d
