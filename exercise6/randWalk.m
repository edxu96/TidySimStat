function [delta] = randWalk()
    delta = randi(2, 1);
    if delta == 2
        delta = -1;
    end
end
