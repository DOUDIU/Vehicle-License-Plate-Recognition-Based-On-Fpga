`timescale 1ns / 1ns

//ʹ��BMPͼƬ��ʽ����VIP��Ƶͼ�����㷨
module bmp_sim_VIP_tb();
 
integer iBmpFileId;                 //����BMPͼƬ

integer oBmpFileId_1;                 //���BMPͼƬ 1
integer oBmpFileId_2;                 //���BMPͼƬ 2
integer oBmpFileId_3;                 //���BMPͼƬ 3
integer oBmpFileId_4;                 //���BMPͼƬ 3

integer oTxtFileId;                 //����TXT�ı�
        
integer iIndex = 0;                 //���BMP��������
integer pixel_index = 0;            //��������������� 
        
integer iCode;      
        
integer iBmpWidth;                  //����BMP ���
integer iBmpHight;                  //����BMP �߶�
integer iBmpSize;                   //����BMP �ֽ���
integer iDataStartIndex;            //����BMP ��������ƫ����
    
reg [ 7:0] rBmpData [0:2000000];    //���ڼĴ�����BMPͼƬ�е��ֽ����ݣ�����54�ֽڵ��ļ�ͷ��

reg [ 7:0] Vip_BmpData_1 [0:2000000]; //���ڼĴ���Ƶͼ����֮�� ��BMPͼƬ ����  
reg [ 7:0] Vip_BmpData_2 [0:2000000]; //���ڼĴ���Ƶͼ����֮�� ��BMPͼƬ ���� 
reg [ 7:0] Vip_BmpData_3 [0:2000000]; //���ڼĴ���Ƶͼ����֮�� ��BMPͼƬ ���� 
reg [ 7:0] Vip_BmpData_4 [0:2000000]; //���ڼĴ���Ƶͼ����֮�� ��BMPͼƬ ���� 

reg [31:0] rBmpWord;                //���BMPͼƬʱ���ڼĴ����ݣ���wordΪ��λ����4byte��

reg [ 7:0] pixel_data;              //�����Ƶ��ʱ����������

reg clk;
reg rst_n;

//reg [ 7:0] vip_pixel_data [0:230400];   	//320x240x3
reg [ 7:0] vip_pixel_data_1 [0:921600];   	//640x480x3
reg [ 7:0] vip_pixel_data_2 [0:921600];   	//640x480x3
reg [ 7:0] vip_pixel_data_3 [0:921600];   	//640x480x3
reg [ 7:0] vip_pixel_data   [0:921600];     //640x480x3

integer i;
integer j;
wire [0:4] 	char_feature  [7:0] [7:0] ;		//�������

`define QuestaSim

`ifndef QuestaSim
//---------------------------------------------
initial begin
	iBmpFileId	= 	$fopen("../../../../../pic/PIC/21_Su_A65NF7/21_Su_A65NF7.bmp","rb");

//������BMPͼƬ���ص������� 21_Su_A65NF7
	iCode = $fread(rBmpData,iBmpFileId);
 
    //����BMPͼƬ�ļ�ͷ�ĸ�ʽ���ֱ�����ͼƬ�� ��� /�߶� /��������ƫ���� /ͼƬ�ֽ���
	iBmpWidth       = {rBmpData[21],rBmpData[20],rBmpData[19],rBmpData[18]};
	iBmpHight       = {rBmpData[25],rBmpData[24],rBmpData[23],rBmpData[22]};
	iBmpSize        = {rBmpData[ 5],rBmpData[ 4],rBmpData[ 3],rBmpData[ 2]};
	iDataStartIndex = {rBmpData[13],rBmpData[12],rBmpData[11],rBmpData[10]};
    
    //�ر�����BMPͼƬ
	$fclose(iBmpFileId);
        
    //�ӳ�13ms���ȴ���һ֡VIP�������
    #13000000    
	
    //����ͼ�����BMPͼƬ���ļ�ͷ����������

//---------------------------------------------		
	oBmpFileId_1 	= 	$fopen("../../../../../pic/PIC/21_Su_A65NF7/output_file_1.bmp","wb+");
	//�����һ��
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
		if(iIndex < 54)
            Vip_BmpData_1[iIndex] = rBmpData[iIndex];
        else
            Vip_BmpData_1[iIndex] = vip_pixel_data_1[iIndex-54];
	end
    //�������е�����д�����BMPͼƬ��    
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
		rBmpWord = Vip_BmpData_1[iIndex];
		$fwrite(oBmpFileId_1,"%c",rBmpWord);
	end
	$fclose(oBmpFileId_1);

//---------------------------------------------		
	oBmpFileId_2 	= 	$fopen("../../../../../pic/PIC/21_Su_A65NF7/output_file_2.bmp","wb+");
	//����ڶ���
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
		if(iIndex < 54)
            Vip_BmpData_2[iIndex] = rBmpData[iIndex];
        else
            Vip_BmpData_2[iIndex] = vip_pixel_data_2[iIndex-54];
	end
    //�������е�����д�����BMPͼƬ��  
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
		rBmpWord = Vip_BmpData_2[iIndex];
		$fwrite(oBmpFileId_2,"%c",rBmpWord);
	end
	$fclose(oBmpFileId_2);

//---------------------------------------------
//�ӳ�13ms���ȴ��ڶ�֡VIP�������
    #13000000 	

//---------------------------------------------	
	//���������
	oBmpFileId_3 	= 	$fopen("../../../../../pic/PIC/21_Su_A65NF7/output_file_3.bmp","wb+");
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
		if(iIndex < 54)
            Vip_BmpData_3[iIndex] = rBmpData[iIndex];
        else
            Vip_BmpData_3[iIndex] = vip_pixel_data_3[iIndex-54];
	end
    //�������е�����д�����BMPͼƬ��    
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
		rBmpWord = Vip_BmpData_3[iIndex];
		$fwrite(oBmpFileId_3,"%c",rBmpWord);
	end
	$fclose(oBmpFileId_3);
	
//---------------------------------------------
//�ӳ�13ms���ȴ�����֡VIP�������
    #17000000 	
//---------------------------------------------		
	//���������
	oBmpFileId_4 	= 	$fopen("../../../../../pic/PIC/21_Su_A65NF7/output_file_4.bmp","wb+");
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
		if(iIndex < 54)
            Vip_BmpData_4[iIndex] = rBmpData[iIndex];
        else
            Vip_BmpData_4[iIndex] = vip_pixel_data[iIndex-54];
	end
    //�������е�����д�����BMPͼƬ��    
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
		rBmpWord = Vip_BmpData_4[iIndex];
		$fwrite(oBmpFileId_4,"%c",rBmpWord);
	end
	$fclose(oBmpFileId_4);

//---------------------------------------------	
	//�������Txt�ı�
	oTxtFileId 		= $fopen("../../../../../pic/PIC/21_Su_A65NF7/output_file.txt","w+");
	//�������ֵ
	for(i=0;i<8;i++)begin
		for(j=0;j<8;j++) begin
			$fdisplay(oTxtFileId,"%b",char_feature[i][7-j]);
		end
		$fdisplay(oTxtFileId,"\n");
	end    
	//�ر�Txt�ı�
    $fclose(oTxtFileId);

end  
//initial end
//--------------------------------------------- 
`else
//---------------------------------------------
initial begin

    //������BMPͼƬ
	iBmpFileId      = $fopen("E:\\github\\Vehicle-License-Plate-Recognition\\pic\\PIC\\21_Su_A65NF7\\21_Su_A65NF7.bmp","rb");

    //������BMPͼƬ���ص������� 21_Su_A65NF7
	iCode = $fread(rBmpData,iBmpFileId);
 
    //����BMPͼƬ�ļ�ͷ�ĸ�ʽ���ֱ�����ͼƬ�� ��� /�߶� /��������ƫ���� /ͼƬ�ֽ���
	iBmpWidth       = {rBmpData[21],rBmpData[20],rBmpData[19],rBmpData[18]};
	iBmpHight       = {rBmpData[25],rBmpData[24],rBmpData[23],rBmpData[22]};
	iBmpSize        = {rBmpData[ 5],rBmpData[ 4],rBmpData[ 3],rBmpData[ 2]};
	iDataStartIndex = {rBmpData[13],rBmpData[12],rBmpData[11],rBmpData[10]};
    
    //�ر�����BMPͼƬ
	$fclose(iBmpFileId);

