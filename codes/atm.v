	`timescale 1ns / 1ps
	//////////////////////////////////////////////////////////////////////////////////
	// Company: 
	// Engineer: 
	// 
	// Create Date:    20:27:57 12/15/2019 
	// Design Name: 
	// Module Name:    atm 
	// Project Name: 
	// Target Devices: 
	// Tool versions: 
	// Description: 
	//
	// Dependencies: 
	//
	// Revision: 
	// Revision 0.01 - File Created
	// Additional Comments: 
	//
	//////////////////////////////////////////////////////////////////////////////////
	module atm (input clk,
								input rst,
								input BTN3, BTN2, BTN1,
								input [3:0] SW,
								output reg [7:0] LED,                                     // LED[7] is the left most-LED
								output reg [6:0] digit4, digit3, digit2, digit1  // digit4 is the left-most SSD
							  );
	  
		 reg [3:0] password ;
		 reg [15:0] balance; 
		 reg [3:0] current_state;
		 reg [3:0] next_state;	
		 
		//…					// additional registers
		
		 reg[31:0] counter = 0; //counter to wait
		
		 parameter IDLE = 4'b0000;
		 parameter PASS_ENT_3 = 4'b0001;
		 parameter PASS_ENT_2 = 4'b0010;
		 parameter PASS_ENT_1 = 4'b0011;
		 parameter LOCK = 4'b0100;
		 parameter ATM_MENU = 4'b0101;	 
		 parameter MONEY = 4'b0110;
		 parameter  WARNING = 4'b0111;	 
		 parameter PASS_CHG_3 = 4'b1000;
		 parameter PASS_CHG_2 = 4'b1001;
		 parameter  PASS_CHG_1 = 4'b1010;
		 parameter  PASS_NEW = 4'b1011;	



		// sequential part - state transitions
		always @ (posedge clk or posedge rst)
		begin
		//	…		// your code goes here
		if(rst)
			begin
			current_state <= IDLE;
			password <= 4'b0000;
			balance <= 15'b000000000000000;
			end
		else
		begin
			current_state <= next_state;
			counter <= counter + 9'b000000001;
		end	
		end

		// combinational part - next state definitions
		always @ (*)
		begin
		//	…		// your code goes here	
		case(current_state)
		
		IDLE:
			begin
				if(BTN3)
				 next_state = PASS_ENT_3;
				else
				next_state = IDLE;
			end
			
		PASS_ENT_3:
			begin
				
				if(SW == password && BTN3 == 1)
				 next_state = ATM_MENU;
				else if (SW != password && BTN3 == 1)
					next_state = PASS_ENT_2;
				else
					next_state = PASS_ENT_3;
			end
			
		PASS_ENT_2:
			begin
				if(SW == password && BTN3 == 1)
				 next_state = ATM_MENU;
				else if (SW != password && BTN3 ==1)
					next_state = PASS_ENT_1;
				else
					next_state = PASS_ENT_2;
			end
			
			PASS_ENT_1:		
			begin
				if(SW == password && BTN3 ==1 )
				 next_state = ATM_MENU;
				else if( SW != password && BTN3 ==1) 
					next_state = LOCK;
				else
					next_state = PASS_ENT_1;
			end
		
			LOCK:		
			begin
				/*
				if( counter == 9'b111110100)
				 next_state = IDLE;
				 else
				 begin
				 counter = counter + 1;
				 next_state = LOCK;
				 
				 end
				 */
				 next_state = LOCK;

			end
			
			ATM_MENU:
			begin
			  if(BTN3)
				 next_state = MONEY;
			  else if(BTN2)
				 next_state = PASS_CHG_3;
			  else if(BTN1)
				 next_state = IDLE;
				else
				  next_state = ATM_MENU;

				end
		
			MONEY:
			begin
				//for depositing money
				if(BTN3)
				 begin
					balance = balance + SW;
				 end
				 
				 //for withdrawing money
				 else if(BTN2)
				 begin
					if(balance < SW)
						next_state = WARNING;
					else
						balance = balance - SW;
				 end
				 
				else if(BTN1)
				  next_state = ATM_MENU;
				else
					next_state = MONEY;
			end
			
			WARNING:
			begin
			/*
				if(counter == 9'b11111010)
					next_state = IDLE;
				else
					begin
					next_state = WARNING;
					counter = counter + 1;
					end
					*/
					next_state = IDLE;
			end
			
			PASS_CHG_3:
			begin
				if(SW == password && BTN3 ==1)
					next_state = PASS_NEW;

				else if (SW != password && BTN3 ==1)	
			   	next_state = PASS_CHG_2;
				else
					next_state = PASS_CHG_3;
			end
			
			PASS_CHG_2:
			begin
				if(SW == password && BTN3 ==1)
					next_state = PASS_NEW;
				
				else if(SW != password && BTN3 == 1)
			   	next_state = PASS_CHG_1;
				else
					next_state = PASS_CHG_2;

			end
			
			PASS_CHG_1:
			begin
				if(SW == password && BTN3 == 1)
					next_state = PASS_NEW;

				else if(SW != password && BTN3 ==1)				
			   	next_state = LOCK;
				else
					next_state = PASS_CHG_1;
			end
			
			PASS_NEW:
			begin
				if(BTN3)
					begin
					password = SW;
					next_state= ATM_MENU;
					end	
				else if(BTN1)
					next_state = ATM_MENU;
				else
					next_state = PASS_NEW;
			end
			
			endcase
			
		end
		
		// sequential part - control registers
		/*
		always @ (posedge clk or posedge rst)
		begin
		//	…		// your code goes here	
		end 	
		*/
		

	/*
	// sequential part - outputs
		always @ (posedge clk or posedge rst)
		begin
		//	…		// your code goes here	

			LED[0] = 0;
			LED[1] = 0;
			LED[2] = 0;
			LED[3] = 0;
			LED[3] = 0;
			LED[4] = 0;
			LED[5] = 0;
			LED[6] = 0;
			LED[7] = 0;
			
			case(current_state)
			IDLE: begin
					//SSD = CArd
					LED[0]= 1; //led0 will blink 
					end
			PASS_ENT_3:
					begin
					//SSD = PE-3
					LED[7] = 1; //led7 will be open
					end
			
			PASS_ENT_2:
					begin
					//SSD = PE-2
					LED[6] = 1; //led6 will be open
					LED[7] = 1; //led7 will be open

					end
					
			PASS_ENT_1:
					begin
					//SSD = PE-1
					LED[5] = 1; //led5 will be open
					LED[6] = 1; //led6 will be open
					LED[7] = 1; //led7 will be open

					end	
			LOCK:
				begin
					//SSD = FAIL
					//all leds are on
					//lock all buttons for 5 seconds
				end
			
			ATM_MENU:
				 begin
					//SSD = OPen
					LED[4] = 1;
				 end
			 MONEY:
				begin
					//SSD = 	Balance
					LED[3] = 1;
				end
			 WARNING:
				begin
					//SSD = -nA-
					//all leds are on
				end
				
				PASS_CHG_3:
				begin
					//SSD = PC-3
					LED[2]= 1;
				end
				PASS_CHG_2:
				 begin
					//SSD = PC2
					LED[2] = 1;
					LED[1] = 1;
				 end
				 PASS_CHG_3:
				 begin
					//SSD = PC1
					LED[2] = 1;
					LED[1] = 1;
					LED[0] = 1;
				 end
				 PASS_NEW:
				 begin
					//SSD = PASS
					LED[1] = 1;				
				 end
			 
			endcase
		 
		
		end
		*/

		//…		// additional always statements

	endmodule
