function x = gaussian(n, w)

  if nargin < 1 || nargin > 2
    usage("x = gaussian(n, w)");
  end
 
  x = exp ( -0.5 * ( w/n * [ -(n-1) : 2 : n-1 ]' ) .^ 2 );

  end