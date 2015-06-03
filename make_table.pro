;---------Settings--------------
in_file_agc = '/Volumes/Global_250m/political/global_agb_stats_vcf_v4.2.5_wd3.csv'
in_file_bgc = '/Volumes/Global_250m/political/global_bgb_stats_vcf_v4.2.5_wd3.csv'
country_file = './country_names.txt'

template_file = './table_template.tex'

out_prefix = '/Volumes/Global_250m/political/tables/country_stats_v4.2.5_table_'

max_lines_ppg = 35   ;maximum number of countries per page.  break into new table when this happens
min_carbon = 0.1 ; Minimum amount of carbon in Tg for a country to be listed
pixel_area = 231.65635825D * 231.65635825D

;--------------------------------




openr, template_lun, template_file, /get_lun
country_names = read_csv(country_file)
sorted_index = sort((country_names.(0))[1:*])+1 ; skip first row

country_data_agc = read_csv(in_file_agc)
country_data_bgc = read_csv(in_file_bgc)

n_countries = n_elements(sorted_index)


pg_lines = 1
pg_num = 1


;start first page/tex file
file_name = out_prefix + strtrim(string(pg_num),2) + '.tex'
openw, out_lun, file_name, /get_lun
;write first part of template
write_table_prefix, template_lun, out_lun

country_code = country_data_agc.(0)

for i=0, n_countries-1 do begin
	if (pg_lines gt max_lines_ppg) then begin
		;Finish the current tex file and start a new one
		write_table_suffix, template_lun, out_lun
		pg_num += 1
		pg_lines = 1
		file_name = out_prefix + strtrim(string(pg_num),2) + '.tex'
		openw, out_lun, file_name, /get_lun
		write_table_prefix, template_lun, out_lun
	endif

	data_index = where(country_code eq sorted_index[i], count)
	if (count eq 1) then begin
		current_name = (country_names.(0))[sorted_index[i]]
		if (strmid(current_name,strlen(current_name)-1,1) ne '*') then begin
			outstring = current_name + '&'
			tmp_val = (country_data_agc.(2))[data_index] + (country_data_bgc.(2))[data_index]
			outstring += strtrim(string(tmp_val, format=fltformat(tmp_val)),2) + '&'
			tmp_area = (country_data_agc.(1))[data_index] * pixel_area / 10000 / 1000000   ;for million hectare
			outstring += strtrim(string(tmp_area, format=fltformat(tmp_area)),2) + '&'
			tmp_val = (country_data_agc.(4))[data_index] + (country_data_bgc.(4))[data_index]
			outstring += strtrim(string(tmp_val, format=fltformat(tmp_val)),2) + '&'
			tmp_area = (country_data_agc.(3))[data_index] * pixel_area / 10000 / 1000000   ;for million hectare
			outstring += strtrim(string(tmp_area, format=fltformat(tmp_area)),2) + '&'
			tmp_val = (country_data_agc.(6))[data_index] + (country_data_bgc.(6))[data_index]
			outstring += strtrim(string(tmp_val, format=fltformat(tmp_val)),2) + '&'
			tmp_area = (country_data_agc.(5))[data_index] * pixel_area / 10000 / 1000000   ;for million hectare
			outstring += strtrim(string(tmp_area, format=fltformat(tmp_area)),2) + '\\'
			printf, out_lun, outstring
			pg_lines += 1
		endif
	endif

endfor
; write total
printf, out_lun, '\addlinespace'
last_row = n_elements(country_data_agc.(0)) -1
outstring = '\textbf{Total} &'
tmp_val = ((country_data_agc.(2))[last_row] + (country_data_bgc.(2))[last_row]) / 1000
tmp_area = (country_data_agc.(1))[last_row] * pixel_area / 10000 / 1000000 / 1000
outstring += strtrim(string(tmp_val,format=fltformat(tmp_val)),2) + ' PgC&'
outstring += strtrim(string(tmp_area,format=fltformat(tmp_val)),2) + ' B Ha&'
tmp_val = ((country_data_agc.(4))[last_row] + (country_data_bgc.(4))[last_row]) / 1000
tmp_area = (country_data_agc.(3))[last_row] * pixel_area / 10000 / 1000000 / 1000
outstring += strtrim(string(tmp_val,format=fltformat(tmp_val)),2) + ' PgC&'
outstring += strtrim(string(tmp_area,format=fltformat(tmp_val)),2) + ' B Ha&'
tmp_val = ((country_data_agc.(6))[last_row] + (country_data_bgc.(6))[last_row]) / 1000
tmp_area = (country_data_agc.(5))[last_row] * pixel_area / 10000 / 1000000 / 1000
outstring += strtrim(string(tmp_val,format=fltformat(tmp_val)),2) + ' PgC&'
outstring += strtrim(string(tmp_area,format=fltformat(tmp_val)),2) + ' B Ha\\'
printf, out_lun, outstring

write_table_suffix, template_lun, out_lun

free_lun, template_lun

end