//---------------------------------------------		
	//�����BMPͼƬ
	oBmpFileId_1 = $fopen("E:\\github\\Vehicle-License-Plate-Recognition\\pic\\PIC\\21_Su_A65NF7\\output_file_1.bmp","wb+");
	oBmpFileId_2 = $fopen("E:\\github\\Vehicle-License-Plate-Recognition\\pic\\PIC\\21_Su_A65NF7\\output_file_2.bmp","wb+");
	oBmpFileId_3 = $fopen("E:\\github\\Vehicle-License-Plate-Recognition\\pic\\PIC\\21_Su_A65NF7\\output_file_4.bmp","wb+");
	oBmpFileId_4 = $fopen("E:\\github\\Vehicle-License-Plate-Recognition\\pic\\PIC\\21_Su_A65NF7\\output_file_3.bmp","wb+");
        
    //�ӳ�13ms���ȴ���һ֡VIP�������
    #13000000    
	
    //����ͼ�����BMPͼƬ���ļ�ͷ����������
	
//---------------------------------------------		
	//�����һ��
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
		if(iIndex < 54)
            Vip_BmpData_1[iIndex] = rBmpData[iIndex];
        else
            Vip_BmpData_1[iIndex] = vip_pixel_data_1[iIndex-54];
	end
    //�������е�����д�����BMPͼƬ��    
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 4) begin
		rBmpWord = {Vip_BmpData_1[iIndex+3],Vip_BmpData_1[iIndex+2],Vip_BmpData_1[iIndex+1],Vip_BmpData_1[iIndex]};
		$fwrite(oBmpFileId_1,"%u",rBmpWord);
	end

//---------------------------------------------		
	//����ڶ���
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
		if(iIndex < 54)
            Vip_BmpData_2[iIndex] = rBmpData[iIndex];
        else
            Vip_BmpData_2[iIndex] = vip_pixel_data_2[iIndex-54];
	end
    //�������е�����д�����BMPͼƬ��    
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 4) begin
		rBmpWord = {Vip_BmpData_2[iIndex+3],Vip_BmpData_2[iIndex+2],Vip_BmpData_2[iIndex+1],Vip_BmpData_2[iIndex]};
		$fwrite(oBmpFileId_2,"%u",rBmpWord);
	end
	
//---------------------------------------------
//�ӳ�13ms���ȴ��ڶ�֡VIP�������
    #13000000 	
	
//---------------------------------------------		
	//���������
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
		if(iIndex < 54)
            Vip_BmpData_3[iIndex] = rBmpData[iIndex];
        else
            Vip_BmpData_3[iIndex] = vip_pixel_data_3[iIndex-54];
	end
    //�������е�����д�����BMPͼƬ��    
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 4) begin
		rBmpWord = {Vip_BmpData_3[iIndex+3],Vip_BmpData_3[iIndex+2],Vip_BmpData_3[iIndex+1],Vip_BmpData_3[iIndex]};
		$fwrite(oBmpFileId_3,"%u",rBmpWord);
	end

//---------------------------------------------
//�ӳ�13ms���ȴ�����֡VIP�������
    #17000000 	
	
