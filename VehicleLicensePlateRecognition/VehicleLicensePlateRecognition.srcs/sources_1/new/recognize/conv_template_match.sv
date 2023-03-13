
//------------------------------------------
//ͨ�����ģ��ƥ��Ը��ַ�����ʶ��

module conv_template_match(
	input				clk,  				//cmos video pixel clock
	input				rst_n,				//global reset
	
	input 		[4:0] 	char_feature  [7:0] [7:0],
    input               char_feature_valid, //��������ֵ��Ч��־��һ��ʱ������
	
	output reg [7:0]	char_index [7:0],	//ƥ����ַ�����
	output reg 			match_valid			//ƥ��ɹ���־
);

localparam CHAR_NUM  = 34;	//Ӣ��+����  ����
localparam ENG_NUM 	 = 24;	//Ӣ������
localparam CHINA_NUM = 31;	//��������


wire [4:0] CHAR  [33:0] [7:0]; //A��Z  0��9����ȥӢ��O��Ӣ��I������34���ַ������������֣���ÿ���ַ�8�У�ÿ����5�������
wire [4:0] CHINA [30:0] [7:0]; //�����ַ�����ʡ�е�����


reg [3:0] step;

reg [7:0] china_match_cnt;  //���ĶԱ���Ŀ
reg [7:0] char_match_cnt ;   //Ӣ�ĶԱ���Ŀ

reg [2:0] plate_char_cnt;	//��ƥ����ַ�����
reg [2:0] plate_line_cnt;	//���ַ��е��м���
reg [2:0] plate_bit_cnt	;	//�����е�bitλ����

reg [7:0] match_score	 ;	//ƥ��÷�
reg [7:0] match_score_max;  //�Ĵ���ߵ÷�
reg [7:0] score_max_index;	//��ߵ÷�����Ӧ������

reg [4:0] compare_char [7:0];	//���ڼĴ�Ƚ϶���: ���Ƶ��ַ�
reg [4:0] compare_temp [7:0];	//���ڼĴ�Ƚ϶����ַ�ģ��

integer i; 
 
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        step            <=  4'd0;
		
        plate_char_cnt  <=  3'd0;
        plate_line_cnt  <=  3'd0;
        plate_bit_cnt	<=  3'd0;
		
		china_match_cnt	<=  8'd0;
		char_match_cnt 	<=  8'd0;
		
		match_score	 	<=  8'd0;
		match_score_max <=  8'd0;
		score_max_index <= 	8'd0;
		
		match_valid		<= 	1'b0;
    end
    else begin
        case (step)
        
            4'd0 : begin
				plate_char_cnt  <=  3'd0;
				plate_line_cnt  <=  3'd0;
				plate_bit_cnt	<=  3'd0;
				
				china_match_cnt	<=  8'd0;
				char_match_cnt 	<=  8'd0;
				
				match_score	 	<=  8'd0;
				match_score_max <=  8'd0;
				score_max_index <= 	8'd0;
				
				match_valid		<= 	1'b0;
				
                if(char_feature_valid)      	//����ֵ��Чʱ������ʶ�����
                    step	<= 4'd1;
                else
                    step	<= step;
            end
			
            4'd1 : begin
				china_match_cnt	<= 	8'd0;
				char_match_cnt 	<=  8'd0;
				match_score_max <=	8'd0;
				score_max_index <= 	8'd0;
			
                case (plate_char_cnt)  
				
                    3'd0 : begin                     //�����ַ�����ʡ�е�����
                        step  <= 4'd2; 
						for(i=0;i<8;i++)			
							compare_char[i] <= char_feature[0][i];				//�Ĵ����ڱȽϵĳ����ַ������֣�
					end

                    3'd2 :	begin					//��
                        step  <= 4'd1;           
						plate_char_cnt <= plate_char_cnt + 1'b1;
					end
					
                    default: begin					//Ӣ����ĸ�������� 
                        step  <= 4'd6;           
						for(i=0;i<8;i++)
							compare_char[i] <= char_feature[plate_char_cnt][i];//�Ĵ����ڱȽϵĳ����ַ�
					end
                endcase
            end
			
			//��������������������������������������������������������������������������������������������������������������������������������������������������������������������
			//���к��ֵ�ƥ�����
			
            4'd2 : begin		
				for(i=0;i<8;i++)					//�Ĵ����ڱȽϵĺ���ģ��
					compare_temp[i] <= CHINA[china_match_cnt][i];
					
				match_score	 	<=	8'd128;			//ƥ��÷ֳ�ʼ��Ϊ�м�ֵ128
				
				plate_line_cnt  <=  3'd0;
				plate_bit_cnt	<=  3'd0;
				
				step  			<= 	4'd3;
            end
			
            4'd3 : begin							//����40������ֵ������ƥ��
				
				if(compare_char[plate_line_cnt][plate_bit_cnt]==compare_temp[plate_line_cnt][plate_bit_cnt])
					match_score <= match_score + 1'b1;	//ÿ��bitƥ��ɹ�����÷ּ�1
				else
					match_score <= match_score - 1'b1;	//ÿ��bitƥ�䲻�ɹ�����÷ּ�1
					
				if(plate_bit_cnt < 3'd4)
					plate_bit_cnt <= plate_bit_cnt + 1'b1;
				else begin
					plate_bit_cnt <= 3'd0;
					
					if(plate_line_cnt < 3'd7)
						plate_line_cnt <= plate_line_cnt + 1'b1;
					else
						step <= 4'd4;					//�ַ�ƥ����̽��� 
				end
            end
			
            4'd4 : begin								//���ƥ���������ֵ
				if(match_score > match_score_max) begin
					match_score_max <= match_score;
					score_max_index <= china_match_cnt;
				end
				
				if(china_match_cnt < CHINA_NUM -1) begin //������һ���ַ�ģ��ıȽ�
					china_match_cnt <= china_match_cnt + 1'b1;
					step <= 4'd2;					
				end
				else 
					step <= 4'd5;
            end
            4'd5 : begin								//�Ĵ溺��ƥ���������ֵ			
				char_index[0] 	<= score_max_index;
				plate_char_cnt	<= plate_char_cnt + 1'b1;
				step <= 4'd1;
            end
			
			//��������������������������������������������������������������������������������������������������������������������������������������������������������������������
			//����Ӣ��/���ֵ�ƥ�����

            4'd6 : begin		
				for(i=0;i<8;i++)					//�Ĵ����ڱȽϵĺ���ģ��
					compare_temp[i] <= CHAR[char_match_cnt][i];
					
				match_score	 	<=	8'd128;			//ƥ��÷ֳ�ʼ��Ϊ�м�ֵ128
				
				plate_line_cnt  <=  3'd0;
				plate_bit_cnt	<=  3'd0;
				
				step  			<= 	4'd7;
            end

            4'd7 : begin							//����40������ֵ������ƥ��
				
				if(compare_char[plate_line_cnt][plate_bit_cnt]==compare_temp[plate_line_cnt][plate_bit_cnt])
					match_score <= match_score + 1'b1;	//ÿ��bitƥ��ɹ�����÷ּ�1
				else
					match_score <= match_score - 1'b1;	//ÿ��bitƥ�䲻�ɹ�����÷ּ�1
					
				if(plate_bit_cnt < 3'd4)
					plate_bit_cnt <= plate_bit_cnt + 1'b1;
				else begin
					plate_bit_cnt <= 3'd0;
					
					if(plate_line_cnt < 3'd7)
						plate_line_cnt <= plate_line_cnt + 1'b1;
					else
						step <= 4'd8;					//�ַ�ƥ����̽��� 
				end
            end
			
            4'd8 : begin								//���ƥ���������ֵ
				if(match_score >= match_score_max) begin
					match_score_max <= match_score;
					score_max_index <= char_match_cnt;
				end
				
				if((plate_char_cnt == 3'd1)&&(char_match_cnt == ENG_NUM -1))		//���Ƶڶ����ַ�ΪӢ�ģ���Ϊ���� 
					step <= 4'd9;
				else if((plate_char_cnt > 3'd2)&&(char_match_cnt == CHAR_NUM -1))//������ַ�����ΪӢ��/���� 
					step <= 4'd9;
				else begin 												
					char_match_cnt <= char_match_cnt + 1'b1;				//������һ���ַ�ģ��ıȽ�
					step <= 4'd6;					
				end
            end
            4'd9 : begin								//�Ĵ�Ӣ����ĸƥ���������ֵ			
				char_index[plate_char_cnt] 	<= score_max_index;
				if(plate_char_cnt < 3'd7) begin
					plate_char_cnt 	<= plate_char_cnt + 1'b1;
					step <= 4'd1;
				end
				else begin
					step <= 4'd10;						//���г����ַ�ʶ�����
				end
            end
			
            4'd10 : begin
				match_valid	<=	1'b1;					//���ʶ������Ч��־������һ��ʱ������
				step 		<=  4'd0;
            end
        
        endcase
    
    end

end

//��ĸ A
assign CHAR[0] = {
	5'b00100,
	5'b01110,
	5'b01110,
	5'b01110,
	5'b01010,
	5'b01011,
	5'b11111,
	5'b10001
};

//��ĸ B
assign CHAR[1] = {
	5'b11110,
	5'b10001,
	5'b10010,
	5'b11110,
	5'b10011,
	5'b10001,
	5'b10010,
	5'b11110
};

//��ĸ C
assign CHAR[2] = {
	5'b01111,
	5'b10001,
	5'b10000,
	5'b10000,
	5'b10000,
	5'b10001,
	5'b10001,
	5'b01110
};

//��ĸ D
assign CHAR[3] = {
	5'b11110,
	5'b10010,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b11110
};

//��ĸ E
assign CHAR[4] = {
	5'b11111,
	5'b10000,
	5'b10000,
	5'b11110,
	5'b10000,
	5'b10000,
	5'b10000,
	5'b11111
};

//��ĸ F
assign CHAR[5] = {
	5'b11111,
	5'b11000,
	5'b10000,
	5'b11000,
	5'b11110,
	5'b10000,
	5'b10000,
	5'b10000
};

//��ĸ G
assign CHAR[6] = {
	5'b01110,
	5'b10001,
	5'b10000,
	5'b10111,
	5'b10001,
	5'b10001,
	5'b11011,
	5'b01110
};

//��ĸ H
assign CHAR[7] = {
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10011,
	5'b11111,
	5'b10001,
	5'b10001,
	5'b10001
};

//��ĸ J
assign CHAR[8] = {
	5'b00001,
	5'b00001,
	5'b00001,
	5'b00001,
	5'b00001,
	5'b00001,
	5'b10001,
	5'b01110
};

//��ĸ K
assign CHAR[9] = {
	5'b10001,
	5'b10010,
	5'b10110,
	5'b11110,
	5'b11010,
	5'b10010,
	5'b10001,
	5'b10001
};

//��ĸ L
assign CHAR[10] = {
	5'b10000,
	5'b10000,
	5'b10000,
	5'b10000,
	5'b10000,
	5'b10000,
	5'b10000,
	5'b11111
};

//��ĸ M
assign CHAR[11] = {
	5'b11011,
	5'b11111,
	5'b11111,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10001
};

//��ĸ N
assign CHAR[12] = {
	5'b11001,
	5'b11001,
	5'b11001,
	5'b10101,
	5'b10101,
	5'b10011,
	5'b10011,
	5'b10001
};

//��ĸ P
assign CHAR[13] = {
	5'b11110,
	5'b10001,
	5'b10001,
	5'b11011,
	5'b11110,
	5'b10000,
	5'b10000,
	5'b10000
};

//��ĸ Q
assign CHAR[14] = {
	5'b01110,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10101,
	5'b10011,
	5'b01111
};

//��ĸ R
assign CHAR[15] = {
	5'b11110,
	5'b10001,
	5'b10001,
	5'b11111,
	5'b11110,
	5'b10010,
	5'b10011,
	5'b10001
};

//��ĸ S
assign CHAR[16] = {
	5'b01110,
	5'b10001,
	5'b10000,
	5'b01110,
	5'b00011,
	5'b00001,
	5'b10011,
	5'b01110
};

//��ĸ T
assign CHAR[17] = {
	5'b11111,
	5'b00100,
	5'b00100,
	5'b00100,
	5'b00100,
	5'b00100,
	5'b00100,
	5'b00100
};

//��ĸ U
assign CHAR[18] = {
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b01110
};

//��ĸ V
assign CHAR[19] = {
	5'b10001,
	5'b11001,
	5'b01011,
	5'b01010,
	5'b01110,
	5'b01110,
	5'b00110,
	5'b00100
};

//��ĸ W
assign CHAR[20] = {
	5'b10001,
	5'b10001,
	5'b10101,
	5'b11111,
	5'b11111,
	5'b01011,
	5'b01011,
	5'b01001
};

//��ĸ X
assign CHAR[21] = {
	5'b11001,
	5'b01010,
	5'b01110,
	5'b00100,
	5'b00110,
	5'b01110,
	5'b01011,
	5'b10001
};

//��ĸ Y
assign CHAR[22] = {
	5'b11011,
	5'b01010,
	5'b00110,
	5'b00100,
	5'b00100,
	5'b00100,
	5'b00100,
	5'b00100
};

//��ĸ Z
assign CHAR[23] = {
	5'b11111,
	5'b00010,
	5'b00010,
	5'b00100,
	5'b00100,
	5'b01000,
	5'b01000,
	5'b11110
};

//���� 0
assign CHAR[24] = {
	5'b01110,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b10001,
	5'b01110
};

//���� 1
assign CHAR[25] = {
	5'b01110,
	5'b01110,
	5'b01110,
	5'b01110,
	5'b01110,
	5'b01110,
	5'b01110,
	5'b01110
};

//���� 2
assign CHAR[26] = {
	5'b01110,
	5'b11011,
	5'b00011,
	5'b00010,
	5'b00100,
	5'b01100,
	5'b01000,
	5'b11111
};

//���� 3
assign CHAR[27] = {
	5'b11111,
	5'b00010,
	5'b00100,
	5'b00110,
	5'b00001,
	5'b00001,
	5'b10001,
	5'b01110
};

//���� 4
assign CHAR[28] = {
	5'b00010,
	5'b00110,
	5'b00110,
	5'b01010,
	5'b01010,
	5'b11010,
	5'b11111,
	5'b00010
};

//���� 5
assign CHAR[29] = {
	5'b11111,
	5'b10000,
	5'b10000,
	5'b11110,
	5'b00001,
	5'b00001,
	5'b10001,
	5'b01110
};

//���� 6
assign CHAR[30] = {
	5'b00010,
	5'b00100,
	5'b01000,
	5'b01000,
	5'b11111,
	5'b10001,
	5'b11001,
	5'b01110
};

//���� 7
assign CHAR[31] = {
	5'b11111,
	5'b00011,
	5'b00010,
	5'b00010,
	5'b00100,
	5'b00100,
	5'b00100,
	5'b00100
};

//���� 8
assign CHAR[32] = {
	5'b01111,
	5'b11001,
	5'b11001,
	5'b01110,
	5'b11011,
	5'b10001,
	5'b10001,
	5'b01110
};

//���� 9
assign CHAR[33] = {
	5'b01111,
	5'b10001,
	5'b10001,
	5'b01111,
	5'b00011,
	5'b00010,
	5'b00100,
	5'b01000
};

//����������������������������������������������������������������������������������������������������������������


//����������������������������������������������������������������������������������������������������������������


//���� ��
assign CHINA[0] = {
	5'b00000,
	5'b00001,
	5'b01000,
	5'b00000,
	5'b01110,
	5'b00100,
	5'b00101,
	5'b00100
};

//���� ��
assign CHINA[1] = {
	5'b10011,
	5'b10000,
	5'b00011,
	5'b00010,
	5'b01010,
	5'b00100,
	5'b00101,
	5'b00000
};

//���� ��
assign CHINA[2] = {
	5'b00010,
	5'b11110,
	5'b11110,
	5'b11110,
	5'b11110,
	5'b11010,
	5'b11010,
	5'b00111
};

//���� ��
assign CHINA[3] = {
	5'b00000,
	5'b00000,
	5'b00101,
	5'b00101,
	5'b00111,
	5'b10100,
	5'b10100,
	5'b00000
};

//���� ��
assign CHINA[4] = {
	5'b01010,
	5'b01111,
	5'b00000,
	5'b01110,
	5'b00110,
	5'b10011,
	5'b01010,
	5'b00010
};

//���� ��
assign CHINA[5] = {
	5'b00000,
	5'b01110,
	5'b10111,
	5'b00100,
	5'b01100,
	5'b00110,
	5'b00010,
	5'b00000
};

//���� ��
assign CHINA[6] = {
	5'b00000,
	5'b00111,
	5'b00111,
	5'b00110,
	5'b00111,
	5'b01111,
	5'b00111,
	5'b00101
};

//���� ��
assign CHINA[7] = {
	5'b00010,
	5'b00000,
	5'b01010,
	5'b00000,
	5'b01000,
	5'b00010,
	5'b00000,
	5'b00000
};

//���� ³
assign CHINA[8] = {
	5'b00000,
	5'b11110,
	5'b00111,
	5'b00101,
	5'b00000,
	5'b00000,
	5'b01001,
	5'b01001
};

//���� ��
assign CHINA[9] = {
	5'b11111,
	5'b11111,
	5'b11111,
	5'b11111,
	5'b11111,
	5'b11111,
	5'b01111,
	5'b00110
};

//���� ԥ
assign CHINA[10] = {
	5'b00000,
	5'b01110,
	5'b11111,
	5'b11110,
	5'b00110,
	5'b00110,
	5'b10111,
	5'b00000
};

//���� M
assign CHINA[11] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� N
assign CHINA[12] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� P
assign CHINA[13] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� Q
assign CHINA[14] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� R
assign CHINA[15] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� S
assign CHINA[16] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� T
assign CHINA[17] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� U
assign CHINA[18] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� V
assign CHINA[19] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� W
assign CHINA[20] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� X
assign CHINA[21] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� Y
assign CHINA[22] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� Z
assign CHINA[23] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� 0
assign CHINA[24] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� 1
assign CHINA[25] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� 2
assign CHINA[26] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� 3
assign CHINA[27] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� 4
assign CHINA[28] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� 5
assign CHINA[29] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

//���� 6
assign CHINA[30] = {
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000,
	5'b00000
};

endmodule