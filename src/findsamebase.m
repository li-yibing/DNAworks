function samebase  = findsamebase(data1,data2)

szA = length(data1);
szB = length(data2);
samebase=[];
% HumanHEXA = fastaread('DNA.fasta'); %读fasta文件
% humanHEXA=getfield(HumanHEXA,'Sequence');%获取fasta文件中的序列
% HumanHEXA = fastaread('base实验.txt'); %读fasta文件
% humanHEXA=getfield(HumanHEXA,'Sequence');%获取fasta文件中的序列
% humanORFs = seqshoworfs(humanHEXA);%找到起始和终止密码子
% [localscore, localAlignment] = swalign(humanHEXA,humanHEXA); %局部对比
% showalignment(localAlignment);
% [globalscore, globalAlignment] = nwalign(humanHEXA,humanHEXA);%全局对比
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