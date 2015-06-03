PRO write_table_prefix, template_lun, out_lun

	text_line = ''
	point_lun, template_lun, 0
	readf, template_lun, text_line
	while(text_line ne '<insert_stats_here>') do begin
		printf, out_lun, text_line
		readf, template_lun, text_line
	endwhile

End	
