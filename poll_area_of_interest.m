function [xmin, ymin, xmax, ymax, w, h] = poll_area_of_interest(img)
    I = double(img);

    imshow(I);
    k = waitforbuttonpress;
    button_down = get(gca,'CurrentPoint');  % button down detected
    rectregion = rbbox; % this does nothing i don't know why i need it but the code breaks without it
    button_release = get(gca,'CurrentPoint'); % button release
    
    button_down = button_down(1,1:2); %%% extract col/row min and maxs
    button_release = button_release(1,1:2);
    
    lowerleft = round(min(button_down, button_release));
    upperright = round(max(button_down, button_release));
    
    ymax = lowerleft(1, 2);
    ymin = upperright(1, 2);
    xmin = lowerleft(1, 1);
    xmax = upperright(1, 1);
    w = abs(xmax - xmin) + 1;
    h = abs(ymax - ymin) + 1;
end