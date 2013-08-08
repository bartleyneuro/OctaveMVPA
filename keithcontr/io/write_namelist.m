## Copyright (C) Darien Pardinas Diaz <darien.pardinas-diaz@monash.edu>
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

## WRITE_NAMELIST(S, FILENAME) writes a namelist data structure S to a
## file FILENAME. S should follow the following structure:
##
##                  |--VAR1
##                  |--VAR2
##     |-- NMLST_A--|...
##     |            |--VARNa
##     |
##     |            |--VAR1
##     |-- NMLST_B--|--VAR2
##     |            |...
## S --|     ...    |--VARNb
##     |
##     |            |--VAR1
##     |-- NMLST_M--|--VAR2
##                  |...
##                  |--VARNm
## 
## Notes: Only supports variables of type: 
## Scalars, vectors and 2D numeric arrays (integers and floating points)
## Scalars and 1D boolean arrays specified as '.true.' and '.false.' strings
## Single and 1D arrays of strings
##  
## Example:
##     NMLST = read_namelist ("OPTIONS.nam");
##     NMLST.NAM_FRAC.XUNIF_NATURE = 0.1;
##     write_namelist(NMlST, "MOD_OPTIONS.nam");

## Written by:     Darien Pardinas Diaz (darien.pardinas-diaz@monash.edu)
## Version:        1.0
## Date:           16 Dec 2011
##
## Released under GPL License 30/3/2013

function [ ret ] = write_namelist (S, filename)

  fid = fopen (filename, "w");
  name_lists = fieldnames (S);
  n_name_lists = length(name_lists);
  
  for ii = 1:n_name_lists,
    ## Write individual namelist records
    fprintf (fid, "&%s\n", name_lists{ii});
    rcrds = S.(name_lists{ii});
    
    rcrds_name = fieldnames(rcrds);
    n_rcrds = length(rcrds_name);
    
    for jj = 1:n_rcrds,
      var = rcrds.(rcrds_name{jj});
      ## Find variable type...
      if (iscell (var)),
        fprintf (fid, "   %s =", rcrds_name{jj});
        if (strcmp (var{1}, ".true.") || strcmp (var{1},"'.false.")),    
          for kk = 1:length (var),
            fprintf (fid, " %s,", var{kk});    
          endfor
        else
          for kk = 1:length (var),
            fprintf (fid, " %s,", [ "'" var{kk} "'" ]);    
          endfor
        endif
        fprintf (fid, "%s\n", "");
      else
        [r, c] = size (var);
        if (r == 1 || c == 1)
          ## Variable is a scalar or vector
          fprintf (fid, "   %s =", rcrds_name{jj});
          fprintf (fid, " %g,", var);
          fprintf (fid, "%s\n", "");
        else
          ## Varible is a two dimensional array
          for kk = 1:r,
            fprintf (fid, "   %s(%i,:) =", rcrds_name{jj}, kk);
            fprintf (fid, " %g,", var(kk,:));
            fprintf (fid, "%s\n", ""); 
          endfor
        endif
      endif
    endfor
    fprintf (fid, "%s\n", "/");
  endfor

  fclose (fid);

endfunction