//---------------------------------------------		
	//���������
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
		if(iIndex < 54)
            Vip_BmpData_4[iIndex] = rBmpData[iIndex];
        else
            Vip_BmpData_4[iIndex] = vip_pixel_data[iIndex-54];
	end
    //�������е�����д�����BMPͼƬ��    
	for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 4) begin
		rBmpWord = {Vip_BmpData_4[iIndex+3],Vip_BmpData_4[iIndex+2],Vip_BmpData_4[iIndex+1],Vip_BmpData_4[iIndex]};
		$fwrite(oBmpFileId_4,"%u",rBmpWord);
	end	
    	
    //�ر����BMPͼƬ
	$fclose(oBmpFileId_1);
	$fclose(oBmpFileId_2);
	$fclose(oBmpFileId_3);
	$fclose(oBmpFileId_4);
		
//---------------------------------------------	
	//�������Txt�ı�
	oTxtFileId = $fopen("E:\\github\\Vehicle-License-Plate-Recognition\\pic\\PIC\\21_Su_A65NF7\\output_file.txt","w+");

	//�������ֵ
	for(i=0;i<8;i++)begin
		for(j=0;j<8;j++) begin
			$fdisplay(oTxtFileId,"%b",char_feature[i][7-j]);
		end
		$fdisplay(oTxtFileId,"\n");
	end


    //�������е�����д�����Txt�ı���
	//$fwrite(oTxtFileId,"%p",rBmpData);
	
    //�ر�Txt�ı�
    $fclose(oTxtFileId);

