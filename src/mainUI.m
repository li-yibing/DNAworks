function varargout = mainUI(varargin)
% MAINUI MATLAB code for mainUI.fig
%      MAINUI, by itself, creates a new MAINUI or raises the existing
%      singleton*.
%
%      H = MAINUI returns the handle to a new MAINUI or the handle to
%      the existing singleton*.
%
%      MAINUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINUI.M with the given input arguments.
%
%      MAINUI('Property','Value',...) creates a new MAINUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainUI

% Last Modified by GUIDE v2.5 02-Feb-2018 20:47:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mainUI_OpeningFcn, ...
    'gui_OutputFcn',  @mainUI_OutputFcn, ...
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


% --- Executes just before mainUI is made visible.
function mainUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainUI (see VARARGIN)

% Choose default command line output for mainUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mainUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mainUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function ID_Open_Callback(hObject, eventdata, handles)
% hObject    handle to ID_Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global Filepath info;
set(handles.edit2,'string','Opening H5 files...');
[Filename,Filepath]=uigetfile('*.h5','Open H5 files');%gui中打开文件
if Filename==0
    set(handles.edit2,'string','Cancel to open H5 file');
else
    Filename_all=strcat(Filepath,Filename);
    info=h5info(Filename_all);
    handles.info=info;
    handles.Filepath=Filepath;
    guidata(hObject,handles);
    set(handles.edit2,'string','Open the file successfully');
    try
        info=handles.info;
        Filepath=handles.Filepath;
    catch
        info=[];
    end
    if isempty(info)==1
        set(handles.edit2,'string','H5 file not selected, unable to save data!');
    else
        set(handles.edit2,'string','H5 file is being saved in the data, the file is larger, please be patient ...');
        dir=Filename(1:end-3);
        mkdir(strcat(Filepath,dir));
        for G_id = 1:length(info.Groups)
            if isempty(info.Groups(G_id).Groups)
                for D_id = 1:length(info.Groups(G_id).Datasets)
                    path=strcat(info.Groups(G_id).Name,'/',info.Groups(G_id).Datasets(D_id).Name);
                    data = h5read(info.Filename, path);
                    txtname=strcat(num2str(G_id),'_',info.Groups(G_id).Datasets(D_id).Name,'.xls');
                    txtpath=strcat(Filepath,dir,'/',dir,txtname);
                    if iscell(data)
                        try
                            data=cell2mat(data);
                        catch
                            try
                                data=cell2string(data);
                            catch
                                break;
                            end
                        end
                    end
                    fid = fopen(txtpath,'wt');
                    fprintf(fid,'%g\n',data);
                    fclose(fid);
                end
            else
                %代码开始
                for G_id2 = 1:length(info.Groups(G_id).Groups)
                    for D_id2 = 1:length(info.Groups(G_id).Groups(G_id2).Datasets)
                        path=strcat(info.Groups(G_id).Groups(G_id2).Name,'/',info.Groups(G_id).Groups(G_id2).Datasets(D_id2).Name);
                        data = h5read(info.Filename, path);
                        txtname=strcat(num2str(G_id),'_',info.Groups(G_id).Groups(G_id2).Datasets(D_id2).Name,'.xls');
                        txtpath=strcat(Filepath,dir,txtname);
                        if iscell(data)
                            try
                                data=cell2mat(data);
                            catch
                                try
                                    data=cell2string(data);
                                catch
                                    break;
                                end
                            end
                        end
                        fid = fopen(txtpath,'wt');
                        fprintf(fid,'%g\n',data);
                        fclose(fid);
                    end
                end
                %代码结束
            end
        end
        helpdlg('Save all data of H5 file successfully !','Successful operation');
        set(handles.edit2,'string',strcat('Save all data of H5 file successfully ！',10,'Path:',strcat(Filepath,dir),10));
    end
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ID_Tools_Callback(hObject, eventdata, handles)
% hObject    handle to ID_Save_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ID_Save_Data_Callback(hObject, eventdata, handles)
% hObject    handle to ID_Save_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global Filepath info;
% try
%     info=handles.info;
%     Filepath=handles.Filepath;
% catch
%     info=[];
% end
% if isempty(info)==1
%     %helpdlg('未打开H5文件','提示');
%     set(handles.edit2,'string','未选择H5文件，无法保存数据！');
% else
%     set(handles.edit2,'string','正在保存H5文件中的数据，文件较大，请耐心等待...');
%     if ~exist(strcat(Filepath,'results'))
%         mkdir(strcat(Filepath,'results'));
%         dir='results\';
%     else
%         mkdir(strcat(Filepath,'results1'));
%         dir='results1\';
%     end
%     for G_id = 1:length(info.Groups)
%         if isempty(info.Groups(G_id).Groups)
%             for D_id = 1:length(info.Groups(G_id).Datasets)
%                 path=strcat(info.Groups(G_id).Name,'/',info.Groups(G_id).Datasets(D_id).Name);
%                 data = h5read(info.Filename_all, path);
%                 txtname=strcat(num2str(G_id),'_',info.Groups(G_id).Datasets(D_id).Name,'.xls');
%                 txtpath=strcat(Filepath,dir,txtname);
%                 %if strcmp(info.Groups(G_id).Datasets(D_id).Datatype.Class,'H5T_STRING') &&~strcmp( info.Groups(G_id).Datasets(D_id).Datatype.Type.Length,'H5T_VARIABLE')
%                 if iscell(data)
%                     try
%                         data=cell2mat(data);
%                     catch
%                         try
%                             data=cell2string(data);
%                         catch
%                             break;
%                         end
%                     end
%                 end
%                 fid = fopen(txtpath,'wt');
%                 %fid = fopen('txtpath.txt','wt');
%                 fprintf(fid,'%g\n',data);
%                 fclose(fid);
%             end
%
%         else
%             %代码开始
%             for G_id2 = 1:length(info.Groups(G_id).Groups)
%                 for D_id2 = 1:length(info.Groups(G_id).Groups(G_id2).Datasets)
%                     path=strcat(info.Groups(G_id).Groups(G_id2).Name,'\',info.Groups(G_id).Groups(G_id2).Datasets(D_id2).Name);
%                     data = h5read(info.Filename_all, path);
%                     txtname=strcat(num2str(G_id),'_',info.Groups(G_id).Groups(G_id2).Datasets(D_id2).Name,'.xls');
%                     txtpath=strcat(Filepath,dir,txtname);
%                     %if strcmp(info.Groups(G_id).Datasets(D_id).Datatype.Class,'H5T_STRING') &&~strcmp( info.Groups(G_id).Datasets(D_id).Datatype.Type.Length,'H5T_VARIABLE')
%                     if iscell(data)
%                         try
%                             data=cell2mat(data);
%                         catch
%                             try
%                                 data=cell2string(data);
%                             catch
%                                 break;
%                             end
%                         end
%                     end
%                     fid = fopen(txtpath,'wt');
%                     %fid = fopen('txtpath.txt','wt');
%                     fprintf(fid,'%g\n',data);
%                     fclose(fid);
%                 end
%             end
%             %代码结束
%         end
%     end
%     helpdlg('将数据储存在H5所在路径下results文件夹，请查看！','操作成功');
%     set(handles.edit2,'string',strcat('将数据储存在H5所在路径下results文件夹，请查看！',10,'路径为:',Filepath,10));
% end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit2,'string','Opening data 1, please wait ...');
[Filename,Filepath]=uigetfile({'*.xls;*.txt;*.mat;*.fasta'},'Open data file');%gui中打开文件

