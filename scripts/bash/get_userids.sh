#!/bin/bash

# all_emails=(
# "JohnRichard.Abella@ngc.com"
# "Shahina.Akhter@ngc.com"
# "Brent.Bateman@ngc.com"
# "Patricia.Carrasco@ngc.com"
# "Christian.Cavalier@ngc.com"
# "David.Chong@ngc.com"
# "Mathew.Cosgrove@ngc.com"
# "Nicholas.Dulin@ngc.com"
# "Mustafa.Gobulukoglu@ngc.com"
# "Bo.Halamandaris@ngc.com"
# "Adam.Hebert@ngc.com"
# "CHUONG.Hua@ngc.com"
# "Timothy.Huang@ngc.com"
# "Dharnisha.Jayasundera@ngc.com"
# "Gregory.Jenkins@ngc.com"
# "Todd.Khacherian@ngc.com"
# "Rishi.Kumar@ngc.com"
# "Justin.La@ngc.com"
# "Fangyu.Liang@ngc.com"
# "Andrew.Lockwood@ngc.com"
# "Wanyu.Luo@ngc.com"
# "JuanCarlos.Magpantay@ngc.com"
# "Alexis.Mendez@ngc.com"
# "Aaron.Montano@ngc.com"
# "JuanCarlos.Oliveros@ngc.com"
# "nishith.patel@ngc.com"
# "Anthony.Rogers@ngc.com"
# "David.Romero3@ngc.com"
# "Stefania.Romisch@ngc.com"
# "David.Rosenwasser@ngc.com"
# "Taylor.Schluter@ngc.com"
# "Henry.Senanian2@ngc.com"
# "Jake.Sheppard@ngc.com"
# "David.Vartanian@ngc.com"
# "Michaela.Villarreal@ngc.com"
# "Kenneth.Wong@ngc.com"
# "German.Zepeda@ngc.com"
# )
all_emails=(
"Andrew.Lockwood@ngc.com"
"Wanyu.Luo@ngc.com"
"JuanCarlos.Magpantay@ngc.com"
"Alexis.Mendez@ngc.com"
"Aaron.Montano@ngc.com"
"JuanCarlos.Oliveros@ngc.com"
"nishith.patel@ngc.com"
"Anthony.Rogers@ngc.com"
"David.Romero3@ngc.com"
"Stefania.Romisch@ngc.com"
"David.Rosenwasser@ngc.com"
"Taylor.Schluter@ngc.com"
"Henry.Senanian2@ngc.com"
"Jake.Sheppard@ngc.com"
"David.Vartanian@ngc.com"
"Michaela.Villarreal@ngc.com"
"Kenneth.Wong@ngc.com"
"German.Zepeda@ngc.com"
)

core_emails=(
"JohnRichard.Abella@ngc.com"
"Patricia.Carrasco@ngc.com"
"Christian.Cavalier@ngc.com"
"Mathew.Cosgrove@ngc.com"
"Nicholas.Dulin@ngc.com"
"Mustafa.Gobulukoglu@ngc.com"
"CHUONG.Hua@ngc.com"
"Timothy.Huang@ngc.com"
"Justin.La@ngc.com"
"JuanCarlos.Magpantay@ngc.com"
"Aaron.Montano@ngc.com"
"Anthony.Rogers@ngc.com"
"David.Romero3@ngc.com"
"Taylor.Schluter@ngc.com"
"Henry.Senanian2@ngc.com"
)

# for email in ${all_emails[@]}; do
#   echo "searching for" $email
#   output_filename=$email.ldap.log
#   ldapsearch -x -H ldap://northgrum.com:389 -D "cosgrma@northgrum.com" -w "asdfcIUY987(*&" -b "ou=employees,ou=people,dc=northgrum,dc=com" "(&(mail=$email))" -s one > $output_filename
#   # echo $res | grep "employeeID:"
#   # department:
#   sleep 20;
# done;


fieldlist=(
  "displayName:"
  "title:"
  "mail:"
  "givenName:"
  "sn:"
  "department:"
  "ngcDepartmentDescription:"
)

for l in `ls *.log`; do
  for f in ${fieldlist[@]}; do
    echo "$f " `cat $l | grep $f | cut -d':' -f2`;
  done
done;