end  
//initial end
//--------------------------------------------- 
`endif


//---------------------------------------------		
//��ʼ��ʱ�Ӻ͸�λ�ź�
initial begin
    clk     = 1;
    rst_n   = 0;
    #110
    rst_n   = 1;
end 

//����50MHzʱ��
always #10 clk = ~clk;
 
//---------------------------------------------		
//��ʱ�������£��������ж����������ݣ�������Modelsim�в鿴BMP�е����� 
always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        pixel_data  <=  8'd0;
        pixel_index <=  0;
    end
    else begin
        pixel_data  <=  rBmpData[pixel_index];
        pixel_index <=  pixel_index+1;
    end
end
 
//---------------------------------------------
//��������ͷʱ�� 

wire		cmos_vsync ;
reg			cmos_href;
wire        cmos_clken;
reg	[23:0]	cmos_data;	
		 
reg         cmos_clken_r;

reg [31:0]  cmos_index;

parameter [10:0] IMG_HDISP = 11'd640;
parameter [10:0] IMG_VDISP = 11'd480;

localparam H_SYNC = 11'd5;		
localparam H_BACK = 11'd5;		
localparam H_DISP = IMG_HDISP;	
localparam H_FRONT = 11'd5;		
localparam H_TOTAL = H_SYNC + H_BACK + H_DISP + H_FRONT;	

localparam V_SYNC = 11'd1;		
localparam V_BACK = 11'd0;		
localparam V_DISP = IMG_VDISP;	
localparam V_FRONT = 11'd1;		
localparam V_TOTAL = V_SYNC + V_BACK + V_DISP + V_FRONT;

//---------------------------------------------
//ģ�� OV7725/OV5640 ����ģ�������ʱ��ʹ��
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cmos_clken_r <= 0;
	else
        cmos_clken_r <= ~cmos_clken_r;
end

//---------------------------------------------
//ˮƽ������
reg	[10:0]	hcnt;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		hcnt <= 11'd0;
	else if(cmos_clken_r) 
		hcnt <= (hcnt < H_TOTAL - 1'b1) ? hcnt + 1'b1 : 11'd0;
end

//---------------------------------------------
//��ֱ������
reg	[10:0]	vcnt;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		vcnt <= 11'd0;		
	else if(cmos_clken_r) begin
		if(hcnt == H_TOTAL - 1'b1)
			vcnt <= (vcnt < V_TOTAL - 1'b1) ? vcnt + 1'b1 : 11'd0;
		else
			vcnt <= vcnt;
    end
end

//---------------------------------------------
//��ͬ��
reg	cmos_vsync_r;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cmos_vsync_r <= 1'b0;			//H: Vaild, L: inVaild
	else begin
		if(vcnt <= V_SYNC - 1'b1)
			cmos_vsync_r <= 1'b0; 	//H: Vaild, L: inVaild
		else
			cmos_vsync_r <= 1'b1; 	//H: Vaild, L: inVaild
    end
end
assign	cmos_vsync	= cmos_vsync_r;

//---------------------------------------------
//����Ч
wire	frame_valid_ahead =  ( vcnt >= V_SYNC + V_BACK  && vcnt < V_SYNC + V_BACK + V_DISP
                            && hcnt >= H_SYNC + H_BACK  && hcnt < H_SYNC + H_BACK + H_DISP ) 
						? 1'b1 : 1'b0;
      
reg			cmos_href_r;      
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cmos_href_r <= 0;
	else begin
		if(frame_valid_ahead)
			cmos_href_r <= 1;
		else
			cmos_href_r <= 0;
    end
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cmos_href <= 0;
	else
        cmos_href <= cmos_href_r;
end

assign cmos_clken = cmos_href & cmos_clken_r;

//-------------------------------------
//������������Ƶ��ʽ�����������
wire [10:0] x_pos;
wire [10:0] y_pos;

assign x_pos = frame_valid_ahead ? (hcnt - (H_SYNC + H_BACK )) : 0;
assign y_pos = frame_valid_ahead ? (vcnt - (V_SYNC + V_BACK )) : 0;

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) begin
       cmos_index   <=  0;
       cmos_data    <=  24'd0;
   end
   else begin
       //cmos_index   <=  y_pos * 960  + x_pos*3 + 54;        //  3*(y*320 + x) + 54
       cmos_index   <=  y_pos * 1920  + x_pos*3 + 54;         //  3*(y*640 + x) + 54
       cmos_data    <=  {rBmpData[cmos_index], rBmpData[cmos_index+1] , rBmpData[cmos_index+2]};
   end
end
 
//-------------------------------------
//VIP�㷨������ɫת�Ҷ�

wire 		per_frame_vsync	=	cmos_vsync ;	
wire 		per_frame_href	=	cmos_href;	
wire 		per_frame_clken	=	cmos_clken;	
wire [7:0]	per_img_red		=	cmos_data[ 7: 0];	   	
wire [7:0]	per_img_green	=	cmos_data[15: 8];   	            
wire [7:0]	per_img_blue	=	cmos_data[23:16];   	            


wire 		post0_frame_vsync;   
wire 		post0_frame_href ;   
wire 		post0_frame_clken;    
wire [7:0]	post0_img_Y      ;   
wire [7:0]	post0_img_Cb     ;   
wire [7:0]	post0_img_Cr     ;   

VIP_RGB888_YCbCr444	u_VIP_RGB888_YCbCr444
(
	//global clock
	.clk				(clk),					
	.rst_n				(rst_n),				

	//Image data prepred to be processd
	.per_frame_vsync	(per_frame_vsync),		
	.per_frame_href		(per_frame_href),		
	.per_frame_clken	(per_frame_clken),		
	.per_img_red		(per_img_red),			
	.per_img_green		(per_img_green),		
	.per_img_blue		(per_img_blue),			
	
	//Image data has been processd
	.post_frame_vsync	(post0_frame_vsync),	
	.post_frame_href	(post0_frame_href),		
	.post_frame_clken	(post0_frame_clken),	
	.post_img_Y			(post0_img_Y ),			
	.post_img_Cb		(post0_img_Cb),			
	.post_img_Cr		(post0_img_Cr)			
);

//--------------------------------------
//VIP�㷨������ֵ��

wire			post1_frame_vsync;
wire			post1_frame_href ;
wire			post1_frame_clken;
wire	     	post1_img_Bit    ;

binarization u_binarization (
	.clk					(clk				),  				
	.rst_n					(rst_n				),				

	//Image data prepred to be processd
	.per_frame_vsync		(post0_frame_vsync	),	
	.per_frame_href			(post0_frame_href	),		
	.per_frame_clken		(post0_frame_clken	),	
	.per_img_Y				(post0_img_Cb		),			
    
	//Image data has been processd
	.post_frame_vsync		(post1_frame_vsync	),	
	.post_frame_href		(post1_frame_href	),		
	.post_frame_clken		(post1_frame_clken	),	
	.post_img_Bit			(post1_img_Bit		),		
	
	//��ֵ����ֵ 
	.Binary_Threshold		(150				)				
);


//--------------------------------------
//VIP�㷨������ʴ
wire			post2_frame_vsync;	
wire			post2_frame_href;	
wire			post2_frame_clken;	
wire			post2_img_Bit;		

VIP_Bit_Erosion_Detector#(
	.IMG_HDISP				(IMG_HDISP			),	//640*480
	.IMG_VDISP				(IMG_VDISP			)
)u_VIP_Bit_Erosion_Detector(
	//global clock
	.clk					(clk				),  				
	.rst_n					(rst_n				),				

	//Image data prepred to be processd
	.per_frame_vsync		(post1_frame_vsync	),	
	.per_frame_href			(post1_frame_href	),		
	.per_frame_clken		(post1_frame_clken	),	
	.per_img_Bit			(post1_img_Bit		),		

	//Image data has been processd
	.post_frame_vsync		(post2_frame_vsync	),	
	.post_frame_href		(post2_frame_href	),		
	.post_frame_clken		(post2_frame_clken	),	
	.post_img_Bit			(post2_img_Bit		)			
);

//--------------------------------------
//VIP �㷨����Sobel��Ե���

wire			post4_frame_vsync;	 
wire			post4_frame_href;	 
wire			post4_frame_clken;	 
wire			post4_img_Bit;		 

VIP_Sobel_Edge_Detector #(
	.IMG_HDISP				(IMG_HDISP	),	 
	.IMG_VDISP				(IMG_VDISP	)
) u_VIP_Sobel_Edge_Detector (
	.clk					(clk		),  				
	.rst_n					(rst_n		),				

	//Image data prepred to be processd
	.per_frame_vsync		(post2_frame_vsync	),	
	.per_frame_href			(post2_frame_href	),		
	.per_frame_clken		(post2_frame_clken	),	
	.per_img_Y				({8{post2_img_Bit}}	),			

	//Image data has been processd
	.post_frame_vsync		(post4_frame_vsync	),	
	.post_frame_href		(post4_frame_href	),		
	.post_frame_clken		(post4_frame_clken	),	
	.post_img_Bit			(post4_img_Bit		),		
	
	//User interface
	.Sobel_Threshold		(128)					
);

//--------------------------------------
//VIP�㷨����ͶӰǰ�Ƚ������������ͣ���ֹ�Ƕ�ƫ��1��2������
wire			post5_frame_vsync;	
wire			post5_frame_href;	
wire			post5_frame_clken;	
wire			post5_img_Bit;	
	
VIP_Bit_Dilation_Detector#(
	.IMG_HDISP	(IMG_HDISP),	//640*480
	.IMG_VDISP	(IMG_VDISP)
)u_VIP_Bit_Dilation_Detector(
	//global clock
	.clk					(clk				),  				
	.rst_n					(rst_n				),				

	//Image data prepred to be processd
	.per_frame_vsync		(post4_frame_vsync	),	
	.per_frame_href			(post4_frame_href	),		
	.per_frame_clken		(post4_frame_clken	),	
	.per_img_Bit			(post4_img_Bit		),		

	//Image data has been processd
	.post_frame_vsync		(post5_frame_vsync	),	
	.post_frame_href		(post5_frame_href	),		
	.post_frame_clken		(post5_frame_clken	),	
	.post_img_Bit			(post5_img_Bit		)			
);


//--------------------------------------
//VIP�㷨��������֡ͼ�������ֱͶӰ

wire [9:0] 		max_line_left ;  
wire [9:0] 		max_line_right;
	
VIP_vertical_projection#(
	.IMG_HDISP	(IMG_HDISP),	//640*480
	.IMG_VDISP	(IMG_VDISP),
	
	.EDGE_THROD	(45)			//��Ե��ֵ
)u_VIP_vertical_projection(
	//global clock
	.clk					(clk),  				
	.rst_n					(rst_n),				

	//Image data prepred to be processd
	.per_frame_vsync		(post5_frame_vsync	),	
	.per_frame_href			(post5_frame_href	),		
	.per_frame_clken		(post5_frame_clken	),	
	.per_img_Bit			(post5_img_Bit		),		

	//Image data has been processd
	.post_frame_vsync		(),	
	.post_frame_href		(),	
	.post_frame_clken		(),	
	.post_img_Bit			(),


	.max_line_left 			(max_line_left 		),  
	.max_line_right			(max_line_right		),
                             
	.vertical_start			(0					), 
	.vertical_end			(IMG_VDISP - 1		)   
);

//--------------------------------------
//VIP�㷨��������֡ͼ�����ˮƽͶӰ
wire [9:0] 		max_line_up  ;  
wire [9:0] 		max_line_down;
	
VIP_horizon_projection#(
	.IMG_HDISP	(IMG_HDISP),	//640*480
	.IMG_VDISP	(IMG_VDISP),
	
	.EDGE_THROD	(100)			//��Ե��ֵ
)u_VIP_horizon_projection(
	//global clock
	.clk					(clk				),  				
	.rst_n					(rst_n				),				

	//Image data prepred to be processd
	.per_frame_vsync		(post5_frame_vsync	),	
	.per_frame_href			(post5_frame_href	),		
	.per_frame_clken		(post5_frame_clken	),	
	.per_img_Bit			(post5_img_Bit		),		

	//Image data has been processd
	.post_frame_vsync		(),	
	.post_frame_href		(),	
	.post_frame_clken		(),	
	.post_img_Bit			(),

	.max_line_up  			(max_line_up  		),  
	.max_line_down			(max_line_down		),
                             
	.horizon_start			(0					), 
	.horizon_end			(IMG_HDISP - 1		)   
);




//-------------------------------------
//�������Ƶı߽磬ʹ��ֻ�����ַ�����

wire [9:0] 	plate_boarder_up 	;  	//������ı߿�
wire [9:0] 	plate_boarder_down	; 
wire [9:0] 	plate_boarder_left 	;
wire [9:0] 	plate_boarder_right	;

plate_boarder_adjust u_plate_boarder_adjust(
	//global clock
	.clk					(clk				),  				
	.rst_n					(rst_n				),				

	//Image data prepred to be processd
	.per_frame_vsync		(post5_frame_vsync	),	

	.max_line_up  			(max_line_up  		),  
	.max_line_down			(max_line_down		),
	.max_line_left 			(max_line_left 		),  
	.max_line_right			(max_line_right		),
	
    .plate_boarder_up 	    (plate_boarder_up 	),
    .plate_boarder_down	    (plate_boarder_down	),
    .plate_boarder_left     (plate_boarder_left ),
    .plate_boarder_right    (plate_boarder_right),

	.plate_exist_flag	    ()	
);


//--------------------------------------
//VIP�㷨�������ַ�������ж�ֵ��


wire			post8_frame_vsync;
wire			post8_frame_href ;
wire			post8_frame_clken;
wire	     	post8_img_Bit    ;

binarization_char #(
	.IMG_HDISP	(IMG_HDISP),	//640*480
	.IMG_VDISP	(IMG_VDISP)
)u_binarization_char (
	.clk					(clk				),  				
	.rst_n					(rst_n				),				

	//Image data prepred to be processd	
	.per_frame_vsync		(per_frame_vsync	),		
	.per_frame_href			(per_frame_href		),		
	.per_frame_clken		(per_frame_clken	),		
	.per_img_Y				(per_img_red		),			
    
	//Image data has been processd
	.post_frame_vsync		(post8_frame_vsync	),	
	.post_frame_href		(post8_frame_href	),		
	.post_frame_clken		(post8_frame_clken	),	
	.post_img_Bit			(post8_img_Bit		),
	
	//��ֵ����ֵ 
	.Binary_Threshold		(128				),

    .plate_boarder_up 	    (plate_boarder_up 	),
    .plate_boarder_down	    (plate_boarder_down	),
	
    .plate_boarder_left     (plate_boarder_left ),
    .plate_boarder_right    (plate_boarder_right) 
);

//--------------------------------------
//VIP�㷨������ʴ
wire			post9_frame_vsync;	
wire			post9_frame_href;	
wire			post9_frame_clken;	
wire			post9_img_Bit;		

VIP_Bit_Erosion_Detector#(
	.IMG_HDISP	(IMG_HDISP),	//640*480
	.IMG_VDISP	(IMG_VDISP)
)u_VIP_Bit_Erosion_Detector_red(
	//global clock
	.clk					(clk				),  				
	.rst_n					(rst_n				),				

	//Image data prepred to be processd
	.per_frame_vsync		(post8_frame_vsync	),	
	.per_frame_href			(post8_frame_href	),		
	.per_frame_clken		(post8_frame_clken	),	
	.per_img_Bit			(post8_img_Bit		),		

	//Image data has been processd
	.post_frame_vsync		(post9_frame_vsync	),	
	.post_frame_href		(post9_frame_href	),		
	.post_frame_clken		(post9_frame_clken	),	
	.post_img_Bit			(post9_img_Bit		)			
);


//--------------------------------------
//VIP�㷨��������
wire			post10_frame_vsync;	
wire			post10_frame_href;	
wire			post10_frame_clken;	
wire			post10_img_Bit;	
	
VIP_Bit_Dilation_Detector#(
	.IMG_HDISP				(IMG_HDISP			),	//640*480
	.IMG_VDISP				(IMG_VDISP			)
)u_VIP_Bit_Dilation_Detector_red(
	//global clock
	.clk					(clk				),  				
	.rst_n					(rst_n				),				

	//Image data prepred to be processd
	.per_frame_vsync		(post9_frame_vsync	),	
	.per_frame_href			(post9_frame_href	),		
	.per_frame_clken		(post9_frame_clken	),	
	.per_img_Bit			(post9_img_Bit		),		

	//Image data has been processd
	.post_frame_vsync		(post10_frame_vsync	),	
	.post_frame_href		(post10_frame_href	),		
	.post_frame_clken		(post10_frame_clken	),	
	.post_img_Bit			(post10_img_Bit		)			
);


//--------------------------------------
//VIP�㷨�����ַ����������ֱͶӰ
wire			post11_frame_vsync;	
wire			post11_frame_href;	
wire			post11_frame_clken;	
wire			post11_img_Bit;	

wire [20:0] 	char_boarder[7:0];
	
VIP_vertical_projection_char#(
	.IMG_HDISP				(IMG_HDISP				),	//640*480
	.IMG_VDISP				(IMG_VDISP				)
)u_VIP_vertical_projection_char(
	//global clock
	.clk					(clk					),  				
	.rst_n					(rst_n					),				

	//Image data prepred to be processd
	.per_frame_vsync		(post10_frame_vsync		),	
	.per_frame_href			(post10_frame_href		),		
	.per_frame_clken		(post10_frame_clken		),	
	.per_img_Bit			(post10_img_Bit			),		

	//Image data has been processd
	.post_frame_vsync		(post11_frame_vsync		),	
	.post_frame_href		(post11_frame_href		),		
	.post_frame_clken		(post11_frame_clken		),	
	.post_img_Bit			(post11_img_Bit			),

	.char_boarder			(char_boarder			),
	
	.vertical_start			(0						), 	//���Ʒ�Χ����������У��Ѿ��ڶ�ֵ����ʱ�򱻹��˵���
	.vertical_end			(IMG_VDISP - 1			),
	
    .plate_boarder_left     (plate_boarder_left 	),  //���ƺ������꣬�����ų���һ������Ϊ���ҽṹʱ������ʶ��������ַ�
    .plate_boarder_right    (plate_boarder_right	) 	
);

//--------------------------------------
//VIP�㷨�����ַ��������ˮƽͶӰ

wire [9:0] 	char_top  ;
wire [9:0] 	char_down;
	
VIP_horizon_projection_char#(
	.IMG_HDISP	(IMG_HDISP),	//640*480
	.IMG_VDISP	(IMG_VDISP),
	
	.EDGE_THROD	(14)			//���ر仯����7*2�Σ���ʾ����߽�λ��
)u_VIP_horizon_projection_char(
	//global clock
	.clk					(clk),  				
	.rst_n					(rst_n),				

	//Image data prepred to be processd
	.per_frame_vsync		(post10_frame_vsync	),	
	.per_frame_href			(post10_frame_href	),		
	.per_frame_clken		(post10_frame_clken	),	
	.per_img_Bit			(post10_img_Bit		),			

	//Image data has been processd
	.post_frame_vsync		(),	
	.post_frame_href		(),	
	.post_frame_clken		(),	
	.post_img_Bit			(),

	.char_top 				(char_top ),
	.char_down				(char_down),
                             
	.horizon_start			(0				), //���Ʒ�Χ����������У��Ѿ��ڶ�ֵ����ʱ�򱻹��˵���
	.horizon_end			(IMG_HDISP - 1	)
);

//--------------------------------------
//VIP�㷨��������ʶ��
	
//��ʴ�����ͺ������ֱ�������ƫ�ƣ���Ҫ���е���
	
plate_feature_recognize
#(
	.IMG_HDISP	(IMG_HDISP),	//640*480
	.IMG_VDISP	(IMG_VDISP)
)
u_plate_feature_recognize
(
	//global clock
	.clk					(clk),  				
	.rst_n					(rst_n),				

	//Image data prepred to be processd
	.per_frame_vsync		(post11_frame_vsync),	
	.per_frame_href			(post11_frame_href),		
	.per_frame_clken		(post11_frame_clken),	
	.per_img_Bit			(post11_img_Bit),		

	//Image data has been processd
	// .post_frame_vsync		(post10_frame_vsync),	
	// .post_frame_href			(post10_frame_href),		
	// .post_frame_clken		(post10_frame_clken),	
	// .post_img_Bit			(post10_img_Bit),

	.char_top       (char_top ),
    .char_down      (char_down),
	.char_boarder	(char_boarder),
	
	.char_feature	(char_feature)
);

wire exist;
//--------------------------------------
// //VIP�㷨�������ģ��ƥ��

// wire [0:4] 	char_feature_updown  [7:0] [7:0] ;		//����������·�ת

// assign char_feature_updown[j][0] = char_feature[j][7];
// assign char_feature_updown[j][1] = char_feature[j][6];
// assign char_feature_updown[j][2] = char_feature[j][5];
// assign char_feature_updown[j][3] = char_feature[j][4];
// assign char_feature_updown[j][4] = char_feature[j][3];
// assign char_feature_updown[j][5] = char_feature[j][2];
// assign char_feature_updown[j][6] = char_feature[j][1];
// assign char_feature_updown[j][7] = char_feature[j][0];

wire [7:0]	char_index [7:0];	//ƥ����ַ�����
wire		match_valid		;	//ƥ��ɹ���־

conv_template_match conv_template_match(
	.clk					(clk),  				
	.rst_n					(rst_n),
	
	.char_feature			(char_feature),
    .char_feature_valid		(~post11_frame_vsync), 
	
	.char_index 			(char_index ),
	.match_valid			(match_valid)
);

//-------------------------------------
//��Ƶ��ʾ����

wire video_hs;
wire video_vs;
wire video_de;

wire [10:0]  pixel_xpos;          //���ص������
wire [10:0]  pixel_ypos;          //���ص�������   

//������Ƶ��ʾ����ģ��
video_driver u_video_driver(
    .pixel_clk      (clk),
    .sys_rst_n      (rst_n),

    .video_hs       (video_hs),
    .video_vs       (video_vs),
    .video_de       (video_de),
    .video_rgb      (),
   
    .pixel_xpos     (pixel_xpos),
    .pixel_ypos     (pixel_ypos),
    .pixel_data     ()
    );

    wire   [3:0]         VGA_R;
    wire   [3:0]         VGA_G;
    wire   [3:0]         VGA_B;
	

//lcd��ʾģ��    
lcd_display u_lcd_display(          
    .lcd_clk        (clk),    
    .sys_rst_n      (rst_n ),
    
    .pixel_xpos     (pixel_xpos), 
    .pixel_ypos     (pixel_ypos),
    
    .VGA_R          (VGA_R),
    .VGA_G          (VGA_G),
    .VGA_B          (VGA_B),
    
    .up_pos       	(max_line_up    ),  
    .down_pos      	(max_line_down  ),
	.left_pos       (max_line_left 	),
    .right_pos      (max_line_right	),

    .char_up_pos	(char_top ),  
    .char_down_pos	(char_down),
	.char_left_pos	(plate_boarder_left ),
    .char_right_pos	(plate_boarder_right),

	.char_top       (char_top ),
    .char_down      (char_down),
	.char_boarder	(char_boarder) 
    );




//-------------------------------------

wire 		PIC1_vip_out_frame_vsync;   
wire 		PIC1_vip_out_frame_href ;   
wire 		PIC1_vip_out_frame_clken;    
wire [7:0]	PIC1_vip_out_img_R     ;   
wire [7:0]	PIC1_vip_out_img_G     ;   
wire [7:0]	PIC1_vip_out_img_B     ;  

wire 		PIC2_vip_out_frame_vsync;   
wire 		PIC2_vip_out_frame_href ;   
wire 		PIC2_vip_out_frame_clken;    
wire [7:0]	PIC2_vip_out_img_R     ;   
wire [7:0]	PIC2_vip_out_img_G     ;   
wire [7:0]	PIC2_vip_out_img_B     ;   

wire 		PIC3_vip_out_frame_vsync;   
wire 		PIC3_vip_out_frame_href ;   
wire 		PIC3_vip_out_frame_clken;    
wire [7:0]	PIC3_vip_out_img_R     ;   
wire [7:0]	PIC3_vip_out_img_G     ;   
wire [7:0]	PIC3_vip_out_img_B     ; 


//��һ�����Sobel��Ե���֮��Ľ��
assign PIC1_vip_out_frame_vsync 	= 	post4_frame_vsync ;   
assign PIC1_vip_out_frame_href  	= 	post4_frame_href  ;   
assign PIC1_vip_out_frame_clken 	= 	post4_frame_clken ;  
assign PIC1_vip_out_img_R        	= 	{8{post4_img_Bit}};   
assign PIC1_vip_out_img_G        	= 	{8{post4_img_Bit}};   
assign PIC1_vip_out_img_B        	= 	{8{post4_img_Bit}}; 

//�ڶ��������ֵ�˲�֮��Ľ��
assign PIC2_vip_out_frame_vsync 	=  	post5_frame_vsync ;   
assign PIC2_vip_out_frame_href  	=  	post5_frame_href  ;   
assign PIC2_vip_out_frame_clken 	=  	post5_frame_clken ; 
assign PIC2_vip_out_img_R 			=  	{8{post5_img_Bit}};
assign PIC2_vip_out_img_G 			=  	{8{post5_img_Bit}};
assign PIC2_vip_out_img_B 			=  	{8{post5_img_Bit}};


//����������Ҷ�ת��֮���Cb
 assign PIC3_vip_out_frame_vsync 	=	post10_frame_vsync ; 	   
 assign PIC3_vip_out_frame_href  	=	post10_frame_href  ; 	   
 assign PIC3_vip_out_frame_clken 	=	post10_frame_clken ; 	 
 assign PIC3_vip_out_img_R 			=	{8{post10_img_Bit}};	
 assign PIC3_vip_out_img_G 			=	{8{post10_img_Bit}};	
 assign PIC3_vip_out_img_B 			=	{8{post10_img_Bit}};



//�Ĵ�ͼ����֮�����������

//-------------------------------------
//��һ��ͼ
reg [31:0]  PIC1_vip_cnt;
reg         PIC1_vip_vsync_r;    //�Ĵ�VIP����ĳ�ͬ�� 
reg         PIC1_vip_out_en;     //�Ĵ�VIP����ͼ���ʹ���źţ���ά��һ֡��ʱ��

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) 
        PIC1_vip_vsync_r   <=  1'b0;
   else 
        PIC1_vip_vsync_r   <=  PIC1_vip_out_frame_vsync;
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) 
        PIC1_vip_out_en    <=  1'b1;
   else if(PIC1_vip_vsync_r & (!PIC1_vip_out_frame_vsync))  //��һ֡����֮��ʹ������
        PIC1_vip_out_en    <=  1'b0;
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) begin
        PIC1_vip_cnt <=  32'd0;
   end
   else if(PIC1_vip_out_en) begin
        if(PIC1_vip_out_frame_href & PIC1_vip_out_frame_clken) begin
            PIC1_vip_cnt <=  PIC1_vip_cnt + 3;
            vip_pixel_data_1[PIC1_vip_cnt+0] <= PIC1_vip_out_img_R;
            vip_pixel_data_1[PIC1_vip_cnt+1] <= PIC1_vip_out_img_G;
            vip_pixel_data_1[PIC1_vip_cnt+2] <= PIC1_vip_out_img_B;
        end
   end
end

//-------------------------------------
//�ڶ���ͼ

reg [31:0]  PIC2_vip_cnt;
reg         PIC2_vip_vsync_r;    //�Ĵ�VIP����ĳ�ͬ�� 
reg         PIC2_vip_out_en;     //�Ĵ�VIP����ͼ���ʹ���źţ���ά��һ֡��ʱ��

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) 
        PIC2_vip_vsync_r   <=  1'b0;
   else 
        PIC2_vip_vsync_r   <=  PIC2_vip_out_frame_vsync;
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) 
        PIC2_vip_out_en    <=  1'b1;
   else if(PIC2_vip_vsync_r & (!PIC2_vip_out_frame_vsync))  //��һ֡����֮��ʹ������
        PIC2_vip_out_en    <=  1'b0;
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) begin
        PIC2_vip_cnt <=  32'd0;
   end
   else if(PIC2_vip_out_en) begin
        if(PIC2_vip_out_frame_href & PIC2_vip_out_frame_clken) begin
            PIC2_vip_cnt <=  PIC2_vip_cnt + 3;
            vip_pixel_data_2[PIC2_vip_cnt+0] <= PIC2_vip_out_img_R;
            vip_pixel_data_2[PIC2_vip_cnt+1] <= PIC2_vip_out_img_G;
            vip_pixel_data_2[PIC2_vip_cnt+2] <= PIC2_vip_out_img_B;
        end
   end
end

//-------------------------------------
//������ͼ
reg [31:0]  PIC3_vip_cnt;
reg         PIC3_vip_vsync_r;    //�Ĵ�VIP����ĳ�ͬ�� 
reg         PIC3_vip_out_en;     //�Ĵ�VIP����ͼ���ʹ���źţ���ά��һ֡��ʱ��

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) 
        PIC3_vip_vsync_r   <=  1'b0;
   else 
        PIC3_vip_vsync_r   <=  PIC3_vip_out_frame_vsync;
end

reg frame_2nd_en;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n) begin
        PIC3_vip_out_en	<=	1'b0;
		frame_2nd_en 	<= 	1'b0;
	end
	else if(PIC1_vip_out_en == 1) begin
		PIC3_vip_out_en	<=  1'b0;
		frame_2nd_en 	<= 	1'b0;
	end
	else if((!frame_2nd_en) & PIC3_vip_out_frame_vsync & (!PIC3_vip_vsync_r)) begin //��һ֡����֮�����ߵڶ�֡ʹ��
        PIC3_vip_out_en	<=  1'b1;
		frame_2nd_en 	<= 	1'b1;
	end
	else if(PIC3_vip_vsync_r & (!PIC3_vip_out_frame_vsync))  //�ڶ�֡����֮��ʹ������
        PIC3_vip_out_en    <=  1'b0;
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) begin
        PIC3_vip_cnt <=  32'd0;
   end
   else if(PIC3_vip_out_en) begin
        if(PIC3_vip_out_frame_href & PIC3_vip_out_frame_clken) begin
            PIC3_vip_cnt <=  PIC3_vip_cnt + 3;
            vip_pixel_data_3[PIC3_vip_cnt+0] <= PIC3_vip_out_img_R;
            vip_pixel_data_3[PIC3_vip_cnt+1] <= PIC3_vip_out_img_G;
            vip_pixel_data_3[PIC3_vip_cnt+2] <= PIC3_vip_out_img_B;
        end
   end
end

//-------------------------------------
//������ͼ
reg [31:0] vip_cnt;

wire [7:0]	vip_out_img_R;   
wire [7:0]	vip_out_img_G;   
wire [7:0]	vip_out_img_B;  

assign vip_out_img_R       = {VGA_R,  VGA_R};   
assign vip_out_img_G       = {VGA_G,  VGA_G};   
assign vip_out_img_B       = {VGA_B,  VGA_B};

wire out_border_flag;

assign out_border_flag = VGA_R[0] | VGA_G[0] | VGA_B[0];

 
reg    vip_vsync_r;    //�Ĵ�VIP����ĳ�ͬ�� 
reg    vip_out_en;     //�Ĵ�VIP����ͼ���ʹ���źţ���ά��һ֡��ʱ��

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) 
        vip_vsync_r   <=  1'b0;
   else 
        vip_vsync_r   <=  video_vs;
end

reg frame_3rd_en;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n) begin
        vip_out_en		<=	1'b0;
		frame_3rd_en	<= 1'b0;
	end
	else if((PIC1_vip_out_en == 1)||(PIC3_vip_out_en == 1)) begin 		//ǰ��֡ͼ��������У�ʹ������
		vip_out_en    	<=	1'b0;
		frame_3rd_en	<=	1'b0;
	end
	else  if((!frame_3rd_en) & video_vs & (!vip_vsync_r)) begin //�ڶ�֡����֮��ʹ������
        vip_out_en    	<=  1'b1;
		frame_3rd_en	<= 	1'b1;
	end
	else if(vip_vsync_r & (!video_vs))  
        vip_out_en    <=  1'b0;
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) begin
        vip_cnt <=  32'd0;
   end
   else if(vip_out_en) begin
        if(video_de) begin
            vip_cnt <=  vip_cnt + 3;
            // vip_pixel_data[vip_cnt+0] <= (vip_out_img_R == 8'b1111_0000) ? 8'h00 : vip_pixel_data_3[vip_cnt+0];
            // vip_pixel_data[vip_cnt+1] <= (vip_out_img_G == 8'b1111_0000) ? 8'h00 : vip_pixel_data_3[vip_cnt+1];
            // vip_pixel_data[vip_cnt+2] <= (vip_out_img_B == 8'b1111_0000) ? 8'hFF : vip_pixel_data_3[vip_cnt+2];
			
            vip_pixel_data[vip_cnt+0] <= out_border_flag ? vip_out_img_B : vip_pixel_data_3[vip_cnt+0];
            vip_pixel_data[vip_cnt+1] <= out_border_flag ? vip_out_img_G : vip_pixel_data_3[vip_cnt+1];
            vip_pixel_data[vip_cnt+2] <= out_border_flag ? vip_out_img_R : vip_pixel_data_3[vip_cnt+2];
        end
   end
end
 


endmodule 