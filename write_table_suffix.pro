PRO write_table_suffix, template_lun, out_lun

	text_line = ''
	while(~eof(template_lun)) do begin
		readf, template_lun, text_line
		printf, out_lun, text_line
	endwhile

	free_lun, out_lun

End
