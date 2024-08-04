module SPI_Slave_tb();
//Signals Declaration
reg MOSI,SS_n,clk,rst_n,tx_valid;
reg [7:0] tx_data;
wire [9:0] rx_data;
wire rx_valid,MISO;
//Clock Generation
initial begin
	clk=0;
	forever
	#5 clk=~clk;//Period=10ns
end
//DUT Instantiation
SPI_Slave DUT (.MOSI(MOSI),.MISO(MISO),.SS_n(SS_n),.clk(clk),.rst_n(rst_n),.rx_data(rx_data),.rx_valid(rx_valid),.tx_data(tx_data),.tx_valid(tx_valid));
//Test Stimiulus Generator
initial begin
	//Activate Reset ,Un-Enable SS_n& Initialize all signals
	rst_n=0;
	MOSI=0;
	SS_n=1;
	tx_data=0;
	tx_valid=0;
	@(negedge clk);
	//De-Activate Reset ,Enable SS_n & Start testing
	rst_n=1;
	SS_n=0;
	@(negedge clk);
	//Test Writing Address
	SS_n=0;
	@(negedge clk);
	MOSI=0;//Write
	@(negedge clk);
	repeat(2) begin//2'b00 >> To write address
		MOSI=0;
		@(negedge clk);
	end
	repeat(8) begin//8'b00000000 >> Address
		MOSI=0;
		@(negedge clk);
	end
	SS_n=1;
	@(negedge clk);
	//Test Writing Data
	SS_n=0;
	@(negedge clk);
	MOSI=0;//Write
	@(negedge clk);
	MOSI=0;
	@(negedge clk);
	MOSI=1;//2'b01 >> To write Data
	repeat(8) begin//8'b11111111 >> Data
		MOSI=1;
		@(negedge clk);
	end
	SS_n=1;
	@(negedge clk);
	//Test Reading Address
	SS_n=0;
    @(negedge clk);
    MOSI=1;//Read
	@(negedge clk);
	MOSI=1;
	@(negedge clk);
	MOSI=0;//2'b10 >> To Read address
	@(negedge clk);
	repeat(8) begin//8'b00000000 >> Address
		MOSI=0;
		@(negedge clk);
	end
	SS_n=1;
	@(negedge clk);
	//Test Reading Data
	SS_n=0;
	@(negedge clk);
	MOSI=1;//Read
	@(negedge clk);
	repeat(2) begin//2'b11 >> To Read Data
		MOSI=1;
		@(negedge clk);
	end
	repeat(8) begin//8'b00000000 >> Dummy Data
		MOSI=1;
		@(negedge clk);
	end
	tx_valid=1;
	tx_data=8'b11111111;//Data to be transmitted to MISO
	repeat(15) @(negedge clk);//Wait To Read Data
	SS_n=1;
	@(negedge clk);
$stop;
end
//Test Monitor & Results
initial begin
    $monitor("MOSI = %b, MISO = %b, SS_n = %b, rx_data = %b, rx_valid = %b",MOSI, MISO, SS_n, rx_data, rx_valid);
end
endmodule