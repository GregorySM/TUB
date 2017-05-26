function x = denormalize(xn,xmin,xmax)

    x = xmin + (xmax - xmin) *xn;

end