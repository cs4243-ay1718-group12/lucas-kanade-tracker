function [dx, dy] = DarrenLKTrackPyramidalRecurse(im1, im2, x, y, max_levels, w)
    if max_levels == 1
        [dx, dy] = DarrenLKTrack(im1, im2, x, y, w);
        return;
    end
    
    disp(max_levels-1)
    [dx_2, dy_2] = DarrenLKTrackPyramidalRecurse(impyramid(im1, 'reduce'), impyramid(im2, 'reduce'), x/2.0, y/2.0, max_levels-1, w/2);
    
    [dx, dy] = DarrenLKTrack(im1, im2, x, y, w);
    
    dx = dx + dx_2*2;
    dy = dy + dy_2*2;
end