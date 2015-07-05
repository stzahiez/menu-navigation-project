function varargout = SG_GUI_2(varargin)
%{
Model Name 	:	GUI_Tests
Generated	:	27.10.2012
Author		:	Yoav Shvartz
Project		:	Symbol Generator Project

Description: 
GUI_Test is a Graphical User Interface with which the user can build 
frames with added or removed symbols which are being loaded by the GUI.
The user can choose the time of waiting between opcodes and frames with 
the 'wait' panel.
The frames with their relevant opcodes and waiting times are written into
a text file with the name the user choose and the suffix "_TEXT" which is being added automatically.
Moreover, another text file is created with the relevent bits' sequence for the UART communication.
This file has the name the user choose and the suffix "_UART" which is being added automatically.
In additon, the user can print into another file the screen, in any given
time.

Order of actions:
1. choose a name for your test file and click the 'start' button.
2. adding symbol:
    - click the 'load symbol' button and choose a symbol to add
    - choose the coordinate (x,y). 
      remark: 
              1. x is an integer between 1 to 20
              2. y is an integer between 1 to 15  
    - click the 'add symbol' to add the symbol to the screen
    - choose time and units, to wait AFTER the opcode of the added symbol
      is executed.
      remarks: 
              1. unit [T] is 1 clock cycle.  
              2. default waiting is 0[T]
   removing symbol:
    - choose the coordinate (x,y). 
      remark: 
              1. x is an integer between 1 to 20
              2. y is an integer between 1 to 15  
    - click the 'remove symbol' to remove the symbol from the screen
    - choose time and units, to wait AFTER the opcode of the removed symbol
      is executed
3. after adding and removing symbols to and from the screen, click the 
   'create frame' button to create the frame and to write the opcodes to 
   your test file.
4. repeat stages 1-4 to add as many frames as desired.
   when finished, click the 'create files' button to create your _TEXT , _UART 
   file
5. the text file ,_TEXT, always starts with 300 zeroed opcodes for initializing the
   test.
   the text file ,_UART, always starts with 300 zeroed opcodes (for initializing) being translated to
   the UART protocol.
6. At any given time you can print the screen on th GUI to a file named 
   <name of test file>_screen. 
 
Revision:
		Number		Date		Name				Description			
		1.00		20.4.2012   Yoav Shvartz		Creation
        2.00		20.2.2013   Yoav Shvartz		Adding text _UART
        3.00		28.3.2013   Olga Liberman		Prepare the GUI to Serial Communication

Todo:
	(1) add a 'help' button.
    (2) 
    (3)
%}


% SG_GUI_2 MATLAB code for SG_GUI_2.fig
%      SG_GUI_2, by itself, creates a new SG_GUI_2 or raises the existing
%      singleton*.
%
%      H = SG_GUI_2 returns the handle to a new SG_GUI_2 or the handle to
%      the existing singleton*.
%
%      SG_GUI_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SG_GUI_2.M with the given input arguments.
%
%      SG_GUI_2('Property','Value',...) creates a new SG_GUI_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SG_GUI_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SG_GUI_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SG_GUI_2

% Last Modified by GUIDE v2.5 04-Apr-2013 19:36:04

% new_test initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SG_GUI_2_OpeningFcn, ...
                   'gui_OutputFcn',  @SG_GUI_2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SG_GUI_2 is made visible.
function SG_GUI_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SG_GUI_2 (see VARARGIN)

% default screen is black
% creating "windows" , "opcode" and "participate" variables:
% in the "windows" we save the symbols represented in binary base.
% in the "opcode" we create the relevant opcode for the cell.
% in the "participate" we save 0 if the cell in the screen has not changed
% and 1 if it has changed.

