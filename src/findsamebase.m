function samebase  = findsamebase(data1,data2)

szA = length(data1);
szB = length(data2);
samebase=[];
% HumanHEXA = fastaread('DNA.fasta'); %��fasta�ļ�
% humanHEXA=getfield(HumanHEXA,'Sequence');%��ȡfasta�ļ��е�����
% HumanHEXA = fastaread('baseʵ��.txt'); %��fasta�ļ�
% humanHEXA=getfield(HumanHEXA,'Sequence');%��ȡfasta�ļ��е�����
% humanORFs = seqshoworfs(humanHEXA);%�ҵ���ʼ����ֹ������
% [localscore, localAlignment] = swalign(humanHEXA,humanHEXA); %�ֲ��Ա�
% showalignment(localAlignment);
% [globalscore, globalAlignment] = nwalign(humanHEXA,humanHEXA);%ȫ�ֶԱ�
% showalignment(globalAlignment); 
% for i = 1:szA
i=1;
    for j = 1:szB-szA+1
        if isequal(data1(i:szA), data2(j:j+szA-i))
            samebase.base1=data1(i:szA);
            samebase.base2=data2(j:j+szA-i);
            break;
        end
    end
%     if ~isempty(samebase)
%             break;
%      end
% end