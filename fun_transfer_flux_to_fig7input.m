function [to_plot_layer_eng] = fun_transfer_flux_to_fig7input(average_fluence,model_size,colorTickLabel,vol)
% function [to_plot_layer_eng] = fun_transfer_flux_to_fig7input(average_fluence,model_size,threshold,class_interval,vol)
%{
turn the simulation result (average fluence rate) into the input of fig.7
%Chien-Jung Chiu
%Last update: 2023/2/13 

%}
chk = model_size;
chk1 = size(average_fluence);
to_plot_layer_eng = vol.vol;
if chk ~= chk1
    disp("model's and average fluence rate's size do not match");
end
for x = 1:model_size(1)
    for y = 1:model_size(2)
        for z = 1:model_size(3)
            if vol.vol(x,y,z) == 6
                to_plot_layer_eng(x,y,z) = 0;
            elseif (vol.vol(x,y,z) == 4) && (vol.vol(x,y+1,z) == 5)
                to_plot_layer_eng(x,y,z) = 1;
            elseif (vol.vol(x,y,z) == 4) && (vol.vol(x,y-1,z) == 5)
                to_plot_layer_eng(x,y,z) = 1;
            elseif (vol.vol(x,y,z) == 4) && (vol.vol(x-1,y,z) == 5)
                to_plot_layer_eng(x,y,z) = 1;
            elseif (vol.vol(x,y,z) == 4) && (vol.vol(x+1,y,z) == 5)
                to_plot_layer_eng(x,y,z) = 1;
            elseif (vol.vol(x,y,z) == 4) || (vol.vol(x,y,z) == 5)
                if (str2double(cell2mat(colorTickLabel(1,6))) < average_fluence(x,y,z)) && (average_fluence(x,y,z) < str2double(cell2mat(colorTickLabel(1,7))))
                    to_plot_layer_eng(x,y,z) = 6;
                elseif (str2double(cell2mat(colorTickLabel(1,7))) < average_fluence(x,y,z)) && (average_fluence(x,y,z) < str2double(cell2mat(colorTickLabel(1,8))))
                     to_plot_layer_eng(x,y,z) = 7;
                elseif (str2double(cell2mat(colorTickLabel(1,8))) < average_fluence(x,y,z)) && (average_fluence(x,y,z) < str2double(cell2mat(colorTickLabel(1,9))))
                     to_plot_layer_eng(x,y,z) = 8;
                elseif (str2double(cell2mat(colorTickLabel(1,9))) < average_fluence(x,y,z)) && (average_fluence(x,y,z) < str2double(cell2mat(colorTickLabel(1,10))))
                     to_plot_layer_eng(x,y,z) = 9;
                elseif (str2double(cell2mat(colorTickLabel(1,10))) < average_fluence(x,y,z)) && (average_fluence(x,y,z) < str2double(cell2mat(colorTickLabel(1,11))))
                     to_plot_layer_eng(x,y,z) = 10;
                elseif (str2double(cell2mat(colorTickLabel(1,11))) < average_fluence(x,y,z)) && (average_fluence(x,y,z) < str2double(cell2mat(colorTickLabel(1,12))))
                     to_plot_layer_eng(x,y,z) = 11;
                elseif (str2double(cell2mat(colorTickLabel(1,12))) < average_fluence(x,y,z)) && (average_fluence(x,y,z) < str2double(cell2mat(colorTickLabel(1,13))))
                     to_plot_layer_eng(x,y,z) = 12;
                elseif (str2double(cell2mat(colorTickLabel(1,13))) < average_fluence(x,y,z)) && (average_fluence(x,y,z) < str2double(cell2mat(colorTickLabel(1,14))))
                     to_plot_layer_eng(x,y,z) = 13;
                elseif (str2double(cell2mat(colorTickLabel(1,14))) < average_fluence(x,y,z)) && (average_fluence(x,y,z) < str2double(cell2mat(colorTickLabel(1,15))))
                     to_plot_layer_eng(x,y,z) = 14;
                elseif (str2double(cell2mat(colorTickLabel(1,15))) < average_fluence(x,y,z)) && (average_fluence(x,y,z) < str2double(cell2mat(colorTickLabel(1,16))))
                     to_plot_layer_eng(x,y,z) = 15;
                elseif (str2double(cell2mat(colorTickLabel(1,16))) < average_fluence(x,y,z)) && (average_fluence(x,y,z) < str2double(cell2mat(colorTickLabel(1,17))))
                     to_plot_layer_eng(x,y,z) = 16;
                elseif str2double(cell2mat(colorTickLabel(1,17))) < average_fluence(x,y,z)
                     to_plot_layer_eng(x,y,z) = 17;
                end
            end
        end
    end
end
%test = unique(to_plot_layer_eng);

end