handles.pic_name= 'P:\Menu_Navigation_Projectwc\trunk\GOLDEN MODEL\project_1_impl_1\Program\Matlab\GUI\symbol_00.bmp'; % the symbol path name. For example: handles.pic_name = "H:\Project\Project Files\Matlab\GUI\Project Files_yoav\Matlab\MATLAB\GUI - final\symbol_00.bmp"  
handles.screen=imread('screen.bmp');
handles.opcode=cell(15,20);
handles.changed=zeros(15,20);
set(handles.path,'String','P:\Menu_Navigation_Projectwc\trunk\GOLDEN MODEL\project_1_impl_1\Program\Matlab\GUI');
handles.new_test=0;
path = strcat( get(handles.path,'String') ,'\test_files\test_');
i = 1;
path_temp = strcat(path,num2str(i));
while ( exist(path_temp,'dir') == 7)
    i = i + 1;
    path_temp = strcat(path,num2str(i));
end;
handles.test_num = i - 1;
handles.uart_txt_num = 1;
axes(handles.window);
imshow(handles.screen);


for y=1:15
    for x=1:20
        handles.opcode{y,x}='000000000000000000000000';
    end
end

set(handles.loaded_file,'String','symbol_0.bmp');


% Choose default command line output for SG_GUI_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SG_GUI_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SG_GUI_2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Load_symbol.
function Load_symbol_Callback(hObject, eventdata, handles)
% hObject    handle to Load_symbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%checking the user initiate the text file by using the 'new_test' button
if (handles.new_test==0)
    error('first click the start button');
end

[File,Dir] = uigetfile({'*.bmp; *.png; *.jpg; *.gif ; *.tif', 'Picture File (*.bmp, *.png, *.jpg, *.gif)'; '*.*', 'All files (*.*)'}, 'Choose Image Files',  'symbols/','MultiSelect', 'off');
handles.pic_name = strcat(Dir,File);   %Concatenate File after Dir
set(handles.loaded_file,'String',File);
guidata(hObject, handles);

function x_loc_Callback(hObject, eventdata, handles)
% hObject    handle to x_loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_loc as text
%        str2double(get(hObject,'String')) returns contents of x_loc as a double

%checking the user initiate the text file by using the 'new_test' button
if (handles.new_test==0)
%     set(handles.x_loc,'String','1');
    uiwait(msgbox('First click the "New Test" button'));
%     error('first click the start button');
end
x_list = get(handles.x_loc, 'String');
x_choice = get(handles.x_loc, 'Value');
x_str = x_list{x_choice};
x=str2num(x_str);
% if (x<1)||(x>20)
%    set(handles.x_loc,'String','1');
%    error('x is out of bounds [1,20]'); 
% end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function x_loc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_loc_Callback(hObject, eventdata, handles)
% hObject    handle to y_loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_loc as text
%        str2double(get(hObject,'String')) returns contents of y_loc as a double

%checking the user initiate the text file by using the 'new_test' button
if (handles.new_test==0)
%     set(handles.y_loc,'String','1');
    uiwait(msgbox('First click the "New Test" button'));
