# -----------------------------------------------------------
# Create components in the order:
# 1) All CHE and CH families height-wise
# 2) All COW families height-wise
# -----------------------------------------------------------

*createmark comps 1 "all"
set allComps [hm_getmark comps 1]

array unset famExists
array set famExists {}

set regex {^Cone([0-9]+(CHEI|CHEO|CHWI|CHWO|COWI|COWO))}

# Extract all names like 10CHEI, 15CHWI, 20COWO
foreach compID $allComps {
    set name [hm_entityinfo name comps $compID]
    if {[regexp $regex $name -> fam]} {
        set famExists($fam) 1
    }
}

# Convert to list
set famList [array names famExists]


# -------------------------------
# Extract heights
# -------------------------------
array unset heights
array set heights {}

foreach f $famList {
    regexp {^([0-9]+)} $f -> h
    set heights($h) 1
}

set heightList [lsort -integer [array names heights]]


# -------------------------------
# ORDERED CREATION
# -------------------------------

# 1️⃣ Block 1: CHE + CH (height wise)
foreach h $heightList {

    foreach suffix {CHEI CHEO CHWI CHWO} {
        set name "${h}${suffix}"
        if {[info exists famExists($name)]} {
            *createentity comps name=$name
            puts "Created: $name"
        }
    }
}

# 2️⃣ Block 2: COW (height wise)
foreach h $heightList {

    foreach suffix {COWI COWO} {
        set name "${h}${suffix}"
        if {[info exists famExists($name)]} {
            *createentity comps name=$name
            puts "Created: $name"
        }
    }
}

puts "\n✔ Components created in requested order."
