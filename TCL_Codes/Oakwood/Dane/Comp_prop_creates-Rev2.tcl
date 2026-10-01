#TimeTooth Script to Create Component Collector, Thickness properties and Assign Properties for Oakwood models
#Badri & Girish....created 12.04.09
#Siva..............Updated 12.10.11
#Nanda.............Optimized Cone Location Input Logic 24.06.26

# First Collect information on Number of Cones and number of locations on each cone

set numcones [hm_getint "Number of Cones" "Enter Number of Cones"]
set tmpnumcones [expr {$numcones + 1}]

set sameloc [hm_getint "Location Pattern" "Do all cones have same number of locations?\n1 = Yes\n0 = No"]

if {$sameloc == 1} {

    set commonloc [hm_getint "Locations" "Enter Number of Locations for all Cones"]

    for {set i 1} {$i < $tmpnumcones} {incr i} {
        set numloccone$i $commonloc
    }

} else {

    for {set i 1} {$i < $tmpnumcones} {incr i} {
        set numloccone$i [hm_getint "Number of Locations on Cone$i" "Enter Number of Locations on Cone$i"]
    }

}

set numlevels [hm_getint "Number of Levels" "Enter Number of Levels"]

set alphabet {0 10CHEI 10CHEO 10CHWI 10CHWO 15CHEI 15CHEO 15CHWI 15CHWO 20CHEI 20CHEO 20CHWI 20CHWO 25CHEI 25CHEO 25CHWI 25CHWO 30CHEI 30CHEO 30CHWI 30CHWO 35CHEI 35CHEO 35CHWI 35CHWO 40CHEI 40CHEO 40CHWI 40CHWO 50CHEI 50CHEO 50CHWI 50CHWO 8COWI 8COWO 10COWI 10COWO 15COWI 15COWO 20COWI 20COWO 25COWI 25COWO 30COWI 30COWO 35COWI 35COWO 40COWI 40COWO 50COWI 50COWO

}

#Read Thickness Data from Single Column txt file
#Thickness Data needs to follow specific rules sequence in txt file as shown below
#First data should be 0 (first line of thk data in file will be ignored)
#In data,first index levels, then index locations, then index cones

set filename [tk_getOpenFile]
set fh [open "$filename" r]
set thkdata [read $fh]
set propnum [llength $thkdata]
close $fh
set tid 1

for {set j 1} {$j<$tmpnumcones} {incr j} {

    set m [set numloccone$j]
    set l [expr $m+1]

    set coneid [lindex $alphabet $j]

    for {set k 1} {$k<$l} {incr k} {

        set n [expr $numlevels+1]

        for {set o 1} {$o<$n} {incr o} {

            *collectorcreateonly components "Cone${coneid}_loc${k}_lev$o" "" 25

            set thkval [lindex $thkdata $tid]

            *collectorcreateonly properties "tk_Cone${coneid}_loc${k}_lev$o" "" 11
            *createmark properties 2 "tk_Cone${coneid}_loc${k}_lev$o"
            *dictionaryload properties 2 "C:/Program Files/Altair/2021/hwdesktop/templates/feoutput/ls-dyna971/dyna.key" "SectShll"

            *attributeupdateint properties $tid 4540 9 2 0 1
            *attributeupdateint properties $tid 90 9 2 0 0
            *attributeupdateint properties $tid 399 9 0 0 0
            *attributeupdatedouble properties $tid 402 9 0 0 1
            *attributeupdateint properties $tid 427 9 0 0 2
            *attributeupdatedouble properties $tid 428 9 0 0 0
            *attributeupdateint properties $tid 458 9 2 0 0
            *attributeupdatedouble properties $tid 429 9 0 0 0
            *attributeupdateint properties $tid 430 9 0 0 0
            *attributeupdateint properties $tid 4428 9 0 0 1
            *attributeupdateint properties $tid 457 9 2 0 0
            *attributeupdatedouble properties $tid 431 9 0 0 0
            *attributeupdatedouble properties $tid 435 9 0 0 0
            *attributeupdatedouble properties $tid 4190 9 0 0 0
            *attributeupdatedouble properties $tid 431 9 1 0 $thkval

            *createmark components 2 "Cone${coneid}_loc${k}_lev$o"
            *dictionaryload components 2 "C:/Program Files/Altair/2021/hwdesktop/templates/feoutput/ls-dyna971/dyna.key" "Part"
            *propertyupdate components 2 "tk_Cone${coneid}_loc${k}_lev$o"
            *attributeupdateint components $tid 4193 9 2 0 0
            *attributeupdateint components $tid 459 9 2 0 1
            *attributeupdateint components $tid 2827 9 2 0 0
            *attributeupdatestring components $tid 100 9 2 0 ""
            *attributeupdateentity components $tid 460 9 0 0 properties 0
            *attributeupdateentity components $tid 461 9 0 0 properties 0
            *attributeupdateentity components $tid 462 9 0 0 properties 0
            *attributeupdateint components $tid 464 9 0 0 0
            *attributeupdateint components $tid 463 9 0 0 0
            *attributeupdateentity components $tid 465 9 0 0 materials 0
            *attributeupdateint components $tid 117 9 2 0 0
            *attributeupdateint components $tid 2817 9 2 0 0
            *attributeupdateint components $tid 2824 9 2 0 0
            *attributeupdateint components $tid 4324 9 2 0 0
            *attributeupdateint components $tid 2895 9 2 0 0
            *attributeupdateentity components $tid 460 9 1 0 properties $tid

            incr tid

        }
    }
}
