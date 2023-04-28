%{
turn .mat(double) into .bin

Chien-Jung Chiu

Last Updated: 2022/11/30
%}


%%
a = single(average_fluence_rate);
fid = fopen('Cone1_mean_fluence_rate_1064.bin','wb');
fwrite(fid,a,'single');

%%
fidd = fopen('Cone1_mean_fluence_rate_1064.bin');
bin = fread(fidd,[436,364*364],'single=>single');
rbin = reshape(bin,[436 364 364]);
c = setdiff(a,rbin);   %check whether .bin file is same as the original file
TF = isempty(c);
if TF == 1
    disp('.bin file was correctly turned in!');
else
    disp('ERROR!!!');
end
