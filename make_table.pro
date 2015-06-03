;---------Settings--------------
in_file = '/Volumes/Global_250m/political/'
country_file = './country_names.txt'

template_file = '/Users/yifan/work/projects/global_carbon/idl/post/global_stat_make_table/table_template.tex'

out_prefix = '/Users/yifan/work/projects/global_carbon/manuscript/250m/tables/country_stats_v4.2.3_table_'

max_lines_ppg = 35   ;maximum number of countries per page.  break into new table when this happens
min_carbon = 0.1 ; Minimum amount of carbon in Tg for a country to be listed

;--------------------------------




openr, in_lun, in_file, /get_lun
openr, template_lun, template_file, /get_lun
country_names = read_csv(country_file)
sorted_index = sort((country_names.(0))[1:*])+1 ; skip first row

n_countries = n_elements(country_data.(0))-1

country_data = read_csv(country_file)

pg_lines = 0
pg_num = 1

text_line = ''

;start first page/tex file
file_name = out_prefix + strtrim(string(pg_num),2) + '.tex'
openw, out_lun, file_name, /get_lun
;write first part of template
point_lun, template_lun, 0
readf, template_lun, text_line
while(text_line ne '<insert_stats_here>') do begin
	printf, out_lun, text_line
	readf, template_lun, text_line
endwhile

for i=0, n_countries-1 do begin
	if (pg_lines gt max_lines_ppg) then begin
		;Finish the current tex file and start a new one
		while(~eof(template_lun)) do begin
			readf, template_lun, text_line
			printf, out_lun, text_line
		endwhile
		free_lun, out_lun
		pg_num += 1
		file_name = out_prefix + strtrim(string(pg_num),2) + '.tex'
		openw, out_lun, file_name, /get_lun
	endif
		

endfor
