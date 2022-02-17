module STI_DAC(clk ,reset, load, pi_data, pi_length, pi_fill, pi_msb, pi_low, pi_end,
	       so_data, so_valid,
	       pixel_finish, pixel_dataout, pixel_addr,
	       pixel_wr);
input		clk, reset;
input		load, pi_msb, pi_low, pi_end; 
input	[15:0]	pi_data;
input	[1:0]	pi_length;
input		pi_fill;
output reg		so_data, so_valid;
output reg  pixel_finish, pixel_wr;
output reg [7:0] pixel_addr;
output reg [7:0] pixel_dataout;
reg [10:0] pix_count;
reg [10:0]so_count;
reg[1:0] prev_length;
reg prev_msb,prev_low,prev_fill;
reg [7:0]prev_data;

//==============================================================================
always @(posedge clk or posedge reset) begin
	if(reset)begin
		so_valid <= 1'd0;
		pixel_addr <= -8'd1;
		so_count <= -11'd1;
		pix_count <= -11'd1;
	end
 	else  begin
		//if(so_count != 9  && so_count != 17 && so_count != 25 && so_count != 33)begin
	  		pixel_wr <= 1'd0;
		//end
		if(so_count <= 11'd8 && so_count >= 11'd1)begin
		pixel_dataout[8 - so_count] <= so_data;
		if (so_count == 8) begin
			pixel_wr <= 1'd1;
			pixel_addr <= pixel_addr + 1;
			pix_count <= pix_count + 1;
		end
		end
		else if(so_count <= 11'd16 && so_count >= 11'd9)begin
			pixel_dataout[16-so_count] <= so_data;
			if (so_count == 16) begin
				pixel_wr <= 1'd1;
				pixel_addr <= pixel_addr + 1;
				pix_count <= pix_count + 1;
			end
		end
		else if(so_count <= 11'd24 && so_count >= 11'd17)begin
			pixel_dataout[24-so_count] <= so_data;
			if (so_count == 24) begin
				pixel_wr <= 1'd1;
				pixel_addr <= pixel_addr + 1;
				pix_count <= pix_count + 1;
			end
		end
		else if(so_count <= 11'd32 && so_count >= 11'd25)begin
			pixel_dataout[32-so_count] <= so_data;
			if (so_count == 32) begin
				pixel_wr <= 1'd1;
				pixel_addr <= pixel_addr + 1;
				pix_count <= pix_count + 1;
			end
	 	end
		if(prev_length != pi_length || pi_msb != prev_msb || pi_fill != prev_fill || pi_low != prev_low || prev_data !=pi_data )begin
			case(pi_length)
			2'b00:begin
				so_count <= so_count + 11'd1;
				if (so_count == -11'd1) begin
					so_valid <= 1'd1;
				end
				else if(so_count >= 11'd0 && so_count <= 7 )begin
					if (pi_low == 1'd1) begin
						if(pi_msb == 1'd1)begin
							so_data <= pi_data[15 - so_count];
						end
						else begin
							so_data <= pi_data[8 + so_count];
						end
					end
					else begin
						if(pi_msb == 1'd1)begin
							so_data <= pi_data[7 - so_count];
						end
						else begin
							so_data <= pi_data[so_count];
						end
					end
				end
				else if(so_count == 11'd8)begin
					so_valid <= 1'd0;
				end
				else if (so_count == 11'd9) begin
					so_count <= -11'd1;
					prev_length <= pi_length;
					prev_msb <= pi_msb;
					prev_fill <= pi_fill;
					prev_low <= pi_low;
					prev_data <= pi_data;
				end
			end
			2'b01:begin
				so_count <= so_count + 11'd1;
				if (so_count == -11'd1) begin
					so_valid <= 1'd1;
				end
				else if(so_count <= 11'd15 && so_count >= 11'd0)begin
					if(pi_msb == 1'd1)begin
						so_data <= pi_data[15-so_count];
					end
					else begin
						so_data <= pi_data[so_count];
					end
				end
				else if(so_count == 11'd16)begin
					so_valid <= 1'd0;
				end
				else if (so_count == 11'd17) begin
					so_count <= -11'd1;
					prev_length <= pi_length;
					prev_msb <= pi_msb;
					prev_fill <= pi_fill;
					prev_low <= pi_low;
					prev_data <= pi_data;
				end
			end
			2'b10:begin
				so_count <= so_count + 11'd1;
				if (so_count == -11'd1) begin
					so_valid <= 1'd1;
				end
				else if(so_count <= 11'd23 && so_count >= 11'd0)begin
					if(pi_fill == 1'd1)begin
						if(pi_msb == 1'd1)begin
							if(so_count > 11'd15)begin
								so_data <= 1'd0;
							end
							else begin
								so_data <= pi_data[15-so_count];
							end
						end
						else begin
							if(so_count < 11'd8)begin
								so_data <= 1'd0;
							end
							else begin
								so_data <= pi_data[so_count-8];	
							end
						end
					end
					else begin
						if(pi_msb == 1'd1)begin
							if(so_count < 11'd8)begin
								so_data <= 1'd0;
							end
							else begin
								so_data <= pi_data[23-so_count];
							end
						end
						else begin
							if(so_count > 11'd15)begin
								so_data <= 1'd0;	
							end
							else begin
								so_data <= pi_data[so_count];		
							end
						end		
					end
				end
				else if(so_count == 11'd24)begin
					so_valid <= 1'd0;
				end
				else if (so_count == 11'd25) begin
					so_count <= -11'd1;
					prev_length <= pi_length;
					prev_msb <= pi_msb;
					prev_fill <= pi_fill;
					prev_low <= pi_low;
					prev_data <= pi_data;
				end
			end
			2'b11:begin
				so_count <= so_count + 11'd1;
				if (so_count == -11'd1) begin
					so_valid <= 1'd1;
				end
				else if( so_count <= 11'd31 && so_count >= 11'd0)begin
					if(pi_fill == 1'd1)begin
						if(pi_msb == 1'd1)begin
							if(so_count > 11'd15)begin
								so_data <= 1'd0;	
							end
							else begin
								so_data <= pi_data[15-so_count];
							end
						end
						else begin
							//pi_msb == 0
							if(so_count < 11'd16)begin
								so_data <= 1'd0;
							end
							else begin
								so_data <= pi_data[so_count-16];	
							end
						end
					end
					else begin
						//pi_fill ==0
						if(pi_msb == 1'd1)begin
							if(so_count < 11'd16)begin
								so_data <= 1'd0;
							end
							else begin
								so_data <= pi_data[31-so_count];	
							end
						end
						else begin
							if(so_count > 11'd15)begin
								so_data <= 1'd0;	
							end
							else begin
								so_data <= pi_data[so_count];
							end
						end
					end
				end
				else if(so_count == 11'd32)begin
					so_valid <= 1'd0;
				end
				else if (so_count == 11'd33) begin
					so_count <= -11'd1;
					prev_length <= pi_length;
					prev_msb <= pi_msb;
					prev_fill <= pi_fill;
					prev_low <= pi_low;
					prev_data <= pi_data;
				end
			end
			endcase
		end
		else begin
		   so_data <= 1'd0;
		   so_count <= so_count + 1;
		   if(so_count == 11'd33)begin
			 so_count <= -11'd1;
		   end
		end
	end
end

always @(*) begin
	// if(so_count != 9  && so_count != 17 && so_count != 25 && so_count != 33)begin
	//   		pixel_wr = 1'd0;
	// 	end
	// 	if(so_count <= 11'd8 && so_count >= 11'd1)begin
	// 	pixel_dataout[8 - so_count] = so_data;
	// 	if (so_count == 8) begin
	// 		pixel_wr = 1'd1;
	// 		pixel_addr = pixel_addr + 1;
	// 		pix_count = pix_count + 1;
	// 	end
	// 	end
	// 	else if(so_count <= 11'd16 && so_count >= 11'd9)begin
	// 		pixel_dataout[16-so_count] = so_data;
	// 		if (so_count == 16) begin
	// 			pixel_wr = 1'd1;
	// 			pixel_addr = pixel_addr + 1;
	// 			pix_count = pix_count + 1;
	// 		end
	// 	end
	// 	else if(so_count <= 11'd24 && so_count >= 11'd17)begin
	// 		pixel_dataout[24-so_count] = so_data;
	// 		if (so_count == 24) begin
	// 			pixel_wr = 1'd1;
	// 			pixel_addr = pixel_addr + 1;
	// 			pix_count = pix_count + 1;
	// 		end
	// 	end
	// 	else if(so_count <= 11'd32 && so_count >= 11'd25)begin
	// 		pixel_dataout[32-so_count] = so_data;
	// 		if (so_count == 32) begin
	// 			pixel_wr = 1'd1;
	// 			pixel_addr = pixel_addr + 1;
	// 			pix_count = pix_count + 1;
	// 		end
	// 	end
	if(pix_count == 255)begin//255mdsim ok/256ncv ok
	  pixel_finish = 1'd1;
	end
	else begin
		pixel_finish = 0;
	end
end
endmodule
