`default_nettype none
  
module stencil
  #(
    parameter WIDTH=8,
    parameter EXPON=3
    )
  (
   input wire [WIDTH-1:0]  um,
   input wire [WIDTH-1:0]  up,
   
   output wire [WIDTH-1:0] u_out
   );
   reg [WIDTH-1:0] 	  h2;
   wire [WIDTH-1:0] 	  um_p_up;
   wire [WIDTH-1:0] 	  h2_p_uu;

   initial h2 = 8'd1<<EXPON;
   
   assign um_p_up = um + up;
   assign h2_p_uu = h2 + um_p_up;

   assign u_out = h2_p_uu / (2);
   
endmodule // stencil

module jacobi
  #(
    parameter NU=10,
    parameter WIDTH=8,
    parameter EXPON=3
    )
   (
    input wire [NU*WIDTH-1:0]  uin_arr,
    output wire [NU*WIDTH-1:0] uou_arr
    );

   assign uou_arr[NU*WIDTH-1:(NU-1)*WIDTH] 
     = uin_arr[NU*WIDTH-1:(NU-1)*WIDTH];
   assign uou_arr[WIDTH-1:0] 
     = uin_arr[WIDTH-1:0];
   
   genvar  		    i;
   generate
      for (i=1; i<NU-1; i=i+1) begin
	 stencil #(.WIDTH(WIDTH), .EXPON(EXPON)
		   ) stenc
	    (
	     uin_arr[(i-1)*WIDTH +WIDTH-1 : (i-1)*WIDTH],
	     uin_arr[(i+1)*WIDTH +WIDTH-1 : (i+1)*WIDTH],
	     uou_arr[(i  )*WIDTH +WIDTH-1 : (i  )*WIDTH] );
      end
   endgenerate
   
endmodule // jacobi
