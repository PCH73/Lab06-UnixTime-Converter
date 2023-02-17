//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : B2BCD_IP.v
//   Module Name : B2BCD_IP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module B2BCD_IP
#(parameter WIDTH = 4, parameter DIGIT = 2)   // input width
  ( input      [WIDTH-1:0] Binary_code   ,  // binary
    output reg [4*DIGIT-1:0] BCD_code   ); // bcd {...,thousands,hundreds,tens,ones}
   
integer i,j;

reg [4:0] in1,in2,in3,in4,in5,in6;
wire[4:0] out1,out2,out3,out4,out5,out6;

SA1  M1(.SA_in1(in1), .SA_out1(out1));
SA2  M2(.SA_in2(in2), .SA_out2(out2));
SA3  M3(.SA_in3(in3), .SA_out3(out3));
SA4  M4(.SA_in4(in4), .SA_out4(out4));
SA5  M5(.SA_in5(in5), .SA_out5(out5));
SA6  M6(.SA_in6(in6), .SA_out6(out6));

	
always @(*) 
begin
    for(i=0;i<=DIGIT*4-1;i=i+1) BCD_code[i]=0;
    BCD_code[WIDTH-1:0]=Binary_code;                                   
    for(i=0;i<WIDTH-3;i=i+1)
    begin      
        for(j=0;j<=i/3;j=j+1) 
        begin
            if(BCD_code[WIDTH-i+4*j-:4]>4)
            BCD_code[WIDTH-i+4*j-:4]=BCD_code[WIDTH-i+4*j-:4]+3; 
        end     
    end  
end
endmodule


module SA1 (SA_in1, SA_out1);
input [4:0] SA_in1;
output reg [4:0] SA_out1;
always @(*) 
begin
    if (SA_in1==5) SA_out1=SA_in1 + 3;
    else if(SA_in1==6)  SA_out1=SA_in1+ 3;
    else if(SA_in1==7)  SA_out1=SA_in1 + 3;
    else if(SA_in1==8)  SA_out1=SA_in1 + 3;
    else if(SA_in1==9)  SA_out1=SA_in1 + 3;
    else if(SA_in1==10) SA_out1=SA_in1 + 3;
    else if(SA_in1==11) SA_out1=SA_in1 + 3;
    else if(SA_in1==12) SA_out1=SA_in1 + 3;
    else if(SA_in1==13) SA_out1=SA_in1 + 3;
    else if(SA_in1==14) SA_out1=SA_in1 + 3;
    else if(SA_in1==15) SA_out1=SA_in1 + 3;
    else SA_out1= SA_in1;
end

endmodule

module SA2 (SA_in2, SA_out2);
input [4:0] SA_in2;
output reg [4:0] SA_out2;
always @(*) 
begin
    if (SA_in2==5) SA_out2=SA_in2 + 3;
    else if(SA_in2==6)  SA_out2=SA_in2+ 3;
    else if(SA_in2==7)  SA_out2=SA_in2 + 3;
    else if(SA_in2==8)  SA_out2=SA_in2 + 3;
    else if(SA_in2==9)  SA_out2=SA_in2 + 3;
    else if(SA_in2==10) SA_out2=SA_in2 + 3;
    else if(SA_in2==11) SA_out2=SA_in2 + 3;
    else if(SA_in2==12) SA_out2=SA_in2 + 3;
    else if(SA_in2==13) SA_out2=SA_in2 + 3;
    else if(SA_in2==14) SA_out2=SA_in2 + 3;
    else if(SA_in2==15) SA_out2=SA_in2 + 3;
    else SA_out2= SA_in2;
end

endmodule

module SA3 (SA_in3, SA_out3);
input [4:0] SA_in3;
output reg [4:0] SA_out3;
always @(*) 
begin
    if (SA_in3==5) SA_out3=SA_in3 + 3;
    else if(SA_in3==6)  SA_out3=SA_in3 + 3;
    else if(SA_in3==7)  SA_out3=SA_in3 + 3;
    else if(SA_in3==8)  SA_out3=SA_in3 + 3;
    else if(SA_in3==9)  SA_out3=SA_in3 + 3;
    else if(SA_in3==10) SA_out3=SA_in3 + 3;
    else if(SA_in3==11) SA_out3=SA_in3 + 3;
    else if(SA_in3==12) SA_out3=SA_in3 + 3;
    else if(SA_in3==13) SA_out3=SA_in3+ 3;
    else if(SA_in3==14) SA_out3=SA_in3+ 3;
    else if(SA_in3==15) SA_out3=SA_in3 + 3;
    else SA_out3= SA_in3;
end

endmodule

module SA4 (SA_in4, SA_out4);
input [4:0] SA_in4;
output reg [4:0] SA_out4;
always @(*) 
begin
    if (SA_in4==5) SA_out4=SA_in4 + 3;
    else if(SA_in4==6)  SA_out4=SA_in4 + 3;
    else if(SA_in4==7)  SA_out4=SA_in4 + 3;
    else if(SA_in4==8)  SA_out4=SA_in4 + 3;
    else if(SA_in4==9)  SA_out4=SA_in4 + 3;
    else if(SA_in4==10) SA_out4=SA_in4 + 3;
    else if(SA_in4==11) SA_out4=SA_in4 + 3;
    else if(SA_in4==12) SA_out4=SA_in4 + 3;
    else if(SA_in4==13) SA_out4=SA_in4 + 3;
    else if(SA_in4==14) SA_out4=SA_in4 + 3;
    else if(SA_in4==15) SA_out4=SA_in4 + 3;
    else SA_out4= SA_in4;
end

endmodule

module SA5 (SA_in5, SA_out5);
input [4:0] SA_in5;
output reg [4:0] SA_out5;
always @(*) 
begin
    if (SA_in5==5) SA_out5=SA_in5 + 3;
    else if(SA_in5==6)  SA_out5=SA_in5 + 3;
    else if(SA_in5==7)  SA_out5=SA_in5 + 3;
    else if(SA_in5==8)  SA_out5=SA_in5 + 3;
    else if(SA_in5==9)  SA_out5=SA_in5 + 3;
    else if(SA_in5==10) SA_out5=SA_in5 + 3;
    else if(SA_in5==11) SA_out5=SA_in5 + 3;
    else if(SA_in5==12) SA_out5=SA_in5 + 3;
    else if(SA_in5==13) SA_out5=SA_in5 + 3;
    else if(SA_in5==14) SA_out5=SA_in5 + 3;
    else if(SA_in5==15) SA_out5=SA_in5 + 3;
    else SA_out5= SA_in5;
end

endmodule

module SA6 (SA_in6, SA_out6);
input [4:0] SA_in6;
output reg [4:0] SA_out6;
always @(*) 
begin
    if (SA_in6==5) SA_out6=SA_in6 + 3;
    else if(SA_in6==6)  SA_out6=SA_in6 + 3;
    else if(SA_in6==7)  SA_out6=SA_in6 + 3;
    else if(SA_in6==8)  SA_out6=SA_in6 + 3;
    else if(SA_in6==9)  SA_out6=SA_in6 + 3;
    else if(SA_in6==10) SA_out6=SA_in6 + 3;
    else if(SA_in6==11) SA_out6=SA_in6 + 3;
    else if(SA_in6==12) SA_out6=SA_in6 + 3;
    else if(SA_in6==13) SA_out6=SA_in6 + 3;
    else if(SA_in6==14) SA_out6=SA_in6 + 3;
    else if(SA_in6==15) SA_out6=SA_in6 + 3;
    else SA_out6= SA_in6;
end

endmodule












