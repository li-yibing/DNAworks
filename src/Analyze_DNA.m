function Analyze_DNA
%**************************************************************************
%
%  This example shows how to read and write variable-length
%  string datatypes to a dataset.  The program first writes
%  variable-length strings to a dataset with a dataspace of
%  DIM0, then closes the file.  Next, it reopens the file,
%  reads back the data, and outputs it to the screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'job-117.h5';
%fileName       = 'DNA.h5';

%% Now we begin the read section of this example.  Here we assume

info=h5info(fileName);

for G_id = 1:length(info.Groups)
    for D_id = 1:length(info.Groups(G_id).Datasets)
path=strcat(info.Groups(G_id).Name,'/',info.Groups(G_id).Datasets(D_id).Name);
data = h5read(fileName, path);
txtpath=strcat(num2str(G_id),'_',info.Groups(G_id).Datasets(D_id).Name,'.xls');
if strcmp(info.Groups(G_id).Datasets(D_id).Datatype.Class,'H5T_STRING')% && info.Groups(G_id).Datasets(D_id).Datatype.Type.Length==1
    data=cell2mat(data);
end
fid = fopen(txtpath,'wt');
%fid = fopen('txtpath.txt','wt');
fprintf(fid,'%g\n',data);      
fclose(fid);
    end
end

fid = fopen('DNA.fasta','r');
bb = textscan(fid,'%s');
fclose(fid);
aa=bb{1,1}{2,1}(:);
num=0;
for i=1:length(aa)
    if aa(i)=='G'
        num=[num;i];
    end
end

