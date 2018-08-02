function [squ_data , pos]  = char2squ(char_data)
        pos=[];
        squ_data=char_data;
        for i=1 : length(char_data)
            if ~strcmp(char_data(i),'A')&&~strcmp(char_data(i),'G')&&~strcmp(char_data(i),'C')&&~strcmp(char_data(i),'T')
                pos=[pos;i];
                squ_data(i)='*';
            end
        end