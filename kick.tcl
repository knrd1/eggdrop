# Zdefiniuj last_nick jako $botnick - jesli nie jest jeszcze zdefiniowany:

if {![info exists last_nick]} {set last_nick $botnick}

proc wypierdol_kogos {nick uhost handle chan args} {
  global botnick last_nick
  global rep

# Zdefiniuj last_nick jako $botnick jesli last_nick opuscil kanal:

  if {![onchan $last_nick $chan]} {set last_nick $botnick}
  set mylist [chanlist $chan]

# Usun bota z listy nickow do wypierdolenia:

  set wb [lsearch $mylist $botnick]
  set mylist [lreplace $mylist $wb $wb]

# Jesli last_nick jest botem - OK. Jesli nie jest, usun ten nick z listy do wypierdolenia:

  if {$last_nick != $botnick} {
    set wl [lsearch $mylist $last_nick]
    set mylist [lreplace $mylist $wl $wl]
  }

# Wybierz losowy nick na kanale. Upewnij sie, ze nie jestes sam na kanale:

  set mylength [llength $mylist]
  if {$mylength == 0} {
  putserv "PRIVMSG $chan :Hm, $nick, nikogo chyba nie ma..."
  return 0
  }
  set myindex [rand $mylength]
  set result [lindex $mylist $myindex]

# Zbuduj napiecie za pomoca przeklenstw i wypierdol kogos:

  putserv "PRIVMSG $chan :Spoko!"
  putserv "NOTICE $chan :Uwaga frajerzy, zaraz kogos wypierdole!"
  putserv "PRIVMSG $chan :Ej, $result, wypierdalasz!"
  putserv "KICK $chan $result :Chuj ci w dupe nygusie!"

# Zdefiniuj last_nick do kolejnej rundy:

  set last_nick $result
  return 1
}

# Publiczna komenda do wypierdalania:

bind pubm - "*!wypierdol*" wypierdol_kogos
