BEGIN { FS="\",\"" }
NR > 1 {
         print "holiday.day" NR ".name=" $4
         print "holiday.day" NR ".date=" $3
       }