%     error('first click the start button');
end
y_list = get(handles.y_loc, 'String');
y_choice = get(handles.y_loc, 'Value');
y_str = y_list{y_choice};
y=str2num(y_str);
% if (y<1)||(y>15)
%    set(handles.y_loc,'String','1');
%    error('y is out of bounds [1,15]'); 
% end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function y_loc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in add_symbol.
function add_symbol_Callback(hObject, eventdata, handles)
        % hObject    handle to add_symbol (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        %checking the user initiate the text file by using the 'new_test' button
        if (handles.new_test==0)
            error('first click the start button');
        end

% %         x=get(handles.x_loc,'String');
% %         y=get(handles.y_loc,'String');
% %         x=str2num(x);
% %         y=str2num(y);
        x_list = get(handles.x_loc, 'String');
        x_choice = get(handles.x_loc, 'Value');
        x_str = x_list{x_choice};
        x=str2num(x_str);
        y_list = get(handles.y_loc, 'String');
        y_choice = get(handles.y_loc, 'Value');
        y_str = y_list{y_choice};
        y=str2num(y_str);

        %checkin bounds of x & y
        if ( (x>20)||(x<1)||(y>15)||(y<1) )
            error(' x or y are out of bounds ( x = [1,20] y = [1,15] )');
        end

        axes(handles.window);
        Symbol=imread(handles.pic_name);
        Symbol_2_dim=Symbol(:,:,1);
        handles.screen( ((y-1)*32+1):(y*32),((x-1)*32+1):(x*32) ) = Symbol_2_dim; % y = rows , x = columns 
        imshow(handles.screen);

        handles.changed(y,x)=1;  % image was added !

        % finding the number of the loaded picture:
        % example: if picture name = "...XXX_02.bmp", then pic_num = "0000000000010" (13 bits)  .
        i1=find(handles.pic_name == '_',1,'last');
        i2=find(handles.pic_name == '.',1,'last');
        pic_num=dec2base(   str2num(handles.pic_name((i1+1):(i2-1)))  ,2  ,13);
        x_bin=dec2bin(x-1,5);
        y_bin=dec2bin(y-1,4);
        handles.opcode{y,x}=strcat('0','1',pic_num,y_bin,x_bin);

        guidata(hObject, handles);


% --- Executes on button press in clear_screen.
function clear_screen_Callback(hObject, eventdata, handles)
        % hObject    handle to clear_screen (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        %Clear SCREEN (SCREEN is black)
%         handles.uart_txt_num = 1;
        handles.screen=imread('screen.bmp');
        axes(handles.window);
        imshow(handles.screen);
        for y=1:15
            for x=1:20
                x_bin=dec2bin(x-1,5);
                y_bin=dec2bin(y-1,4);
                handles.opcode{y,x}=strcat('0','0','0000000000000',y_bin,x_bin);
                handles.changed(y,x)=1;
                
            end
        end
%         handles.new_test=0; % the user needs to push 'start' buton again
        guidata(hObject, handles);

% --- Executes on button press in remove_symbol.
function remove_symbol_Callback(hObject, eventdata, handles)
        % hObject    handle to remove_symbol (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        %checking the user initiate the text file by using the 'new_test' button
        if (handles.new_test==0)
            error('first click the start button');
        end
        
% %         x=get(handles.x_loc,'String');
% %         y=get(handles.y_loc,'String');
% %         x=str2num(x);
% %         y=str2num(y);
        x_list = get(handles.x_loc, 'String');
        x_choice = get(handles.x_loc, 'Value');
        x_str = x_list{x_choice};
        x=str2num(x_str);
        y_list = get(handles.y_loc, 'String');
        y_choice = get(handles.y_loc, 'Value');
        y_str = y_list{y_choice};
        y=str2num(y_str);

        %checking the user doesn't remove a black symbol  
        if ( size(find(handles.screen( ((y-1)*32+1):(y*32),((x-1)*32+1):(x*32) ) == 0),1) == (32*32) )
            error('cannot clear a black symbol');
        end

%         %checking bounds of x & y
%         if ( (x>20)||(x<1)||(y>15)||(y<1) )
%             error(' x or y are out of bounds ( x = [1,20] y = [1,15] )');
%         end 

        Symbol=imread('symbol_00.bmp');
        axes(handles.window);
        Symbol_2_dim=Symbol(:,:,1);
        handles.screen( ((y-1)*32+1):y*32,((x-1)*32+1):x*32 ) = Symbol_2_dim;
        imshow(handles.screen);

        handles.changed(y,x)=-1;  % image was deleted !

        x_bin=dec2bin(x-1,5);
        y_bin=dec2bin(y-1,4);
        handles.opcode{y,x}=strcat('0','0','0000000000000',y_bin,x_bin);

        guidata(hObject, handles);


% --- Executes on button press in create_uart_txt.
function create_uart_txt_Callback(hObject, eventdata, handles)
        % hObject    handle to create_uart_txt (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        handles.uart_txt_num = handles.uart_txt_num + 1;

        folder_name = get(handles.path,'String');
        folder_name = strcat(folder_name,'\test_files\test_',num2str(handles.test_num));
% %         file_UART = fopen(strcat(folder_name,'\uart_tx\uart_tx_',num2str(handles.uart_txt_num),'.txt'),'w'); 28.03.2013 olga

        [num_of_opcodes,~]=size(find(handles.changed));
        display (num_of_opcodes);
		
		%%%%%%%%%%%%%%%%%%%%%%%% Sending chunk of changes to SG %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Prepare serial port
		serial_port= instrfind('Port','COM7'); %Close any COM3 serial connection
		if numel(serial_port) ~= 0
			fclose(serial_port);
		end
		serial_port = serial('COM7','BaudRate', 115200,'Parity', 'none', 'DataBits', 8, 'StopBits', 1,'Timeout', 2, 'OutputBufferSize', 1024 + 8, 'InputBufferSize', 1024 + 8);
        fopen(serial_port);
        % constants
        sof = 100; % SOF value
        eof = 200;
        type = 128; % type=0x80 -> write to register
        addr = 16; % SG register base address for burst write
        length = num_of_opcodes*3 - 1;
        length_msb = floor(length/256);
        length_lsb = mod(length,256);
        crc_sum = type + addr + length_msb + length_lsb;
        % adding new frame to UART file
		fwrite(serial_port, sof);
        fwrite(serial_port, type);
        fwrite(serial_port, 0);
        fwrite(serial_port, addr);
        fwrite(serial_port, length_msb);
        fwrite(serial_port, length_lsb);
        for y=1:15
            for x=1:20
				if  (handles.changed(y,x) ~= 0 )
					segment1 = bin2dec(handles.opcode{y,x}(1:8));    % segment 1 (MSB at first) 
					segment2 = bin2dec(handles.opcode{y,x}(9:16));   % segment 2 
					segment3 = bin2dec(handles.opcode{y,x}(17:24));  % segment 3 (LSB at last)
					fwrite(serial_port, segment1);
					fwrite(serial_port, segment2);
					fwrite(serial_port, segment3);
					crc_sum = crc_sum + segment1 + segment2 + segment3;
					% zeroing opcodes for the next create_uart_txt
					handles.opcode{y,x}='000000000000000000000000';
					handles.changed(y,x)=0;
				end
            end
        end
        crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
		fwrite(serial_port, crc);
        fwrite(serial_port, eof);
		fclose(serial_port);
		% % End of transaction
        uiwait(msgbox('Transmission is done!','Status'));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


% % %         %creating expected image - 28.03.2013 olga
% % %         expected_im=imread('out_img_1.bmp');
% % %         expected_im=expected_im(:,:,1);
% % %         expected_im( ((600-480)/2+1):((600-480)/2+480),((800-640)/2+1):((800-640)/2+640) ) = handles.screen;
% % %         imwrite( expected_im , strcat(folder_name,'\expected\out_img_',num2str(handles.uart_txt_num),'.bmp') , 'bmp');

        guidata(hObject, handles);


% --- Executes on button press in new_test.
function new_test_Callback(hObject, eventdata, handles)
        % hObject    handle to new_test (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        handles.new_test = 1;

        handles.test_num = handles.test_num + 1;

        %creating directories for new test
        parentFolder = get(handles.path,'String');
        parentFolder = strcat(parentFolder,'\test_files');
        parentFolder = get(handles.path,'String');
%         mkdir(parentFolder,strcat('\test_',num2str(handles.test_num)));
        parentFolder = strcat(parentFolder,'\test_',num2str(handles.test_num));
%         mkdir(parentFolder,'uart_tx');
%         mkdir(parentFolder,'expected');
%         mkdir(parentFolder,'output');

        %copy initialization file uart_tx_1
        %example: copyfile('myFun.m','d:/work/Projects/')
        % % % copyfile( 'uart_tx_1.txt',strcat(parentFolder,'\uart_tx') ); %28.03.2013
        % % % copyfile( 'out_img_1.bmp',strcat(parentFolder,'\expected') ); %28.03.2013

        %Clear SCREEN (SCREEN is black)
        handles.uart_txt_num = 1;
        handles.screen=imread('screen.bmp');
        axes(handles.window);
        imshow(handles.screen);
        for y=1:15
            for x=1:20
                handles.opcode{y,x}='000000000000000000000000';
                handles.changed(y,x)=0;
            end
        end

%         set(handles.x_loc,'String','1');
%         set(handles.y_loc,'String','1');
        
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
		% Prepare serial port
		serial_port= instrfind('Port','COM7'); %Close any COM3 serial connection
		if numel(serial_port) ~= 0
			fclose(serial_port);
		end
		serial_port = serial('COM7','BaudRate', 115200,'Parity', 'none', 'DataBits', 8, 'StopBits', 1,'Timeout', 2, 'OutputBufferSize', 1024 + 8, 'InputBufferSize', 1024 + 8);
		fopen(serial_port);
		
% % % % % 		serial_port = fopen('exp.txt', 'w');  % open the file with write permission % FIXME - debug
% % % %         sof = 100; % SOF value
% % % %         eof = 200;
% % % %         type = 129; % type=0x81 -> write to register
% % % %         addr = 16; % SG register base address for burst write
% % % %         length = 1 - 1;
% % % %         length_msb = floor(length/256);
% % % %         length_lsb = length - 256*length_msb;
% % % %         crc_sum = type + addr + length_msb + length_lsb;
% % % %         payload = 5;
% % % %         crc_sum = crc_sum + payload;
% % % %         crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
% % % %         fopen(serial_port); %Open serial port
% % % %         fwrite(serial_port, sof);
% % % %         fwrite(serial_port, type);
% % % %         fwrite(serial_port, 0);
% % % %         fwrite(serial_port, addr);
% % % %         fwrite(serial_port, length_msb);
% % % %         fwrite(serial_port, length_lsb);
% % % %         fwrite(serial_port, payload);
% % % %         fwrite(serial_port, crc);
% % % %         fwrite(serial_port, eof);
% % % %         % End of transaction
% % % % 		uiwait(msgbox('Transmission is DONE!!!','Status'));
% % % % 		fclose(serial_port);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
        
        %%%%%%%%%%%%%%%%%%%%%%%% Initializing RAM with zeros %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % constants
        sof = 100; % SOF value
        eof = 200;
        type = 128; % type=0x80 -> write to register
        addr = 16; % SG register base address for burst write
        length = 900 - 1;
        length_msb = floor(length/256);
        length_lsb = mod(length,256);
        % crc sum
        crc_sum = type + addr + length_msb + length_lsb;
        fwrite(serial_port, sof);
        fwrite(serial_port, type);
        fwrite(serial_port, 0);
        fwrite(serial_port, addr);
        fwrite(serial_port, length_msb);
        fwrite(serial_port, length_lsb);
        for y=1:15
            for x=1:20 
                x_bin = dec2bin(x-1,5);
                y_bin = dec2bin(y-1,4);
                zero7 = dec2bin(0,7);
                segment1 = 0;    % segment 1 (MSB at first) 
                segment2 = bin2dec(strcat(zero7,y_bin(1)));   % segment 2 
                segment3 = bin2dec(strcat(y_bin(2:4),x_bin));  % segment 3 (LSB at last)
				fwrite(serial_port, segment1);
				fwrite(serial_port, segment2);
				fwrite(serial_port, segment3);
                crc_sum = crc_sum + segment1 + segment2 + segment3;
            end
        end
        crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
		fwrite(serial_port, crc);
        fwrite(serial_port, eof);
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
		
		%%%%%%%%%%%%%%%%%%%%%%%% Loading SDRAM with symbols %%%%%%%%%%%%%%%%%%%%%%%%%%%
        symbol_num = 23;
        % constants
        sof = 100; % SOF value
        eof = 200;
        type = 0; % type=0x00 -> write to memory
        addr = 0;
        length = 32*32 - 1; % number of pixels in every symbol = 1023
        length_msb = floor(length/256);
        length_lsb = mod(length,256);
        for i = 0:symbol_num % first symbol is balck
%         for i = 17:symbol_num % first symbol is balck                                                               % FIXME - debug!
            crc_sum = type + addr + length_msb + length_lsb; % crc sum
			fwrite(serial_port, sof);
			fwrite(serial_port, type);
			fwrite(serial_port, 0);
			fwrite(serial_port, addr);
			fwrite(serial_port, length_msb);
			fwrite(serial_port, length_lsb);
            s=imread(strcat('H:\Project\Project Files\Matlab\GUI\GUI - final\symbols\symbol_',num2str(i),'.bmp'));
            s=s(:,:,1);
            for j = 1:32
                for k =1:32
					fwrite(serial_port, s(j,k));
                    crc_sum = crc_sum + double(s(j,k));
                end
            end
            crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
			fwrite(serial_port, crc);
			fwrite(serial_port, eof);
        end
        % summary
        sof = 100; % SOF value
        eof = 200;
        type = 2; % type=0x00 -> write to register
        addr = 0;
        length = 2 - 1; % number of pixels in every symbol = 1023
        length_msb = floor(length/256);
        length_lsb = mod(length,256);
		fwrite(serial_port, sof);
        fwrite(serial_port, type);
        fwrite(serial_port, 0);
        fwrite(serial_port, addr);
        fwrite(serial_port, length_msb);
        fwrite(serial_port, length_lsb);
		payload = [48 0];
        fwrite(serial_port, payload(1));
        fwrite(serial_port, payload(2));
        crc_sum = type + addr + length + payload(1); % crc sum
		crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
		fwrite(serial_port, crc);
        fwrite(serial_port, eof);
		
		fclose(serial_port);
		uiwait(msgbox('Transmission is done!','Status'));
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
        guidata(hObject, handles);


% --- Executes during object deletion, before destroying properties.
function path_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path as text
%        str2double(get(hObject,'String')) returns contents of path as a double



function reg_addr_Callback(hObject, eventdata, handles)
% hObject    handle to reg_addr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reg_addr as text
%        str2double(get(hObject,'String')) returns contents of reg_addr as a double


% --- Executes during object creation, after setting all properties.
function reg_addr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reg_addr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on reg_addr and none of its controls.
function reg_addr_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to reg_addr (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function reg_data_Callback(hObject, eventdata, handles)
% hObject    handle to reg_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reg_data as text
%        str2double(get(hObject,'String')) returns contents of reg_data as a double


% --- Executes during object creation, after setting all properties.
function reg_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reg_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reg_write_button.
function reg_write_button_Callback(hObject, eventdata, handles)
% hObject    handle to reg_write_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Prepare serial port
    serial_port= instrfind('Port','COM7'); %Close any COM3 serial connection
    if numel(serial_port) ~= 0
        fclose(serial_port);
    end
    serial_port = serial('COM3','BaudRate', 115200,'Parity', 'none', 'DataBits', 8, 'StopBits', 1,'Timeout', 2, 'OutputBufferSize', 1024 + 8, 'InputBufferSize', 1024 + 8);
    fopen(serial_port);
        
    % constants
    sof = 100; % SOF value
    eof = 200;
    type = 128; % type=0x80 -> write to register
    length = 1 - 1; % transmit 1 byte
    length_msb = floor(length/256);
    length_lsb = mod(length,256);
    
    % get register address
    clear addr;
	addr_list = get(handles.reg_addr, 'String');
    addr_choice = get(handles.reg_addr, 'Value');
    addr_str = addr_list{addr_choice};
    switch addr_str
        case 'Version Register 0x01'
            addr = 1;
        case 'SG Opcode Register 0x10'
            addr = 16;
        otherwise
            addr = 1;
    end
    
    % get payload
    clear payload;
    payload = hex2dec(get(handles.reg_data, 'String'));
    %checkin bounds of payload
    if (payload > 255)
        error('Data should be less than 0xFF');
    end
    
    fwrite(serial_port, sof);
    fwrite(serial_port, type);
    fwrite(serial_port, 0);
    fwrite(serial_port, addr);
    fwrite(serial_port, length_msb);
    fwrite(serial_port, length_lsb);
    fwrite(serial_port, payload);
    crc_sum = type + addr + length_msb + length_lsb + payload;
    crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
    fwrite(serial_port, crc);
    fwrite(serial_port, eof);
		
	fclose(serial_port);
	uiwait(msgbox('Transmission is done!','Status'));
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    
    
% --- Executes on button press in reg_read_button.
function reg_read_button_Callback(hObject, eventdata, handles)
% hObject    handle to reg_read_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Prepare serial port
    serial_port= instrfind('Port','COM7'); %Close any COM3 serial connection
    if numel(serial_port) ~= 0
        fclose(serial_port);
    end
    serial_port = serial('COM7','BaudRate', 115200,'Parity', 'none', 'DataBits', 8, 'StopBits', 1,'Timeout', 2, 'OutputBufferSize', 1024 + 8, 'InputBufferSize', 1024 + 8);
    fopen(serial_port);
        
    % constants
    sof = 100; % SOF value
    eof = 200;
    type = 128; % type=0x80 -> write to register
    length = 1 - 1; % transmit 1 byte
    length_msb = floor(length/256);
    length_lsb = mod(length,256);
    % get register address
    clear payload;
	addr_list = get(handles.reg_addr, 'String');
    addr_choice = get(handles.reg_addr, 'Value');
    addr_str = addr_list{addr_choice};
    switch addr_str
        case 'Version Register 0x01'
            payload = 1;
        case 'reg2'
            payload = 2;
        case 'reg3'
            payload = 3;
        case 'SG Opcode Register 0x10'
            payload = 16;
        otherwise
            payload = 1;
    end
    addr = 12;
    fwrite(serial_port, sof);
    fwrite(serial_port, type);
    fwrite(serial_port, 0);
    fwrite(serial_port, addr);
    fwrite(serial_port, length_msb);
    fwrite(serial_port, length_lsb);
    fwrite(serial_port, payload);
    crc_sum = type + addr + length_msb + length_lsb + payload;
    crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
    fwrite(serial_port, crc);
    fwrite(serial_port, eof);
    
    % constants
    sof = 100; % SOF value
    eof = 200;
    type = 128; % type=0x80 -> write to register
    length = 1 - 1; % transmit 1 byte
    length_msb = floor(length/256);
    length_lsb = mod(length,256);
    addr = 9;
    payload = 0;
    fwrite(serial_port, sof);
    fwrite(serial_port, type);
    fwrite(serial_port, 0);
    fwrite(serial_port, addr);
    fwrite(serial_port, length_msb);
    fwrite(serial_port, length_lsb);
    fwrite(serial_port, payload);
    crc_sum = type + addr + length_msb + length_lsb + payload;
    crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
    fwrite(serial_port, crc);
    fwrite(serial_port, eof);
    
    % constants
    sof = 100; % SOF value
    eof = 200;
    type = 128; % type=0x80 -> write to register
    length = 1 - 1; % transmit 1 byte
    length_msb = floor(length/256);
    length_lsb = mod(length,256);
    addr = 11;
    payload = 1;
    fwrite(serial_port, sof);
    fwrite(serial_port, type);
    fwrite(serial_port, 0);
    fwrite(serial_port, addr);
    fwrite(serial_port, length_msb);
    fwrite(serial_port, length_lsb);
    fwrite(serial_port, payload);
    crc_sum = type + addr + length_msb + length_lsb + payload;
    crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
    fwrite(serial_port, crc);
    fwrite(serial_port, eof);
    % read register data
    A = fread(serial_port);
%     display(['Version register value is : ' dec2hex(A(6)) ]);
%     display('Read registers DONE');
    uiwait(msgbox(['Register data is : ' dec2hex(A(6))] ,'Status'));

    fclose(serial_port);