%file=[filename,filepath];
%fid=fopen(file,'rt');%read txt
if Filename==0
    %helpdlg('No data is opened','Waring');
    set(handles.edit2,'string','No experimental data is opened !');
else
    %遍历文件结构储存数据
    
    Path=strcat(Filepath,Filename);
    fid=fopen(Path,'r');
    data1=fscanf(fid,'%g');
    if isempty(data1)
        HumanHEXA = fastaread(Path); %读fasta文件
        data1=getfield(HumanHEXA,'Sequence');%获取fasta文件中的序列
        data1=int16(data1');
        
    end
    fclose(fid);
    handles.data1=data1;
    guidata(hObject,handles);
    hObject.String=Filename;
    set(handles.edit2,'string',strcat('Already selected experimental data',10,Filename,10));
    try
        %set(handles.uitable1,'data',cellstr(char(data1)));%将数据1赋值给table
        set(handles.uitable1,'data',char(data1));%将数据1赋值给table
    catch
        set(handles.uitable1,'data',data1);%将数据1赋值给table
    end
end
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit2,'string','Opening data 2, please wait ...');
[Filename,Filepath]=uigetfile({'*.xls;*.txt;*.mat;*.fasta'},'Open data file');%gui中打开文件
if Filename==0
    %helpdlg('未打开文件','提示');
    set(handles.edit2,'string','No control data is opened !');
