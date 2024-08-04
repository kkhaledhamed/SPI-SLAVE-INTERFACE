module SPI_Slave (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
//Ports
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0] tx_data;
output reg [9:0] rx_data;
output reg rx_valid,MISO;
//Internal Signals
reg [3:0] serial_to_parallel_counter;//Data Converted from serial to parallel in 10 clock cycles
reg [2:0] parallel_to_serial_counter;//Data Converted from parallel to serial in 8 clock cycles
reg addr_read_rec;//Address Read Received >> Ensures that reading address is done before reading data
//CS & NS
(*fsm_encoding="one_hot"*)
reg [2:0] cs ,ns;
//States
parameter IDLE = 3'b000;
parameter CHK_CMD = 3'b001;
parameter WRITE = 3'b010;
parameter READ_ADD = 3'b011;
parameter READ_DATA = 3'b100;
//Next State Logic (Comb)
always @(*) begin//always@(cs,MOSI,tx_data,tx_valid)
	case(cs)
		IDLE:begin
			if (~SS_n) begin
				ns=CHK_CMD;
			end
			else begin
				ns=IDLE;
			end
		end
		CHK_CMD:begin
			if (SS_n) begin
				ns=IDLE;
			end
			else begin
				if (~MOSI) begin
					ns=WRITE;
				end
				else begin
					if (~addr_read_rec) begin
						ns=READ_ADD;
					end
					else begin
						ns=READ_DATA;
					end
				end
			end
		end
		WRITE:begin
			if (SS_n) begin
				ns=IDLE;
			end
			else begin
				ns=WRITE;
			end
		end
		READ_ADD:begin
			if (SS_n) begin
				ns=IDLE;
			end
			else begin
				ns=READ_ADD;
			end
		end
		READ_DATA:begin
			if (SS_n) begin
				ns=IDLE;
			end
			else begin
				ns=READ_DATA;
			end
		end
		default : ns = IDLE; 
	endcase
end
//State Memory (Seq)
always @(posedge clk) begin
	if (~rst_n) begin
		cs<=IDLE;
	end
	else begin
		cs<=ns;
	end
end
//Output Logic (Seq)
always @(posedge clk) begin
	if (~rst_n) begin
		rx_data<=0;
		rx_valid<=0;
		MISO<=0;
		addr_read_rec<=0;
		serial_to_parallel_counter<=0;
		parallel_to_serial_counter<=0;
	end
	else begin
		case(cs)
			IDLE:begin
				rx_valid<=0;
				MISO<=0;
				serial_to_parallel_counter<=0;
				parallel_to_serial_counter<=0;
			end
			CHK_CMD:
			begin
				rx_valid<=0;
				serial_to_parallel_counter<=0;
				parallel_to_serial_counter<=0;
			end
			WRITE:begin
				if (serial_to_parallel_counter<10) begin
					rx_data <= {rx_data[8:0],MOSI};//Could be calculated as shift register or Using Up Counter : rx_data[9-serial_to_parallel_counter]<=MOSI;
					serial_to_parallel_counter<=serial_to_parallel_counter+1;
					rx_valid<=0;
				end
				else begin
					rx_valid<=1;//Conversion is done
				end
			end
			READ_ADD:begin
				addr_read_rec<=1;
				if (serial_to_parallel_counter<10) begin
					rx_data <= {rx_data[8:0],MOSI};//Could be calculated as shift register or Using Up Counter : rx_data[9-serial_to_parallel_counter]<=MOSI;
					serial_to_parallel_counter<=serial_to_parallel_counter+1;
					rx_valid<=0;
				end
				else begin
					rx_valid<=1;//Conversion is done
				end
			end
			READ_DATA:begin
				if (tx_valid && parallel_to_serial_counter<8) begin
					MISO <= tx_data[7 - parallel_to_serial_counter]; 
                    parallel_to_serial_counter <= parallel_to_serial_counter + 1;
					/*Could be calculated as shift register or Using Up Counter :MISO <= tx_data[7]; 
                     															 tx_data <= tx_data << 1; */
				end
				else begin
					if (serial_to_parallel_counter<10) begin
						rx_data <= {rx_data[8:0],MOSI};//Could be calculated as shift register or Using Up Counter : rx_data[9-serial_to_parallel_counter]<=MOSI;
						serial_to_parallel_counter<=serial_to_parallel_counter+1;
						rx_valid<=0;
					end
					else begin
						rx_valid<=1;//Conversion is done
						addr_read_rec<=0;
					end
				end
			end
		endcase
	end
end
endmodule