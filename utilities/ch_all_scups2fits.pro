;+
; PROJECT:  CHIANTI
;
;       CHIANTI is an Atomic Database Package for Spectroscopic Diagnostics of
;       Astrophysical Plasmas.  See www.chiantidatabase.org 
;
;     		          
; Purpose     : converts the CHIANTI ascii SCUPS files to FITS files
;
; Explanation : each CHIANTI ascii SCUPS file is read into an IDL
;               structure, which is then written to a FITS file.
;               The routine goes through the masterlist of the ions.
;
; Inputs      : none
;
; Optional Input: the top-level CHIANTI database directory
;
; Outputs     : none
;
; Calls:
;             ch_read_list_ions, read_scups, wrt_fits_bin_exten
;
; 
; Written     : 
;       Version 1, Giulio Del Zanna (GDZ)  13 Oct 2020
;
; Modified    :
;       Ver.2, 09-Mar-2021, Peter Young
;         The output file is now gzipped.
;       Ver.3, 15-Oct-2024, Peter Young
;         Now uses ch_read_list_ions and reads both the general ion
;         list and the advanced model ion lin.
;
; VERSION     :    V.3, 15-Oct-2024
;
;-        
;---------------------------

pro ch_all_scups2fits, dir=dir

  if n_elements(dir) eq 1 then begin

     dir1=!xuvtop 

     !xuvtop=dir
  end
  

 ;
 ; Combine the standard and advanced masterlists.
 ;
  mlist1=ch_read_list_ions()
  mlist2=ch_read_list_ions(/advanced)
 ;
  list=[mlist1.list_ions,mlist2.list_ions]
  list=list[uniq(list,sort(list))]
;  read_masterlist,'',list

  nlist=n_elements(list)

  FOR ilist=0,nlist-1 do BEGIN

   err = 0

   gname=list[ilist]
   
   ion2filename,gname,fname
   
   file_scups =fname+'.scups'
   file_fits=fname+'.scups.fits'

   print,'converting '+file_scups

; read the structure with the data:
  read_scups,  file_scups,  st, /verb
  
  wrt_fits_bin_exten,st.info, file_fits

  wrt_fits_bin_exten,st.data, file_fits,/append

  file_gzip, file_fits, /delete

  
ENDFOR  ; main loop for the ions

 if n_elements(dir) eq 1 then !xuvtop=dir1
  
end
