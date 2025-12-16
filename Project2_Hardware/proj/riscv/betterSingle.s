.text
.global main
main:
	j sub1

sub1:
	j sub2

sub2:
	j sub3

sub3:
	j end

end:
	wfi