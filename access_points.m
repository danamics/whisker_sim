%
%  This function takes the points object and returns the "index"th entry
%  that if of type "type".
%


function j = access_points( pts, type, index )

    % normally we just iterate until we count "index" instances of "type"
    if ~isequal(index,'end')
       
       j = 0;
       count = 0;
       while count < index
          j     = j + 1;
          count = count + isequal( type, pts(j).type );
       end
       
    else

      % but if we receive the "end" key word, we iterate backwards until
      % we find the first (ie. the last) instance of the specified "type"
      j = length(pts);
      while ( j > 0 )
          if isequal( type, pts(j).type ), break,  end;
          j = j - 1;
      end
          
    end
    