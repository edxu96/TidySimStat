function [x] = randWalk()
    x = randi(2, 1);
    if x == 2
        x = -1;
    end
end
