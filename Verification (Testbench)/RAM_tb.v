`timescale 1ns/1ps
module RAM_tb ();
//Signals Declaration
reg [9:0] din ;
reg clk,rst_n,rx_valid ;
wire [7:0] dout ;
wire tx_valid ;
integer i = 0;
//Clock Generation
initial begin
	clk=0;
	forever 
	#5 clk=~clk;//Period=10ns
end
//DUT Instantiation
RAM #(.MEM_DEPTH(256),.ADDR_SIZE(8)) DUT (.din(din),.clk(clk),.rst_n(rst_n),.rx_valid(rx_valid),.dout(dout),.tx_valid(tx_valid));
//Test Stimiulus Generator
initial begin
	//Initializing Memory
	for(i=0;i<256;i=i+1) begin
		DUT.mem[i]=0;
	end
	//Activate rst_n & Initialize all signals
	rst_n = 0;
	din=0;
	rx_valid=0;
	@(negedge clk);
	//De-Activate rst_n & Start Testing
	rst_n=1;
	//Test Holding din[7:0] as a Write Address
	rx_valid=1;
	din[9:8]=2'b00;
	din[7:0]=8'd10;//Memory Location Where data goes to
	@(negedge clk);
	//Test Writing in the memory with address held previously
	rx_valid=1;
	din[9:8]=2'b01;
	din[7:0]=8'd19;//Data which will bw stored in memory
	@(negedge clk);
	//Test Holding din[7:0] as a Read Address
	rx_valid=1;
	din[9:8]=2'b10;
	din[7:0]=8'd10;//Read data from this memory location
	@(negedge clk);
	//Test Writing in the memory with address held previously & Raising tx_valid high
				/*rx_valid Will not affect neither is 0 nor 1*/
				   /*Expected Output is 19 in location 10*/
	din[9:8]=2'b11;
	din[7:0]=$random;//Dummy Data
	@(negedge clk);
	$stop;
end
//Test Monitor & Results
initial begin
	$monitor("clk=%d,rst_n=%d,rx_valid=%d,din=%d,dout=%d,tx_valid=%d",clk,rst_n,rx_valid,din,dout,tx_valid);
end
endmodule