else
    %遍历文件结构储存数据
    
    Path=strcat(Filepath,Filename);
    fid=fopen(Path,'r');
    data2=fscanf(fid,'%g');
    if isempty(data2)
        HumanHEXA = fastaread(Path); %读fasta文件
        data2=getfield(HumanHEXA,'Sequence');%获取fasta文件中的序列
        data2=int16(data2');
    end
    fclose(fid);
    handles.data2=data2;
    guidata(hObject,handles);
    hObject.String=Filename;
    set(handles.edit2,'string',strcat('Already selected control data',10,Filename,10));
    
    set(handles.uitable2,'data',data2);%将数据2赋值给table
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
func=0;
set(handles.edit2,'string','Processing data, please wait ...');
try
    data1=handles.data1;
    data2=handles.data2;
    func=get(handles.popupmenu2, 'value');%功能选择标识
catch
    %helpdlg('请先选择文件','提示');
    set(handles.edit2,'string','No data file selected, operation ended!');
end
switch func
    case 0%未读到数据
        
    case 1%对比序列
        squ1=char(data1)';
        squ2=char(data2)';
        [squ1,~]=char2squ(squ1);
        [squ2,~]=char2squ(squ2);
        [globalscore, globalAlignment,~] = nwalign(squ2,squ1);%全局对比
        showalignment(globalAlignment);
        %         seqdotplot(squ2,squ1) %绘制散点图
        %         ylabel('实验数据');
        %         xlabel('对照数据');
        pos=[];
        for i=1:length(globalAlignment(2,:))
            if strcmp(globalAlignment(2,i),'|');
                pos=[pos; i];
            end
        end
        for i=1:length(pos)
            temp_data2(i)=data2(pos(i));
        end
        handles.pos=pos;
        guidata(hObject,handles);
        data1=data1(1:length(pos));
        data2=temp_data2';
        %        [localscore, localAlignment] = swalign(squ2,squ1); %局部对比
        %        showalignment(localAlignment);
        %        samebase=findsamebase(data1,data2);
        if length(data1)==length(data2)
            %添加代码
            diff_num=0;
            diff_pos=[];
            len=length(data1);
            base.A=[];
            base.C=[];
            base.G=[];
            base.T=[];
            base.NULL=[];
            for i=1:len
                if data1(i)~=data2(i)&&~isempty(data1)&&~isempty(data2)
                    diff_num=diff_num+1;
                    diff_pos=[diff_pos;i];
                end
                %记录碱基位置START
                try
                    if data1(i)==65
                        base.A=[base.A;i];
                    else if data1(i)==67
                            base.C=[base.C;i];
                        else if data1(i)==71
                                base.G=[base.G;i];
                            else if data1(i)==84
                                    base.T=[base.T;i];
                                else if data1(i)==0
                                        base.NULL=[base.NULL;i];
                                    end
                                end
                            end
                        end
                    end
                catch
                    if strcmp(data1(i),'A')
                        base.A=[base.A;i];
                    else if strcmp(data1(i),'C')
                            base.C=[base.C;i];
                        else if strcmp(data1(i),'G')
                                base.G=[base.G;i];
                            else if strcmp(data1(i),'T')
                                    base.T=[base.T;i];
                                else
                                    base.NULL=[base.NULL;i];
                                end
                            end
                        end
                    end
                end
                %记录碱基位置END
                
            end
            str=strcat('筛选后序列总长度为：',num2str(len),10,'差异序列长度：',num2str(diff_num),10,'序列不同的行数将显示在表格3中！');
            str=strcat(str,10,'A:',num2str(length(base.A)),32,'C:',num2str(length(base.C)),32,'G:',num2str(length(base.G)),32,'T:',num2str(length(base.T)),32,'空缺:',num2str(length(base.NULL)),32);
            set(handles.edit2,'string',str);
            set(handles.uitable3,'data',diff_pos);%将有差异的行数赋值给table3
            handles.base=base;
            guidata(hObject,handles);
            handles.squ=data1;  %将序列数据交给总句柄
            guidata(hObject,handles);
            set(handles.pushbutton5,'Visible','On');
            set(handles.pushbutton6,'Visible','On');
            
        else
            len1=length(data1);
            len2=length(data2);
            str=strcat('The length of data 1 is：',num2str(len1),10,'The length of data 2 is',num2str(len2),10,'Sequence comparison is not possible !');
            set(handles.edit2,'string',str);
            %helpdlg('序列长度不同，无法进行比较！','提示');
        end
    case 2%计算IPD的差
        pos=handles.pos;
        for i=1:length(pos)
            temp_data2(i)=data2(pos(i));
        end
        data1=data1(1:length(pos));
        data2=temp_data2';
        if length(data1)==length(data2)
            %添加代码
            diff_num=0;
            diff_pos=[];
            threshold=str2double(get(handles.edit4,'String'));
            size=str2double(get(handles.edit5,'String'));
            %选择碱基START
            if handles.radiobutton6.Value~=1
                if handles.radiobutton2.Value==1
                    for i=1:length(data1)
                        temp_data1(i)=0;
                        temp_data2(i)=0;
                    end
                    for j=1:length(handles.base.A)
                        for i=0:size
                            if handles.base.A(j)>size && handles.base.A(j)+size<=length(data1)
                                temp_data1((handles.base.A(j)-i):(handles.base.A(j)+i))=data1((handles.base.A(j)-i):(handles.base.A(j)+i));
                                temp_data2((handles.base.A(j)-i):(handles.base.A(j)+i))=data2((handles.base.A(j)-i):(handles.base.A(j)+i));
                            end
                        end
                    end
                    temp_data1=temp_data1';
                    temp_data2=temp_data2';
                    %                 for i=1:length(handles.base.A)
                    %                     temp_data1(i)=data1(handles.base.A(i));
                    %                     temp_data2(i)=data2(handles.base.A(i));
                    %                 end
                end
                if handles.radiobutton3.Value==1
                    for i=1:length(data1)
                        temp_data1(i)=0;
                        temp_data2(i)=0;
                    end
                    for j=1:length(handles.base.C)
                        for i=0:size
                            if handles.base.C(j)>size && handles.base.C(j)+size<=length(data1)
                                temp_data1((handles.base.C(j)-i):(handles.base.C(j)+i))=data1((handles.base.C(j)-i):(handles.base.C(j)+i));
                                temp_data2((handles.base.C(j)-i):(handles.base.C(j)+i))=data2((handles.base.C(j)-i):(handles.base.C(j)+i));
                            end
                        end
                    end
                    temp_data1=temp_data1';
                    temp_data2=temp_data2';
                    %                 for i=1:length(handles.base.C)
                    %                     temp_data1(i)=data1(handles.base.C(i));
                    %                     temp_data2(i)=data2(handles.base.C(i));
                    %                 end
                end
                if handles.radiobutton4.Value==1
                    for i=1:length(data1)
                        temp_data1(i)=0;
                        temp_data2(i)=0;
                    end
                    for j=1:length(handles.base.G)
                        for i=0:size
                            if handles.base.G(j)>size && handles.base.G(j)+size<=length(data1)
                                temp_data1((handles.base.G(j)-i):(handles.base.G(j)+i))=data1((handles.base.G(j)-i):(handles.base.G(j)+i));
                                temp_data2((handles.base.G(j)-i):(handles.base.G(j)+i))=data2((handles.base.G(j)-i):(handles.base.G(j)+i));
                            end
                        end
                    end
                    temp_data1=temp_data1';
                    temp_data2=temp_data2';
                    %                 for i=1:length(handles.base.G)
                    %                     temp_data1(i)=data1(handles.base.G(i));
                    %                     temp_data2(i)=data2(handles.base.G(i));
                    %                 end
                end
                if handles.radiobutton5.Value==1
                    for i=1:length(data1)
                        temp_data1(i)=0;
                        temp_data2(i)=0;
                    end
                    for j=1:length(handles.base.T)
                        for i=0:size
                            if handles.base.T(j)>size && handles.base.T(j)+size<=length(data1)
                                temp_data1((handles.base.T(j)-i):(handles.base.T(j)+i))=data1((handles.base.T(j)-i):(handles.base.T(j)+i));
                                temp_data2((handles.base.T(j)-i):(handles.base.T(j)+i))=data2((handles.base.T(j)-i):(handles.base.T(j)+i));
                            end
                        end
                    end
                    temp_data1=temp_data1';
                    temp_data2=temp_data2';
                    %                 for i=1:length(handles.base.T)
                    %                     temp_data1(i)=data1(handles.base.T(i));
                    %                     temp_data2(i)=data2(handles.base.T(i));
                    %                 end
                end
            else
                temp_data1=data1;
                temp_data2=data2;
            end
            %选择碱基END
            
            for i=1:min(length(temp_data1),length(temp_data2))
                diff_data(i)=temp_data1(i)-temp_data2(i);
                if(diff_data(i)>threshold)
                    diff_num=diff_num+1;
                    diff_pos=[diff_pos ; i];
                else
                    if diff_data(i)>0
                        diff_data(i)=0;
                    end
                    %diff_data(i)=0;
                end
            end
            
            [H,P]=ttest(temp_data1,temp_data2,'Tail','right');
            str=strcat('After screening the total length of sequence：',num2str(length(data1)),10,'IPD Sequence length of deviation:',num2str(diff_num),10,'The result of the IPD deviation is shown in Table 4!',10,...
                'T-Test (one tail) for IPD sequence...',10,'H=',num2str(H),'&','P=',num2str(P));
            set(handles.edit2,'string',str);
            %此处为uitable赋值序列
            table_data=cellstr(char(handles.squ));
            set(handles.uitable3,'data',table_data);
            set(handles.uitable4,'data',diff_data');%将有差异的行数赋值给table4
            set(handles.pushbutton5,'Visible','On');
            set(handles.pushbutton6,'Visible','On');
            set(handles.pushbutton7,'Visible','On');
        else
            len1=length(data1);
            len2=length(data2);
            str=strcat('The length of data 1 is：',num2str(len1),10,'The length of data 2 is',num2str(len2),10,'Unable to calculate sequence IPD differences !');
            set(handles.edit2,'string',str);
            %helpdlg('序列长度不同，无法进行计算！','提示');
        end
    case 3%计算PW的差
        pos=handles.pos;
        for i=1:length(pos)
            temp_data2(i)=data2(pos(i));
        end
        data1=data1(1:length(pos));
        data2=temp_data2';
        if length(data1)==length(data2)
            %添加代码
            diff_num=0;
            diff_pos=[];
            threshold=str2double(get(handles.edit4,'String'));
            size=str2double(get(handles.edit5,'String'));
            %选择碱基STRAT
            if handles.radiobutton6.Value~=1
                if handles.radiobutton2.Value==1
                    for i=1:length(data1)
                        temp_data1(i)=0;
                        temp_data2(i)=0;
                    end
                    for j=1:length(handles.base.A)
                        for i=0:size
                            if handles.base.A(j)>size && handles.base.A(j)+size<=length(data1)
                                temp_data1((handles.base.A(j)-i):(handles.base.A(j)+i))=data1((handles.base.A(j)-i):(handles.base.A(j)+i));
                                temp_data2((handles.base.A(j)-i):(handles.base.A(j)+i))=data2((handles.base.A(j)-i):(handles.base.A(j)+i));
                            end
                        end
                    end
                    temp_data1=temp_data1';
                    temp_data2=temp_data2';
                    %                 for i=1:length(handles.base.A)
                    %                     temp_data1(i)=data1(handles.base.A(i));
                    %                     temp_data2(i)=data2(handles.base.A(i));
                    %                 end
                end
                if handles.radiobutton3.Value==1
                    for i=1:length(data1)
                        temp_data1(i)=0;
                        temp_data2(i)=0;
                    end
                    for j=1:length(handles.base.C)
                        for i=0:size
                            if handles.base.C(j)>size && handles.base.C(j)+size<=length(data1)
                                temp_data1((handles.base.C(j)-i):(handles.base.C(j)+i))=data1((handles.base.C(j)-i):(handles.base.C(j)+i));
                                temp_data2((handles.base.C(j)-i):(handles.base.C(j)+i))=data2((handles.base.C(j)-i):(handles.base.C(j)+i));
                            end
                        end
                    end
                    temp_data1=temp_data1';
                    temp_data2=temp_data2';
                    %                 for i=1:length(handles.base.C)
                    %                     temp_data1(i)=data1(handles.base.C(i));
                    %                     temp_data2(i)=data2(handles.base.C(i));
                    %                 end
                end
                if handles.radiobutton4.Value==1
                    for i=1:length(data1)
                        temp_data1(i)=0;
                        temp_data2(i)=0;
                    end
                    for j=1:length(handles.base.G)
                        for i=0:size
                            if handles.base.G(j)>size && handles.base.G(j)+size<=length(data1)
                                temp_data1((handles.base.G(j)-i):(handles.base.G(j)+i))=data1((handles.base.G(j)-i):(handles.base.G(j)+i));
                                temp_data2((handles.base.G(j)-i):(handles.base.G(j)+i))=data2((handles.base.G(j)-i):(handles.base.G(j)+i));
                            end
                        end
                    end
                    temp_data1=temp_data1';
                    temp_data2=temp_data2';
                    %                 for i=1:length(handles.base.G)
                    %                     temp_data1(i)=data1(handles.base.G(i));
                    %                     temp_data2(i)=data2(handles.base.G(i));
                    %                 end
                end
                if handles.radiobutton5.Value==1
                    for i=1:length(data1)
                        temp_data1(i)=0;
                        temp_data2(i)=0;
                    end
                    for j=1:length(handles.base.T)
                        for i=0:size
                            if handles.base.T(j)>size && handles.base.T(j)+size<=length(data1)
                                temp_data1((handles.base.T(j)-i):(handles.base.T(j)+i))=data1((handles.base.T(j)-i):(handles.base.T(j)+i));
                                temp_data2((handles.base.T(j)-i):(handles.base.T(j)+i))=data2((handles.base.T(j)-i):(handles.base.T(j)+i));
                            end
                        end
                    end
                    temp_data1=temp_data1';
                    temp_data2=temp_data2';
                    %                 for i=1:length(handles.base.T)
                    %                     temp_data1(i)=data1(handles.base.T(i));
                    %                     temp_data2(i)=data2(handles.base.T(i));
                    %                 end
                end
            else
                temp_data1=data1;
                temp_data2=data2;
            end
            %选择碱基END
            for i=1:min(length(temp_data1),length(temp_data2));
                diff_data(i)=temp_data1(i)-temp_data2(i);
                if(diff_data(i)>threshold)
                    diff_num=diff_num+1;
                    diff_pos=[diff_pos ; i];
                else
                    if diff_data(i)>0
                        diff_data(i)=0;
                    end
                    %diff_data(i)=0;
                end
            end
            
            
            [H,P]=ttest(temp_data1,temp_data2,'Tail','right');
            str=strcat('After screening the total length of sequence：',num2str(length(data1)),10,'IPD Sequence length of deviation:',num2str(diff_num),10,'The result of the IPD deviation is shown in Table 4!',10,...
                'T-Test (one tail) for IPD sequence...',10,'H=',num2str(H),'&','P=',num2str(P));
            set(handles.edit2,'string',str);
            %此处将碱基序列赋值给uitable3
            table_data=cellstr(char(handles.squ));
            set(handles.uitable3,'data',table_data);
            set(handles.uitable4,'data',diff_data');%将有差异的行数赋值给table4
            set(handles.pushbutton5,'Visible','On');
            set(handles.pushbutton6,'Visible','On');
            set(handles.pushbutton7,'Visible','On');
        else
            len1=length(data1);
            len2=length(data2);
            
            str=strcat('The length of data 1 is:',num2str(len1),10,'The length of data 2 is:',num2str(len2),10,'Unable to calculate sequence PW differences !');
            set(handles.edit2,'string',str);
%             helpdlg('序列长度不同，无法进行计算！','提示');
        end
end
% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
% if(hObject.Value~=1)
%
%     set(handles.text16,'Visible','On');
%     set(handles.edit4,'Visible','On');
%     set(handles.text17,'Visible','On');
%     set(handles.edit5,'Visible','On');
%         set(handles.radiobutton2,'Visible','On');
%         set(handles.radiobutton3,'Visible','On');
%         set(handles.radiobutton4,'Visible','On');
%         set(handles.radiobutton5,'Visible','On');
%         set(handles.radiobutton6,'Visible','On');
% else
%         set(handles.radiobutton2,'Visible','Off');
%         set(handles.radiobutton3,'Visible','Off');
%         set(handles.radiobutton4,'Visible','Off');
%         set(handles.radiobutton5,'Visible','Off');
%         set(handles.radiobutton6,'Visible','Off');
%     set(handles.text16,'Visible','Off');
%     set(handles.edit4,'Visible','Off');
%     set(handles.text17,'Visible','Off');
%     set(handles.edit5,'Visible','Off');
% end


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg(strcat('软件制作人：李宜兵',10,'联系邮箱：li_yi_bing@163.com',10),'关于软件');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure;
bar(handles.uitable4.Data);
set(gca,'xtick',1:length(handles.squ),'xticklabel', char(handles.squ));
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit2,'string','Saving Table 4...');
[Filename,Filepath]=uiputfile('*.xls','Save .xls files','data');%gui中保存表格文件

if Filename==0
    helpdlg('Unnamed form file','waring');
    set(handles.edit2,'string','Unnamed form file');
else
    %遍历文件结构储存数据
    Filename=strcat(Filepath,Filename);
    %xlswrite(Filename, handles.uitable4.Data);
    fid = fopen(Filename,'wt');
    %fprintf(fid,'%g\n',handles.uitable3.Data);
    fprintf(fid,'%g\n',handles.uitable4.Data);
    fclose(fid);
    
    helpdlg('Save table 4 successfully','Successful operation');
    set(handles.edit2,'string','Save table 4 successfully');
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit2,'string','Saving table 3...');
[Filename,Filepath]=uiputfile('*.xls','Save .xls file ','base');%gui中保存表格文件

if Filename==0
    helpdlg('Unnamed form file','waring');
    set(handles.edit2,'string','Unnamed form file');
else
    %遍历文件结构储存数据
    Filename=strcat(Filepath,Filename);
    %xlswrite(Filename, handles.uitable4.Data);
    fid = fopen(Filename,'wt');
    %fprintf(fid,'%g\n',handles.uitable3.Data);
    fprintf(fid,'%c\n',cell2mat(handles.uitable3.Data));
    fclose(fid);
    
    helpdlg('Save table 3 successfully','Successful operation');
    set(handles.edit2,'string','Save table 3 successfully');
end


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
