function fltformat, num
  exponent = fix(alog10(num))
  if (exponent lt 1) then begin
    return, '(f6.4)'
  endif
  if (exponent lt 2) then begin
    return, '(f6.3)'
  endif

  if (exponent lt 3) then begin
    return, '(f6.2)'
  endif

  if (exponent lt 4) then begin
    return, '(f6.1)'
  endif

  return, '(i0)'

end
