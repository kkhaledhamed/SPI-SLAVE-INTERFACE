module RAM (din,clk,rst_n,rx_valid,dout,tx_valid);
//Ports
input [9:0] din ;
input clk,rst_n,rx_valid ;
output reg [7:0] dout ;
output reg tx_valid ;
//Parameters
parameter MEM_DEPTH = 256 ;
parameter ADDR_SIZE = 8 ;
//Addresses
reg [ADDR_SIZE-1:0] addr_rd , addr_wr ;
//Memory , Memory Width >> 8 Bits as ADDR_SIZE & din 10 bits & 1st 2 bits are for protocol only
reg [7:0] mem [MEM_DEPTH-1:0] ;
//RAM Functionality , Active Low Async. rst , but in vivado async. signals make problems in synthesis so its sync. here
always @(posedge clk) begin
	if (~rst_n) begin
		dout<=0;
		tx_valid<=0;
		addr_rd<=0;
		addr_wr<=0;
	end
	else begin
		case(din[9:8])
			2'b00: begin
				//Hold Write Address
				tx_valid<=0;
				if (rx_valid) begin
					addr_wr<=din[7:0];
				end
			end
			2'b01: begin
				//Write in the memory with address held previously
				tx_valid<=0;
				if (rx_valid) begin
					mem[addr_wr]<=din[7:0];
				end
			end
			2'b10: begin
				//Hold Read Address
				tx_valid<=0;
				if (rx_valid) begin
					addr_rd<=din[7:0];
				end
			end
			2'b11: begin
				//Readt the memory with address held previously , din[7:0] Is dummy & Raise tx_valid high
				dout<=mem[addr_rd];
				tx_valid<=1;
			end
		endcase
	end
end
//tx_valid could be also calculated as : assign tx_valid = din[9] & din[8] , Out of the always block
endmodule