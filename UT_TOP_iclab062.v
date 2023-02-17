//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : UT_TOP.v
//   Module Name : UT_TOP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
`include "B2BCD_IP.v"
//synopsys translate_on

module UT_TOP (
    // Input signals
    clk, rst_n, in_valid, in_time,
    // Output signals
    out_valid, out_display, out_day
);

// ===============================================================
// Input & Output Declaration
// ===============================================================
input clk, rst_n, in_valid;
input [30:0] in_time;
output reg out_valid;
output reg [3:0] out_display;
output reg [2:0] out_day;

// ===============================================================
// Parameter & Integer Declaration
// ===============================================================
parameter S_IDLE = 3'd0;
parameter S_IN   = 3'd1;
parameter S_CAL  = 3'd2;
parameter S_OUT  = 3'd3;

//================================================================
// Wire & Reg Declaration
//================================================================
reg [2:0] c_state,n_state;
reg [30:0] unix_time;
reg [4:0]count_4year;
reg [30:0] left_time;
reg [2:0]count_year;
reg [2:0]count_day;
reg [11:0] year;
reg [3:0] month;
reg [7:0] day;
reg [7:0] hour;
reg [7:0] minute,second;
reg [1:0] flag_count_4year,flag_count_year,flag_year,flag_month,flag_day,flag_hour,flag_minute,flag_second,flag_out_day;
reg [3:0] count_out;


wire [15:0] BCD_code_year;
wire [7:0] BCD_code_month;
wire [11:0] BCD_code_day,BCD_code_hour,BCD_code_minute,BCD_code_second;
parameter w1=12;
parameter w2=4;
parameter w3=8;
parameter d1=4;
parameter d2=2;
parameter d3=3;
B2BCD_IP #(.WIDTH(w1), .DIGIT(d1)) I_B2BCD_IP1 ( .Binary_code(year), .BCD_code(BCD_code_year) );
B2BCD_IP #(.WIDTH(w2), .DIGIT(d2)) I_B2BCD_IP2 ( .Binary_code(month),.BCD_code(BCD_code_month) );
B2BCD_IP #(.WIDTH(w3), .DIGIT(d3)) I_B2BCD_IP3 ( .Binary_code(day),  .BCD_code(BCD_code_day) );
B2BCD_IP #(.WIDTH(w3), .DIGIT(d3)) I_B2BCD_IP4 ( .Binary_code(hour), .BCD_code(BCD_code_hour) );
B2BCD_IP #(.WIDTH(w3), .DIGIT(d3)) I_B2BCD_IP5 ( .Binary_code(minute),.BCD_code(BCD_code_minute) );
B2BCD_IP #(.WIDTH(w3), .DIGIT(d3)) I_B2BCD_IP6 ( .Binary_code(second),.BCD_code(BCD_code_second) );
//==============================================//
//             Current State Block              //
//==============================================//
always@(posedge clk or negedge rst_n) 
begin
    if(!rst_n) c_state <= S_IDLE ; /* initial state */
    else c_state <= n_state;
end

//==============================================//
//              Next State Block                //
//==============================================//
always@(*) 
begin
    if (!rst_n) n_state=S_IDLE;
    else 
        begin
        case(c_state)
            S_IDLE:
                begin
                if (in_valid) n_state=S_IN;
                else n_state=S_IDLE;
                end
            S_IN:n_state=S_CAL;              
            S_CAL:
                begin
                if (flag_second) n_state=S_OUT;
                else n_state=S_CAL;
                end
            S_OUT:
                begin
                if (count_out<15) n_state=S_OUT;////////////////////////////////////////////////
                else n_state=S_IDLE;
                end
            
            default:n_state=S_IDLE;
        endcase
        end
end

//================================================================
// DESIGN
//================================================================
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n) unix_time<=0;
else if (n_state==S_IDLE) unix_time<=0;
else if (n_state==S_IN) unix_time<=in_time;////////////////////////////////////////////////////
//else unix_time<=unix_time;
end

//per 4 years is 126230400
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n) 
begin
    count_4year<=0;
    flag_count_4year<=0;
end
else if (n_state==S_IDLE)
begin
    count_4year<=0;
    flag_count_4year<=0;
end
else if(n_state==S_CAL)
if(unix_time<126230400)
    begin
    count_4year<=0;
    flag_count_4year<=1;
    end
else if(unix_time>126230399 && unix_time<252460800)
    begin
    count_4year<=1;
    flag_count_4year<=1;
    end
else if(unix_time>252460799 && unix_time<378691200)
    begin
    count_4year<=2;
    flag_count_4year<=1;
    end
else if(unix_time>378691199 && unix_time<504921600)
    begin
    count_4year<=3;
    flag_count_4year<=1;
    end
else if(unix_time>504921599 && unix_time<631152000)
    begin
    count_4year<=4;
    flag_count_4year<=1;
    end
else if(unix_time>631151999 && unix_time<757382400)
    begin
    count_4year<=5;
    flag_count_4year<=1;
    end
else if(unix_time>757382399 && unix_time<883612800)
    begin
    count_4year<=6;
    flag_count_4year<=1;
    end
else if(unix_time>883612799 && unix_time<1009843200)
    begin
    count_4year<=7;
    flag_count_4year<=1;
    end
else if(unix_time>1009843199 && unix_time<1136073600)
    begin
    count_4year<=8;
    flag_count_4year<=1;
    end
else if(unix_time>1136073599 && unix_time<1262304000)
    begin
    count_4year<=9;
    flag_count_4year<=1;
    end
else if(unix_time>1262303999 && unix_time<1388534400)
    begin
    count_4year<=10;
    flag_count_4year<=1;
    end
else if(unix_time>1388534399 && unix_time<1514764800)
    begin
    count_4year<=11;
    flag_count_4year<=1;
    end
else if(unix_time>1514764799 && unix_time<1640995200)
    begin
    count_4year<=12;
    flag_count_4year<=1;
    end
else if(unix_time>1640995199 && unix_time<1767225600)
    begin
    count_4year<=13;
    flag_count_4year<=1;
    end
else if(unix_time>1767225599 && unix_time<1893456000)
    begin
    count_4year<=14;
    flag_count_4year<=1;
    end
else if(unix_time>189345599 && unix_time<2019686400)
    begin
    count_4year<=15;
    flag_count_4year<=1;
    end
else if(unix_time>2019686399 && unix_time<2145916800)
    begin
    count_4year<=16;
    flag_count_4year<=1;
    end
else if(unix_time>2145916799)
    begin
    count_4year<=17;
    flag_count_4year<=1;
    end

//else count_4year<=count_4year;
end

reg [7:0]count;
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n) count<=0;
else if (n_state==S_IDLE) count<=0;
else if(n_state==S_CAL) count<=count+1;
else if(n_state==S_OUT) count<=0;
end

//left_time
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n) left_time<=0;
else if (n_state==S_IDLE) left_time<=0;
else if(n_state==S_CAL) 
begin
    if(flag_count_4year==1 && flag_count_year==0) 
    begin
    left_time<=unix_time-count_4year*126230400;
    flag_year<=1;
    end
    else if(count==3) 
    begin
        case(count_year)
        0:left_time<=left_time;
        1:left_time<=left_time-31536000;
        2:left_time<=left_time-63072000;
        3:left_time<=left_time-94694400;
        endcase
    end
    else if(count==5)
    begin
        if(count_year==2)
        begin
            case(month)
            1: left_time<=left_time;
            2: left_time<=left_time-2678400;
            3: left_time<=left_time-5097600-86400;
            4: left_time<=left_time-7776000-86400;
            5: left_time<=left_time-10368000-86400;
            6: left_time<=left_time-13046400-86400;
            7: left_time<=left_time-15638400-86400;
            8: left_time<=left_time-18316800-86400;
            9: left_time<=left_time-20995200-86400;
            10:left_time<=left_time-23587200-86400;
            11:left_time<=left_time-26265600-86400;
            12:left_time<=left_time-28857600-86400;
            //default:left_time<=left_time;
        endcase
        end
        else if(count_year==0 || count_year==1 ||count_year==3)
        begin
            case(month)
            1: left_time<=left_time;
            2: left_time<=left_time-2678400;
            3: left_time<=left_time-5097600;
            4: left_time<=left_time-7776000;
            5: left_time<=left_time-10368000;
            6: left_time<=left_time-13046400;
            7: left_time<=left_time-15638400;
            8: left_time<=left_time-18316800;
            9: left_time<=left_time-20995200;
            10:left_time<=left_time-23587200;
            11:left_time<=left_time-26265600;
            12:left_time<=left_time-28857600;
            //default:left_time<=left_time;
            endcase
        end
        //else left_time<=left_time;
    end
    else if(count==7) left_time<=left_time-(day-1)*86400;
    else if(count==9) left_time<=left_time-hour*3600;
    else left_time<=left_time;
end
else left_time<=left_time;
end
//assign left_time=unix_time-count_4year*9'd126230400;
//assign left_time3=left_time2-(day-1)*86400;
//assign left_time4=left_time3-hour*3600;
//assign year=1970+count_4year*4+count_year;

//365_1 365_2 366_1 365_3
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n) 
begin
    count_year<=0;
    flag_count_year<=0;
end
else if (n_state==S_IDLE) 
begin
    count_year<=0;
    flag_count_year<=0;
end
else if(n_state==S_CAL) 
begin
    if(count==2)
    begin
        if(left_time<31536000) 
        begin
            count_year<=0;
            flag_count_year<=1;
        end
        else if(left_time>31535999 && left_time<63072000)
        begin
            count_year<=1;
            flag_count_year<=1;
        end 
        else if(left_time>63071999 && left_time<94694400)
        begin
            count_year<=2;
            flag_count_year<=1;
        end 
        else if(left_time>94694399) 
        begin
            count_year<=3;
            flag_count_year<=1;
        end
        //else count_year<=count_year;
    end
    /*else
    begin
        count_year<=0;
        flag_count_year<=0;
    end*/
end
//else count_year<=count_year;
end

//year
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n) 
begin
    year<=0;
    flag_year<=0;
end
else if (n_state==S_IDLE)
begin
    year<=0;
    flag_year<=0;
end
else if(n_state==S_CAL)
begin
    if(flag_count_year==1) 
    begin
        year<=1970+count_4year*4+count_year;
        flag_year<=1;
    end
end
//else year<=year;
end

//month
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n)
begin
    month<=0;
    flag_month<=0;
end
else if (n_state==S_IDLE)
begin
    month<=0;
    flag_month<=0;
end
else if(n_state==S_CAL) 
begin
    if(count==4)
    begin
        if(count_year==2)/////////////////////////////////////////////////
        begin
            if(left_time<2678400)
            begin
                month<=1;
                flag_month<=1;
            end
            else if(left_time>2678399  && left_time<5184000)
            begin
                month<=2;
                flag_month<=1;
            end
            else if(left_time>5097599  && left_time<7862400)
            begin
                month<=3;
                flag_month<=1;
            end
            else if(left_time>7775999  && left_time<10454400) 
            begin
                month<=4;
                flag_month<=1;
            end
            else if(left_time>10367999  && left_time<13046400)
            begin
                month<=5;
                flag_month<=1;
            end
            else if(left_time>13046399 && left_time<15724800)
            begin
                month<=6;
                flag_month<=1;
            end
            else if(left_time>15638399 && left_time<18403200)
            begin
                month<=7;
                flag_month<=1;
            end
            else if(left_time>18316799 && left_time<21081600)
            begin
                month<=8;
                flag_month<=1;
            end
            else if(left_time>20995199 && left_time<23673600)
            begin
                month<=9;
                flag_month<=1;
            end
            else if(left_time>23587199 && left_time<26352000)
            begin
                month<=10;
                flag_month<=1;
            end
            else if(left_time>26265599 && left_time<28944000) 
            begin
                month<=11;
                flag_month<=1;
            end
            else if(left_time>28857599)
            begin
                month<=12;
                flag_month<=1;
            end
        end
        else 
        begin
            if(left_time<2678400)
            begin
                month<=1;
                flag_month<=1;
            end
            else if(left_time>2678399  && left_time<5097600)
            begin
                month<=2;
                flag_month<=1;
            end
            else if(left_time>5097599  && left_time<7776000)
            begin
                month<=3;
                flag_month<=1;
            end
            else if(left_time>7775999  && left_time<10368000) 
            begin
                month<=4;
                flag_month<=1;
            end
            else if(left_time>10367999  && left_time<13046400)
            begin
                month<=5;
                flag_month<=1;
            end
            else if(left_time>13046399 && left_time<15638400)
            begin
                month<=6;
                flag_month<=1;
            end
            else if(left_time>15638399 && left_time<18316800)
            begin
                month<=7;
                flag_month<=1;
            end
            else if(left_time>18316799 && left_time<20995200)
            begin
                month<=8;
                flag_month<=1;
            end
            else if(left_time>20995199 && left_time<23587200)
            begin
                month<=9;
                flag_month<=1;
            end
            else if(left_time>23587199 && left_time<26265600)
            begin
                month<=10;
                flag_month<=1;
            end
            else if(left_time>26265599 && left_time<28857600) 
            begin
                month<=11;
                flag_month<=1;
            end
            else if(left_time>28857599)
            begin
                month<=12;
                flag_month<=1;
            end
        end
    end
end
//else month<=month;
end

/*always @(posedge clk or negedge rst_n) 
begin
if (!rst_n) left_time2<=0;
else if (n_state==S_IDLE) left_time2<=0;
else if(n_state==S_CAL)//flag 
begin
    if(count_year==2)
    begin
        case(month)
        1: left_time2<=left_time;
        2: left_time2<=left_time-2678400;
        3: left_time2<=left_time-5097600-86400;
        4: left_time2<=left_time-7776001-86400;
        5: left_time2<=left_time-1036800-86400;
        6: left_time2<=left_time-13036400-86400;
        7: left_time2<=left_time-15638400-86400;
        8: left_time2<=left_time-18316800-86400;
        9: left_time2<=left_time-20995200-86400;
        10:left_time2<=left_time-23587200-86400;
        11:left_time2<=left_time-26265600-86400;
        12:left_time2<=left_time-28857600-86400;
        //default:left_time2<=left_time2;
    endcase
    end
    else if(count_year==0 || count_year==1 ||count_year==3)
    begin
        case(month)
        1: left_time2<=left_time;
        2: left_time2<=left_time-2678400;
        3: left_time2<=left_time-5097600;
        4: left_time2<=left_time-7776001;
        5: left_time2<=left_time-1036800;
        6: left_time2<=left_time-13036400;
        7: left_time2<=left_time-15638400;
        8: left_time2<=left_time-18316800;
        9: left_time2<=left_time-20995200;
        10:left_time2<=left_time-23587200;
        11:left_time2<=left_time-26265600;
        12:left_time2<=left_time-28857600;
        //default:left_time2<=left_time2;
        endcase
    end
    //else left_time2<=left_time2;
end
//else left_time2<=left_time2;
end*/

//day
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n)
begin
    day<=0;
    flag_day<=0;
end
else if (n_state==S_IDLE)
begin
    day<=0;
    flag_day<=0;
end
else if(n_state==S_CAL)
begin
    if(count==6)
    begin
    //day<=left_time/86400;
    flag_day<=1;
    if(left_time<86400) day<=1;
    else if(left_time>86399   && left_time<172800)  day<=2;
    else if(left_time>172799  && left_time<259200)  day<=3;
    else if(left_time>259199  && left_time<345600)  day<=4;
    else if(left_time>345599  && left_time<432000)  day<=5;
    else if(left_time>431999  && left_time<518400)  day<=6;
    else if(left_time>518399  && left_time<604800)  day<=7;
    else if(left_time>604799  && left_time<691200)  day<=8;
    else if(left_time>691199  && left_time<777600)  day<=9;
    else if(left_time>777599  && left_time<864000)  day<=10;
    else if(left_time>863999  && left_time<950400)  day<=11;
    else if(left_time>950399  && left_time<1036800) day<=12;
    else if(left_time>1036799 && left_time<1123200) day<=13;
    else if(left_time>1123199 && left_time<1209600) day<=14;
    else if(left_time>1209599 && left_time<1296000) day<=15;
    else if(left_time>1295999 && left_time<1382400) day<=16;
    else if(left_time>1382399 && left_time<1468800) day<=17;
    else if(left_time>1468799 && left_time<1555200) day<=18;
    else if(left_time>1555199 && left_time<1641600) day<=19;
    else if(left_time>1641599 && left_time<1728000) day<=20;
    else if(left_time>1727999 && left_time<1814400) day<=21;
    else if(left_time>1814399 && left_time<1900800) day<=22;
    else if(left_time>1900799 && left_time<1987200) day<=23;
    else if(left_time>1987199 && left_time<2073600) day<=24;
    else if(left_time>2073599 && left_time<2160000) day<=25;
    else if(left_time>2159999 && left_time<2246400) day<=26;
    else if(left_time>2246399 && left_time<2332800) day<=27;
    else if(left_time>2332799 && left_time<2419200) day<=28;
    else if(left_time>2419199 && left_time<2505600) day<=29;
    else if(left_time>2505599 && left_time<2592000) day<=30;
    else if(left_time>2591999) day<=31;
    //else day<=day;
    end
end
//else day<=day;
end



//hour
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n)
begin
    hour<=0;
    flag_hour<=0;
end
else if (n_state==S_IDLE)
begin
    hour<=0;
    flag_hour<=0;
end
else if(n_state==S_CAL)
begin
    if(count==8)
    begin
    //hour<=left_time/3600;
    flag_hour<=1;
    if(left_time<3600) hour<=0;
    else if(left_time>3599  && left_time<7200)  hour<=1;
    else if(left_time>7199  && left_time<10800) hour<=2;
    else if(left_time>10799 && left_time<14400) hour<=3;
    else if(left_time>14399 && left_time<18000) hour<=4;
    else if(left_time>17999 && left_time<21600) hour<=5;
    else if(left_time>21599 && left_time<25200) hour<=6;
    else if(left_time>25199 && left_time<28800) hour<=7;
    else if(left_time>28799 && left_time<32400) hour<=8;
    else if(left_time>32399 && left_time<36000) hour<=9;
    else if(left_time>35999 && left_time<39600) hour<=10;
    else if(left_time>39599 && left_time<43200) hour<=11;
    else if(left_time>43199 && left_time<46800) hour<=12;
    else if(left_time>46799 && left_time<50400) hour<=13;
    else if(left_time>50399 && left_time<54000) hour<=14;
    else if(left_time>53999 && left_time<57600) hour<=15;
    else if(left_time>57599 && left_time<61200) hour<=16;
    else if(left_time>61199 && left_time<64800) hour<=17;
    else if(left_time>64799 && left_time<68400) hour<=18;
    else if(left_time>68399 && left_time<72000) hour<=19;
    else if(left_time>71999 && left_time<75600) hour<=20;
    else if(left_time>75599 && left_time<79200) hour<=21;
    else if(left_time>79199 && left_time<82800) hour<=22;
    else if(left_time>82799) hour<=23;
    //else hour<=hour;
    end
end
//else hour<=hour;
end

//minute
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n)
begin
    minute<=0;
    flag_minute<=0;
end
else if (n_state==S_IDLE) 
begin
    minute<=0;
    flag_minute<=0;
end
else if(n_state==S_CAL)
begin 
    if(count==10)
    begin
    flag_minute<=1;
    if(left_time<60) minute<=0;
    else if(left_time>59   && left_time<120)  minute<=1;
    else if(left_time>119  && left_time<180)  minute<=2;
    else if(left_time>179  && left_time<240)  minute<=3;
    else if(left_time>239  && left_time<300)  minute<=4;
    else if(left_time>299  && left_time<360)  minute<=5;
    else if(left_time>359  && left_time<420)  minute<=6;
    else if(left_time>419  && left_time<480)  minute<=7;
    else if(left_time>479  && left_time<540)  minute<=8;
    else if(left_time>539  && left_time<600)  minute<=9;
    else if(left_time>599  && left_time<660)  minute<=10;
    else if(left_time>659  && left_time<720)  minute<=11;
    else if(left_time>719  && left_time<780)  minute<=12;
    else if(left_time>779  && left_time<840)  minute<=13;
    else if(left_time>839  && left_time<900)  minute<=14;
    else if(left_time>899  && left_time<960)  minute<=15;
    else if(left_time>959  && left_time<1020) minute<=16;
    else if(left_time>1019 && left_time<1080) minute<=17;
    else if(left_time>1079 && left_time<1140) minute<=18;
    else if(left_time>1139 && left_time<1200) minute<=19;
    else if(left_time>1199 && left_time<1260) minute<=20;
    else if(left_time>1259 && left_time<1320) minute<=21;
    else if(left_time>1319 && left_time<1380) minute<=22;
    else if(left_time>1379 && left_time<1440) minute<=23;
    else if(left_time>1439 && left_time<1500) minute<=24;
    else if(left_time>1499 && left_time<1560) minute<=25;
    else if(left_time>1559 && left_time<1620) minute<=26;
    else if(left_time>1619 && left_time<1680) minute<=27;
    else if(left_time>1679 && left_time<1740) minute<=28;
    else if(left_time>1739 && left_time<1800) minute<=29;
    else if(left_time>1799 && left_time<1860) minute<=30;
    else if(left_time>1859 && left_time<1920) minute<=31;
    else if(left_time>1919 && left_time<1980) minute<=32;
    else if(left_time>1979 && left_time<2040) minute<=33;
    else if(left_time>2039 && left_time<2100) minute<=34;
    else if(left_time>2099 && left_time<2160) minute<=35;
    else if(left_time>2159 && left_time<2220) minute<=36;
    else if(left_time>2119 && left_time<2280) minute<=37;
    else if(left_time>2279 && left_time<2340) minute<=38;
    else if(left_time>2339 && left_time<2400) minute<=39;
    else if(left_time>2399 && left_time<2460) minute<=40;
    else if(left_time>2459 && left_time<2520) minute<=41;
    else if(left_time>2519 && left_time<2580) minute<=42;
    else if(left_time>2579 && left_time<2640) minute<=43;
    else if(left_time>2639 && left_time<2700) minute<=44;
    else if(left_time>2699 && left_time<2760) minute<=45;
    else if(left_time>2759 && left_time<2820) minute<=46;
    else if(left_time>2819 && left_time<2880) minute<=47;
    else if(left_time>2879 && left_time<2940) minute<=48;
    else if(left_time>2939 && left_time<3000) minute<=49;
    else if(left_time>2999 && left_time<3060) minute<=50;
    else if(left_time>3059 && left_time<3120) minute<=51;
    else if(left_time>3119 && left_time<3180) minute<=52;
    else if(left_time>3179 && left_time<3240) minute<=53;
    else if(left_time>3239 && left_time<3300) minute<=54;
    else if(left_time>3299 && left_time<3360) minute<=55;
    else if(left_time>3359 && left_time<3420) minute<=56;
    else if(left_time>3419 && left_time<3480) minute<=57;
    else if(left_time>3479 && left_time<3540) minute<=58;
    else if(left_time>3539) minute<=59;
    //else minute<=minute;
    end
end
//else minute<=minute;
end

//second
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n)
begin
    second<=0;
    flag_second<=0;
end
else if (n_state==S_IDLE)
begin
    second<=0;
    flag_second<=0;
end
else if(n_state==S_CAL)
begin
    if(count==12)
    begin
    second<=left_time-60*minute;
    flag_second<=1;
    end
end 
//else second<=second;
end

//count day
/*always @(posedge clk or negedge rst_n) 
begin
if (!rst_n) count_day<=0;
else if (n_state==S_IDLE) count_day<=0;
else if(n_state==S_CAL) count_day<=((unix_time-(unix_time%86400))/86400)%7;////////////////////////////
//else count_day<=count_day;
end*/

reg [30:0] total_day;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) count_day<=4'd0;
    else if(n_state==S_IDLE) count_day<=4'd0;
    else if(n_state==S_CAL) 
    begin
        if(count==8) count_day<=total_day%7;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) total_day<=0;
    else if(n_state==S_IDLE) total_day<=0;
    else if(n_state==S_CAL) 
    begin
        if(count==7) 
        begin
            if(count_year==0) 
            begin
                case(month)
                4'd1:total_day<=(1461*count_4year+day-1);
                4'd2:total_day<=(1461*count_4year+30+day);
                4'd3:total_day<=(1461*count_4year+58+day);
                4'd4:total_day<=(1461*count_4year+89+day);
                4'd5:total_day<=(1461*count_4year+119+day);
                4'd6:total_day<=(1461*count_4year+150+day);
                4'd7:total_day<=(1461*count_4year+180+day);
                4'd8:total_day<=(1461*count_4year+211+day);
                4'd9:total_day<=(1461*count_4year+242+day);
                4'd10:total_day<=(1461*count_4year+272+day);
                4'd11:total_day<=(1461*count_4year+303+day);
                4'd12:total_day<=(1461*count_4year+333+day);
                endcase
            end
            else if(count_year==1) 
            begin
                case(month)
                4'd1:total_day<=(1461*count_4year+364+day);
                4'd2:total_day<=(1461*count_4year+395+day);
                4'd3:total_day<=(1461*count_4year+423+day);
                4'd4:total_day<=(1461*count_4year+454+day);
                4'd5:total_day<=(1461*count_4year+484+day);
                4'd6:total_day<=(1461*count_4year+515+day);
                4'd7:total_day<=(1461*count_4year+545+day);
                4'd8:total_day<=(1461*count_4year+576+day);
                4'd9:total_day<=(1461*count_4year+607+day);
                4'd10:total_day<=(1461*count_4year+637+day);
                4'd11:total_day<=(1461*count_4year+668+day);
                4'd12:total_day<=(1461*count_4year+698+day);
                endcase
            end
            else if(count_year==2) 
            begin
                case(month)
                4'd1:total_day<=(1461*count_4year+729+day);
                4'd2:total_day<=(1461*count_4year+760+day);
                4'd3:total_day<=(1461*count_4year+789+day);
                4'd4:total_day<=(1461*count_4year+820+day);
                4'd5:total_day<=(1461*count_4year+850+day);
                4'd6:total_day<=(1461*count_4year+881+day);
                4'd7:total_day<=(1461*count_4year+911+day);
                4'd8:total_day<=(1461*count_4year+942+day);
                4'd9:total_day<=(1461*count_4year+973+day);
                4'd10:total_day<=(1461*count_4year+1003+day);
                4'd11:total_day<=(1461*count_4year+1034+day);
                4'd12:total_day<=(1461*count_4year+1064+day);
                endcase
            end
            else if(count_year==3) begin
                case(month)
                4'd1:total_day<=(1461*count_4year+1095+day);
                4'd2:total_day<=(1461*count_4year+1126+day);
                4'd3:total_day<=(1461*count_4year+1154+day);
                4'd4:total_day<=(1461*count_4year+1185+day);
                4'd5:total_day<=(1461*count_4year+1215+day);
                4'd6:total_day<=(1461*count_4year+1246+day);
                4'd7:total_day<=(1461*count_4year+1276+day);
                4'd8:total_day<=(1461*count_4year+1307+day);
                4'd9:total_day<=(1461*count_4year+1338+day);
                4'd10:total_day<=(1461*count_4year+1368+day);
                4'd11:total_day<=(1461*count_4year+1399+day);
                4'd12:total_day<=(1461*count_4year+1429+day);
                endcase
            end
        end
    end
end

//count out
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n) count_out<=0;
else if (n_state==S_IDLE) count_out<=0;
else if(n_state==S_OUT) count_out<=count_out+1;
//else count_out<=count_out;
end

//==============================================//
//                Output Block                  //
//==============================================//



always@(posedge clk or negedge rst_n) 
begin
    if(!rst_n) out_valid <= 0; /* remember to reset */
    else if(n_state == S_IDLE) out_valid<=0;
    else if (count_out>0 && count_out<15) out_valid <= 1;
    //else out_valid <= 0;
end

always@(posedge clk or negedge rst_n)
begin
  if(!rst_n) out_display<=0;
  else if(n_state==S_IDLE) out_display<=0;
  else if(n_state==S_OUT)
  begin
    case (count_out)
    1:out_display<=BCD_code_year[15:12];
    2:out_display<=BCD_code_year[11:8];
    3:out_display<=BCD_code_year[7:4];
    4:out_display<=BCD_code_year[3:0];
    5:out_display<=BCD_code_month[7:4];
    6:out_display<=BCD_code_month[3:0];
    7:out_display<=BCD_code_day[7:4];
    8:out_display<=BCD_code_day[3:0];
    9:out_display<=BCD_code_hour[7:4];
    10:out_display<=BCD_code_hour[3:0];
    11:out_display<=BCD_code_minute[7:4];
    12:out_display<=BCD_code_minute[3:0];
    13:out_display<=BCD_code_second[7:4];
    14:out_display<=BCD_code_second[3:0];
    default:out_display<=0;
    endcase
  end
end

//week
always @(posedge clk or negedge rst_n) 
begin
if (!rst_n)
begin
    out_day<=0;
    flag_out_day<=0;
end
else if (n_state==S_IDLE)
begin
    out_day<=0;
    flag_out_day<=0;
end
else if(count_out>0 && count_out<16)
begin
    flag_out_day<=1;
    case(count_day)
    0:out_day<=4;
    1:out_day<=5;
    2:out_day<=6;
    3:out_day<=0;
    4:out_day<=1;
    5:out_day<=2;
    6:out_day<=3;
    default:out_day<=0;
    endcase
end
else out_day<=0;
end

endmodule